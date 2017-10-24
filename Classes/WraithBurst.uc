//=============================================================================
//=============================================================================
class WraithBurst extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter41
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ResetOnTrigger=True
         ColorScale(0)=(Color=(B=55,G=142,R=53))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=98,G=43,R=91))
         MaxParticles=3
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=7.000000,Max=7.000000))
         InitialParticlesPerSecond=12.000000
         Texture=Texture'AW-2004Particles.Energy.EclipseCircle'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.WraithBurst.SpriteEmitter41'

     AutoDestroy=True
     CullDistance=6500.000000
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
}
