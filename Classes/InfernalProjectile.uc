class InfernalProjectile extends Projectile;

var class<Emitter> FlyingEffectclass, Explosionclass;
var Sound	ExplosionSound;
var Emitter FlyingEffect;

var bool bHitWater;
var vector Dir;
var float RandSpinAmount;


simulated function Destroyed()
{
	if ( FlyingEffect != None )
		FlyingEffect.Kill();
		
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		FlyingEffect = spawn(FlyingEffectclass, self);
		
		if (FlyingEffect != None)
			FlyingEffect.SetBase(self);
	}
	
	Dir = vector(Rotation);
	Velocity = speed * Dir;
	
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	Super.PostBeginPlay();
	RandSpin(RandSpinAmount);
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	PlaySound(ExplosionSound,,7.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	spawn(Explosionclass,,,HitLocation + HitNormal*16,rotator(HitNormal));
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }
    BlowUp(HitLocation);

	Destroy();
}


simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
	if (Volume.bWaterVolume)
    {
        Velocity *= 0.65;
        FlyingEffect.Kill();        
    }
}

defaultproperties
{
     FlyingEffectclass=Class'fpsMonsterPack.InfernalFlames'
     Explosionclass=Class'Onslaught.ONSTankHitRockEffect'
     ExplosionSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     RandSpinAmount=200000.000000
     Speed=6000.000000
     MaxSpeed=6000.000000
     Damage=1000.000000
     DamageRadius=750.000000
     MomentumTransfer=125000.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeInfernalPlasma'
     ExplosionDecal=Class'fpsMonsterPack.InfernalScorch'
     DrawType=DT_StaticMesh
     AmbientSound=Sound'VMVehicleSounds-S.HoverTank.IncomingShell'
     LifeSpan=6.000000
     DrawScale=3.000000
     AmbientGlow=140
     FluidSurfaceShootStrengthMod=40.000000
     bFullVolume=True
     SoundVolume=255
     SoundRadius=2500.000000
     TransientSoundVolume=1.000000
     TransientSoundRadius=1000.000000
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bUseCollisionStaticMesh=True
     bFixedRotationDir=True
     RotationRate=(Pitch=800,Yaw=1600,Roll=1000)
     DesiredRotation=(Pitch=400,Yaw=1200,Roll=600)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
