class TinyBlueFlame extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         UseColorScale=True
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=2,R=2,A=255))
         Opacity=0.300000
         FadeOutStartTime=0.050000
         FadeInEndTime=0.030000
         MaxParticles=40
         StartLocationRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000))
         StartLocationPolarRange=(Y=(Min=65536.000000,Max=65536.000000),Z=(Max=180.000000))
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=0.780000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.100000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames-grey'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.TinyBlueFlame.SpriteEmitter6'

     bNoDelete=False
}
