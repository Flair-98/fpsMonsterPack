class MilkGlobHit extends Emitter;

/*
(0) darkred smoke
(1) brighten smoke
(2) airblast/expl
*/

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter40X
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.400000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=255,G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=6
         StartLocationOffset=(X=10.000000)
         StartLocationRange=(X=(Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.700000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=20.000000,Max=30.000000))
         InitialParticlesPerSecond=3000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2004Particles.Energy.BurnFlare'
         LifetimeRange=(Min=0.300000,Max=0.450000)
     End Object
     Emitters(0)=SpriteEmitter'fpsMonsterPack.MilkGlobHit.SpriteEmitter40X'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
}
