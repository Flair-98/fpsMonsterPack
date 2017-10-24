class BGhostBall extends Gasbag;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	MyAmmo.ProjectileClass = class'bghostballprojectile';
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
		PlaySound(sound'WeaponSounds.BioRifle.BioRifleFire',SLOT_Talk);
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
	if ( FRand() < 0.6 )
		TweenAnim('Shrivel', 0.05);
	else
		TweenAnim('Shrivel', 0.05);
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
    Spawn(class'XEffects.ShockComboCore'); //replace xEmitter with the class of the effect you want, for example: class'ShockComboCore' 

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
     bMeleeFighter=True
     MeleeRange=1000
     DodgeSkillAdjust=6.000000
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
     AmmunitionClass=Class'fpsMonsterPack.SkaarjAmmox'
     ScoringValue=1
     bCanFly=True
     bCanStrafe=True
     AirSpeed=1000.000000
     Health=65
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
     SoundRadius=15.000000
     Mesh=VertMesh'Xweapons_rc.GoopMesh'
     Skins(0)=Shader'aw-2004particles.weapons.ripplefallback'
     Skins(1)=Shader'aw-2004particles.weapons.ripplefallback'
     CollisionHeight=12.000000
     CollisionRadius=14.000000
     PrePivot=(X=4.000000,Y=4.000000,Z=-3.000000)
     Mass=250.000000
     drawscale=3
     bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=195
     LightSaturation=20
     LightBrightness=255.000000
     LightRadius=50.000000
     bBerserk=True
     bMuffledHearing=False
     bAroundCornerHearing=True
     Alertness=500.000000
     SightRadius=450.000000
     SkillModifier=5
     GibGroupClass=Class'XEffects.xBotGibGroup'
     GibCountCalf=4
     GibCountForearm=2
     GibCountHead=2
     GibCountTorso=2
     GibCountUpperArm=2
}
