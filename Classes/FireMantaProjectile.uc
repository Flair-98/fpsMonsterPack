//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FireMantaProjectile extends Projectile;

var class<Emitter> FlyingEffectclass, Explosionclass;
var class<Projectile> Chunkclass;
var Sound	ExplosionSound;
var Emitter FlyingEffect;

var bool bHitWater;
var vector Dir;
var float RandSpinAmount;
var int ChunkNumber;

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
	PlaySound(ExplosionSound,,4.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	spawn(Explosionclass,,,HitLocation + HitNormal*16,rotator(HitNormal));
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }
    BlowUp(HitLocation);
    SpawnChunks(HitNormal);
	Destroy();
}

simulated function SpawnChunks(vector HitNormal)
{
	local vector Start;
    local rotator rot;
    local int i;
    local Projectile NewChunk;
	
    Start = Location + 10 * HitNormal;
    
	if ( Role == ROLE_Authority )
	{
		for (i=0; i<ChunkNumber; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewChunk = spawn(Chunkclass,, '', Start, rot);
		}
	}
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
     FlyingEffectClass=Class'FireMantaTrail'
     ExplosionClass=Class'fireExplosiony'
     Chunkclass=Class'FireFlame'
     ExplosionSound=Sound'ONSVehicleSounds-S.Explosions.Explosion09'
     RandSpinAmount=200000.000000
     ChunkNumber=5
     Speed=3300.000000
     MaxSpeed=5000.000000
     Damage=89.000000
     DamageRadius=390.000000
     MomentumTransfer=125000.000000
     MyDamageType=Class'DamTypeFireChunkB'
     ExplosionDecal=Class'RocketExplosion'
     DrawType=DT_None
     AmbientSound=Sound'Rocketlauncherprojectile'
     LifeSpan=1000.000000
     DrawScale=1.000000
     AmbientGlow=140
     FluidSurfaceShootStrengthMod=40.000000
     bFullVolume=True
     SoundVolume=255
     SoundRadius=400.000000
     TransientSoundVolume=2.000000
     TransientSoundRadius=1000.000000
     CollisionRadius=3.000000
     CollisionHeight=3.000000
     bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightSaturation=20
     LightBrightness=255.000000
     LightRadius=35.000000
     bUseCollisionStaticMesh=True
     bFixedRotationDir=True
     RotationRate=(Pitch=800,Yaw=1600,Roll=1000)
     DesiredRotation=(Pitch=400,Yaw=1200,Roll=600)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
