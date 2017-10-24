class MagdalenaINI extends Monster config(fpsMonsterPack);

var config float fHealth;
var sound FootStep[2];
var name DeathAnim[4];
var byte sprayoffset;
var()	class<xEmitter> FlashEmitterClass;
var()	xEmitter FlashEmitter;
var()	class<xEmitter> SmokeEmitterClass;
var()	xEmitter SmokeEmitter;
var	float Momentum;
var	float TraceRange;
var	class<DamageType>  MyDamageType;
var	class<xEmitter>     mTracerClass;
var	xEmitter            mTracer;
var	float				mTracerFreq;
var	float				mTracerLen;
var	float				mLastTracerTime;
var	vector				mHitLocation,mHitNormal;
var	rotator				mHitRot;
var	float				mTracerUpdateTime;
var() int SprayDamage,SprayDamageMax;
var FireProperties RocketFireProperties;
var class<Ammunition> RocketAmmoClass;
var Ammunition RocketAmmo;
var() int PunchDamage;
var() sound Punch;
var() sound PunchHit;
var() sound Flip;
var() sound CheckWeapon;
var() sound WeaponSpray;
var() sound syllable1;
var() sound syllable2;
var() sound syllable3;
var() sound syllable4;
var() sound syllable5;
var() sound syllable6;
var() sound breath;
var() sound footstep1;

var bool bLeftShot;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Health = fHealth;
}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('Monster') || P.IsA('MagdalenaINIv3') || P.IsA('blueskaarjbaby') || P.IsA('Skaarj') || P.IsA('SkaarjPupae')));
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
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Y + 0.4 * CollisionHeight * Z;
}

simulated	function DoFireEffect()
{
    MakeNoise(1.0);
	InitEffects();
    FlashMuzzleFlash();
    StartMuzzleSmoke();
}

function PlaySoundINI()
{
	PlaySound(Sound'ONSVehicleSounds-S.PRV.PRVFire02');
}

simulated function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal, RefNormal;
    local int Damage;
    local Actor Other;
    local bool bDoReflect;
    local int ReflectNum;


    ReflectNum = 0;
    while (true)
    {
        bDoReflect = false;
        X = Vector(Dir);
        End = Start + TraceRange * X;

        Other = Trace(HitLocation, HitNormal, End, Start, true);

   		if ( Role == ROLE_Authority )
   		{
			mHitLocation=HitLocation;
        	mHitNormal=HitNormal;
        }


		Damage=SprayDamage+Rand(SprayDamageMax-SprayDamage);
        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
            {
                bDoReflect = true;
                HitNormal = Vect(0,0,0);
            }
            else  if (!Other.bWorldGeometry)
            {
            	if(Level.NetMode != NM_Client)
            	{
                Other.TakeDamage(Damage, self, HitLocation, Momentum*X, MyDamageType);
                HitNormal = Vect(0,0,0);
                }
            }
            else
            {
                SpawnHitEffect(Other, mHitLocation, mHitNormal);
            }
        }
        else
        {
            HitLocation = End;
            HitNormal = Vect(0,0,0);
        }

        UpdateTracer();

        if (bDoReflect && ++ReflectNum < 4)
        {
            Start = HitLocation;
            Dir = Rotator(RefNormal); //Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else
        {
            break;
        }
    }
    return;
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
	local float decision;
	if ( bShotAnim )
		return;
	bShotAnim=true;
	decision = FRand();

	if ( Physics == PHYS_Swimming )
		SetAnimAction('Swim_Thread');
	else if ( Velocity == vect(0,0,0) )
	{
		if (decision < 0.35)
		{
			SetAnimAction('Weapon_Switch');
                        FireProjectile();
                        PlaySoundINI();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('Crouch');
			SpawnTwoShots();
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
			FireProjectile();
			PlaySoundINI();
		}
		else
		{
			sprayoffset = 0;
			SetAnimAction('WalkF');
			FireProjectile();
			PlaySoundINI();
		}
	}
}

simulated function SprayTarget()
{
	local rotator AdjRot;
	local Vector StartTrace;
	local vector RotX,RotY,RotZ;

	GetAxes(Rotation, RotX, RotY, RotZ);
	StartTrace = GetFireStart(RotX, RotY, RotZ); //ViewSpot;//Location;// + Instigator.EyePosition();
	if(Controller!=none)
	{
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

		AdjRot = Controller.AdjustAim(SavedFireProperties,StartTrace,600);
	}

	if ( GetAnimSequence() == 'Dead5' )
		AdjRot.Yaw += 1500 * (2 - sprayOffset);
	else
		AdjRot.Yaw += 500 * (3 - sprayOffset);
	sprayoffset++;

	if ( GetAnimSequence() == 'Dead5' )
		sprayoffset++;

    DoFireEffect();
    DoTrace(StartTrace,AdjRot);
}

simulated function UpdateTracer()
{
    local float len;
    local float invSpeed, hitDist;
	local Vector RotX,RotY,RotZ;
	local vector FireStart;

    if (Level.NetMode == NM_DedicatedServer)
        return;

    mTracerUpdateTime = Level.TimeSeconds;
	GetAxes(Rotation,RotX,RotY,RotZ);
	FireStart=GetFireStart(RotX,RotY,RotZ);
	mHitRot = rotator(mHitLocation - FireStart);

	if (mTracer == None)
        mTracer = Spawn(mTracerClass);

    if ( Level.bDropDetail || Level.DetailMode == DM_Low )
		mTracerFreq = 2 * Default.mTracerFreq;
	else
		mTracerFreq = Default.mTracerFreq;

    if (mTracer != None &&
        Level.TimeSeconds > mLastTracerTime + mTracerFreq)
    {
        mTracer.SetLocation(FireStart);
        mTracer.SetRotation(mHitRot);

		hitDist = VSize(mHitLocation - FireStart);

        len = mTracerLen * hitDist;
        invSpeed = 1.f / mTracer.mSpeedRange[1];

        mTracer.mLifeRange[0] = len * invSpeed;
        mTracer.mLifeRange[1] = mTracer.mLifeRange[0];
        mTracer.mSpawnVecB.Z = -1.f * (1.0-mTracerLen) * hitDist * invSpeed;
        mTracer.mStartParticles = 1;

        mLastTracerTime = Level.TimeSeconds;
    }
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
        PlayAnim('DeathF',, 0.2);
    else if ( Dir Dot X < -0.7 )
         PlayAnim('DeathB',, 0.2);
    else if ( Dir Dot Y > 0 )
        PlayAnim('DeathL',, 0.2);
    else if ( HasAnim('DeathF') )
        PlayAnim('DeathL',, 0.2);
    else
        PlayAnim('DeathR',, 0.2);
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
     fHealth=1000.000000
     Footstep(0)=Sound'SkaarjPack_rc.Cow.walkC'
     Footstep(1)=Sound'SkaarjPack_rc.Cow.walkC'
     bTryToWalk=True
     AmmunitionClass=Class'fpsMonsterPack.blastAmmo'
     ScoringValue=15
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     RagdollOverride="Magdalena"
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
     Mesh=SkeletalMesh'fpsMonAnim.Magdalena'
     DrawScale=1.800000
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'fpsMonTex.Magdalena.magdalena_body'
     Skins(1)=Texture'fpsMonTex.Magdalena.magdalena_head'
     CollisionRadius=50.000000
     CollisionHeight=75.000000
     Buoyancy=150.000000
}
