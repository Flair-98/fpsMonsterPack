class Reapersmoke extends Emitter
	placeable;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         Acceleration=(Z=5.000000)
         ColorScale(0)=(Color=(A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
         Opacity=0.100000
         FadeOutStartTime=3.120000
         FadeInEndTime=0.280000
         MaxParticles=50
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=10.000000,Max=20.000000)
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.780000,RelativeSize=3.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.100000)
         StartSizeRange=(X=(Min=30.000000,Max=60.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Smoke.Smokepuff'
         StartVelocityRange=(X=(Max=5.000000),Z=(Min=7.000000,Max=10.000000))
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.Reapersmoke.SpriteEmitter0'

     bNoDelete=False
     bDirectional=True
}
