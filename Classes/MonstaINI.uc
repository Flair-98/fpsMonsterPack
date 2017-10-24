class MonstaINI extends Monster config(fpsMonsterPack);

var config float fHealth;
var sound FootStep[2];
var name DeathAnim[4];

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Health = fHealth;
}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SMPTitan') || P.IsA('SMPQueen') || P.IsA('Monster')|| P.IsA('Skaarj') || P.IsA('SkaarjPupae') || P.IsA('MonstaINIv3')));
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlaySound(sound'hairflp2sk',SLOT_Interact);	
	SetAnimAction('AssSmack');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Y + 0.4 * CollisionHeight * Z;
}

function SpawnTwoShots()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	
	GetAxes(Rotation,X,Y,Z);
	FireStart = GetFireStart(X,Y,Z);
	if ( !SavedFireProperties.bInitialized )
	{
		SavedFireProperties.AmmoClass = MyAmmo.Class;
		SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
		SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
		SavedFireProperties.MaxRange = MyAmmo.MaxRange;
		SavedFireProperties.bTossed = MyAmmo.bTossed;
		SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
		SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
		SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
		SavedFireProperties.bInitialized = true;
	}
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
		
	FireStart = FireStart - 1.8 * CollisionRadius * Y;
	FireRotation.Yaw += 400;
	spawn(MyAmmo.ProjectileClass,,,FireStart, FireRotation);
}

simulated function AnimEnd(int Channel)
{
	local name Anim;
	local float frame,rate;
	
	if ( Channel == 0 )
	{
		GetAnimParams(0, Anim,frame,rate);
		if ( Anim == 'Idle_Rifle' )
			IdleWeaponAnim = 'Idle_Biggun';
		else if ( (Anim == 'Idle_Rifle') && (FRand() < 0.5) )
			IdleWeaponAnim = 'Idle_Biggun';
	}
	Super.AnimEnd(Channel);
}

function RunStep()
{
	PlaySound(FootStep[Rand(2)], SLOT_Interact);
}

function WalkStep()
{
	PlaySound(FootStep[Rand(2)], SLOT_Interact,0.2);
}

function SpinDamageTarget()
{
	if (MeleeDamageTarget(20, (30000 * Normal(Controller.Target.Location - Location))) )
		PlaySound(sound'clawhit1s', SLOT_Interact);		
}

function ClawDamageTarget()
{
	if ( MeleeDamageTarget(25, (25000 * Normal(Controller.Target.Location - Location))) )
		PlaySound(sound'clawhit1s', SLOT_Interact);			
}

function RangedAttack(Actor A)
{
	local name Anim;
	local float frame,rate;
	
	if ( bShotAnim )
		return;
	bShotAnim = true;
	if ( Physics == PHYS_Swimming )
		SetAnimAction('Swim_Tread');
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		if ( FRand() < 0.7 )
		{
			SetAnimAction('Gesture_Taunt01');
			SpinDamageTarget();
			PlaySound(sound'Spin1s', SLOT_Interact);
			Acceleration = AccelRate * Normal(A.Location - Location);
			return;
		}
		SetAnimAction('Gesture_Taunt02');
		ClawDamageTarget();
		PlaySound(sound'Claw2s', SLOT_Interact);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}	
	else if ( Velocity == vect(0,0,0) )
	{
		SetAnimAction('Crouch');
		SpawnTwoShots();
		//Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	else
	{
		GetAnimParams(0,Anim,frame,rate);
		if ( Anim == 'RunL' )
			SetAnimAction('WalkL');
		else if ( Anim == 'RunR' )
			SetAnimAction('WalkR');
		else
			SetAnimAction('RunF');
			FireProjectile();
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false; 
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	LifeSpan = 0.2; //RagdollLifeSpan;
    GotoState('Dying');
		
	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetInvisibility(0.0);
    PlayDirectionalDeath(HitLoc);
    SetPhysics(PHYS_Falling);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
    local Vector X,Y,Z, Dir;

    GetAxes(Rotation, X,Y,Z);
    HitLoc.Z = Location.Z;

    // random
    if ( VSize(Velocity) < 10.0 && VSize(Location - HitLoc) < 1.0 )
    {
        Dir = VRand();
    }
    // velocity based
    else if ( VSize(Velocity) > 0.0 )
    {
        Dir = Normal(Velocity*Vect(1,1,0));
    }
    // hit location based
    else
    {
        Dir = -Normal(Location - HitLoc);
    }

    if ( Dir Dot X > 0.7 || Dir == vect(0,0,0))
        PlayAnim('WalkF',, 0.2);
    else if ( Dir Dot X < -0.7 )
         PlayAnim('WalkF',, 0.2);
    else if ( Dir Dot Y > 0 )
        PlayAnim('WalkF',, 0.2);
    else if ( HasAnim('WalkF') )
        PlayAnim('WalkF',, 0.2);
    else
        PlayAnim('WalkF',, 0.2);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
    local Vector X,Y,Z, Dir;

	if ( DrivenVehicle != None )
		return;

    GetAxes(Rotation, X,Y,Z);
    HitLoc.Z = Location.Z;

    // random
    if ( VSize(Location - HitLoc) < 1.0 )
    {
        Dir = VRand();
    }
    // hit location based
    else
    {
        Dir = -Normal(Location - HitLoc);
    }

    if ( Dir Dot X > 0.7 || Dir == vect(0,0,0))
    {
        PlayAnim('HitB',, 0.1);
    }
    else if ( Dir Dot X < -0.7 )
    {
        PlayAnim('HitF',, 0.1);
    }
    else if ( Dir Dot Y > 0 )
    {
        PlayAnim('HitL',, 0.1);
    }
    else
    {
        PlayAnim('HitR',, 0.1);
    }
}

State Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

	function Landed(vector HitNormal)
	{
		SetPhysics(PHYS_None);
		if ( !IsAnimating(0) )
			LandThump();
		Super.Landed(HitNormal);
                Spawn(class'MonstaEffect');
                Spawn(class'ONSShockTankShockExplosionI');
	}

    simulated function Timer()
	{
		if ( !PlayerCanSeeMe() )
			Destroy();
        else if ( LifeSpan <= DeResTime && bDeRes == false )
            StartDeRes();
 		else
 			SetTimer(0.2, true);
 	}
}

defaultproperties
{
     fHealth=1000.000000
     Footstep(0)=Sound'SkaarjPack_rc.Cow.walkC'
     Footstep(1)=Sound'SkaarjPack_rc.Cow.walkC'
     bTryToWalk=True
     AmmunitionClass=Class'fpsMonsterPack.SkaarjAmmoINI'
     ScoringValue=15
     GibGroupClass=Class'XEffects.xAlienGibGroup'
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     RagdollOverride="Monsta"
     MeleeRange=100.000000
     JumpZ=550.000000
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     AirAnims(0)="JumpF_Mid"
     AirAnims(1)="JumpB_Mid"
     AirAnims(2)="JumpL_Mid"
     AirAnims(3)="JumpR_Mid"
     TakeoffAnims(0)="JumpF_Takeoff"
     TakeoffAnims(1)="JumpB_Takeoff"
     TakeoffAnims(2)="JumpL_Takeoff"
     TakeoffAnims(3)="JumpR_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpB_Land"
     LandAnims(2)="JumpL_Land"
     LandAnims(3)="JumpR_Land"
     DoubleJumpAnims(0)="DoubleJumpB"
     DoubleJumpAnims(1)="DoubleJumpF"
     DoubleJumpAnims(2)="DoubleJumpL"
     DoubleJumpAnims(3)="DoubleJumpR"
     DodgeAnims(0)="DodgeF"
     DodgeAnims(1)="DodgeB"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="JumpF_Mid"
     TakeoffStillAnim="Jump_Takeoff"
     IdleWeaponAnim="Idle_Rifle"
     IdleRestAnim="Idle_Character01"
     Mesh=SkeletalMesh'fpsMonAnim.MonstaMesh'
     PrePivot=(Z=5.000000)
     Skins(0)=Texture'fpsMonTex.Monsta.map2'
     Skins(1)=Texture'fpsMontex.Monsta.map1'
     CollisionRadius=50.000000
     CollisionHeight=40.000000
     Mass=2000.000000
     Buoyancy=150.000000
}
