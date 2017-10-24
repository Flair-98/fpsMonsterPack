//Cool particle effect that surrounds the Flame Monster Class all credit goes to rosebum
class MonsterBlueFlame extends Emitter;

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	/*if (Instigator != None)
		Owner = Instigator;*/
	if (Level.NetMode == NM_Client)
		Initialize();
		
}

simulated function Initialize()
{
	if (Level.NetMode == NM_DedicatedServer)
	{
		LifeSpan = 300.0;
	}
	else if (DrawScale > 1.5)
	{
		/*Emitters[0].StartLocationRange.X.Min *= DrawScale;
		Emitters[0].StartLocationRange.X.Max *= DrawScale;
		Emitters[0].StartLocationRange.Y.Min *= DrawScale;
		Emitters[0].StartLocationRange.Y.Max *= DrawScale;*/
		Emitters[0].StartLocationPolarRange.Z.Max *= DrawScale;
		Emitters[0].StartLocationPolarRange.Z.Min *= DrawScale;
		Emitters[0].InitialParticlesPerSecond *= DrawScale;
	}
	SetTimer(1,True);
}

simulated function Timer()
{
	local Pawn P;
    
    P = Monster(Owner);

    if (P == None)
    {
        kill();
        return;
		SetTimer(0,False);
    }
}

simulated function Tick(float deltaTime)
{
	//hackish way to increase max particles since MaxParticles is const
	if (Emitters[0].Initialized)
	{
		Emitters[0].MaxActiveParticles *= DrawScale;
		Emitters[0].Particles.Length = Emitters[0].MaxActiveParticles;
		disable('Tick');
	}
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter69
         UseColorScale=True
         FadeOut=True
         UniformMeshScale=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(Z=20.000000)
         ColorScale(0)=(Color=(B=210))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=153))
         FadeOutStartTime=0.900000
         MaxParticles=300
         StartLocationOffset=(Y=45.000000)
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Max=65536.000000),Z=(Min=50.000000,Max=50.000000))
         RevolutionsPerSecondRange=(Z=(Min=0.200000,Max=0.200000))
         UseRotationFrom=PTRS_Offset
         RotationOffset=(Roll=16384)
         SpinsPerSecondRange=(X=(Min=0.220000,Max=0.285000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=30.000000,Max=40.000000),Y=(Min=30.000000,Max=40.000000),Z=(Min=30.000000,Max=40.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames-grey'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.300000,Max=1.300000)
         StartVelocityRange=(Y=(Min=-45.000000,Max=-45.000000))
         StartVelocityRadialRange=(Max=120.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=0.100000))
         VelocityScale(1)=(RelativeTime=0.100000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.100000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=2.500000))
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.MonsterBlueFlame.SpriteEmitter69'

     AutoDestroy=True
     bNoDelete=False
     bTrailerSameRotation=True
     Physics=PHYS_Trailer
     CollisionRadius=25.000000
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
}
