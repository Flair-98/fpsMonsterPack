Class MechTitanB Extends SMPTitan
	Placeable;

Var() Sound MTHitSound[4];
Var() Int mtHealth;
Var() Int ShockWaveDamage;
Var() Bool DoShockWave;

Var(HeadGun) Float MinSpawnRate;
Var(HeadGun) Float MaxSpawnRate;
Var(HeadGun) Float ExplosionDamage;
Var(HeadGun) Float ExplosionRadius;
Var(HeadGun) Bool Teleports;
Var(HeadGun) Bool Nulls;

Var(Projectiles) 	sound 			Proj1Impact,Proj2Impact,Proj3Impact;
Var(Projectiles) 	StaticMesh 		Projectile1,Projectile2,Projectile3;
Var(Projectiles) 	Int  		    Proj1CollisionRadius,Proj2CollisionRadius,Proj3CollisionRadius;
Var(Projectiles) 	Vector 		    Proj1PrePivot,Proj2PrePivot,Proj3PrePivot;

Var MechTitanBGun HeadGun;
Var MutfpsRPG RPGMut;
Var Float lastDamaged,lastScreech,lastThrown,xpModifier,FallOutHP;

Var MechTitanBShield MTBShield;
Var Float ShieldProb;
Var xEmitter FallOut;

Var Config Array< Class<DamageType> > BlockedDamageTypes;
Var Config Array<Name> BlockedInventories;

Var Config Bool bVorpalJump;
Var Config Bool bVorpalMsgs;
Var Bool bTeleporting;
Var Vector TelepDest;

Simulated Function PreBeginPlay()
{
	Local Int i;

	For (i=0; i<4; i++)
	{
		If (MTHitSound[i] != None)
			HitSound[i] = MTHitSound[i];
	}
	Health = mtHealth;

	Super.PreBeginPlay();
}

Function PostBeginPlay()
{
	Super.PostBeginPlay();
	If (HeadGun == None)
	{
		HeadGun =  Spawn(Class'MechTitanBGun',Self,,Location + Vect(0,0,200),Rotation);
		HeadGun.SetBase(Self);

		// account For this guy with the invasion
		Invasion(Level.Game).NumMonsters++;

		// Timer implemented For a fail safe AutodeStruct in Case of glitch
		SetTimer(5,True);

		RPGMut = Class'MutfpsRPG'.Static.GetRPGMutator(Level.Game);

		// XP to HP 'normalization' 20 damage = 1XP
		xpModifier = (Health/20)/ScoringValue;
		ScoringValue *= xpModifier;
	}
}

//== block poison effect and Monster Mover
Function Bool AddInventory(inventory NewItem)
{
    If ((NewItem.IsA('PoisonInv')) || (NewItem.IsA('MonsterMoverInv')))
      Return False;

  Return Super.AddInventory(NewItem);
}

Function KilledBy( pawn EventInstigator )
{
   //== Do nothing
}

Simulated Function Died(Controller Killer, Class<DamageType> damageType, Vector HitLocation)
{

	If (HeadGun != None)
	{
		HeadGun.Destroy();
	}

	If (MTBShield != None)
		MTBShield.Destroy();

	//==revert scoringValue so player isn't awarded too many poInts For kill
	ScoringValue /= xpModifier;
	SetTimer(0,False);

	If ( FallOut != None )
	    {
			FallOut.mRegen = False;
			FallOut.Destroy();
		}

	Super.Died(Killer,damageType,HitLocation);

}

Function RangedAttack(Actor A)
{
	If ( bShotAnim )
		Return;
	// Shield prob scales with Health, the less HP the more likely he will Spawn a shield up to 25% chance
	// shield cannot Spawn with FallOut
	If ((frand() < ShieldProb) && (FallOut == None))
	{
		SpawnShield();
		Return;
	}
	Else
		Super.RangedAttack(A);

}

//== no its not a rock ...
Function SpawnRock()
{
	Local Vector X,Y,Z, FireStart;
	Local Rotator FireRotation;
	Local Projectile   Proj;

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + 1.2*CollisionRadius * X + 0.4 * CollisionHeight * Z;
	If ( !SavedFireProperties.bInitialized )
	{
		SavedFireProperties.AmmoClass = MyAmmo.Class;
		SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
		SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
		SavedFireProperties.MaxRange = MyAmmo.MaxRange;
		SavedFireProperties.bTossed = MyAmmo.bTossed;
		SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
		SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
		SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
		SavedFireProperties.bInitialized = True;
	}

	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);

	Proj=Spawn(MyAmmo.ProjectileClass,Self,,FireStart,FireRotation);
	If(Proj!=None)
	{
		lastThrown = Level.TimeSeconds;
		Proj.SetPhysics(PHYS_Projectile);
		Proj.setDrawScale(Proj.DrawScale*DrawScale/Default.DrawScale);
		Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/Default.DrawScale,Proj.CollisionHeight*DrawScale/Default.DrawScale);
		Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *Vector(Proj.Rotation)*DrawScale/Default.DrawScale;
	}
	bStomped=False;
	ThrowCount++;
	If(ThrowCount>=2)
	{
		bThrowed=True;
		ThrowCount=0;
	}
}

//== changing this From bouncing to creating a blastwave that imparts knockback
Function Stomp()
{
	Local pawn Thrown;
	Local Emitter Blastwave;

	TriggerEvent(StompEvent,Self, Instigator);
	If (DoShockWave)
	{
		Blastwave = Spawn(Class'MechTitanBShockWave',,,Location - Vect(0,0,245),Rotation);
		//knockback all nearby creatures, and play sound
		Foreach VisibleCollidingActors( Class 'Pawn', Thrown, 1500)
			FlyingMonkeys(Thrown);
	}
	Else
	{
 		Mass=Default.Mass*(CollisionRadius/Default.CollisionRadius);
		//throw all nearby creatures, and play sound
		Foreach VisibleCollidingActors( Class 'Pawn', Thrown,Mass)
			ThrowOther(Thrown,Mass/4);
	}

	PlaySound(StompSound, SLOT_Interact, 150);
	bStomped=True;
}

Function FlyingMonkeys(Pawn Other)
{
//== Knockback code 'Borrowed' From Druid's RPG code, then mangled, changed and subverted to suit(work)
	Local Vector adjustedLocation,KbMomentum;

	If (Other == Self)
		Return;

	adjustedLocation = Self.Location;
//== If the knocker is higher than the one being flung then they will be flung Into the ground, so
// adjust the z component of the Knocker's location to impart an upward Force ... and this actually works
// (unlike the original code ;p (i would substitute 2*CollisionHeight For 600 If not used For this
// specIfically))

	If (Self.Location.z > Other.Location.z)
		adjustedLocation.z = Other.Location.z - 600;

	KbMomentum = adjustedLocation - Other.Location;
	KbMomentum = Normal(KbMomentum);

	KbMomentum *= -2500;
	Other.AddVelocity(KbMomentum);
	Other.SetOverlayMaterial(Shader'XGameShaders.PlayerShaders.VehicleSpawnShaderBlue', 3.0, False);
	Other.TakeDamage(ShockWaveDamage, Self, Other.Location,Normal(KbMomentum), Class'DamTypeMechTitanBShockWave');

}

Function SpawnShield()
{
	Local Controller C;
	Local Int PlayerCount;

	For ( C = Level.ControllerList; C != None; C = C.NextController )
		If ( C.bIsPlayer && (C.Pawn != None) )
			PlayerCount++;

	If(MTBShield != None)
		MTBShield.Destroy();

	MTBShield = Spawn(Class'MechTitanBShield',,,Location);
	MTBShield.ShieldHealth = Min( MTBShield.Default.ShieldHealth, (MTBShield.Default.ShieldHealth * (PlayerCount/6)));
	PLaySound(Sound'WeaponSounds.Misc.ballgun_change',SLOT_Interact,255,,1200,0.75);

}

Function createFallOut()
{
 	FallOut = Spawn(Class'MechTitanFallOut',Self,,Location,Rotation);
	FallOut.SetBase(Self);
	MechTitanFallOut(FallOut).affectedRadius = 1000;
	MechTitanFallOut(FallOut).mSizeRange[0]= 500.000000;
    MechTitanFallOut(FallOut).mSizeRange[1]= 650.000000;
}

Function TakeDamage( Int Damage, Pawn instigatedBy, Vector hitlocation,
						Vector momentum, Class<DamageType> damageType)
{
	Local Int actualDamage;
	Local Float damageAdjustment;
	Local Controller Killer;

	If ( Health <= 0 )
		Return;

	lastDamaged = Level.TimeSeconds;

	// minimize knockback
	momentum = Vect(0,0,0);

	If (instigatedBy != None)
	{
		//==> SuperWeapons
		If (damageType.Default.bSuperWeapon)
		{
			If (FallOut == None)
				createFallOut();

			FallOutHP += (Damage * 2.0);
			PlaySound(Sound'IndoorAmbience.machinery28',SLOT_Talk,255,,1000);
			Return;
		}

		//FallOut absorbs 2/3 of incoming damage
		If (FallOutHP > 0)
		{
			FallOutHP -= Damage * 0.66;
			Damage *= 0.33;
		}

		//==>> Ignore damage If its not coming From a player
		If (!instigatedBy.IsHumanControlled())
			Return;

		If ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.Default.bDelayedDamage && DelayedDamageInstigatorController != None)
			instigatedBy = DelayedDamageInstigatorController.Pawn;

		If ( (Physics == PHYS_None) && (DrivenVehicle == None) )
			SetMovementPhysics();

		If (Weapon != None)
			Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );

		If ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
			Damage *= 2;

		damageAdjustment = fMin(fClamp((0.25 / (Level.Game.NumPlayers / 25.00)), 0.25,2.00) , (0.125 / (RPGMut.CurrentLowestLevelPlayer.Level / 200)));

		Damage = Int(Damage*damageAdjustment);
		actualDamage = Level.Game.ReduceDamage(Damage, Self, instigatedBy, HitLocation, Momentum, DamageType);

		If (actualDamage < 1)
			actualDamage = 1;

		Health -= actualDamage;

		// ShieldProb ranges between 0.2% at full HP to 20% at near-death HP
		ShieldProb = (1.01 - (Health/mtHealth)) / 5;

		If ( HitLocation == Vect(0,0,0) )
			HitLocation = Location;

		PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);
		If ( Health <= 0 )
		{
			// pawn died
			If ( DamageType.Default.bCausedByWorld && (instigatedBy == None || instigatedBy == Self) && LastHitBy != None )
				Killer = LastHitBy;
			Else If ( instigatedBy != None )
				Killer = instigatedBy.GetKillerController();
			If ( Killer == None && DamageType.Default.bDelayedDamage )
				Killer = DelayedDamageInstigatorController;
			If ( bPhysicsAnimUpdate )
				TearOffMomentum = momentum;
			Died(Killer, damageType, HitLocation);
		}
		Else
		{
			If ( Controller != None )
				Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
			If ( instigatedBy != None && instigatedBy != Self )
				LastHitBy = instigatedBy.Controller;
		}
		MakeNoise(1.0);
	}
	Else
		Return;
}

Function Bool SameSpeciesAs(Pawn P)
{
//With RPG this may mean the monster wont attack friEndlymonsters. So we could try to account For that with this code.
	Return ( (Monster(P) != None) && (Monster(P).Controller != None && !Monster(P).Controller.IsA('FriendlyMonster')) );
}

Function PlayChallengeSound()
{
	If ((Level.TimeSeconds - lastScreech) > 15)
	{
		PlaySound(Sound'MechScreech',SLOT_Talk,255,,2000);
		lastScreech = Level.TimeSeconds;
	}
}

Simulated Function PlayDirectionalHit(Vector HitLoc)
{
//== Don't play  directional hits.
}

//== this Function originally causes a bug with the other titans that makes them unable to shoot
//== back when being shot by sniper fire; this fixes that, and he can't be headshot anyway.
Function Bool IsHeadShot(Vector loc, Vector ray, Float AdditionalScale)
{
	Return False;
}

Function Bool IgnoreDamage(Class<DamageType> damageType, Pawn Hitter)
{
  Local Int i;

If (damagetype == None)
Return False;

  For (i = 0; i < BlockedDamageTypes.Length; i++)
  {
    If (damageType == BlockedDamageTypes[i])
    {
      TeleToSafety();
      Return True;
    }
  }

  //== Since Wail made a New Class of Vorpal that Ignores Luci, this is no Longer entirely necessary
  If (Hitter != None && hitter.Weapon.IsA('RW_Vorpal'))
  {
    If (bVorpalJump)
    {
      TeleToSafety();

      If (bVorpalMsgs)
      {
	  Level.Game.BroadcastLocalizedMessage(Class'DarkCriticalEvents',0,Hitter.PlayerReplicationInfo);
      }
    }

    Return True;
  }

  If (damageType.Default.bCausedByWorld)
    Return True;

  Return False;
}

// some code From Luci so he can't fall Out of the world and hit the killZ
Event FellOutOfWorld(eKillZType KillType)
{
	If (Health > 0)
		TeleToSafety();
	Else
		Super.FellOutOfWorld(KillType);
}

Function TeleToSafety()
{
    Local NavigationPoint StartSpot;

    StartSpot = Invasion(Level.Game).FindPlayerStart(None,1);
	DoTranslocateOut(Location);

    SetLocation(StartSpot.Location);

	DoTranslocateOut(Location);

	SetOverlayMaterial(Class'TransRecall'.Default.TransMaterials[0], 1.0, False);
	Instigator.PlayTeleportEffect(False, False);
}

Function Timer()
{
	// move If taking fire and not Returning it, or If not damaged in 20 seconds
	If ((((Level.TimeSeconds - lastThrown) > 10) && (Level.TimeSeconds - lastDamaged < 10))
		|| (Level.TimeSeconds - lastDamaged > 20))
		TeleToSafety();
}

DefaultProperties
{
     BlockedDamageTypes(0)=Class'Engine.fell'
     BlockedDamageTypes(1)=Class'Engine.FellLava'
     BlockedDamageTypes(2)=Class'Gameplay.Depressurized'
     BlockedInventories(0)="PoisonInv"
     BlockedInventories(1)="FreezeInv"
     BlockedInventories(2)="PullForwardInv"
     BlockedInventories(3)="StenchInv"
     BlockedInventories(4)="KnockbackInv"
     bVorpalJump=True
     bVorpalMsgs=True
     bNoTeleFrag=True
     MTHitSound(0)=Sound'ONSVehicleSounds-S.VehicleTakeFire.VehicleHitBullet06'
     MTHitSound(1)=Sound'ONSVehicleSounds-S.VehicleTakeFire.FlakRicochet01'
     MTHitSound(2)=Sound'WeaponSounds.BaseImpactAndExplosions.BBulletImpact5'
     MTHitSound(3)=Sound'WeaponSounds.BaseImpactAndExplosions.BBulletImpact12'
     mtHealth=250000
     ShockWaveDamage=300
     DoShockWave=True
     MinSpawnRate=0.500000
     MaxSpawnRate=0.750000
     ExplosionDamage=125.000000
     ExplosionRadius=250.000000
     Teleports=True
     Nulls=True
     Proj1Impact=Sound'ONSVehicleSounds-S.CollisionSounds.VehicleCollision01'
     Proj2Impact=Sound'GeneralAmbience.metalfx15'
     Proj3Impact=Sound'GeneralAmbience.metalfx14'
     Projectile1=StaticMesh'AW-Junk.Pieces.HugeMech'
     Projectile2=StaticMesh'AW-Junk.Complex.SmashedGasTank'
     Projectile3=StaticMesh'AW-Junk.Metal.AW-TwistedBeam1'
     ShieldProb=0.050000
     SlapDamage=1000
     PunchDamage=1200
     Step=Sound'AssaultSounds.IONGun.IONTurretTurn02'
     StompSound=Sound'train_coupling'
     Slap=Sound'GeneralImpacts.Wet.Breakbone_04'
     swing=Sound'GeneralAmbience.metalfx17'
     Throw=Sound'GeneralAmbience.metalfx14'
     ProjectileSpeed=1000.000000
     AmmunitionClass=Class'MechTitanBAmmo'
     ScoringValue=25
     GibGroupClass=Class'MechTitanBGibGroup'
     DoubleJumpAnims(0)="TBrea001"
     DoubleJumpAnims(1)="TBrea001"
     DoubleJumpAnims(2)="TBrea001"
     DoubleJumpAnims(3)="TBrea001"
     AmbientSound=Sound'InDoorAmbience.machinery26'
     DrawScale=2.000000
     Skins(0)=Texture'MechTitanDetail'
     Skins(1)=Texture'MechTitanDetail'
     AmbientGlow=75
     bFullVolume=True
     SoundRadius=800.000000
     CollisionRadius=240.000000
     CollisionHeight=240.000000
     bBoss=True
}
