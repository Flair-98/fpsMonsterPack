class FireExplosionz extends Emitter
	notplaceable;

var Sound	ExplosionSound[11];
var byte	bPlayed[11];

auto State Explosion
{

Begin:
	PlayUniqueRandomExplosion();
	PlayUniqueRandomExplosion();
	
	Sleep(0.33);
	PlayUniqueRandomExplosion();
}

simulated function PlayUniqueRandomExplosion()
{
	local int Num;
	
	Num = Rand(42) % 11;
	if ( bPlayed[Num] > 0 )	
	{	// try again if already played this sound...
		PlayUniqueRandomExplosion();
		return;
	}

	PlaySound(ExplosionSound[Num],, 0.2,, 40);
	bPlayed[Num] = 1;
}

defaultproperties
{
     ExplosionSound(0)=Sound'ONSVehicleSounds-S.Explosions.Explosion01'
     ExplosionSound(1)=Sound'ONSVehicleSounds-S.Explosions.Explosion02'
     ExplosionSound(2)=Sound'ONSVehicleSounds-S.Explosions.Explosion03'
     ExplosionSound(3)=Sound'ONSVehicleSounds-S.Explosions.Explosion04'
     ExplosionSound(4)=Sound'ONSVehicleSounds-S.Explosions.Explosion05'
     ExplosionSound(5)=Sound'ONSVehicleSounds-S.Explosions.Explosion06'
     ExplosionSound(6)=Sound'ONSVehicleSounds-S.Explosions.Explosion07'
     ExplosionSound(7)=Sound'ONSVehicleSounds-S.Explosions.Explosion08'
     ExplosionSound(8)=Sound'ONSVehicleSounds-S.Explosions.Explosion09'
     ExplosionSound(9)=Sound'ONSVehicleSounds-S.Explosions.Explosion10'
     ExplosionSound(10)=Sound'ONSVehicleSounds-S.Explosions.Explosion11'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         MaxParticles=1
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=0.000000,Max=0.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.250000)
         StartSizeRange=(X=(Min=45.000000,Max=85.000000))
         SpawningSound=PTSC_Random
         InitialParticlesPerSecond=6.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'ExplosionTex.Framed.we1_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=0.700000)
     End Object
     Emitters(0)=SpriteEmitter'FireExplosionz.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=45,G=158,R=234))
         ColorScale(2)=(RelativeTime=0.670000,Color=(B=45,G=158,R=234))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=1.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=60.000000,Max=70.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.670000,Max=0.670000)
     End Object
     Emitters(1)=SpriteEmitter'FireExplosionz.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
}
