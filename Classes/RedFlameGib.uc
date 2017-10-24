class RedFlameGib extends Gib;


simulated function SpawnTrail()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {

		Trail = Spawn(class'BlueHitFlameBig', self,,Location,Rotation);
		Trail.LifeSpan = 4 + 2*FRand();
		LifeSpan = Trail.LifeSpan;
		Trail.SetTimer(LifeSpan - 3.0,false);
		Trail.SetPhysics( PHYS_Trailer );
		RandSpin( 64000 );
	}
}

defaultproperties
{
     GibGroupClass=Class'fpsMonsterPack.RedFlameGibGroup'
     TrailClass=Class'fpsMonsterPack.RedHitFlameBig'
     DrawType=DT_None
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
