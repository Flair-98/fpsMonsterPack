//=============================================================================
//=============================================================================
class FireBallEmitter extends xEmitter;

//Allows for dynamic changing of the emitter's size.
function Scale(float Scaling)
{
	SetDrawScale(DrawScale * Scaling);
}

//Make the emitter slightly more transparent.
function Fade()
{
	if(mColorRange[0].A <= 10)
		return;

	mColorRange[0].A -= 5;
	mColorRange[1].A = mColorRange[0].A;
}

defaultproperties
{
     mMaxParticles=20
     mLifeRange(0)=1.000000
     mLifeRange(1)=1.000000
     mRegenRange(0)=10.000000
     mRegenRange(1)=10.000000
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mPosRelative=True
     mRandOrient=True
     mSpinRange(0)=-50.000000
     mSpinRange(1)=50.000000
     mGrowthRate=20.000000
     mAttenKa=0.100000
     mAttenKb=0.500000
     mNumTileColumns=2
     mNumTileRows=2
     mLifeColorMap=Texture'fpsMonsterPack.FireLifeMap'
     LifeSpan=300.000000
     Skins(0)=Texture'fpsMonsterPack.ChuckedFire'
     Style=STY_Additive
}
