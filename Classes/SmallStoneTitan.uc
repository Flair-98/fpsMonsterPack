class SmallStoneTitan extends SMPStoneTitan;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('BigFly') || P.IsA('BigManta') || P.IsA('BigPupae')|| P.IsA('SmallQueen') || P.IsA('SmallWarlord') || P.IsA('SmallTitan') || P.IsA('SmallStoneTitan')));
}

defaultproperties
{
     Health=1000
     DrawScale=0.300000
     CollisionHeight=30.000000
     Mass=100.000000
}
