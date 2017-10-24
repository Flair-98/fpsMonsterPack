Class MechTitanBProjectile Extends Projectile;

Var Float lastBoundTime;
Var Byte Bounces;
Var xEmitter FallOut;

Replication
{
    Reliable If (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

Simulated Function PostBeginPlay()
{
	Local Float decision;
	If ( bDeleteMe || IsInState('Dying') )
		Return;

	Velocity = (speed+Rand(MaxSpeed-speed)) * Vector(Rotation);

	DesiredRotation.Pitch = Rotation.Pitch + Rand(2000) - 1500;
	DesiredRotation.Roll = Rotation.Roll + Rand(2000) - 1500;
	DesiredRotation.Yaw = Rotation.Yaw + Rand(2000) - 1500;
	decision = FRand();

	// collision radius is set to the radius defined, collision height is set to 60% of the radius value
	// which is approximately the same distance (yeah makes no sense to me either, but look in the editor)
	// the reason For not defining the exact collision height is that the collision cylinder is Always
	// represented as an upright cylinder and Does not Rotate when the mesh Rotates. This way the center
	// of the projectile is solid and the 'dead' projectiles sit on the ground (or in it) instead of appearing to hover

	If (decision<0.34)
	{
		SetStaticMesh(MechTitanB(Owner).Projectile1);
		// Maps with the old Spawn poInt will use Default values
		If (MechTitanB(Owner).Proj1CollisionRadius > 1.0)
			SetCollisionSize( MechTitanB(Owner).Proj1CollisionRadius, (MechTitanB(Owner).Proj1CollisionRadius * 0.60) );
		PrePivot.X=MechTitanB(Owner).Proj1PrePivot.X;
		PrePivot.Y=MechTitanB(Owner).Proj1PrePivot.Y;
		PrePivot.Z=MechTitanB(Owner).Proj1PrePivot.Z;
	}
	Else If (decision<0.67)
	{
		SetStaticMesh(MechTitanB(Owner).Projectile2);
		If (MechTitanB(Owner).Proj1CollisionRadius > 1.0)
			SetCollisionSize( MechTitanB(Owner).Proj2CollisionRadius, (MechTitanB(Owner).Proj2CollisionRadius * 0.60) );
		PrePivot.X=MechTitanB(Owner).Proj2PrePivot.X;
		PrePivot.Y=MechTitanB(Owner).Proj2PrePivot.Y;
		PrePivot.Z=MechTitanB(Owner).Proj2PrePivot.Z;
	}
	Else
	{
		SetStaticMesh(MechTitanB(Owner).Projectile3);
		If (MechTitanB(Owner).Proj1CollisionRadius > 1.0)
			SetCollisionSize( MechTitanB(Owner).Proj3CollisionRadius, (MechTitanB(Owner).Proj3CollisionRadius * 0.60) );
		PrePivot.X=MechTitanB(Owner).Proj3PrePivot.X;
		PrePivot.Y=MechTitanB(Owner).Proj3PrePivot.Y;
		PrePivot.Z=MechTitanB(Owner).Proj3PrePivot.Z;
	}

	If (MechTitanB(Owner).FallOut != None)
		AddFallOut();

	If (FRand() < 0.5)
		RotationRate.Pitch = Rand(70000);

	If ( (RotationRate.Pitch == 0) || (FRand() < 0.8) )
		RotationRate.Roll = Max(0, 50000 + Rand(70000) - RotationRate.Pitch);
}

Function AddFallOut()
{
 	FallOut = Spawn(Class'MechTitanFallOut',MechTitanB(Owner),,Location,Rotation);
	FallOut.SetBase(Self);
	MechTitanFallOut(FallOut).affectedRadius = 500;
}

Function ProcessTouch (Actor Other, Vector HitLocation)
{
	Local Int hitdamage;

	If ((Other == None) || (Other == instigator) || Other.Isa('MechTitanProjectile'))
		Return;

	If (ClassIsChildOf(Other.Class, Class'Monster'))
		If (!Pawn(Other).Controller.IsA('FriendlyMonsterController'))
			Return;
	If (MechTitanBShield(Other) != None)
		Return;

	If (Self.StaticMesh == MechTitanB(Owner).Projectile1)
		PlaySound(MechTitanB(Owner).Proj1Impact, SLOT_Interact, 1);
	Else If (Self.StaticMesh == MechTitanB(Owner).Projectile2)
		PlaySound(MechTitanB(Owner).Proj2Impact, SLOT_Interact, 1);
	Else
		PlaySound(MechTitanB(Owner).Proj3Impact, SLOT_Interact, 1);


	If(Projectile(Other)!=None)
		Other.Destroy();
	Else
	{
		Hitdamage = Damage * VSize(Velocity/Speed);
		instigator = MechTitanB(Owner);
		If ( (HitDamage > 3) && (speed > 150) && ( Role == ROLE_Authority ))
			Other.TakeDamage(hitdamage, instigator,HitLocation,
			(35000.0 * Normal(Velocity)*(DrawScale*10)), MyDamageType );
	}
}

Simulated Function Landed(Vector HitNormal)
{
	SetPhysics(PHYS_None);
    LIfeSpan = 2.0;
}

Simulated Function HitWall (Vector HitNormal, actor Wall)
{
	Local Vector RealHitNormal;
	Local Int HitDamage;


	If ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
	{
		If ( Level.NetMode != NM_Client )
		{
			Hitdamage = Damage * 0.00002 * ((DrawScale*10)**3) * speed;
			If ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
			Wall.TakeDamage( Hitdamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	}

	speed = VSize(velocity);
	If (Bounces > 0 && speed>100)
	{
		MakeSound();
		SetPhysics(PHYS_Falling);
		RealHitNormal = HitNormal;
		If ( FRand() < 0.5 )
			RotationRate.Pitch = Max(RotationRate.Pitch, 100000);
		Else
			RotationRate.Roll = Max(RotationRate.Roll, 100000);
		HitNormal = Normal(HitNormal + 0.5 * VRand());
		If ( (RealHitNormal Dot HitNormal) < 0 )
			HitNormal.Z *= -0.7;
		Velocity = 0.7 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
		DesiredRotation = Rotator(HitNormal);

		Bounces = Bounces - 1;
		Return;
	}
	bFixedRotationDir=False;
	bBounce = False;
}

Function MakeSound()
{
	If (Self.StaticMesh == MechTitanB(Owner).Projectile1)
		PlaySound(MechTitanB(Owner).Proj1Impact, SLOT_Misc, 1,,600);
	Else If (Self.StaticMesh == MechTitanB(Owner).Projectile2)
		PlaySound(MechTitanB(Owner).Proj2Impact, SLOT_Misc, 1,,600);
	Else
		PlaySound(MechTitanB(Owner).Proj3Impact, SLOT_Misc, 1,,600);
}

Simulated Function Destroyed()
{
	If ( FallOut != None )
	    {
			FallOut.mRegen = False;
			FallOut.Destroy();
		}
}


DefaultProperties
{
     Bounces=4
     Speed=1000.000000
     MaxSpeed=1000.000000
     Damage=1500.000000
     MyDamageType=Class'DamTypeMechTitanBProj'
     DrawType=DT_StaticMesh
     CollisionRadius=50.000000
     CollisionHeight=50.000000
     bBlockKarma=True
     bBounce=True
     bFixedRotationDir=True
}
