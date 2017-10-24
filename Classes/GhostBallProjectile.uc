class GhostBallProjectile extends Projectile;

var		FX_Laser_Purple			Laser;
var		class<FX_Laser_Purple>	LaserClass;		// Human
var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();

	Velocity		= Speed * Vector(Rotation);
	Acceleration	= Velocity;
	SetupProjectile();
}


simulated function Destroyed()
{
    if ( Laser != None )
        Laser.Destroy();

	super.Destroyed();
}

simulated function SetupProjectile()
{
	// FX
	if ( Level.NetMode != NM_DedicatedServer )
	{
		Laser = Spawn(LaserClass, Self,, Location, Rotation);

		if ( Laser != None )
		{
			Laser.SetBase( Self );
			Laser.SetScale( 0.67, 0.67 );
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
	SpawnExplodeFX(HitLocation, HitNormal);
    PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');
	BlowUp(HitLocation);
	ShakeView();
	Destroy();
}

simulated function SpawnExplodeFX(vector HitLocation, vector HitNormal)
{
	if ( EffectIsRelevant(Location, false) )
	{
		Spawn(class'GhostBallPExplosion',,, HitLocation + HitNormal * 2, rotator(HitNormal));
		Spawn(class'ComboDecal',,, HitLocation + HitNormal * 2, rotator(HitNormal));
	}
}

    function ShakeView()
    {
        local Controller C;
        local PlayerController PC;
        local float Dist, Scale;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            PC = PlayerController(C);
            if ( PC != None && PC.ViewTarget != None )
            {
                Dist = VSize(Location - PC.ViewTarget.Location);
                if ( Dist < DamageRadius * 2.0)
                {
                    if (Dist < DamageRadius)
                        Scale = 1.0;
                    else
                        Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                    C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }
    }

//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	if ( Other == Instigator || Other == Owner || Other.Owner == Instigator || Other.Base == Instigator )
		return false;

	super.EncroachingOn( Other );
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local float		AdjustedDamage;

	if ( Instigator != None )
	{
		if (Other == Instigator) return;
		if (Other.Owner == Instigator || Other.Base == Instigator) return;
	}

	if (Other == Owner) return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );

			AdjustedDamage = Damage;
			if ( ASVehicle_Sentinel(Instigator) != None && ASVehicle_Sentinel(Instigator).bSpawnCampProtection )
				AdjustedDamage *= 10;

			Other.TakeDamage(AdjustedDamage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
		Explode(HitLocation, -Normal(Velocity));
	}
}


//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     LaserClass=Class'FX_Laser_Purple'
     ShakeRotMag=(Z=100.000000)
     ShakeRotRate=(Z=1500.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=8.000000)
     ShakeOffsetRate=(Z=180.000000)
     ShakeOffsetTime=5.000000
     Speed=2500.000000
     MaxSpeed=3000.000000
     Damage=90.000000
     DamageRadius=200.000000
     MomentumTransfer=21000.000000
     MyDamageType=Class'DamTypeGhostBallP'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=195
     LightSaturation=85
     LightBrightness=255.000000
     LightRadius=175.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     DrawType=DT_None
     AmbientSound=Sound'WeaponSounds.LinkGun.LinkGunProjectile'
     LifeSpan=100.000000
     SoundVolume=255
     SoundRadius=400.000000
     TransientSoundVolume=1.800000
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=5.000000
}
