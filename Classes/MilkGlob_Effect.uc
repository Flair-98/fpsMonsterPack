class MilkGlob_Effect extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseAbsoluteTimeForSizeScale=True
         UniformSize=True
         UseRandomSubdivision=True
         MaxParticles=25
         SpinCCWorCW=(X=2.000000,Y=2.000000,Z=2.000000)
         SpinsPerSecondRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         StartSpinRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         SizeScale(1)=(RelativeSize=0.200000)
         Texture=Texture'AW-2004Particles.Energy.ElecPanels'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.125000,Max=0.125000)
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.MilkGlob_Effect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         SpinParticles=True
         UniformSize=True
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         Texture=Texture'AW-2004Particles.Energy.EclipseCircle'
         LifetimeRange=(Min=0.010000,Max=0.010000)
     End Object
     Emitters(1)=SpriteEmitter'fpsMonsterPack.MilkGlob_Effect.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         UseSizeScale=True
         UseAbsoluteTimeForSizeScale=True
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.750000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         Opacity=0.400000
         MaxParticles=25
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         Texture=Texture'AW-2004Particles.Energy.SparkHead'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-1500.000000,Max=1500.000000),Y=(Min=-1500.000000,Max=1500.000000),Z=(Min=-1500.000000,Max=1500.000000))
     End Object
     Emitters(2)=SpriteEmitter'fpsMonsterPack.MilkGlob_Effect.SpriteEmitter2'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=10.000000
     Style=STY_Translucent
     bDirectional=True
}
