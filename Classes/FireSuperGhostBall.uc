class FireSuperGhostBall extends Gasbag;


event PostBeginPlay()
{
	Super.PostBeginPlay();
	MyAmmo.ProjectileClass = class'firesuperprojectile';
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
			SetAnimAction('fly');
		else
			SetAnimAction('fly');
	}
	else	
			SetAnimAction('fly');
			FireProjectile();
			bShotAnim = true;
}	

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if ( FRand() < 0.5 )
		PlayAnim('fly',, 0.1);
	else
		PlayAnim('fly',, 0.1);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	if ( FRand() < 0.3 )
		{
		TweenAnim('fly', 0.05);
		} 
	else
		{
		TweenAnim('fly', 0.05);
		}
}

function PlayVictory()
{
	SetAnimAction('fly');
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
    Spawn(class'XEffects.RedeemerExplosion'); //replace xEmitter with the class of the effect you want, for example: class'ShockComboCore' 
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
     bunlit=True
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
     ScoringValue=25
     bCanFly=True
     bCanStrafe=True
     AirSpeed=3800.000000
     Health=10000
     MovementAnims(0)="fly"
     MovementAnims(1)="fly"
     MovementAnims(2)="fly"
     MovementAnims(3)="fly"
     TurnLeftAnim="fly"
     TurnRightAnim="fly"
     CrouchAnims(0)="fly"
     CrouchAnims(1)="fly"
     CrouchAnims(2)="fly"
     CrouchAnims(3)="fly"
     AirAnims(0)="fly"
     AirAnims(1)="fly"
     AirAnims(2)="fly"
     AirAnims(3)="fly"
     TakeoffAnims(0)="fly"
     TakeoffAnims(1)="fly"
     TakeoffAnims(2)="fly"
     TakeoffAnims(3)="fly"
     LandAnims(0)="fly"
     LandAnims(1)="fly"
     LandAnims(2)="fly"
     LandAnims(3)="fly"
     DodgeAnims(0)="fly"
     DodgeAnims(1)="fly"
     DodgeAnims(2)="fly"
     DodgeAnims(3)="fly"
     AirStillAnim="fly"
     TakeoffStillAnim="fly"
     CrouchTurnRightAnim="fly"
     CrouchTurnLeftAnim="fly"
     IdleWeaponAnim="fly"
     AmbientSound=Sound'GeneralAmbience.texture23'
     SoundVolume=255
     SoundRadius=480.000000
     Mesh=VertMesh'Skaarjpack_rc.Manta1'
     Skins(0)=Shader'H_E_L_Ltx.shaders.cp_electrotransshader1_epic'
     Skins(1)=Shader'H_E_L_Ltx.shaders.cp_electrotransshader1_epic'
     CollisionHeight=80.000000
     CollisionRadius=285.000000
     PrePivot=(X=70.000000,Y=0.000000,Z=-60.000000)
     Mass=1000.000000
     drawscale=12
     bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightSaturation=30
     LightBrightness=255.000000
     LightRadius=375.000000
     bMuffledHearing=False
     bAroundCornerHearing=True
     Alertness=50000.000000
     PeripheralVision=50000.000000
     SkillModifier=10
     GibGroupClass=Class'XEffects.xBotGibGroup'
     GibCountCalf=4
     GibCountForearm=2
     GibCountHead=2
     GibCountTorso=2
     GibCountUpperArm=2
}
