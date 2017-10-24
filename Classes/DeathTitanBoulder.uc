Class DeathTitanBoulder	extends	DeathTitanBigRock;


/*
function SpawnChunks(int num)
{
	local int    NumChunks,i;
	local SMPTitanBigRock   TempRock;
	local float pscale;

	NumChunks = 1+Rand(num);
	pscale = 12 * sqrt(0.52/NumChunks);
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempRock = Spawn(class'DeathTitanBigRock');
		if (TempRock != None )
			TempRock.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}  */

function MakeSound()
{
	local float soundRad;
	soundRad = 90 * DrawScale;

	PlaySound(ImpactSound, SLOT_Misc, DrawScale/20,,soundRad);
}
simulated function HitWall (vector HitNormal, actor Wall)
{
	Velocity = 0.75 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
	SetRotation(rotator(HitNormal));
	setDrawScale( DrawScale* 0.7);
	SpawnChunks(8);
	Destroy();
}

defaultproperties
{
     Speed=900.000000
     MaxSpeed=900.000000
     CollisionRadius=60.000000
     CollisionHeight=60.000000
}
