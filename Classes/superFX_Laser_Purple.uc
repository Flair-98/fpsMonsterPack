class superFX_Laser_Purple extends Emitter
	notplaceable;

simulated function SetRedColor()
{
	Emitters[0].ColorScale[0].Color = class'Canvas'.static.MakeColor(200, 80, 48);
	Emitters[0].ColorScale[1].Color = Emitters[0].ColorScale[0].Color;
	Emitters[1].ColorScale[0].Color = Emitters[0].ColorScale[0].Color;
	Emitters[1].ColorScale[1].Color = Emitters[0].ColorScale[0].Color;
}

simulated function SetScale( float Scale, optional float LengthScale )
{
	if ( LengthScale == 0.f )
		LengthScale = 1.f;

	Emitters[0].StartSizeRange.X.Min = 150 * Scale;
	Emitters[0].StartSizeRange.X.Max = Emitters[0].StartSizeRange.X.Min;
	Emitters[0].StartLocationOffset.X = 150 * Scale * LengthScale;

	Emitters[1].StartLocationOffset.X = -120  - 30 * Scale * LengthScale;
	Emitters[1].StartSizeRange.X.Min = 30 * Scale;
	Emitters[1].StartSizeRange.X.Max = Emitters[1].StartSizeRange.X.Min;
	BeamEmitter(Emitters[1]).BeamEndPoints[0].Offset.X.Min = 600 * Scale * LengthScale;
	BeamEmitter(Emitters[1]).BeamEndPoints[0].Offset.X.Max = BeamEmitter(Emitters[1]).BeamEndPoints[0].Offset.X.Min;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=128,R=180))
         ColorScale(1)=(RelativeTime=0.750000,Color=(B=255,G=64,R=120))
         ColorScale(2)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationOffset=(X=150.000000)
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.500000)
         SizeScale(2)=(RelativeTime=0.150000,RelativeSize=1.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=0.750000)
         StartSizeRange=(X=(Min=160.000000,Max=160.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         InitialDelayRange=(Min=0.150000,Max=0.150000)
     End Object
     Emitters(0)=SpriteEmitter'superFX_Laser_purple.SpriteEmitter1'

     Begin Object Class=BeamEmitter Name=BeamEmitter1
         BeamEndPoints(0)=(offset=(X=(Min=1200.000000,Max=1200.000000)),Weight=3.000000)
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         LowFrequencyPoints=2
         HighFrequencyPoints=2
         UseColorScale=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=128,G=64,R=168))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=128,R=170))
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationOffset=(X=-150.000000)
         StartSizeRange=(X=(Min=190.000000,Max=190.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AS_FX_TX.Beams.LaserTex'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=20.000000,Max=20.000000)
     End Object
     Emitters(1)=BeamEmitter'superFX_Laser_purple.BeamEmitter1'

     bNoDelete=False
     bDirectional=True
}
