class blueskaarjbaby extends SkaarjINI config(fpsMonsterPack);

var config int LifeTime;
var config float fHealth;

simulated function PreBeginPlay() //////
{

		Health = fHealth;
		Instigator = self;
			Super.PreBeginPlay();
			
}

simulated function PostNetBeginPlay()  /////
  {
  
  
        MyAmmo.ProjectileClass = class'BabyBlueSkaarjProj';
  	SetTimer(LifeTime, true);
  	enable('NotifyBump');
  	Instigator.Controller.Restart();
  	Instigator = self;
  	Super.PostNetBeginPlay();

}

simulated function PostBeginPlay()  /////
  {
  
  Super.PostBeginPlay();
        MyAmmo.ProjectileClass = class'BabyBlueSkaarjProj';
  	SetTimer(LifeTime, true);
  	enable('NotifyBump');
  	Instigator.Controller.Restart();
  	Instigator = self;

}

simulated function Timer() ////////
{
		GotoState('Dying');
}

simulated function Tick(float DeltaTime) ////////
{
	super.Tick(DeltaTime);
}

simulated function bool SameSpeciesAs(Pawn P) ///////
{
	return ( (Monster(P) != None) && (P.IsA('MonsterINI') || P.IsA('WarLord') || P.IsA('MagdalenaINI') || P.IsA('Skaarj')) );
}

simulated function PlaySoundINI() //////
{
	PlaySound(Sound'GameSounds.Combo.ComboActivated');
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
                Spawn(class'sucked');
                PlaysoundINI();
                Destroy();
	}

    simulated function Timer()
	{
		if ( !PlayerCanSeeMe() )
			Destroy();
        else if ( LifeSpan <= DeResTime && bDeRes == false )
            StartDeRes();
            Destroy();
 			SetTimer(0.2, true);
 	}
}

simulated function vector GetFireStart(vector X, vector Y, vector Z) /////
{
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Y + 0.4 * CollisionHeight * Z;
}

simulated function SpawnTwoShots() /////
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

defaultproperties
{
     Lifetime=5
     fHealth=1000.000000
     Health=100
     bAlwaysRelevant=True
     DrawScale=0.400000
     Skins(0)=FinalBlend'SkaarjPackSkins.Skins.Skaarjw3'
     Skins(1)=FinalBlend'SkaarjPackSkins.Skins.Skaarjw3'
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bNetInitial=True
}
