class FireSuperProjectileChunkC extends Projectile;

var class<Emitter> FlyingEffectclass, Explosionclass;
var class<Projectile> Chunkclass;
var Sound	ExplosionSound;
var Emitter FlyingEffect;
var byte Bounces;
var float DamageAtten;
var sound ImpactSounds[6];
var bool bHitWater;
var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view
var vector Dir;
var float RandSpinAmount;
var int ChunkNumber;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function Destroyed()
{
	if ( FlyingEffect != None )
		FlyingEffect.Kill();
		
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;
    local float DSM;

    DSM = RandRange(0.8, 1.2);
    self.SetDrawScale(DSM);
    
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
   			FlyingEffect = spawn(FlyingEffectClass, self);
	
			if (FlyingEffect != None)
			{
				FlyingEffect.SetBase(self); 
				FlyingEffect.SetDrawScale(DSM);
			}
        }
            
    }

	Dir = vector(Rotation);
	Velocity = speed * Dir;
    
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();
    if (r > 0.75)
        Bounces = 2;
    else if (r > 0.25)
        Bounces = 1;
    else
        Bounces = 0;

    SetRotation(RotRand());
	RandSpin(100000);
    
    Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
	Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (FireSuperProjectileChunkC(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
    {
        speed = VSize(Velocity);
        if ( speed > 200 )
        {
            if ( Role == ROLE_Authority )
			{
				if ( Instigator == None || Instigator.Controller == None )
					Other.SetDelayedDamageInstigatorController( InstigatorController );

                Other.TakeDamage( Max(5, Damage - DamageAtten*FMax(0,(default.LifeSpan - LifeSpan - 1))), Instigator, HitLocation,
                    (MomentumTransfer * Velocity/speed), MyDamageType );
			}
        }
	  Explode(HitLocation,Vect(0,0,1));
        Destroy();
	  
    }
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
ShakeView();
    SpawnChunks(HitNormal);
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

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry 
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	Explode(Location,HitNormal);
        Destroy();
        return;
    }

    SetPhysics(PHYS_Falling);
	if (Bounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(ImpactSounds[Rand(6)]);

        Velocity = 0.65 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
        Bounces = Bounces - 1;
	Explode(Location,HitNormal);
        return;
    }
	bBounce = false;
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
     FlyingEffectClass=Class'FiretrailC'
     Bounces=1
     DamageAtten=6.000000
     ExplosionClass=Class'fireExplosionxC'
     Chunkclass=Class'FireSuperProjectileChunkA'
     ExplosionSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion2'
     RandSpinAmount=200000.000000
     ImpactSounds(0)=Sound'XEffects.Impact4Snd'
     ImpactSounds(1)=Sound'XEffects.Impact6Snd'
     ImpactSounds(2)=Sound'XEffects.Impact7Snd'
     ImpactSounds(3)=Sound'XEffects.Impact3'
     ImpactSounds(4)=Sound'XEffects.Impact1'
     ImpactSounds(5)=Sound'XEffects.Impact2'
     ChunkNumber=4
     ShakeRotMag=(Z=300.000000)
     ShakeRotRate=(Z=2500.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=20.000000)
     ShakeOffsetRate=(Z=300.000000)
     ShakeOffsetTime=6.000000
     Speed=2700.000000
     MaxSpeed=3000.000000
     Damage=164.000000
     DamageRadius=600.000000
     MomentumTransfer=225000.000000
     MyDamageType=Class'DamTypeFireChunkB'
     ExplosionDecal=Class'RocketExplosion'
     DrawType=DT_None
     AmbientSound=Sound'Rocketlauncherprojectile'
     LifeSpan=1000.000000
     Physics=PHYS_Falling
     DrawScale=1.000000
     AmbientGlow=255
     FluidSurfaceShootStrengthMod=40.000000
     bFullVolume=True
     SoundVolume=255
     SoundRadius=300.000000
     TransientSoundVolume=0.600000
     TransientSoundRadius=1000.000000
     CollisionRadius=3.000000
     CollisionHeight=3.000000
     bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightSaturation=20
     LightBrightness=255.000000
     LightRadius=55.000000
     bBounce=True
     bUseCollisionStaticMesh=True
     bFixedRotationDir=True
     RotationRate=(Pitch=800,Yaw=1600,Roll=1000)
     DesiredRotation=(Pitch=400,Yaw=1200,Roll=600)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
