class MultiColorFireMonster extends BlueFireMonster;


simulated function PostBeginPlay()
{
	local int i;
	i = Rand(5);
	AmbientSound = AmSound[i];

	super(Monster).PostBeginPlay();
	If(Level.NetMode != NM_DedicatedServer)
	{
		Effect = self.spawn(class'MonsterMultiColorFlame', self);
		Effect.SetBase(self);
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
		S = Spawn(class'MultiColorFlameShot',,,FireStart,ProjRot);
        S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
	}
}

defaultproperties
{
     Health=7500
}
