//=============================================================================
//=============================================================================
class suck extends PlayerSpawnEffect;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter40
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ResetOnTrigger=True
         ColorScale(0)=(Color=(B=255,G=255,R=128))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=64,R=64))
         ColorScale(2)=(Color=(B=255,G=255,R=128))
         ColorMultiplierRange=(Y=(Min=0.700000))
         MaxParticles=40
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=80.000000,Max=80.000000)
         SpinsPerSecondRange=(X=(Min=0.250000,Max=0.250000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000))
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.700000,Max=0.700000)
         StartVelocityRadialRange=(Min=120.000000,Max=120.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.Suck.SpriteEmitter40'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter41
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ResetOnTrigger=True
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=255,G=128,R=128))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=3
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=7.000000,Max=7.000000))
         InitialParticlesPerSecond=12.000000
         Texture=Texture'AW-2004Particles.Fire.BlastMark'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'fpsMonsterPack.Suck.SpriteEmitter41'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter35
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=202,G=72,R=53))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=182,G=48,R=62))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=182,G=74,R=48))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=2
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=0.800000,RelativeSize=10.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=12.000000,Max=12.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Min=0.800000,Max=0.800000)
     End Object
     Emitters(2)=SpriteEmitter'fpsMonsterPack.Suck.SpriteEmitter35'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter37
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=242,G=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=128,R=128))
         FadeOutStartTime=0.600000
         FadeInEndTime=0.200000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=150.000000,Max=150.000000)
         StartSpinRange=(X=(Min=0.500000,Max=0.500000))
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=25.000000,Max=25.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'EpicParticles.Beams.WhiteStreak01aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.800000,Max=0.800000)
         StartVelocityRadialRange=(Min=200.000000,Max=200.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'fpsMonsterPack.Suck.SpriteEmitter37'

}
