class DoomLordINI extends Monster config(fpsMonsterPack);

var config float fHealth;
var bool bRocketDir;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Health = fHealth;
}

function bool SameSpeciesAs(Pawn P)
{
	return ( (Monster(P) != None) && (P.IsA('Skaarj') || P.IsA('WarLord')) );
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bMeleeFighter = (FRand() < 0.5);
}

function Step()
{
	PlaySound(sound'step1t', SLOT_Interact);
}

function Flap()
{
	PlaySound(sound'fly1WL', SLOT_Interact);
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	local vector X,Y,Z,duckdir;

    GetAxes(Rotation,X,Y,Z);
	if (DoubleClickMove == DCLICK_Forward)
		duckdir = X;
	else if (DoubleClickMove == DCLICK_Back)
		duckdir = -1*X; 
	else if (DoubleClickMove == DCLICK_Left)
		duckdir = Y; 
	else if (DoubleClickMove == DCLICK_Right)
		duckdir = -1*Y; 

	SetPhysics(PHYS_Flying);
	if ( !bShotAnim && (FRand() < 0.3) )
	{
		bShotAnim = true;
		SetAnimAction('FDodgeUp');
	}
	Controller.Destination = Location + 200 * duckDir;
	Velocity = AirSpeed * duckDir;
	Controller.GotoState('TacticalMove', 'DoMove');
	return true;
}	

event Landed(vector HitNormal)
{
	SetPhysics(PHYS_Walking);
	Super.Landed(HitNormal);
}

event HitWall( vector HitNormal, actor HitWall )
{
	if ( HitNormal.Z > MINFLOORZ )
		SetPhysics(PHYS_Walking);
	Super.HitWall(HitNormal,HitWall);
}

singular function Falling()
{
	SetPhysics(PHYS_Flying);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if ( Physics == PHYS_Flying )
		PlayAnim('Dead2A');
	else
		PlayAnim('Dead1');
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	if ( Damage > 50 )
		Super.PlayTakeHit(HitLocation,Damage,DamageType);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	local name Anim;
	local float frame,rate;

	if ( bShotAnim )
		return;
		
	GetAnimParams(0, Anim,frame,rate);

	if ( Anim == 'FDodgeUp' )
		return;
	TweenAnim('TakeHit', 0.05);
}

function PlayVictory()
{
	SetPhysics(PHYS_Falling);
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlaySound(sound'laugh1WL',SLOT_Interact);	
	SetAnimAction('Laugh');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	
	if ( Physics == PHYS_Flying )
		SetAnimAction('FlyFire');
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('Strike');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'Threat1WL', SLOT_Talk); 
	}
	else if ( !Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
	{
		SetPhysics(PHYS_Flying);
		SetAnimAction('FlyFire');
	}
	else
	{
		SetAnimAction('Fire');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	bShotAnim = true;
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
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

defaultproperties
{
     fHealth=1000.000000
     bMeleeFighter=False
     bTryToWalk=True
     bBoss=True
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'SkaarjPack_rc.WarLord.injur1WL'
     HitSound(1)=Sound'SkaarjPack_rc.WarLord.injur2WL'
     HitSound(2)=Sound'SkaarjPack_rc.WarLord.injur1WL'
     HitSound(3)=Sound'SkaarjPack_rc.WarLord.injur2WL'
     DeathSound(0)=Sound'SkaarjPack_rc.WarLord.DeathCry1WL'
     DeathSound(1)=Sound'SkaarjPack_rc.WarLord.DeathCry1WL'
     DeathSound(2)=Sound'SkaarjPack_rc.WarLord.DeathCry1WL'
     DeathSound(3)=Sound'SkaarjPack_rc.WarLord.DeathCry1WL'
     ChallengeSound(0)=Sound'OutdoorAmbience.BThunder.creature3'
     ChallengeSound(1)=Sound'OutdoorAmbience.BThunder.creature3'
     ChallengeSound(2)=Sound'OutdoorAmbience.BThunder.creature3'
     ChallengeSound(3)=Sound'SkaarjPack_rc.WarLord.breath1WL'
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     AmmunitionClass=Class'fpsMonsterPack.DoomAmmo'
     ScoringValue=10
     bCanFly=True
     MeleeRange=80.000000
     GroundSpeed=550.000000
     AirSpeed=700.000000
     Health=600
     MovementAnims(1)="RunF"
     MovementAnims(2)="RunF"
     MovementAnims(3)="RunF"
     TurnLeftAnim="Idle_Rest"
     TurnRightAnim="Idle_Rest"
     WalkAnims(1)="WalkF"
     WalkAnims(2)="WalkF"
     WalkAnims(3)="WalkF"
     AirAnims(0)="Fly"
     AirAnims(1)="Fly"
     AirAnims(2)="Fly"
     AirAnims(3)="Fly"
     TakeoffAnims(0)="Fly"
     TakeoffAnims(1)="Fly"
     TakeoffAnims(2)="Fly"
     TakeoffAnims(3)="Fly"
     AirStillAnim="Fly"
     TakeoffStillAnim="Fly"
     Mesh=VertMesh'SkaarjPack_rc.WarlordM'
     Skins(0)=Texture'fpsMonTex.Skins.DoomLord'
     Skins(1)=Texture'fpsMonTex.Skins.DoomLord'
     TransientSoundVolume=1.000000
     TransientSoundRadius=1500.000000
     CollisionRadius=47.000000
     CollisionHeight=78.000000
     Mass=300.000000
}
