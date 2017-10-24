class FireTrailC extends Emitter
	notplaceable;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter30
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         UseVelocityScale=True
         Acceleration=(Z=30.000000)
         ColorScale(0)=(Color=(B=192,G=192,R=192))
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=160,G=160,R=160,A=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=128,G=128,R=128,A=192))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
         MaxParticles=50
         StartLocationRange=(Z=(Max=20.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=115.000000,Max=120.000000))
         ParticlesPerSecond=35.000000
         InitialParticlesPerSecond=35.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Weapons.DustSmoke'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.500000,Max=2.900000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=200.000000,Max=200.000000))
         VelocityScale(0)=(RelativeVelocity=(Z=0.500000))
         VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=0.200000))
     End Object
     Emitters(0)=SpriteEmitter'FireTrailC.SpriteEmitter30'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter31
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=45.000000)
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=0,G=110,R=200,A=255))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=255,G=255,R=255,A=50))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         StartLocationShape=PTLS_All
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.200000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=120.000000,Max=120.000000))
         ParticlesPerSecond=40.000000
         InitialParticlesPerSecond=40.000000
         Texture=Texture'Emittertextures.largeflames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.700000,Max=0.900000)
         StartVelocityRange=(Z=(Min=2.000000,Max=2.000000))
     End Object
     Emitters(1)=SpriteEmitter'FireTrailC.SpriteEmitter31'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter32
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=9,G=175,R=255))
         ColorScale(2)=(RelativeTime=0.400000,Color=(B=0,G=65,R=242))
         ColorScale(3)=(RelativeTime=1.000000)
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=110.000000,Max=120.000000))
         ParticlesPerSecond=30.000000
         InitialParticlesPerSecond=30.000000
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=0.280000,Max=0.280000)
         StartVelocityRange=(Z=(Min=30.000000,Max=40.000000))
     End Object
     Emitters(2)=SpriteEmitter'FireTrailC.SpriteEmitter32'

     bNoDelete=False
}
