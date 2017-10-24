class ReaperProjectile extends Projectile; 

var Emitter ReaperBall;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
    {

		ReaperBall = Spawn(class'ReaperEnergyBall', self);
		ReaperBall.Setbase(Self);

	}

	Velocity = Speed * Vector(Rotation); 
}

simulated function Destroyed()
{
	if ( ReaperBall != None )
		ReaperBall.Kill();
	Super.Destroyed();
}



simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

   	PlaySound(ImpactSound, SLOT_Misc);
	//if (ReaperBall != None)
	//	ReaperBall.Destroy();
	SetCollisionSize(0.0, 0.0);

	Destroy();
}

defaultproperties
{
     Speed=4000.000000
     MaxSpeed=4000.000000
     Damage=30.000000
     DamageRadius=150.000000
     MomentumTransfer=70000.000000
     MyDamageType=Class'XWeapons.DamTypeShockBall'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=100
     LightSaturation=85
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=10.000000
     Texture=Texture'XEffectMat.Link.link_muz_green'
     DrawScale=0.100000
     Skins(0)=Texture'XEffectMat.Link.link_muz_green'
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=60.000000
}
