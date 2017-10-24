class ReaperDeathOrbEmitter extends Emitter
	placeable;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         ColorScale(0)=(Color=(A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
         Opacity=0.240000
         FadeOutStartTime=5.000000
         FadeInEndTime=0.500000
         MaxParticles=5
         StartSizeRange=(X=(Min=500.000000,Max=500.000000),Y=(Min=500.000000,Max=500.000000),Z=(Min=500.000000,Max=500.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Smoke.Smokepuff'
         LifetimeRange=(Min=5.500000,Max=5.500000)
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.ReaperDeathOrbEmitter.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
}
