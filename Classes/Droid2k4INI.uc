//=============================================================================
//=============================================================================
class Droid2k4INI extends Monster config(fpsMonsterPack);

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
var  Sound DeathSoundINI[4];
var config float fHealth;
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

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlaySound(sound'pain100',SLOT_Interact);	
	SetAnimAction('gesture_cheer');
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
	PlaySound(Sound'ONSVehicleSounds-S.PRV.PRVFire01');
}

function RangedAttack(Actor A)
{
	local float decision;
	if ( bShotAnim )
		return;
	bShotAnim=true;
	decision = FRand();

	if ( Physics == PHYS_Swimming )
		SetAnimAction('SwimFire');
	else if ( Velocity == vect(0,0,0) )
	{
		if (decision < 0.35)
		{
			SetAnimAction('Weapon_Switch');
                        SpawnRocketINI();
                        PlaySoundINI();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('Weapon_Switch');
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
			SetAnimAction('WalkF');
			SpawnRocket();
			PlaySoundINI();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('WalkF');
			SpawnRocket();
			PlaySoundINI();
		}
	}
}
simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
	if ( sprayoffset >= 1 && sprayoffset <= 5 )
	{
		if ( GetAnimSequence() == 'Weapon_Switch' )
			return Location + 1.25 * CollisionRadius * X - CollisionRadius * (0.2 * sprayoffset - 0.3) * Y;
		else
			return Location + 1.25 * CollisionRadius * X - CollisionRadius * (0.1 * sprayoffset - 0.1) * Y;
	}
	else
		return Location + 0.9 * CollisionRadius * X - 0.9 * CollisionRadius * Y;
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

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SMPTitan') || P.IsA('SMPQueen') || P.IsA('Monster')|| P.IsA('Skaarj') || P.IsA('SkaarjPupae') || P.IsA('Droid2k4INI')));
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
    PlaySound(DeathSoundINI[Rand(4)], SLOT_Pain,1000*TransientSoundVolume, true,800);
}

defaultproperties
{
     SmokeEmitterClass=Class'XEffects.MinigunMuzzleSmoke'
     MyDamageType=Class'fpsMonsterPack.DamTypeFireChuckerFire'
     RocketAmmoClass=Class'fpsMonsterPack.FireFAmmo'
     DeathSoundINI(0)=Sound'fpsMonsterPack.pain100'
     DeathSoundINI(1)=Sound'fpsMonsterPack.pain100'
     DeathSoundINI(2)=Sound'fpsMonsterPack.pain100'
     DeathSoundINI(3)=Sound'fpsMonsterPack.pain100'
     fHealth=1000.000000
     bMeleeFighter=False
     bTryToWalk=True
     HitSound(0)=Sound'fpsMonsterPack.combolite'
     HitSound(1)=Sound'fpsMonsterPack.combolite'
     HitSound(2)=Sound'fpsMonsterPack.combolite'
     HitSound(3)=Sound'fpsMonsterPack.combolite'
     AmmunitionClass=Class'fpsMonsterPack.FireFAmmo'
     ScoringValue=7
     GibGroupClass=Class'XEffects.xBotGibGroup'
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     RagdollOverride="Droid2k4"
     AccelRate=800.000000
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
     Mesh=SkeletalMesh'fpsMonAnim.Droid_Alien'
     DrawScale=2.000000
     PrePivot=(Z=15.000000)
     Skins(0)=Texture'fpsMonTex.Droid.Headtex'
     Skins(1)=Texture'fpsMonTex.Droid.Bodytex'
     CollisionRadius=60.000000
     CollisionHeight=75.000000
     Mass=50.000000
     Buoyancy=150.000000
}
