class FireBallExplosionEmitter extends Emitter;


//Allows for dynamic changing of the emitter's size and opacity.
function Scale(float Scaling, float Opacity)
{
	Opacity = FMax(0, Opacity);

	Emitters[0].StartSizeRange.X.Min *= Scaling;
	Emitters[0].StartSizeRange.X.Max *= Scaling;

	Emitters[0].ColorMultiplierRange.X.Min *= Opacity;
	Emitters[0].ColorMultiplierRange.X.Max *= Opacity;
	Emitters[0].ColorMultiplierRange.Y.Min *= Opacity;
	Emitters[0].ColorMultiplierRange.Y.Max *= Opacity;
	Emitters[0].ColorMultiplierRange.Z.Min *= Opacity;
	Emitters[0].ColorMultiplierRange.Z.Max *= Opacity;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=112,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(G=102,R=204))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.300000
         CoordinateSystem=PTCS_Relative
         StartSpinRange=(X=(Max=65536.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=4.000000,Max=6.000000))
         InitialParticlesPerSecond=50.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'EmitterTextures.SingleFrame.FlamePart_02'
         LifetimeRange=(Min=0.700000,Max=0.700000)
         StartVelocityRange=(Z=(Min=-2.000000,Max=7.000000))
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.FireBallExplosionEmitter.SpriteEmitter0'

     bNoDelete=False
     LifeSpan=1.000000
}
