class MilkGlobChocolate extends projectile;

var MilkGlob_EffectChocolate trail;

simulated function Destroyed()
{
    if (Trail != none)
        Trail.Destroy();
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Velocity = Vector(Rotation);
    Velocity *= Speed;
    if ( Level.NetMode != NM_DedicatedServer)
    {
        Trail = Spawn(class'MilkGlob_EffectChocolate',self);
        Trail.SetBase(self);
    }
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

    if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
        return;
    }
    if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
        if ( Role == ROLE_Authority )
        {
            if ( Instigator == None || Instigator.Controller == None )
                Other.SetDelayedDamageInstigatorController( InstigatorController );
            Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
        }
        Explode(HitLocation, vect(0,0,1));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'MilkSparks',,, HitLocation, rotator(HitNormal));
    }
    HurtRadius(Damage,DamageRadius,MyDamageType,MomentumTransfer,HitLocation);
    PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');
    Spawn(class'fpsMonsterPack.MilkGlobHit',,, HitLocation + HitNormal*8, Rotator(HitNormal));
    Destroy();
}

defaultproperties
{
     Speed=4000.000000
     Damage=500.000000
     DamageRadius=200.000000
     MomentumTransfer=1000.000000
     MyDamageType=Class'fpsMonsterPack.MilkGlob_dmgtype'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_Sprite
     CullDistance=3500.000000
     bHidden=True
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=10.000000
     Texture=Texture'XEffects.BlueMarker_t'
     DrawScale=0.300000
     AmbientGlow=96
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=6.000000
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=40.000000
     CollisionHeight=40.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
