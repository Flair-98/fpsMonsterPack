class Reaper extends Monster;

/* Animations */
//Challenge, Challenge2, WagFinger, ThoatCut
//back (more like an idle), Backward, Forward, stafeleft, StrafeRight
//Attack1, Attack2, longslash, forwardhack
//Deflect
var name MeleeAttack[4];
var bool bAttackSuccess;
var bool bDeflecting;
var float LastDeflectTime;

var Emitter MyDeathTrail;
var Emitter Orb;

var bool bTeleporting;
var		byte AChannel;
var vector TelepDest;
var Vector SpawnOffset;
var Vector OrbSpawnLocation;
var bool bTimeToMoveReaper;


var float LastTelepoTime;


var float LastEnemyTime;
var bool bDontTeleport;
var Pawn PossibleEnemy;

replication
{
	reliable if(Role==ROLE_Authority )
         bTeleporting;
}

//Sadly we have no death ANIMS or Hit ANIMS
//Dean, please make some.
simulated function PlayDirectionalDeath(Vector HitLoc)
{
	PlayAnim('Die');	
	spawn(class'ReaperReturnemitter');
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	//TweenAnim('TakeHit', 0.05);
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if( Level.NetMode != NM_DedicatedServer )
	{
		MyDeathTrail = Spawn(class'Reapersmoke');
		MyDeathTrail.SetBase(self);
	}
	if (Role == Role_Authority)
	{
		LastEnemyTime = Level.TimeSeconds;
		SetTimer(fmax(15,100*frand()), true);
	}
}

simulated function Destroyed()
{
	Super.Destroyed();
	if( MyDeathTrail != None )
	{
		MyDeathTrail.Destroy();
	}

}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return GetBoneCoords('righthand').Origin;
}

/**
 * Creates an orb and attaches it to the righthand of the reaper
 * server-side only (technically, the emitter is client side). 
 */
         
function SpawnOrb()
{

	local emitter REB;
	
	REB = Spawn(class'ReaperEnergyBall_inHand');
    AttachToBone(REB, 'righthand');
}


function ShootOrb()
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

	
	ReaperProjectile(Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation));

}

simulated event SetAnimAction(name NewAction)
{
    if ( !bWaitForAnim || (Level.NetMode == NM_Client) )
    {
		AnimAction = NewAction;
		if (NewAction == 'Deflect' && LoopAnim('Deflect',2.0,0.05))
		{
			if ( Physics != PHYS_None )
				bWaitForAnim = true;
		}
		else if ( PlayAnim(AnimAction,,0.1))
		{
			if ( Physics != PHYS_None )
				bWaitForAnim = true;
		}
    }
}


function RangedAttack(Actor A)
{

	local name Anim;
	local float frame,rate;
	local float dist;

	if ( bShotAnim )
		return;
		
	dist = VSize(A.Location-Location);
	GetAnimParams(0,Anim,frame,rate);
	if ( bDeflecting )
	{
			SetAnimAction('Deflect');
			if( LastDeflectTime + 0.5 < Level.TimeSeconds)
			{
				bDeflecting = false;
			}
	}
	else if ( ( abs(A.Location.Z - Location.Z ) < 500 ) && Dist < (10000 + CollisionRadius + A.CollisionRadius) && Dist > 400 && (fRand() < 0.8) )
	{
		//bShotAnim = true;	
		Controller.Destination = A.Location + VRand()*4;
		//Controller.Destination.Z = A.Location.Z + 70;
		
		Velocity = GroundSpeed * normal(Controller.Destination - Location);
		Controller.GotoState('TacticalMove', 'DoMove');
		//SetTimer(0.5,False);
		return;
	}
	else if ( dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		PlaySound(sound'strike1k',SLOT_Talk);
		SetAnimAction(MeleeAttack[Rand(4)]);
		//Controller.bPreparingMove = true;
		//Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
	else if( !bDontTeleport && VSize(A.Location-Location) > 1000 && !bTeleporting && (fRand() < 0.1))
	{
		GotoState('Teleporting');
		//Controller.bPreparingMove = true;
		//Acceleration = vect(0,0,0);
		//bShotAnim = true;
	}	
	else if(((dist > 10000 || dist < 800) && fRand() < 0.1) || fRand() < 0.01) 
	{
		bShotAnim = true;
		SetAnimAction('ReaperThrow');
	}


}

function SliceDamageTarget()
{
	bAttackSuccess = MeleeDamageTarget(1000000, vect(0,0,0));//should be instagibish.
	if ( bAttackSuccess )
		PlaySound(sound'hit2k',SLOT_Interact);
}

//Defenses 

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	local Vector HitDir;
	local Vector FaceDir;
	
	
	FaceDir=vector(Rotation);
	HitDir = Normal(Location-HitLocation+ Vect(0,0,8));
	RefNormal=FaceDir;
	if ( FaceDir dot HitDir < -0.26 ) // 68 degree protection arc
	{
		LastDeflectTime = Level.TimeSeconds;
		bDeflecting = true;

		return true;
	}
	return false;
}


function Teleport()
{
		local rotator EnemyRot;

		if ( Role == ROLE_Authority )
			ChooseDestination();
		SetLocation(TelepDest+vect(0,0,50));
		if(Controller.Enemy!=none)
			EnemyRot = rotator(Controller.Enemy.Location - Location);
		EnemyRot.Pitch = 0;
		setRotation(EnemyRot);
		//PlaySound(sound'Teleport1', SLOT_Interface);

}

function ChooseDestination()
{
	local NavigationPoint N;
	local vector ViewPoint, Best;
	local float rating, newrating;
	local Actor jActor;
	Best = Location;
	TelepDest = Location;
	rating = 0;
	if(Controller.Enemy==none)
		return;
	for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
			newrating = 0;

			ViewPoint = N.Location +vect(0,0,1)*CollisionHeight/2;
			if (FastTrace( Controller.Enemy.Location,ViewPoint))
				newrating += 20000;
			newrating -= VSize(N.Location - Controller.Enemy.Location) + 1000 * FRand();
			foreach N.VisibleCollidingActors(class'Actor',jActor,CollisionRadius,ViewPoint)
				newrating -= 30000;
			if ( newrating > rating )
			{
				rating = newrating;
				Best = N.Location;
			}
   	}
	TelepDest = Best;
}

simulated function Tick(float DeltaTime)
{
	if(bTeleporting)
	{
		AChannel-=300 *DeltaTime;
	}
	else
		AChannel=40;

		/*
	if(MonsterController(Controller)!=none && Controller.Enemy==none)
	{
		if(MonsterController(Controller).FindNewEnemy())
		{
			GotoState('Teleporting');
	    }
	}
*/

	super.Tick(DeltaTime);
}


state Teleporting
{
	function Tick(float DeltaTime)
	{
		if(AChannel<20)
		{
            if (ROLE == ROLE_Authority)
				Teleport();
			GotoState('');
		}
		global.Tick(DeltaTime);
	}


	function RangedAttack(Actor A)
	{
		return;
	}
	
	function BeginState()
	{
		if(Controller.Enemy==none)
		{
			GotoState('');
			return;
		}
		bTeleporting=true;
		Acceleration = Vect(0,0,0);
		AChannel=40;
		Spawn(class'ReaperReturnemitter',,,Location);
	}

	function EndState()
	{

        bTeleporting=false;
		AChannel=40;
		LastTelepoTime=Level.TimeSeconds;
	}
}


function timer()
{
	if(bTimeToMoveReaper){
		//Level.Game.Broadcast(Instigator.Controller, "Time to move the reaper to:"@OrbSpawnLocation);
		SetLocation(OrbSpawnLocation);
		SetPhysics(PHYS_Falling);
		if(PossibleEnemy != None){
			MonsterController(Controller).ChangeEnemy(PossibleEnemy,MonsterController(Controller).CanSee(PossibleEnemy));
		}
		else{
			MonsterController(Controller).FindNewEnemy();
		}

		bTimeToMoveReaper=false;
		bDontTeleport = true;
		SetTimer(100, true);
		return;
	}
	if( Controller.Enemy != None){
		LastEnemyTime = Level.TimeSeconds;
		bDontTeleport = false;
	}
	if( LastEnemyTime < Level.TimeSeconds - 21){
		SpawnDeathOrb();
		return;
	}
	SetTimer(fmax(15,100*frand()), true);

	


}

function SpawnDeathOrb () {
	//spawn an orb that searches for a new possible location for the monster.
	local Pawn P;
	local Array<Pawn> MapPawns;
	local int i,j;
	
	OrbSpawnLocation = Vect(0,0,0);
	
	//Make a list of pawns, find where there is a group of people.
	i=0;
	ForEach DynamicActors(class'Pawn', P)
	{
		if ( P.Controller != None && !P.isA('Monster') && P.Controller.bIsPlayer)
		{
			if ( (P != None) )
			{
				MapPawns[i]=P;	
				i++;
			}
		}
	}
	
	if(Level.Game.bGameEnded)
		return;
	
	if(MapPawns.length > 1){//make sure there's at least two people'
		for( i = 0; i < MapPawns.length; i++ ){
			for ( j = i+1; j < MapPawns.length; j++){
				if(VSize(MapPawns[i].Location - MapPawns[j].Location) < 1000){
					//perhaps log the players 
					OrbSpawnLocation = ((MapPawns[i].Location + MapPawns[j].Location)*0.5) + SpawnOffset;
					PossibleEnemy = MapPawns[i];
					break;
				}
			}
		}
	}
	else {
		OrbSpawnLocation = MapPawns[0].Location + SpawnOffset;
		PossibleEnemy = MapPawns[0];
	}
	
	if(OrbSpawnLocation != Vect(0,0,0)) 
	{
		Spawn(class'ReaperDeathOrbEmitter',,,OrbSpawnLocation);
		//Level.Game.Broadcast(Instigator.Controller, "About to move the reaper to:"@OrbSpawnLocation);

		bTimeToMoveReaper=true;
		SetTimer(2.0, true);
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType)
{
	local Projectile Proj;
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;

	if (InStr(String(DamageType), "LilLady") != -1 && !instigatedBy.isA('Monster')){
		Damage=0;
		GetAxes(Rotation,X,Y,Z);
		FireStart = (instigatedBy.Location + Location)/2;
		FireRotation = Rotator(instigatedBy.Location - Location);
		//Level.Game.Broadcast(Instigator.Controller, "FireMode Class:"@class<WeaponDamageType>(DamageType).default.WeaponClass.default.FireModeClass[0]);
		if(class<ProjectileFire>(class<WeaponDamageType>(DamageType).default.WeaponClass.default.FireModeClass[0]).default.ProjectileClass != none){
			Proj = spawn(class<ProjectileFire>(class<WeaponDamageType>(DamageType).default.WeaponClass.default.FireModeClass[0]).default.ProjectileClass,,,FireStart,FireRotation);
			
		}
	}
	
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, DamageType);
}

defaultproperties
{
     MeleeAttack(0)="Attack1"
     MeleeAttack(1)="Attack2"
     MeleeAttack(2)="longslash"
     MeleeAttack(3)="forwardHack"
     SpawnOffset=(X=50.000000,Y=50.000000,Z=30.000000)
     AmmunitionClass=Class'fpsMonsterPack.ReaperAmmo'
     GroundSpeed=1540.000000
     JumpZ=10.000000
     MovementAnims(0)="NewForward"
     MovementAnims(1)="Backward"
     MovementAnims(2)="StrafeLeft"
     MovementAnims(3)="StrafeRight"
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     WalkAnims(0)="Forward"
     WalkAnims(1)="Backward"
     WalkAnims(2)="StrafeLeft"
     WalkAnims(3)="StrafeRight"
     AirAnims(0)="forwardHack"
     AirAnims(1)="forwardHack"
     AirAnims(2)="forwardHack"
     AirAnims(3)="forwardHack"
     TakeoffAnims(0)="forwardHack"
     TakeoffAnims(1)="forwardHack"
     TakeoffAnims(2)="forwardHack"
     TakeoffAnims(3)="forwardHack"
     LandAnims(0)="forwardHack"
     LandAnims(1)="forwardHack"
     LandAnims(2)="forwardHack"
     LandAnims(3)="forwardHack"
     DoubleJumpAnims(0)="forwardHack"
     DoubleJumpAnims(1)="forwardHack"
     DoubleJumpAnims(2)="forwardHack"
     DoubleJumpAnims(3)="forwardHack"
     DodgeAnims(0)="forwardHack"
     DodgeAnims(1)="forwardHack"
     DodgeAnims(2)="forwardHack"
     DodgeAnims(3)="forwardHack"
     AirStillAnim="forwardHack"
     TakeoffStillAnim="forwardHack"
     Mesh=SkeletalMesh'fpsMonAnim.Reaper'
     Skins(0)=Texture'fpsMonsterPack.ReaperFinal'
     Skins(1)=Texture'fpsMonsterPack.ReaperFinal'
     Mass=150.000000
     Buoyancy=150.000000
     RotationRate=(Yaw=60000)
}
