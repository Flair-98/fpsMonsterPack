class ReaperEnergyBall_inHand extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(G=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,A=255))
         Opacity=0.120000
         FadeOutStartTime=0.044000
         MaxParticles=50
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.700000)
         StartSizeRange=(X=(Min=8.000000,Max=8.000000),Y=(Min=8.000000,Max=8.000000),Z=(Min=8.000000,Max=8.000000))
         Texture=Texture'EmitterTextures.MultiFrame.Effect_D'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.ReaperEnergyBall_inHand.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=FlashGlow
         ProjectionNormal=(X=1.000000,Z=0.000000)
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=1,G=254,R=27,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=19,G=255,A=255))
         Opacity=0.480000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000))
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=10000.000000
         Texture=Texture'XEffectMat.Link.link_muz_green'
         LifetimeRange=(Min=1.001000,Max=1.001000)
     End Object
     Emitters(1)=SpriteEmitter'fpsMonsterPack.ReaperEnergyBall_inHand.FlashGlow'

     AutoDestroy=True
     bNoDelete=False
     bTrailerSameRotation=True
     bNetTemporary=True
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.850000
}
