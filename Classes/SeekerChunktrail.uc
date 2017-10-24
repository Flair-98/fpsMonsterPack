//=============================================================================
// FlakTrail
//=============================================================================
class SeekerChunktrail extends pclSmoke;

defaultproperties
{
     mParticleType=PT_Stream
     mStartParticles=0
     mMaxParticles=40
     mLifeRange(0)=0.600000
     mLifeRange(1)=0.600000
     mRegenRange(0)=60.000000
     mRegenRange(1)=60.000000
     mSpawnVecB=(X=20.000000,Z=0.000000)
     mSizeRange(0)=4.000000
     mSizeRange(1)=6.000000
     mGrowthRate=-0.500000
     mColorRange(0)=(G=0,R=0)
     mColorRange(1)=(G=0,R=0)
     mNumTileColumns=1
     mNumTileRows=1
     Physics=PHYS_Trailer
     LifeSpan=4.900000
     Skins(0)=Texture'XEffects.FlakTrailTex'
     Style=STY_Additive
}
