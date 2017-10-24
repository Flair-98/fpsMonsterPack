class BenderINI extends Monster config(fpsMonsterPack);

var config int nLaughFrequency;
var config float fHealth;
var config int nScoreValue;
var config float fFireRate;
var  Sound DeathSoundINI[47];
var int nLastLaugh;
var name DeathAnim[4];
var byte sprayoffset;
var()	class<xEmitter> FlashEmitterClass;
var()	xEmitter FlashEmitter;
var()	class<xEmitter> SmokeEmitterClass;
var()	xEmitter SmokeEmitter;
var	float Momentum;
var	class<DamageType>  MyDamageType;
var	vector				mHitLocation,mHitNormal;
var	rotator				mHitRot;
var FireProperties RocketFireProperties;
var class<Ammunition> RocketAmmoClass;
var Ammunition RocketAmmo;
var bool bLeftShot;

replication
{
	unreliable if(Role == ROLE_Authority)
		mHitLocation,mHitNormal;
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Health = fHealth;
}

event PostBeginPlay()
{
	Super.PostBeginPlay();
	RocketAmmo=spawn(RocketAmmoClass);

}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SMPTitan') || P.IsA('SMPQueen') || P.IsA('Monster') || P.IsA('Skaarj') || P.IsA('SkaarjPupae') || P.IsA('BenderINIv3')));
}

function SpawnLeftShot()
{
	bLeftShot = True;
	FireProjectile();
}

function SpawnRightShot()
{
	bLeftShot = True;
	FireProjectile();
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;	
	PlaySound(sound'hairflp2sk',SLOT_Interact);	
	SetAnimAction('PThrust');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
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

function PlaySoundINI()
{
	PlaySound(Sound'fpsMonsterPack.BenderShot');
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
			SetAnimAction('Gesture_Taunt01');
                        SpawnRocketINI();
                        PlaySoundINI();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('Gesture_Taunt01');
			SpawnRocketINI();
			PlaySoundINI();
		}
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	else
	{
		if (decision < 0.35)
		{
			SetAnimAction('CrouchF');
			SpawnRocket();
			PlaySoundINI();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('CrouchF');
			SpawnRocket();
			PlaySoundINI();
		}
	}
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
			return Location + 1.25 * CollisionRadius * X - CollisionRadius * (0.1 * sprayoffset - 0.1) * Y;
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

    if ( (FlashEmitterClass != None) && ((FlashEmitter == None) || FlashEmitter.bDeleteMe) )
        FlashEmitter = Spawn(FlashEmitterClass,,,FireStartLoc);

    if ( (SmokeEmitterClass != None) && ((SmokeEmitter == None) || SmokeEmitter.bDeleteMe) )
        SmokeEmitter = Spawn(SmokeEmitterClass,,,FireStartLoc);
}

simulated	function DoFireEffect()
{
    MakeNoise(1.0);
	InitEffects();
    FlashMuzzleFlash();
    StartMuzzleSmoke();
}

simulated function SpawnHitEffect(Actor Other, vector HitLocation, vector HitNormal)
{
    Spawn(class'HitEffect'.static.GetHitEffect(Other, HitLocation, HitNormal),,, HitLocation, Rotator(HitNormal));
}

simulated function FlashMuzzleFlash()
{
	local Vector RotX,RotY,RotZ;
    if (FlashEmitter != None)
    {
		GetAxes(Rotation,RotX,RotY,RotZ);
        FlashEmitter.SetLocation(GetFireStart(RotX, RotY, RotZ));
        FlashEmitter.SetRotation(Rotation);
        FlashEmitter.Trigger(self, self);
    }
}

simulated function StartMuzzleSmoke()
{
	local Vector RotX,RotY,RotZ;
    if ( !Level.bDropDetail && (SmokeEmitter != None) )
   {
   		GetAxes(Rotation,RotX,RotY,RotZ);
        SmokeEmitter.SetLocation(GetFireStart(RotX, RotY, RotZ));
        SmokeEmitter.SetRotation(Rotation);
        SmokeEmitter.Trigger(self, self);
    }
}

function SpawnRocketINI()
{
	local vector RotX,RotY,RotZ,StartLoc;
	local FireBallProjINI R;

	GetAxes(Rotation, RotX, RotY, RotZ);
	StartLoc=GetFireStart(RotX, RotY, RotZ);
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

	R=FireBallProjINI(Spawn(RocketAmmo.ProjectileClass,,,StartLoc,Controller.AdjustAim(RocketFireProperties,StartLoc,600)));
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
    PlaySound(DeathSoundINI[Rand(47)], SLOT_Pain,1000*TransientSoundVolume, true,800);
}

defaultproperties
{
     nLaughFrequency=15
     fHealth=1000.000000
     nScoreValue=8000
     fFireRate=1.000000
     DeathSoundINI(0)=Sound'fpsMonsterPack.fuaaaaagh'
     DeathSoundINI(1)=Sound'fpsMonsterPack.FFGrudge'
     DeathSoundINI(2)=Sound'fpsMonsterPack.FFKilledFather'
     DeathSoundINI(3)=Sound'fpsMonsterPack.FFKillFriends'
     DeathSoundINI(4)=Sound'fpsMonsterPack.FFLawsuit'
     DeathSoundINI(5)=Sound'fpsMonsterPack.FFLookBad'
     DeathSoundINI(6)=Sound'fpsMonsterPack.FFOhMyGod'
     DeathSoundINI(7)=Sound'fpsMonsterPack.FFOuchOhHey'
     DeathSoundINI(8)=Sound'fpsMonsterPack.FFThankYou'
     DeathSoundINI(9)=Sound'fpsMonsterPack.FFWhatTheHell'
     DeathSoundINI(10)=Sound'fpsMonsterPack.fumonster'
     DeathSoundINI(11)=Sound'fpsMonsterPack.futhepain'
     DeathSoundINI(12)=Sound'fpsMonsterPack.ORDWhoa'
     DeathSoundINI(13)=Sound'fpsMonsterPack.OTHClass'
     DeathSoundINI(14)=Sound'fpsMonsterPack.OTHImBoned'
     DeathSoundINI(15)=Sound'fpsMonsterPack.OTHLiesAndSlander'
     DeathSoundINI(16)=Sound'fpsMonsterPack.OTHPointless'
     DeathSoundINI(17)=Sound'fpsMonsterPack.OTHPrizeCash'
     DeathSoundINI(18)=Sound'fpsMonsterPack.OTHSuccessful'
     DeathSoundINI(19)=Sound'fpsMonsterPack.OTHTerribleShame'
     DeathSoundINI(20)=Sound'fpsMonsterPack.OTHTired'
     DeathSoundINI(21)=Sound'fpsMonsterPack.OTHUhOh'
     DeathSoundINI(22)=Sound'fpsMonsterPack.OTHUpToHere'
     DeathSoundINI(23)=Sound'fpsMonsterPack.OTHWhatGonnaDo'
     DeathSoundINI(24)=Sound'fpsMonsterPack.OTHWheredUGo'
     DeathSoundINI(25)=Sound'fpsMonsterPack.OTHWhoaMama'
     DeathSoundINI(26)=Sound'fpsMonsterPack.TTBoneHead'
     DeathSoundINI(27)=Sound'fpsMonsterPack.TTBringItOn'
     DeathSoundINI(28)=Sound'fpsMonsterPack.TTCantLose'
     DeathSoundINI(29)=Sound'fpsMonsterPack.TTCoffinStuffers'
     DeathSoundINI(30)=Sound'fpsMonsterPack.TTColossalAss'
     DeathSoundINI(31)=Sound'fpsMonsterPack.TTCompareLives'
     DeathSoundINI(32)=Sound'fpsMonsterPack.TTCorpse'
     DeathSoundINI(33)=Sound'fpsMonsterPack.TTCrowdWild'
     DeathSoundINI(34)=Sound'fpsMonsterPack.TTCruel'
     DeathSoundINI(35)=Sound'fpsMonsterPack.TTGetLost'
     DeathSoundINI(36)=Sound'fpsMonsterPack.TTGoodnight'
     DeathSoundINI(38)=Sound'fpsMonsterPack.TTHurtSomeone'
     DeathSoundINI(39)=Sound'fpsMonsterPack.TTKillEverybody'
     DeathSoundINI(40)=Sound'fpsMonsterPack.TTLaughing'
     DeathSoundINI(41)=Sound'fpsMonsterPack.TTLightWeight'
     DeathSoundINI(42)=Sound'fpsMonsterPack.TTPimple'
     DeathSoundINI(43)=Sound'fpsMonsterPack.TTRadical'
     DeathSoundINI(45)=Sound'fpsMonsterPack.TTYoMama'
     DeathSoundINI(46)=Sound'fpsMonsterPack.ACKTedious'
     SmokeEmitterClass=Class'XEffects.MinigunMuzzleSmoke'
     MyDamageType=Class'fpsMonsterPack.DamTypeFireChuckerFire'
     RocketAmmoClass=Class'fpsMonsterPack.BenderAmmo'
     bMeleeFighter=False
     bTryToWalk=True
     HitSound(0)=Sound'SkaarjPack_rc.Krall.hit2k'
     HitSound(1)=Sound'SkaarjPack_rc.Krall.hit2k'
     HitSound(2)=Sound'SkaarjPack_rc.Krall.hit2k'
     HitSound(3)=Sound'SkaarjPack_rc.Krall.hit2k'
     AmmunitionClass=Class'fpsMonsterPack.BenderAmmo'
     ScoringValue=8
     GibGroupClass=Class'XEffects.xBotGibGroup'
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     RagdollOverride="Bender"
     AccelRate=800.000000
     JumpZ=550.000000
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
     Mesh=SkeletalMesh'fpsMonAnim.Bender'
     Skins(0)=Texture'fpsMonTex.Bender.Bhead'
     Skins(1)=Texture'fpsMonTex.Bender.Bbody'
     Buoyancy=150.000000
}
