class GlassINI extends Monster config(fpsMonsterPack);

var int nLastLaugh;
var config int nLaughFrequency;
var name DeathAnim[4];
var byte sprayoffset;
var	float Momentum;
var	class<DamageType>  MyDamageType;
var	vector				mHitLocation,mHitNormal;
var	rotator				mHitRot;
var  Sound DeathSoundINI[2];
var config float fHealth;
var WraithSmoke Dust;
var WraithSmokeGreen Gust;
var FireProperties RocketFireProperties;
var class<Ammunition> RocketAmmoClass;
var Ammunition RocketAmmo;

replication
{
  reliable if ( Role == ROLE_Authority )
    mHitLocation, mHitNormal, Smoke;
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Health = fHealth;
}

event PostBeginPlay()
{
	Super.PostBeginPlay();
        SetTimer(nLaughFrequency, true);
        nLastLaugh=0;
        RocketAmmo=spawn(RocketAmmoClass);
        
}

function Timer()
{
	if (nLastLaugh == 0) {
		PlaySound(sound'flaugh1', SLOT_None, 200.0);
		nLastLaugh = 1;
	} else if (nLastLaugh == 1) {
		PlaySound(sound'flaugh3', SLOT_None, 200.0);
		nLastLaugh = 2;
	} else if (nLastLaugh == 2) {
		PlaySound(sound'flaugh1', SLOT_None, 200.0);
		nLastLaugh = 3;
	} else if (nLastLaugh == 3) {
		PlaySound(sound'flaugh3', SLOT_None, 200.0);
		nLastLaugh = 0;
	}
}
	
function Tick(float DeltaTime)
{
		super.Tick(DeltaTime);
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlaySound(sound'flaugh1',SLOT_Interact);	
	SetAnimAction('gesture_cheer');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

function SpawnRocket()
{
	local vector RotX,RotY,RotZ,StartLoc;
	local FireProj R;

	GetAxes(Rotation, RotX, RotY, RotZ);
	StartLoc=GetFireStart(RotX, RotY, RotZ);
	if ( !RocketFireProperties.bInitialized )
	{
		RocketFireProperties.AmmoClass = RocketAmmo.Class;
		RocketFireProperties.ProjectileClass = RocketAmmo.default.ProjectileClass;
		RocketFireProperties.WarnTargetPct = RocketAmmo.WarnTargetPct;
		RocketFireProperties.MaxRange = RocketAmmo.MaxRange;
		RocketFireProperties.bTossed = RocketAmmo.bTossed;
		RocketFireProperties.bTrySplash = RocketAmmo.bTrySplash;
		RocketFireProperties.bLeadTarget = RocketAmmo.bLeadTarget;
		RocketFireProperties.bInstantHit = RocketAmmo.bInstantHit;
		RocketFireProperties.bInitialized = true;
	}

	R=FireProj(Spawn(RocketAmmo.ProjectileClass,,,StartLoc,Controller.AdjustAim(RocketFireProperties,StartLoc,600)));
	Dust = Spawn(class'WraithSmoke',,,Location - vect(0,0,+50),Rotation);
 	Gust = Spawn(class'WraithSmokeGreen',,,Location - vect(0,0,+50),Rotation);
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
        PlayAnim('HitF',, 0.1);
    }
    else if ( Dir Dot X < -0.7 )
    {
        PlayAnim('HitB',, 0.1);
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

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SMPTitan') || P.IsA('SMPQueen') || P.IsA('Monster')|| P.IsA('Skaarj') || P.IsA('SkaarjPupae') || P.IsA('GlassINI')));
}

function PlaySoundINI()
{
	PlaySound(Sound'fpsMonsterPack.Wraithsfire');
}

simulated function Smoke()
{
 	Dust = Spawn(class'WraithSmoke',,,Location - vect(0,0,+50),Rotation);
 	Gust = Spawn(class'WraithSmokeGreen',,,Location - vect(0,0,+50),Rotation);
}

function RangedAttack(Actor A)
{
	local float decision;
	if ( bShotAnim )
		return;
	bShotAnim=true;
	decision = FRand();

	if ( Physics == PHYS_Swimming )
		SetAnimAction('Swim_Tread');
	else if ( Velocity == vect(0,0,0) )
	{
		if (decision < 0.35)
		{
			SetAnimAction('idle_chat');
                        PlaySoundINI();
                      DoFireEffect();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('idle_chat');
			PlaySoundINI();
                       DoFireEffect();
		}
		Acceleration = vect(0,0,0);
	}
	else
	{
		if (decision < 0.35)
		{
			SetAnimAction('DodgeF');
			PlaySoundINI();
			DoFireEffect();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('DodgeF');
			PlaySoundINI();;
			DoFireEffect();
			

		}
	}
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
		return Location + 100.0*Z;
}

simulated function InitEffects()
{
	local vector RotX,RotY,RotZ;
	local vector FireStartLoc;

    // don't even spawn on server
    if ( Level.NetMode == NM_DedicatedServer )
		return;
	GetAxes(Rotation, RotX, RotY, RotZ);
	FireStartLoc=GetFireStart(RotX, RotY, RotZ);

}

simulated function DoFireEffect()
{
Smoke();
SpawnRocket();

}

function SpawnHit()
{
    Spawn(class'HitEffectINI');
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
    PlaySound(DeathSoundINI[Rand(2)], SLOT_Pain,1000*TransientSoundVolume, true,800);
}

defaultproperties
{
     nLaughFrequency=15
     MyDamageType=Class'fpsMonsterPack.DamTypeFireChuckerFire'
     DeathSoundINI(0)=Sound'fpsMonsterPack.WraithsScream'
     DeathSoundINI(1)=Sound'fpsMonsterPack.WraithsScream'
     fHealth=1000.000000
     RocketAmmoClass=Class'fpsMonsterPack.WraithAmmo'
     bMeleeFighter=False
     bTryToWalk=True
     HitSound(0)=Sound'fpsMonsterPack.Wraithshitsound'
     HitSound(1)=Sound'fpsMonsterPack.Wraithshitsound'
     HitSound(2)=Sound'fpsMonsterPack.Wraithshitsound'
     HitSound(3)=Sound'fpsMonsterPack.Wraithshitsound'
     AmmunitionClass=Class'fpsMonsterPack.WraithAmmo'
     ScoringValue=7
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     RagdollOverride="WlsGlass"
     AccelRate=800.000000
     JumpZ=300.000000
     MovementAnims(2)="RunR"
     MovementAnims(3)="RunL"
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     WalkAnims(2)="WalkR"
     WalkAnims(3)="WalkL"
     AirAnims(0)="JumpF_Mid"
     AirAnims(1)="JumpB_Mid"
     AirAnims(2)="JumpR_Mid"
     AirAnims(3)="JumpL_Mid"
     TakeoffAnims(0)="JumpF_Takeoff"
     TakeoffAnims(1)="JumpB_Takeoff"
     TakeoffAnims(2)="JumpL_Takeoff"
     TakeoffAnims(3)="JumpR_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpB_Land"
     LandAnims(2)="JumpR_Land"
     LandAnims(3)="JumpL_Land"
     DodgeAnims(0)="DodgeF"
     DodgeAnims(1)="DodgeB"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Jump_Mid"
     TakeoffStillAnim="Jump_Takeoff"
     Mesh=SkeletalMesh'fpsMonAnim.Glass'
     DrawScale=2.000000
     PrePivot=(Z=15.000000)
     Skins(0)=Texture'fpsMonTex.Glass.Viscere'
     Skins(1)=Shader'fpsMonTex.Glass.Body'
     CollisionRadius=60.000000
     CollisionHeight=75.000000
     Mass=10.000000
     Buoyancy=150.000000
}
