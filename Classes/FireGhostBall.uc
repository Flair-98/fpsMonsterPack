class FireGhostBall extends Gasbag;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	MyAmmo.ProjectileClass = class'FireProjectile';
}

function FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	
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

		Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));
		PlaySound(FireSound,SLOT_Interact);
	}
}

function RangedAttack(Actor A)
{
	local vector adjust;
	
	if ( bShotAnim )
		return;
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		adjust = vect(0,0,0);
		adjust.Z = Controller.Target.CollisionHeight;
		Acceleration = AccelRate * Normal(Controller.Target.Location - Location + adjust);
		PlaySound(sound'twopunch1g',SLOT_Talk);
		if (FRand() < 0.5)
			SetAnimAction('Drip');
		else
			SetAnimAction('Drip');
	}
	else	
			SetAnimAction('Drip');
			FireProjectile();
			bShotAnim = true;
}	

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if ( FRand() < 0.5 )
		PlayAnim('Flying',, 0.1);
	else
		PlayAnim('Flying',, 0.1);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	if ( FRand() < 0.3 )
		{
		TweenAnim('Shrivel', 0.05);
		} 
	else
		{
		TweenAnim('Shrivel', 0.05);
		}
}

function PlayVictory()
{
	SetAnimAction('hit');
}

simulated function SpawnGiblet( class<Gib> GibClass, Vector Location, Rotator Rotation, float GibPerterbation )
{
return;
}



simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false; 
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    Spawn(class'fpsMonsterPack.FireExplosionx'); //replace xEmitter with the class of the effect you want, for example: class'ShockComboCore' 
    Spawn(class'fpsMonsterPack.FireFlame');
    Spawn(class'fpsMonsterPack.FireSuperProjectileChunkA');

	LifeSpan = RagdollLifeSpan;
    GotoState('Dying');
		
	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetInvisibility(0.0);
    PlayDirectionalDeath(HitLoc);
    SetPhysics(PHYS_Falling);
    Destroy(); 
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
	} 
	simulated function Timer() 
	{ 
		if ( !PlayerCanSeeMe() ) 
			Destroy(); 
		else if ( LifeSpan <= DeResTime && bDeRes == false ) 
			StartDeRes(); 
		else 
			SetTimer(0.0, true); /////how long the monster hangs around on screen whilst the efects are going on, so we want him to blow up and not be seen, so ive set this to a very quick time of 0.2 seconds 
	} 
} 

defaultproperties
{
     bMeleeFighter=False
     DodgeSkillAdjust=60.000000
     HitSound(0)=Sound'generalambience.electricalfx5'
     HitSound(1)=Sound'generalambience.electricalfx5'
     HitSound(2)=Sound'fpsMonsterPack.Oneshot.teleprt3'
     HitSound(3)=Sound'generalambience.electricalfx5'
     DeathSound(0)=Sound'SkaarjPack_rc.Gasbag.death1g'
     DeathSound(1)=Sound'SkaarjPack_rc.Gasbag.death1g'
     DeathSound(2)=Sound'SkaarjPack_rc.Gasbag.death1g'
     DeathSound(3)=Sound'SkaarjPack_rc.Gasbag.death1g'
     ChallengeSound(0)=Sound'fpsMonsterPack.Oneshot.teleprt3'
     ChallengeSound(1)=Sound'fpsMonsterPack.Oneshot.teleprt3'
     ChallengeSound(2)=Sound'fpsMonsterPack.Oneshot.teleprt3'
     ChallengeSound(3)=Sound'fpsMonsterPack.Oneshot.teleprt3'
     FireSound=Sound'fpsMonsterPack.Oneshot.teleprt3'
     AmmunitionClass=Class'SkaarjAmmox'
     ScoringValue=2
     bCanFly=True
     bCanStrafe=True
     AirSpeed=3330.000000
     Health=225
     MovementAnims(0)="flying"
     MovementAnims(1)="flying"
     MovementAnims(2)="flying"
     MovementAnims(3)="flying"
     TurnLeftAnim="flying"
     TurnRightAnim="flying"
     CrouchAnims(0)="flying"
     CrouchAnims(1)="flying"
     CrouchAnims(2)="flying"
     CrouchAnims(3)="flying"
     AirAnims(0)="flying"
     AirAnims(1)="flying"
     AirAnims(2)="flying"
     AirAnims(3)="flying"
     TakeoffAnims(0)="flying"
     TakeoffAnims(1)="flying"
     TakeoffAnims(2)="flying"
     TakeoffAnims(3)="flying"
     LandAnims(0)="flying"
     LandAnims(1)="flying"
     LandAnims(2)="flying"
     LandAnims(3)="flying"
     DodgeAnims(0)="flying"
     DodgeAnims(1)="flying"
     DodgeAnims(2)="flying"
     DodgeAnims(3)="flying"
     AirStillAnim="flying"
     TakeoffStillAnim="flying"
     CrouchTurnRightAnim="flying"
     CrouchTurnLeftAnim="flying"
     IdleWeaponAnim="flying"
     IdleRestAnim="Flying"
     AmbientSound=Sound'GeneralAmbience.texture23'
     SoundVolume=255
     SoundRadius=480.000000
     Mesh=VertMesh'Xweapons_rc.GoopMesh'
     Skins(0)=Shader'H_E_L_Ltx.shaders.cp_electrotransshader1_epic'
     Skins(1)=Shader'H_E_L_Ltx.shaders.cp_electrotransshader1_epic'
     CollisionHeight=60.000000
     CollisionRadius=60.000000
     PrePivot=(X=10.000000,Y=5.000000,Z=-10.000000)
     Mass=1400.000000
     drawscale=12
     bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightSaturation=20
     LightBrightness=255.000000
     LightRadius=50.000000
     bBerserk=True
     bMuffledHearing=False
     bAroundCornerHearing=True
     Alertness=15000.000000
     PeripheralVision=15000.000000
     SkillModifier=10
     GibGroupClass=Class'XEffects.xBotGibGroup'
}
