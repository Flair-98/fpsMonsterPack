class FireSuperProjectileTrail extends Emitter
	notplaceable;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         FadeOutStartTime=1.000000
         FadeInEndTime=0.700000
         MaxParticles=250
         SizeScale(0)=(RelativeTime=3.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=100.000000,Max=100.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'VMParticleTextures.VehicleExplosions.smokeCloudTEX'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         StartVelocityRange=(Z=(Min=5.000000,Max=5.000000))
     End Object
     Emitters(0)=SpriteEmitter'FireSuperProjectileTrail.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         AutoReset=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Acceleration=(Z=45.000000)
         FadeOutStartTime=0.200000
         FadeInEndTime=0.200000
         MaxParticles=70
         ParticlesPerSecond=35.000000
         InitialParticlesPerSecond=35.000000
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.200000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Max=25.000000))
         Texture=Texture'Emittertextures.largeflames'
	   TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.100000,Max=0.300000)
     End Object
     Emitters(1)=SpriteEmitter'FireSuperProjectileTrail.SpriteEmitter1'

     bNoDelete=False
}
