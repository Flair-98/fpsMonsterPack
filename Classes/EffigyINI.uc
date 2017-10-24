class EffigyINI extends Monster config(fpsMonsterPack);


var config array<string> JoeTalks;
var config int nTalkFrequency;
var config float fHealth;
var bool bLeftShot;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Health = fHealth;
}

function PostBeginPlay()
{
Super.PostBeginPlay();
Level.Game.Broadcast(self, "BigJoe: HI!");
	SetTimer(nTalkFrequency, true);
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlaySound(sound'hairflp2sk',SLOT_Interact);	
	SetAnimAction('gesture_cheer');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
	if ( bLeftShot )
		return Location + CollisionRadius * ( X + 0.0 * Y + 0.0 * Z);  //X + 0.9 * Y + 0.4 * Z
	else
		return Location + CollisionRadius * ( X - 0.0 * Y + 0.0 * Z);  //X - 0.9 * Y + 0.4 * Z
}

function SpawnLeftShot()
{
	bLeftShot = false;
	FireProjectile();
}

function SpawnRightShot()
{
	bLeftShot = false;
	FireProjectile();
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
	else if ( Velocity == vect(0,0,0) )
	{
		SetAnimAction('Specific_1');
		FireProjectile();
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
	}
}

function Timer()
{
	local int v;
	v = rand(JoeTalks.Length+4);
	if (v < JoeTalks.Length) {
		Level.Game.Broadcast(self, "BigJoe: " $ JoeTalks[v]);
	}
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
}

function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{

	return super(xPawn).IsHeadShot(loc,ray,AdditionalScale);
}

function bool SameSpeciesAs(Pawn P)
{
	return ( (Monster(P) != None) && (P.IsA('Skaarj') || P.IsA('WarLord') || P.IsA('SMPNaliFighter') || P.IsA('EffigyAddOnINI')));
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false; 
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	LifeSpan = RagdollLifeSpan;
    GotoState('Dying');
		
	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetInvisibility(0.0);
    PlayDirectionalDeath(HitLoc);
    SetPhysics(PHYS_Falling);
}

simulated function ProcessHitFX()
{
	super(xPawn).ProcessHitFX();
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
        PlayAnim('TurnL',, 0.1);
    }
    else if ( Dir Dot X < -0.7 )
    {
        PlayAnim('TurnR',, 0.1);
    }
    else if ( Dir Dot Y > 0 )
    {
        PlayAnim('TurnL',, 0.1);
    }
    else
    {
        PlayAnim('TurnR',, 0.1);
    }
}

defaultproperties
{
     JoeTalks(0)="XD"
     JoeTalks(1)="D:"
     JoeTalks(2)="O-0"
     JoeTalks(3)="This Server Is The Best!"
     JoeTalks(4)="INI rules"
     JoeTalks(5)="Epic Games"
     JoeTalks(6)="Ride This Deemer"
     JoeTalks(7)="Why are you trying to hide?"
     nTalkFrequency=20
     fHealth=5000.000000
     bMeleeFighter=False
     bTryToWalk=True
     AmmunitionClass=Class'fpsMonsterPack.deemerammo'
     ScoringValue=30
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     RagdollOverride="Effigy"
     MovementAnims(2)="RunR"
     MovementAnims(3)="RunL"
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     SwimAnims(1)="SwimF"
     SwimAnims(2)="SwimF"
     SwimAnims(3)="SwimF"
     WalkAnims(1)="WalkF"
     WalkAnims(2)="WalkF"
     WalkAnims(3)="WalkF"
     AirAnims(0)="JumpF_Mid"
     AirAnims(1)="JumpF_Mid"
     AirAnims(2)="JumpF_Mid"
     AirAnims(3)="JumpF_Mid"
     TakeoffAnims(0)="Jump_Takeoff"
     TakeoffAnims(1)="Jump_Takeoff"
     TakeoffAnims(2)="Jump_Takeoff"
     TakeoffAnims(3)="Jump_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpF_Land"
     LandAnims(2)="JumpF_Land"
     LandAnims(3)="JumpF_Land"
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
     Mesh=SkeletalMesh'fpsMonAnim.Effigy'
     DrawScale=2.300000
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'fpsMonTex.Skins.rider'
     Skins(1)=Texture'fpsMonTex.Skins.beast'
     CollisionRadius=50.000000
     CollisionHeight=105.000000
     Mass=2000.000000
     Buoyancy=150.000000
}
