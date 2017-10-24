class FireProj extends Projectile;

var xEmitter Flame;
var() class<xEmitter> FlameClass;
var() class<DamageType> DamageType, BurnDamageType;
var bool bDoTouch;

simulated function PreBeginPlay()
{
	if(Role < ROLE_Authority)
		return;

	if(FRand() > 0.6)
		AmbientSound = None;
	else
		SoundPitch = 16 + Rand(48);
}

simulated function PostBeginPlay()
{
	//No fire underwater.
	if(PhysicsVolume.bWaterVolume)
	{
		Destroy();
		return;
	}

	Super.PostBeginPlay();

	if(Level.Netmode != NM_DedicatedServer)
	{
		Flame = spawn(FlameClass);
		Flame.SetBase(self);

		if(FRand() > 0.8)
		{
			bDynamicLight = true;
			LightHue = Default.LightHue + Rand(20);
		}
	}

	SetTimer(0.1, true);
}

simulated function PostNetBeginPlay()
{
	Velocity = Vector(Rotation) * Speed;
	Acceleration = Velocity / 1.5;

	if(Instigator != None)
		Velocity += 0.7 * Instigator.Velocity;
}

function Timer()
{

	//Flames expand with time.
	SetCollisionSize(CollisionRadius + 2.5, CollisionHeight + 2.5);

	//Simple damage radius.
	if(Role == ROLE_Authority)
	{
		//Damage reduces with distance.
		Damage = Max(Default.Damage * Sqrt(Default.CollisionHeight / CollisionHeight), 1);
		HurtRadius(Damage, CollisionRadius * 5, MyDamageType, MomentumTransfer, Location);
	}
	bDoTouch = !bDoTouch;
}

//No fire underwater.
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	if(NewVolume.bWaterVolume)
	{
		PlaySound(sound'GeneralAmbience.steamfx4', SLOT_Interact);

		if(Level.Netmode != NM_DedicatedServer && !Level.bDropDetail && FRand() > 0.4)
			Spawn(class'SteamEmitter');

		Destroy();
	}
}

simulated function Landed(vector HitNormal)
{
	HitWall(HitNormal, None);
}

//Bounce, but stick close to surface.
simulated function HitWall(vector HitNormal, actor Wall)
{
	Acceleration *= 0;
	Velocity = 0.8 * (Velocity - 1.1*HitNormal*(Velocity dot HitNormal));
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){}
simulated function BlowUp(vector HitLocation){}
simulated function Explode(vector HitLocation, vector HitNormal){}

defaultproperties
{
     BurnDamageType=Class'fpsMonsterPack.DamTypeFireChuckerFire'
     Speed=800.000000
     MaxSpeed=1100.000000
     TossZ=0.000000
     Damage=15.000000
     DamageRadius=40.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeFireChucker'
     LightType=LT_Steady
     LightHue=12
     LightSaturation=128
     LightBrightness=64.000000
     LightRadius=16.000000
     DrawType=DT_None
     LifeSpan=30.250000
     bFullVolume=True
     SoundVolume=255
     SoundPitch=56
     SoundRadius=256.000000
     CollisionRadius=3.500000
     CollisionHeight=3.500000
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bBounce=True
}
