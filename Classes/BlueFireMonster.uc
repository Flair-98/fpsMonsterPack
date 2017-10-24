//=============================================================================
// Brute. All credit goes to rosebum
//=============================================================================
class BlueFireMonster extends Monster;

var Emitter Effect;

var bool bLeftShot;
var bool bRocketDir;

// Sounds
var(Sounds) sound Footstep[2];
var name MeleeAttack[4];
var sound AmSound[5];

simulated function PostBeginPlay()
{
	local int i;
	i = Rand(5);
	AmbientSound = AmSound[i];

	super.PostBeginPlay();
	If(Level.NetMode != NM_DedicatedServer)
	{
		Effect = self.spawn(class'MonsterBlueFlame', self);
		Effect.SetBase(self);
	}
	
}

function RangedAttack(Actor A)
{
	local vector X,Y,Z;

	if ( VSize(A.Location - Location) < MeleeRange/2.125 + CollisionRadius + A.CollisionRadius && FRand() < 0.3 )
	{
		FireProjectile();

			GetAxes(Rotation,X,Y,Z);
			if ( FRand() < 0.5 )
				Y *= -1;
			if ( FRand() < 0.5 )
				Z *= -1;

			Controller.Destination = Location + 200 * (Normal(Location - A.Location) + VRand());
			Controller.Destination = Controller.Destination + 150*Y + 150*Frand()*Z;

			if ( Location.Z <= A.Location.Z+10 && Controller.Destination.Z <= A.Location.Z+10 )
				Controller.Destination.Z += 50;

			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius && FRand() < 0.2 )
	{
		//SpawnRightShot();

			GetAxes(Rotation,X,Y,Z);
			if ( FRand() < 0.5 )
				Y *= -1;
			if ( FRand() < 0.5 )
				Z *= -1;

			Controller.Destination = Location + 50*FRand() * (Normal(Location - A.Location) + VRand());
			Controller.Destination = Controller.Destination + 300*Y + 300*Frand()*Z;

			if ( Location.Z <= A.Location.Z+10 && Controller.Destination.Z <= A.Location.Z+10 )
				Controller.Destination.Z += 50;

			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
		
	}
}

function FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	local rotator ProjRot;
	local SeekingRocketProj S;
	if ( Controller != None )
	{
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
		ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072; 
		else
			ProjRot.Yaw -= 3072; 
		bRocketDir = !bRocketDir;
		S = Spawn(class'BlueFlameShot',,,FireStart,ProjRot);
        S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
	}
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType)
{
	if (DamageType == class'DamTypeSuperShockBeam')
	{
		Damage = 0;
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, DamageType);
}


function Destroyed()
{
	Super.Destroyed();
	AmbientSound = None;
	if (Effect != None)
		Effect.Kill();
	
}

simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
	bGibbed = true;
	if (Effect != None)
		Effect.Kill();
	SetDrawType(DT_None);
	PlayDyingSound();

    while( GibCountTorso-- > 0 )
        SpawnGiblet( Class'BlueFlameGib', Location, HitRotation, ChunkPerterbation );

}

defaultproperties
{
     Footstep(0)=Sound'SkaarjPack_rc.Brute.walk1br'
     Footstep(1)=Sound'SkaarjPack_rc.Brute.walk2br'
     AmSound(0)=Sound'fpsMonsterPack.BlueFlame.chant'
     AmSound(1)=Sound'fpsMonsterPack.BlueFlame.idlemilkrox'
     AmSound(2)=Sound'fpsMonsterPack.BlueFlame.idlemooserox'
     AmSound(3)=Sound'fpsMonsterPack.BlueFlame.idlemeow'
     AmSound(4)=Sound'fpsMonsterPack.BlueFlame.idleburp'
     HitSound(0)=Sound'fpsMonsterPack.BlueFlame.ucantkillme'
     HitSound(1)=Sound'fpsMonsterPack.BlueFlame.areutrying2killme'
     HitSound(2)=Sound'fpsMonsterPack.BlueFlame.die'
     HitSound(3)=Sound'fpsMonsterPack.BlueFlame.chant'
     DeathSound(0)=Sound'fpsMonsterPack.BlueFlame.goodbye'
     DeathSound(1)=Sound'fpsMonsterPack.BlueFlame.idlemilkrox'
     DeathSound(2)=Sound'fpsMonsterPack.BlueFlame.idlemooserox'
     ChallengeSound(0)=Sound'fpsMonsterPack.BlueFlame.usuck'
     ChallengeSound(1)=Sound'fpsMonsterPack.BlueFlame.hello'
     ChallengeSound(2)=Sound'fpsMonsterPack.BlueFlame.plzgoaway'
     ChallengeSound(3)=Sound'fpsMonsterPack.BlueFlame.urdeadson'
     AmmunitionClass=Class'fpsMonsterPack.BlueFlameAmmo'
     ScoringValue=5
     GibGroupClass=Class'fpsMonsterPack.BlueFlameGibGroup'
     GibCountTorso=10
     MeleeRange=22280.000000
     GroundSpeed=50.000000
     WaterSpeed=50.000000
     JumpZ=1000.000000
     Health=2500
     LightHue=222
     LightSaturation=10
     LightBrightness=64.000000
     LightRadius=64.000000
     LightPeriod=32
     LightCone=128
     DrawType=DT_Sprite
     Texture=Texture'fpsMonTex.milk.firesmile'
     DrawScale=0.250000
     Skins(0)=None
     Skins(1)=None
     TransientSoundVolume=255.000000
     TransientSoundRadius=5500.000000
     CollisionRadius=47.000000
     CollisionHeight=52.000000
     Mass=400.000000
     Buoyancy=390.000000
     RotationRate=(Yaw=45000,Roll=0)
}
