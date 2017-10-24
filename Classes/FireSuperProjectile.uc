class FireSuperProjectile extends Projectile;

var class<Emitter> FlyingEffectclass, Explosionclass;
var class<Projectile> Chunkclass;
var class<Projectile> Chunkclass2;
var class<Projectile> Chunkclass5;
var class<Projectile> Chunkclass7;
var class<Pawn> Chunkclass3;
var class<Pawn> Chunkclass4;
var class<Pawn> Chunkclass6;
var Sound	ExplosionSound;
var Emitter FlyingEffect;
var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view
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
	PlaySound(ExplosionSound,,7.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	spawn(Explosionclass,,,HitLocation + HitNormal*16,rotator(HitNormal));
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }
    BlowUp(HitLocation);
    SpawnChunks(HitNormal);
	ShakeView();
	Destroy();
}

simulated function SpawnChunks(vector HitNormal)
{
	local vector Start;
    local rotator rot;
    local int i;
    local Projectile NewChunk;
    local Projectile NewChunk2;
    local Pawn NewChunk3;
    local Pawn NewChunk4;
    local Projectile NewChunk5;
    local Pawn NewChunk6;
    local Projectile NewChunk7;
	
    Start = Location + 10 * HitNormal;
    
	if ( Role == ROLE_Authority )
	{
		for (i=0; i<ChunkNumber; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			if (FRand() < 0.75)
			{
			NewChunk = spawn(Chunkclass,, '', Start, rot);
			}
			else
			{
				if (FRand() < 0.19)
				{
					NewChunk4 = spawn(Chunkclass4,, '', Start, rot);
				}
				else
				{
					if (FRand() < 0.19)
					{
						NewChunk3 = spawn(Chunkclass3,, '', Start, rot);
					}
					else
					{
						if (FRand() < 0.05)
						{
							NewChunk5 = spawn(Chunkclass5,, '', Start, rot);
						}
						else
						{
							if (FRand() < 0.172)
							{
								NewChunk6 = spawn(Chunkclass6,, '', Start, rot);
							}
							else
							{
								if (FRand() < 0.01)
								{
									NewChunk7 = spawn(Chunkclass7,, '', Start, rot);
								}
								else
								{
									NewChunk2 = spawn(Chunkclass2,, '', Start, rot);
								}
							}
						}
					}
				}
			}
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

defaultproperties
{
     FlyingEffectClass=Class'FireSuperProjectileTrail'
     ExplosionClass=Class'Dweather.DWMeteorExplosion'
     Chunkclass=Class'FireSuperProjectileChunkA'
     Chunkclass2=Class'FireSuperProjectileChunkB'
     Chunkclass3=Class'FireGhostBall'
     Chunkclass4=Class'FireBGhostBall'
     Chunkclass5=Class'FireSuperProjectileChunkC'
     Chunkclass6=Class'FireMantaGhostball'
     Chunkclass7=Class'FireSuperProjectileChunkD'
     ShakeRotMag=(Z=500.000000)
     ShakeRotRate=(Z=4700.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(Z=10.000000)
     ShakeOffsetRate=(Z=200.000000)
     ShakeOffsetTime=6.000000
     ExplosionSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     RandSpinAmount=200000.000000
     ChunkNumber=7
     Speed=2800.000000
     MaxSpeed=4000.000000
     Damage=400.000000
     DamageRadius=600.000000
     MomentumTransfer=32500.000000
     MyDamageType=Class'DamTypeFireSuperGhostBallP'
     ExplosionDecal=Class'Dweather.DWMeteorScorch'
     DrawType=DT_None
     AmbientSound=Sound'VMVehicleSounds-S.HoverTank.IncomingShell'
     LifeSpan=600.000000
     DrawScale=3.000000
     AmbientGlow=140
     FluidSurfaceShootStrengthMod=70.000000
     bFullVolume=True
     SoundVolume=255
     SoundRadius=500.000000
     TransientSoundVolume=0.700000
     TransientSoundRadius=1000.000000
     CollisionRadius=9.000000
     CollisionHeight=9.000000
     bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightSaturation=20
     LightBrightness=255.000000
     LightRadius=105.000000
     bUseCollisionStaticMesh=True
     bFixedRotationDir=True
     RotationRate=(Pitch=800,Yaw=1600,Roll=1000)
     DesiredRotation=(Pitch=400,Yaw=1200,Roll=600)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
