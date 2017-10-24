//=============================================================================
// rocket.    all credit goes to rosebum
//=============================================================================
class RedFlameShot extends SeekingRocketProj;

//var	xEmitter SmokeTrail;
//var vector Dir;

simulated function Destroyed() 
{
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		//if ( !Level.bDropDetail )
		//spawn(class'RocketSmokeRing',,,Location, Rotation );
		SmokeTrail = Spawn(class'RedFlame',self);
	}
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	 SetTimer(0.1, true);
	Super(Projectile).PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) ) 
		Explode(HitLocation,Vect(0,0,1));
		if (Pawn(Other) != None)
		{
			if (Pawn(Other).Weapon != None)
			{
				Pawn(Other).Weapon.Destroy();
				Pawn(Other).Controller.ClientSwitchToBestWeapon();
			}
		}
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
	spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
	spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
 	
	BlowUp(HitLocation);
	Destroy(); 
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType)
{
	if ( (Damage > 0) && ((InstigatedBy == None) || (InstigatedBy.Controller == None) || (Instigator == None) || (Instigator.Controller == None) || !InstigatedBy.Controller.SameTeamAs(Instigator.Controller)) )
	{
		
		   
		
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, DamageType);
}


simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);
         
	Acceleration = vect(0,0,0);
    Super.Timer();
    if ( (Seeking != None) && (Seeking != Instigator) ) 
    {
		// Do normal guidance to target.
		ForceDir = Normal(Seeking.Location - Location);
		
		if( (ForceDir Dot InitialDir) > 0 )
		{
			VelMag = VSize(Velocity);
		
			// track vehicles better
			if ( Seeking.Physics == PHYS_Karma )
				ForceDir = Normal(ForceDir * 4.8 * VelMag + Velocity);
			else
				ForceDir = Normal(ForceDir * 4.5 * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;  
			Acceleration += 5 * ForceDir; 
		}
		// Update rocket so it faces in the direction its going.
		SetRotation(rotator(Velocity));
    }
}

defaultproperties
{
     Speed=1550.000000
     MaxSpeed=1550.000000
     Damage=300.000000
     DamageRadius=140.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeRedFlame'
     DrawType=DT_Sprite
     bHidden=True
     LifeSpan=6.000000
     Texture=Texture'XEffectMat.Link.link_muz_red'
     DrawScale=0.300000
     Style=STY_Translucent
}
