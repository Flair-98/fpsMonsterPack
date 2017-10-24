Class MechTitanBGun extEnds ProjectileSpawner
	HideCategories (ProjectileSpawner);

Function PostBeginPlay()
{
	Super.PostBeginPlay();
	SpawnRateMin = MechTitanB(Owner).MinSpawnRate;
	SpawnRateMax = MechTitanB(Owner).MaxSpawnRate;
}

Function SpawnProjectile()
{
    Local MechTitanBLaser Proj1;
	Local MechTitanBLaser Proj2;
 	Local Rotator TargetDirection,Rot1,Rot2;
	Local Vector Loc1,Loc2,X,Y,Z;

	TargetDirection = AdjustAim(Location);

	//==> If these are the same chances are I Don't have a target, so Don't shoot
	If (TargetDirection == (Owner.Rotation))
		Return;

	//== orient gun
	SetRotation(TargetDirection);

	GetAxes(TargetDirection,X,Y,Z);

	Loc1 = Location + (Normal(Y) * 57) + (Normal(X) * 267);
	Loc2 = Location - (Normal(Y) * 57) + (Normal(X) * 267);

	Rot1 = AdjustAim(Loc1);
	Rot2 = AdjustAim(Loc2);

    Proj1 = Spawn(Class'MechTitanBLaser',Self,,Loc1, Rot1);
	Proj2 = Spawn(Class'MechTitanBLaser',Self,,Loc2, Rot2);

    If (SpawnSound != None)
        PlaySound(SpawnSound,SLOT_Interact,255,,500,32);
}

//==> based on AdjustAim in Scripted Controller, withOut the Variables required by that Function
//== which it Doesn't use anyway ... lol
Function Rotator AdjustAim(Vector ProjStart)
{
	Local actor mtTarget;
	Local Rotator LookDir;
	Local Vector targetHead;

	mtTarget = Pawn(Owner).Controller.Enemy;
	If (mtTarget == None)
		Return (Owner.Rotation);

	targetHead = mtTarget.Location + ((Vect(0,0,1)*(mtTarget.CollisionHeight - 2)) + mtTarget.PrePivot);

	LookDir = Rotator(targetHead - projStart);
	Return LookDir;
}

DefaultProperties
{
}
