//=============================================================================
//=============================================================================
class FireBallSmokeRing extends RocketSmokeRing;

function PreBeginPlay()
{
	mPosDev.X *= (FireBallProjINI(Owner).Scaling - 0.9) / 2;
	mPosDev.Y = mPosDev.X;
	mPosDev.Z = mPosDev.X;

	SetDrawScale(((DrawScale * FireBallProjINI(Owner).Scaling) / 4));

	mSpeedRange[0] *= 0.25 + (FireBallProjINI(Owner).Scaling / 4);
	mSpeedRange[1] = mSpeedRange[0];
}

defaultproperties
{
}
