class SmallWarlord extends Warlord;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('BigFly') || P.IsA('BigManta') || P.IsA('BigPupae')|| P.IsA('SmallQueen') || P.IsA('BigRabbit') || P.IsA('SmallTitan') || P.IsA('SmallStoneTitan')));
}

defaultproperties
{
     DrawScale=0.450000
     PrePivot=(Z=0.000000)
     CollisionRadius=50.000000
     CollisionHeight=30.000000
     Mass=100.000000
}
