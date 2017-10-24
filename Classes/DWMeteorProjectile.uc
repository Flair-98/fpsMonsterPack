class DWMeteorProjectile extends Projectile;

var class<Emitter> FlyingEffectclass, Explosionclass;
var Sound	ExplosionSound;
var Emitter FlyingEffect;

var bool bHitWater;
var vector Dir;


function Destroyed()
{
	if ( FlyingEffect != None )
		FlyingEffect.Kill();
		
	Super.Destroyed();
}

function PostBeginPlay()
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

}

function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

function Explode(vector HitLocation, vector HitNormal)
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



function PhysicsVolumeChange( PhysicsVolume Volume )
{
	if (Volume.bWaterVolume)
    {
        Velocity *= 0.65;
        FlyingEffect.Kill();        
    }
}

defaultproperties
{
     FlyingEffectclass=Class'fpsMonsterPack.DWMeteorFlames'
     Explosionclass=Class'fpsMonsterPack.DWMeteorExplosion'
     ExplosionSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     Speed=3000.000000
     MaxSpeed=3000.000000
     Damage=500.000000
     DamageRadius=500.000000
     MomentumTransfer=125000.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeMeteor'
     ExplosionDecal=Class'fpsMonsterPack.DWMeteorScorch'
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
