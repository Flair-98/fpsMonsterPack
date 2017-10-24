class FireExplosionxC extends Emitter
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

	PlaySound(ExplosionSound[Num],, 1,, 400);
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
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=32.000000,Max=64.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.250000)
         StartSizeRange=(X=(Min=200.000000,Max=225.000000))
         SpawningSound=PTSC_Random
         InitialParticlesPerSecond=6.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'ExplosionTex.Framed.we1_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.600000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'FireExplosionxC.SpriteEmitter0'

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
         StartSizeRange=(X=(Min=375.000000,Max=375.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.670000,Max=1.670000)
     End Object
     Emitters(1)=SpriteEmitter'FireExplosionxC.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseCollision=True
         RespawnDeadParticles=False
         AutoDestroy=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-750.000000)
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=48.000000,Max=64.000000)
         StartSizeRange=(X=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=2000.000000
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=3.000000,Max=0.670000)
         InitialDelayRange=(Min=0.250000,Max=0.250000)
         StartVelocityRadialRange=(Min=-800.000000,Max=-800.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(2)=SpriteEmitter'FireExplosionxC.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         MaxParticles=5
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=28.000000,Max=64.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Max=350.000000))
         SpawningSound=PTSC_Random
         InitialParticlesPerSecond=9.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'Part_explode2'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=1.000000)
         InitialDelayRange=(Min=0.550000,Max=0.550000)
     End Object
     Emitters(3)=SpriteEmitter'FireExplosionxC.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         MaxParticles=1
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.670000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=350.000000,Max=375.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'ExplosionTex.Framed.exp2_framesP'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(4)=SpriteEmitter'FireExplosionxC.SpriteEmitter5'

     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
}
