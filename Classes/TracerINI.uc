//=============================================================================
// Tracer.
//=============================================================================
class TracerINI extends xEmitter;

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
     mParticleType=PT_Mesh
     mSpawningType=ST_Line
     mStartParticles=0
     mMaxParticles=100
     mLifeRange(0)=5.000000
     mLifeRange(1)=-5.967100
     mRegenRange(0)=0.000000
     mRegenRange(1)=0.000000
     mSpeedRange(0)=5000.000000
     mSpeedRange(1)=5000.000000
     mPosRelative=True
     mAirResistance=0.000000
     mSpinRange(0)=125.000000
     mSpinRange(1)=250.000000
     mSizeRange(0)=0.100000
     mSizeRange(1)=0.200000
     mGrowthRate=0.200000
     mColorRange(0)=(B=31,G=73,R=245)
     mColorRange(1)=(B=5,G=219,R=250)
     mUseMeshNodes=True
     mMeshNodes(0)=StaticMesh'ParticleMeshes.Complex.IonRingMesh'
     Skins(0)=Shader'EpicParticles.Shaders.IonRingShader'
     Style=STY_Translucent
}
