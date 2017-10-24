class SpellEffect extends Emitter;

/*


	Begin Object Class=SpriteEmitter Name=SpriteEmitter3
		UseColorScale=True
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		UseRandomSubdivision=True
		ColorScale(0)=(Color=(B=255,G=255,R=255))
		ColorScale(1)=(RelativeTime=0.050000,Color=(B=255,G=255,R=255,A=128))
		ColorScale(2)=(RelativeTime=0.800000,Color=(B=128,G=128,R=128,A=128))
		ColorScale(3)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
		MaxParticles=500
		StartLocationOffset=(X=-16.000000)
		StartLocationShape=PTLS_Sphere
		SphereRadiusRange=(Min=1.000000,Max=4.000000)
		UseRotationFrom=PTRS_Actor
		StartSpinRange=(X=(Min=0.550000,Max=0.450000))
		SizeScale(0)=(RelativeSize=0.100000)
		SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
		SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
		StartSizeRange=(X=(Min=25.000000,Max=25.000000))
		ParticlesPerSecond=200.000000
		InitialParticlesPerSecond=200.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=AW-2004Particles.Fire.MuchSmoke1
		TextureUSubdivisions=4
		TextureVSubdivisions=4
		LifetimeRange=(Min=1.000000,Max=1.500000)
		Name="SpriteEmitter3"
	End	Object
	Emitters(1)=SpriteEmitter'SpriteEmitter3'


*/

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=210))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=153))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=5000
         StartLocationOffset=(X=-16.000000)
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=4.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=0.550000,Max=0.450000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.400000)
         StartSizeRange=(X=(Min=25.000000,Max=30.000000))
         ParticlesPerSecond=200.000000
         InitialParticlesPerSecond=200.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames-grey'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=3.000000,Max=3.500000)
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.SpellEffect.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     bHardAttach=True
}
