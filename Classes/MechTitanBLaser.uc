Class MechTitanBLaser Extends PROJ_Sentinel_Laser_Red;

Simulated Function ProcessTouch (Actor Other, Vector HitLocation)
{
	Local Rotator NewRot;

	Local Float teleDecision;

	If ((Other == Self.Owner.Owner) || (Other == Self.Owner) || (Other == None))
		Return;

	If (ClassIsChildOf(Other.Class, Class'Monster'))
		If (!Pawn(Other).Controller.IsA('FriendlyMonsterController'))
			Return;
	If (MechTitanBShield(Other) != None)
		Return;

	If (MechTitanB(Owner.Owner).Nulls)
		GiveNull(Other);

	If (MechTitanB(Owner.Owner).Teleports)
	{
		teleDecision = FRand();
		If ((Other.Location.Z > 1500) || (teleDecision < 0.10))
		{
			If (FastTrace( (Self.Owner.Location + Vect(0,0,1500)), Self.Owner.Location ))
			{
				If ( !Pawn(Other).SetLocation(Self.Owner.Location + Vect(0,0,1500)) )
					Log(Self$" Teleport failed For "$Other);
				Else
				{
					Other.PlayTeleportEffect(False, True);
					//== set view Rotation to look straight Down at Titan
					NewRot = Pawn(Other).Rotation;
					NewRot.Pitch = 49152;
					Pawn(Other).SetViewRotation(NewRot);
				}
			}
			Else If (FastTrace( (Self.Owner.Location + (Vector(Self.Owner.Rotation) * 500)), Self.Owner.Location ))
			{
				If ( !Pawn(Other).SetLocation(Self.Owner.Location + (Vector(Self.Owner.Rotation) * 500) ))
					Log(Self$" Teleport failed For "$Other);
				Else
				{
					Other.PlayTeleportEffect(False, True);
					NewRot = Rotator(Pawn(Other).Location - Self.Owner.Location);
					Pawn(Other).SetViewRotation(NewRot);
				}
			}
		}

	}
	Instigator = None;
	Super.ProcessTouch(Other,HitLocation);
}

Simulated Function GiveNull(Actor Other)
{
	Local Pawn P;
	Local MechTitanInventory Inv;

//=========================================================
// Null entropy associated stuff glommed From Drood's RPG
		P = Pawn(Other);
		If(P == None)
			Return;

		If(P.FindInventoryType(Class'MechTitanInventory') != None)
			Return ;

		Inv = Spawn(Class'MechTitanInventory', P,,, Rot(0,0,0));

		If(Inv == None)
			Return; //wow

		Inv.LIfeSpan = 2;
		Inv.Modifier = 2;
		Inv.GiveTo(P);
//=========================================================

}

Simulated Function Explode(Vector HitLocation, Vector HitNormal)
{

    If (Role == ROLE_Authority)
        HurtRadius(MechTitanB(Owner.Owner).ExplosionDamage, MechTitanB(Owner.Owner).ExplosionRadius, Class'DamTypeMechTitanBLaser', 0, HitLocation);

	SpawnExplodeFX(HitLocation, HitNormal);

    PlaySound(Sound'GeneralAmbience.electricalfx15');
	Destroy();
}

Simulated Function HurtRadius( Float DamageAmount, Float DamageRadius, Class<DamageType> DamageType, Float Momentum, Vector HitLocation )
{
	Local actor Victims;
	Local Float damageScale, dist;
	Local Vector dir;

	If( bHurtEntry )
		Return;

	bHurtEntry = True;
	Foreach VisibleCollidingActors( Class 'Engine.Actor', Victims, DamageRadius, HitLocation )
	{
		// Don't let blast damage affect fluid - VisibleCollisingActors Doesn't really work For them - jag
		If( (Victims != Self) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			If (MechTitanB(Owner.Owner).Nulls)
				GiveNull(Victims);

			If (Instigator != None && Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
		}
	}
	bHurtEntry = False;
}

DefaultProperties
{
}
