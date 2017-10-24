class EvilMilkMonster extends Monster;

var bool bFixed, bMedic, bHasArrived;
var EvilMilkMonster Patient, BD;
var MilkShield Shield;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetPhysics(PHYS_Flying);
}

simulated function Tick( float DeltaTime )
{
	Super.Tick(DeltaTime);

	if ( BD != None && BD.bHasArrived )
		Velocity = vect(0,0,0);
	else if ( Patient != None )
	{
		SetRotation( rotator(Patient.Location-Location) );
		Velocity = AirSpeed*vector(Rotation);
		if ( VSize(Patient.Location-Location) <= 150 )
		{
			if ( Shield == None )
				Shield = Spawn( Class'MilkShield',,,(Patient.Location+Location)/2 );
			else
				Shield.SetLocation( (Patient.Location+Location)/2 );

			if ( !bHasArrived )
			{
				bHasArrived = true;
				SetTimer( 4, false );
			}
		}
	}
}

singular function Falling()
{
	SetPhysics(PHYS_Flying);
}

function FinishRepair()
{
	Patient.Health = Patient.Default.Health;
	PlaySound(sound'TauntPack.r_witness_my_perfection');
	Patient.BD = None;
	Patient.bFixed = false;
	Patient.bMedic = false;
	Patient = None;
	bHasArrived = false;
	if ( Shield != None )
		Shield.Destroy();
}

function RangedAttack(Actor A)
{
	local vector X,Y,Z;

	if ( VSize(A.Location - Location) < MeleeRange/2.125 + CollisionRadius + A.CollisionRadius && FRand() < 0.3 && Patient == None
	 && (BD == None || !BD.bHasArrived) )
	{
		FireProjectile();

		if ( BD == None || !BD.bHasArrived )
		{
			GetAxes(Rotation,X,Y,Z);
			if ( FRand() < 0.5 )
				Y *= -1;
			if ( FRand() < 0.5 )
				Z *= -1;

			Controller.Destination = Location + 200 * (Normal(Location - A.Location) + VRand());
			Controller.Destination = Controller.Destination + 150*Y + 150*Frand()*Z;

			if ( Location.Z <= A.Location.Z+10 && Controller.Destination.Z <= A.Location.Z+10 )
				Controller.Destination.Z += 50;

			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
		}
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius && FRand() < 0.2 && Patient == None
	 && (BD == None || !BD.bHasArrived) )
	{
		//FireProjectile();

		if ( BD == None || !BD.bHasArrived )
		{
			GetAxes(Rotation,X,Y,Z);
			if ( FRand() < 0.5 )
				Y *= -1;
			if ( FRand() < 0.5 )
				Z *= -1;

			Controller.Destination = Location + 50*FRand() * (Normal(Location - A.Location) + VRand());
			Controller.Destination = Controller.Destination + 300*Y + 300*Frand()*Z;

			if ( Location.Z <= A.Location.Z+10 && Controller.Destination.Z <= A.Location.Z+10 )
				Controller.Destination.Z += 50;

			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
		}
	}
}

function Timer()
{
	local EvilMilkMonster D;

	if ( bHasArrived )
		FinishRepair();
	else if ( bMedic )
	{
		foreach VisibleActors(class'EvilMilkMonster', D, MeleeRange*3 )
		{
			if ( D != Self && D.Health > D.Default.Health/3 && (BD == None || VSize(D.Location-Location) < VSize(BD.Location-Location))
			  && D.Patient == None )
				BD = D;
		}

		if ( BD != None )
		{
			BD.Patient = Self;
			BD.PlaySound(sound'TauntPack.r_im_on_it');
		}
		else
			SetTimer( 2, false );
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local int actualDamage;
	local bool bAlreadyDead;
	local Controller Killer;

if ( (Patient == None || !bHasArrived) && (BD == None || !BD.bHasArrived) )
{
	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}
	
	if ( Role < ROLE_Authority )
	{
		log(self$" client damage type "$damageType$" by "$instigatedBy);
		return;
	}

	bAlreadyDead = (Health <= 0);

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;

    if (Weapon != None)
        Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() ) // FIXME THIS SUCKS
        Damage *= 2;
	actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
	if( DamageType.default.bArmorStops && (actualDamage > 0) )
		actualDamage = ShieldAbsorb(actualDamage); 

	Health -= actualDamage;
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;
	if ( bAlreadyDead )
		return;

	PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);
	if ( Health <= 0 )
	{
		if ( Patient != None )
		{
			Patient.BD = None;
			Patient.SetTimer( 1, false);
			if ( Shield != None )
				Shield.Destroy();
		}

		if ( BD != None )
		{
			BD.Patient = None;
			BD.bHasArrived = false;
			if ( BD.Shield != None )
				BD.Shield.Destroy();
		}

		// pawn died
		if ( instigatedBy != None )
			Killer = instigatedBy.GetKillerController();
		if ( bPhysicsAnimUpdate )
			TearOffMomentum = momentum;
		Died(Killer, damageType, HitLocation);
	}
	else if ( Health <= Default.Health/3 )
	{
		if ( FRand() < 0.3 && !bFixed )
		{
			bFixed = true;
			PlaySound(sound'TauntPack.r_rerouting_critical_systems',,2.5*TransientSoundVolume);
			Controller.Destination = Location + 500 * (Normal(Location - instigatedBy.Location) + VRand());
			Controller.Destination.Z = Location.Z + 100;
			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
			Health += Default.Health/3 + FRand()*Default.Health/6;
		}
		else if ( !bMedic )
		{
			if ( Patient != None )
			{
				Patient = None;
				bHasArrived = false;
				Patient.BD = None;
				Patient.SetTimer( 1, false );
				if ( Shield != None )
					Shield.Destroy();
			}

			bFixed = true;
			bMedic = true;
			PlaySound(sound'TauntPack.R_ownage',,2.5*TransientSoundVolume);
			Controller.Destination = Location + 500 * (Normal(Location - instigatedBy.Location) + VRand());
			Controller.Destination.Z = Location.Z + 100;
			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
			SetTimer( 1.25, false);
		}
	}
	else
	{
		AddVelocity( momentum ); 
		if ( Controller != None )
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
	}
	MakeNoise(1.0);
}

}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    local Vector TossVel;

	if ( bDeleteMe )
		return; //already destroyed

	// mutator hook to prevent deaths
	// WARNING - don't prevent bot suicides - they suicide when really needed
	if ( Level.Game.PreventDeath(self, Killer, damageType, HitLocation) )
	{
		Health = max(Health, 1); //mutator should set this higher
		return;
	}
	Health = Min(0, Health);

    if (Weapon != None)
    {
		if ( Controller != None )
			Controller.LastPawnWeapon = Weapon.Class;
        Weapon.HolderDied();
        TossVel = Vector(GetViewRotation());
        TossVel = TossVel * ((Velocity Dot TossVel) + 500) + Vect(0,0,200);
        TossWeapon(TossVel);
    }

	if ( Controller != None ) 
	{   
		Controller.WasKilledBy(Killer);
		Level.Game.Killed(Killer, Controller, self, damageType);
	}
	else
		Level.Game.Killed(Killer, Controller(Owner), self, damageType);
		
	if ( Killer != None )
		TriggerEvent(Event, self, Killer.Pawn);
	else
		TriggerEvent(Event, self, None);

	Velocity.Z *= 1.3;
	if ( IsHumanControlled() )
		PlayerController(Controller).ForceDeathUpdate();
	Spawn(class'RocketExplosion',,,Location);
	ChunkUp( Rotation, DamageType.default.GibPerterbation );

}

defaultproperties
{
     bMeleeFighter=False
     DodgeSkillAdjust=5.000000
     HitSound(0)=Sound'NewWeaponSounds.BioGoopLoop'
     HitSound(1)=Sound'NewWeaponSounds.BioGoopLoop'
     HitSound(2)=Sound'NewWeaponSounds.BioGoopLoop'
     HitSound(3)=Sound'NewWeaponSounds.BioGoopLoop'
     DeathSound(0)=Sound'PlayerSounds.BFootsteps.FootstepWater1'
     DeathSound(1)=Sound'PlayerSounds.BFootsteps.FootstepWater2'
     DeathSound(2)=Sound'PlayerSounds.BFootsteps.FootstepWater2'
     DeathSound(3)=Sound'PlayerSounds.BFootsteps.FootstepWater1'
     FireSound=Sound'PlayerSounds.BFootsteps.FootstepWater1'
     AmmunitionClass=Class'fpsMonsterPack.MilkGlobAmmo'
     ScoringValue=2
     GibGroupClass=Class'fpsMonsterPack.MiniBotGibGroup'
     GibCountCalf=10
     GibCountForearm=5
     GibCountHead=5
     GibCountTorso=5
     GibCountUpperArm=5
     bCanFly=True
     SightRadius=1000000.000000
     MeleeRange=10000.000000
     AirSpeed=100.000000
     AccelRate=1000.000000
     Health=4000
     ReducedDamageType=Class'XWeapons.DamTypeSuperShockBeam'
     bPhysicsAnimUpdate=False
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'fpsMonMesh.milk.milkmonster'
     AmbientSound=Sound'IndoorAmbience.machinery36'
     DrawScale=0.320000
     Skins(0)=ColorModifier'fpsMonTex.milk.LinkPartCMMilk'
     Skins(1)=FinalBlend'fpsMonTex.milk.LignteingBoltFBMilk'
     Skins(2)=FinalBlend'PickupSkins.Shaders.FinalHealthGlass'
     Skins(3)=FinalBlend'fpsMonTex.milk.milkInFB'
     Skins(4)=FinalBlend'PickupSkins.Shaders.FinalHealthGlass'
     Skins(5)=FinalBlend'fpsMonTex.milk.milkBottomFB'
     CollisionRadius=30.000000
     CollisionHeight=30.000000
     RotationRate=(Pitch=6000,Yaw=65000,Roll=8192)
}
