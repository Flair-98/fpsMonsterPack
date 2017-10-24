class InfernalBlue extends Monster config (fpsMonsterPack);

// Log: PlayAnim: Sequence 'Jump' not found for mesh 'Infernal'

var bool bLeftShot;
var name AttackAnims[5];
var()	int		        PoundDamage;           // speaks for itself
var	Emitter		FireEmitter0;           // Flame effects
var	Emitter		FireEmitter1;           // Flame effects
var	Emitter		FireEmitter2;           // Flame effects
var	Emitter		FireEmitter3;           // Flame effects
var	Emitter		FireEmitter4;           // Flame effects
var	Emitter		FireEmitter5;           // Flame effects
var	Emitter		FireEmitter6;           // Flame effects
var 	Emitter		BodyFlame;

var config float fHealth;
var	int	ThrowCount;
var	bool bThrowed;
var()	float	InvalidityMomentumSize;
var() float ProjectileSpeed,ProjectileMaxSpeed;
var()	string	MonsterName;
var()  bool	bNoTelefrag; //cant get telefragged
var() bool bNoCrushVehicle;
var()  array<class<DamageType> >	ReducedDamTypes;
var()  float	ReducedDamPct;
var()  array<class<DamageType> >WeakDamTypes;
var()  float	WeakDamPct;
var()  bool	bReduceDamPlayerNum; //ReduceDamage by Players Number

var float BlastDamage, BlastDamageRadius;
var class<DamageType> BlastDamageType;
var float BlastMomentumTransfer;

Var Bool bIsChallenge;    //to stop take dammage while challenging

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Health = fHealth;
}

event EncroachedBy( actor Other )
{
	local float Speed;
	local vector Dir,Momentum;

	if ( xPawn(Other) != None && bNoTelefrag)
		return;
	if(bNoCrushVehicle && Vehicle(Other)!=none)
	{
		Speed=VSize(Vehicle(Other).Velocity);
		Dir=Normal(Vehicle(Other).Velocity);
		log("dot=" $ Dir dot Normal(Location-Other.Location));

		if(Dir dot Normal(Location-Other.Location)>0)
		{
			Dir=-Dir;
			Momentum=Dir*Speed*Mass*0.1;
			Vehicle(Other).KAddImpulse(Momentum, Other.location);
		}
	}

	super.EncroachedBy(Other);
}

simulated function PostNetBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
	SpawnSpine2();
	SpawnLeftLeg();
	SpawnRightLeg();
	SpawnLeftArm();
	SpawnRightArm();
	SpawnBodyFlame();
	SpawnCrotch();
	}
	Super.PostNetBeginPlay();
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
						vector momentum, class<DamageType> damageType)
{

	local int i;
	local float DamageProb;


	if(InvalidityMomentumSize>VSize(momentum))
		momentum=vect(0,0,0);

	for(i=0;i<ReducedDamTypes.length;i++)
		if(damageType==ReducedDamTypes[i])
			Damage*=ReducedDamPct;

	for(i=0;i<WeakDamTypes.length;i++)
		if(damageType==WeakDamTypes[i])
			Damage*=WeakDamPct;


	if(Damage>0)
	{
		if(bReduceDamPlayerNum)
		{
			DamageProb=float(Damage)/(Level.Game.NumPlayers+Level.Game.NumBots);
			if(DamageProb<1 && Frand()<DamageProb)
				Damage=1;
			else
				Damage=DamageProb;

		}
	}

	if(bNoCrushVehicle && class<DamTypeRoadkill>(damageType)!=none && Damage>10)
		Damage=10;
		


	if(bIsChallenge)
		Damage*=0;


        Damage*=0.2;
	super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('Infernal') || P.IsA('Monster') || P.IsA('Skaarj') || P.IsA('SkaarjPupae')));
}

////////////////////////////////////////////////////////////////////////////////////////
//                           Effects functions                                        //
////////////////////////////////////////////////////////////////////////////////////////

function PlayVictory()
{
        bIsChallenge=true;
	SetPhysics(PHYS_Falling);
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
        PlaySound(sound'infgrowl04e',SLOT_Interact);
	if ( FRand() < 0.5 )
	{
        SetAnimAction('VictoryAnim');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
        return;
        }
        SetAnimAction('Challenge');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');


}


simulated function SpawnSpine2()
{       local vector EffectPos;

  Effectpos = location + Vect(0,1,0);
  FireEmitter0 = Spawn(class'InfernalBlueFlame',,,Effectpos);
  AttachToBone(FireEmitter0, 'Spine3');
}

simulated function SpawnLeftLeg()
{
  FireEmitter1 = Spawn(class'InfernalBlueFlame');
  AttachToBone(FireEmitter1, 'LeftLeg');
}

simulated function SpawnRightLeg()
{
  FireEmitter2 = Spawn(class'InfernalBlueFlame');
  AttachToBone(FireEmitter2, 'RightLeg');
}

simulated function SpawnLeftArm()
{
    local vector EffectPos;

  Effectpos = location + Vect(128,0,0);

  FireEmitter3 = Spawn(class'InfernalBlueFlame');
  AttachToBone(FireEmitter3, 'LeftArm');
}

simulated function SpawnRightArm()
{

  FireEmitter4 = Spawn(class'InfernalBlueFlame');
  AttachToBone(FireEmitter4, 'RightArm');
}

simulated function SpawnCrotch()
{

  FireEmitter5 = Spawn(class'TinyBlueFlame');
  AttachToBone(FireEmitter5, 'RightThigh');


  FireEmitter6 = Spawn(class'TinyBlueFlame');
  AttachToBone(FireEmitter6, 'LeftThigh');

}

simulated function SpawnBodyFlame()
{

  BodyFlame = Spawn(class'HugeBlueFlame',self);
  BodyFlame.SetOwner(self);
  BodyFlame.SetBase(self);
}

////////////////////////////////////////////////////////////////////////////////////////
//                               Attack   Functions                                   //
////////////////////////////////////////////////////////////////////////////////////////

simulated function Pound()
{

		 DoDamage(BlastDamageRadius);
		 SpawnBlastEffect();
}

function DoDamage(float Radius)
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local float dist2, shake;

	foreach VisibleCollidingActors(class 'Actor', Victims, Radius, Location)
	{
		if(Victims != None && !Victims.isA('Monster'))
		{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if ( Victims != none && Victims != self && Victims != Instigator && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo')
		     && (Pawn(Victims) == None || TeamGame(Level.Game) == None || TeamGame(Level.Game).FriendlyFireScale > 0
		         || Pawn(Victims).Controller == None || !Pawn(Victims).Controller.SameTeamAs(Controller(Owner))) )
		{
			dir = Victims.Location - Location;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/BlastDamageRadius);
			if (Pawn(Victims) != None)
				Pawn(Victims).HitDamageType = BlastDamageType;
			Victims.SetDelayedDamageInstigatorController(Instigator.Controller);
			Victims.TakeDamage
			(
				damageScale * BlastDamage,
				self,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * BlastMomentumTransfer * dir),
				BlastDamageType
			);
			dist2 = VSize(Location - Victims.Location);
			shake = 1.0*FMax(500, Mass - dist2);
			if(Pawn(Victims) != None && Pawn(Victims).Controller!=none)
				Pawn(Victims).Controller.ShakeView( vect(0.0,0.02,0.0)*shake, vect(0,1000,0),0.003*shake, vect(0.02,0.02,0.02)*shake, vect(1000,1000,1000),0.003*shake);

		}
		}
	}
}

simulated function SpawnBlastEffect()
{
	local vector EffectPos;
	if(Level.Netmode != NM_DedicatedServer)
	{
	        Effectpos = location + Vect(0,0,-120);
		    Spawn(Class'Onslaught.ONSTankHitRockEffect',,,Effectpos);
	}
}


function SmashDamage()
{
     (MeleeDamageTarget(PoundDamage, (70000.0 * Normal(Controller.Target.Location - Location))) ) ;
}
function RangedAttack(Actor A)
{
        bIsChallenge=False;
	if ( bShotAnim )
		return;
		


	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		if ( FRand() < 0.5 )
  			{
                          SetAnimAction('LeftPound');
                          Return;
                        }
                  	  SetAnimAction('RightPound');
                       	  Return;
	}

	else

                 SetAnimAction(AttackAnims[Rand(5)]);
                 Controller.bPreparingMove = true;
                 Acceleration = vect(0,0,0);
	         bShotAnim = true;
	         Return;



}

function SpawnLeftShotBig()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
        bLeftShot = true;
	GetAxes(Rotation,X,Y,Z);
	FireStart = GetFireStart(X,Y,Z);
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	Spawn(class'SeekingInfernalProjectileBlue',,,FireStart,FireRotation);
}


function SpawnLeftShot()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
        bLeftShot = true;
	GetAxes(Rotation,X,Y,Z);
	FireStart = GetFireStart(X,Y,Z);
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	Spawn(class'InfernalProjectileBlue',,,FireStart,FireRotation);
}


function SpawnRightShot()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
        bLeftShot = false;
	GetAxes(Rotation,X,Y,Z);
	FireStart = GetFireStart(X,Y,Z);
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	Spawn(class'InfernalProjectileBlue',,,FireStart,FireRotation);
}
function SpawnRightShotBig()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
        bLeftShot = false;
	GetAxes(Rotation,X,Y,Z);
	FireStart = GetFireStart(X,Y,Z);
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	Spawn(class'SeekingInfernalProjectileBlue',,,FireStart,FireRotation);
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
	if ( bLeftShot )
		return Location + CollisionRadius * ( X - 0.9 * Y + 1.0 * Z);
	else
		return Location + CollisionRadius * ( X + 0.9 * Y + 1.0 * Z);
}


////////////////////////////////////////////////////////////////////////////////////////
//                              other stuff                                           //
////////////////////////////////////////////////////////////////////////////////////////

simulated function AnimEnd(int Channel)
{
	local name Anim;
	local float frame,rate;
	
	if ( Channel == 0 )
	{
		GetAnimParams(0, Anim,frame,rate);
		if ( Anim == 'Idle_Rest' )
			IdleWeaponAnim = 'Idle_Rest1';
		else if ( (Anim == 'Idle_Rest1') && (FRand() < 0.5) )
			IdleWeaponAnim = 'Idle_Rest2';
	}
	Super.AnimEnd(Channel);
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	if ( Damage > 500)
		Super.PlayTakeHit(HitLocation,Damage,DamageType);
}

simulated function Destroyed()
{
	if ( FireEmitter0 != None )
	                 {
                         Detachfrombone(FireEmitter0);
                         FireEmitter0.Destroy();
                         }
        if ( FireEmitter1 != None )
	                 {
                         Detachfrombone(FireEmitter1);
                         FireEmitter1.Destroy();
                         }
	if ( FireEmitter2 != None )
	                 {
                         Detachfrombone(FireEmitter2);
                         FireEmitter2.Destroy();
                         }
        if ( FireEmitter3 != None )
	                 {
                         Detachfrombone(FireEmitter3);
                         FireEmitter3.Destroy();
                         }
        if ( FireEmitter4 != None )
	                 {
                         Detachfrombone(FireEmitter4);
                         FireEmitter4.Destroy();
                         }
        if ( FireEmitter5 != None )
	                 {
                         Detachfrombone(FireEmitter5);
                         FireEmitter5.Destroy();
                         }
        if ( FireEmitter6 != None )
	                 {
                         Detachfrombone(FireEmitter6);
                         FireEmitter6.Destroy();
                         }
        if ( BodyFlame != None )
	{
                         BodyFlame.Destroy();
        }


	Super.Destroyed();
}


simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
	bGibbed = true;
	PlayDyingSound();


    SpawnGiblet( GetGibClass(EGT_Torso), Location, HitRotation, ChunkPerterbation );
    GibCountTorso--;

    while( GibCountTorso-- > 0 )
        SpawnGiblet( GetGibClass(EGT_Torso), Location, HitRotation, ChunkPerterbation );
    while( GibCountHead-- > 0 )
        SpawnGiblet( GetGibClass(EGT_Head), Location, HitRotation, ChunkPerterbation );
    while( GibCountForearm-- > 0 )
        SpawnGiblet( GetGibClass(EGT_UpperArm), Location, HitRotation, ChunkPerterbation );
    while( GibCountUpperArm-- > 0 )
        SpawnGiblet( GetGibClass(EGT_Forearm), Location, HitRotation, ChunkPerterbation );
}

defaultproperties
{
     AttackAnims(0)="ThrowRightV2"
     AttackAnims(1)="ThrowLeftV2"
     AttackAnims(2)="TwoHandPound"
     AttackAnims(3)="ThrowRight"
     AttackAnims(4)="ThrowLeft"
     PoundDamage=2000
     fHealth=2000.000000
     InvalidityMomentumSize=1500.000000
     ProjectileSpeed=5500.000000
     ProjectileMaxSpeed=5500.000000
     MonsterName="InfernalBlue"
     bNoTeleFrag=True
     bNoCrushVehicle=True
     ReducedDamPct=0.250000
     WeakDamPct=0.500000
     BlastDamage=1550.000000
     BlastDamageRadius=4096.000000
     BlastDamageType=Class'fpsMonsterPack.DamTypeInfernal'
     BlastMomentumTransfer=500000.000000
     bTryToWalk=True
     bBoss=True
     HitSound(0)=Sound'fpsMonsterPack.infgrowl02'
     HitSound(1)=Sound'fpsMonsterPack.infgrowl05e'
     HitSound(2)=Sound'fpsMonsterPack.infgrowl02'
     HitSound(3)=Sound'fpsMonsterPack.infgrowl05e'
     DeathSound(0)=Sound'fpsMonsterPack.infgrowl01'
     DeathSound(1)=Sound'fpsMonsterPack.infgrowl04e'
     DeathSound(2)=Sound'fpsMonsterPack.RockMonsterRoarv3'
     DeathSound(3)=Sound'fpsMonsterPack.infgrowl04e'
     ChallengeSound(0)=Sound'fpsMonsterPack.InfernalRoar'
     ChallengeSound(1)=Sound'fpsMonsterPack.infgrowl01'
     ChallengeSound(2)=Sound'fpsMonsterPack.RockMonsterRoarv3'
     ChallengeSound(3)=Sound'fpsMonsterPack.infgrowl04e'
     AmmunitionClass=Class'fpsMonsterPack.InfernalAmmoBlue'
     ScoringValue=8
     GibGroupClass=Class'fpsMonsterPack.GibGroup'
     GibCountCalf=2
     GibCountHead=1
     GibCountTorso=1
     bCanSwim=False
     SightRadius=1000000.000000
     MeleeRange=128.000000
     GroundSpeed=450.000000
     WaterSpeed=50.000000
     JumpZ=0.000000
     Health=2000
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkF"
     MovementAnims(3)="WalkF"
     TurnLeftAnim="WalkF"
     TurnRightAnim="WalkF"
     WalkAnims(2)="WalkF"
     WalkAnims(3)="WalkF"
     AirAnims(0)="WalkF"
     AirAnims(1)="WalkF"
     AirAnims(2)="WalkF"
     AirAnims(3)="WalkF"
     TakeoffAnims(0)="WalkF"
     TakeoffAnims(1)="WalkF"
     TakeoffAnims(2)="WalkF"
     TakeoffAnims(3)="WalkF"
     LandAnims(0)="WalkF"
     LandAnims(1)="WalkF"
     LandAnims(2)="WalkF"
     LandAnims(3)="WalkF"
     DodgeAnims(0)="RightDodge"
     DodgeAnims(1)="LeftDodge"
     DodgeAnims(2)="RightDodge"
     DodgeAnims(3)="LeftDodge"
     AirStillAnim="WalkF"
     TakeoffStillAnim="WalkF"
     IdleWeaponAnim="Idle_Rest2"
     IdleRestAnim="Idle_Rest1"
     Mesh=SkeletalMesh'fpsMonAnim.Infernal'
     DrawScale=6.000000
     Skins(0)=Combiner'fpsMonTex.Infernal.InfernalSkin'
     CollisionRadius=100.000000
     CollisionHeight=180.000000
     Mass=3000.000000
     RotationRate=(Yaw=500)
}
