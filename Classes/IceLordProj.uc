//=============================================================================
// rocket.
//=============================================================================
class IceLordProj extends RedeemerProjectile config(fpsMonsterPack);

var	NewRedeemerTrail SmokeTrail;
var config float fDamage;
var config float fDamageRadius;
var config float fDeniedScoreAward;
var class<Emitter> ExplosionEffectClass;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Damage = fDamage;
}

simulated function PostBeginPlay()
{
        Local vector Dir;
	DamageRadius = fDamageRadius;

	if ( bDeleteMe || IsInState('Dying') )
		return;
	Dir = vector(Rotation);
	Velocity = speed * Dir;
	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'NewRedeemerTrail',self,,Location - 40 * Dir, Rotation);
		SmokeTrail.SetBase(self);
	}

	Super.PostBeginPlay();
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if ((Damage > 0) && ((EventInstigator == None) || (EventInstigator.Controller == None) || (Instigator == None) || (Instigator.Controller == None) || !EventInstigator.Controller.SameTeamAs(Instigator.Controller)) )
	{
		if ( (EventInstigator == None) || DamageType.Default.bVehicleHit || (DamageType == class'Crushed') )
			BlowUp(Location);
		else
		{
				if ( PlayerController(EventInstigator.Controller) != None ) {
					PlayerController(EventInstigator.Controller).PlayRewardAnnouncement('Denied',1, true);
		    	BroadcastLocalizedMessage(class'InvasionMessages', 2, EventInstigator.Controller.PlayerReplicationInfo);
		    	EventInstigator.Controller.PlayerReplicationInfo.Score += fDeniedScoreAward;
		    }
  			Spawn(class'SmallRedeemerExplosion');
	    	SetCollision(false,false,false);
	    	HurtRadius(Damage, DamageRadius*0.125, MyDamageType, MomentumTransfer, Location);
		}
	}
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

function BeginPlay()
{
	Super.BeginPlay();

	if (Instigator != None)
		Team = Instigator.GetTeamNum();
	SetTimer(0.5, true);
}

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.Destroy();
	Super.Destroyed();
}

event bool EncroachingOn( actor Other )
{
	if ( Other.bWorldGeometry )
		return true;

	return false;
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( Other != instigator )
		Explode(HitLocation,Vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	BlowUp(HitLocation);
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
}

simulated function Landed( vector HitNormal )
{
	BlowUp(Location);
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	BlowUp(Location);
}

simulated event FellOutOfWorld(eKillZType KillType)
{
	BlowUp(Location);
}

function BlowUp(vector HitLocation)
{
    Spawn(ExplosionEffectClass,,, HitLocation - 100 * Normal(Velocity), Rot(0,16384,0));
	MakeNoise(1.0);
	SetPhysics(PHYS_None);
	bHidden = true;
    GotoState('Dying');
}

function Timer()
{
	local Controller C;

	//Enemies who don't have anything else to shoot at will try to shoot redeemer down
	for (C = Level.ControllerList; C != None; C = C.NextController)
		if ( AIController(C) != None && C.Pawn != None && C.GetTeamNum() != Team && AIController(C).Skill >= 2.0
		     && !C.Pawn.IsFiring() && (C.Enemy == None || !C.LineOfSightTo(C.Enemy)) && C.Pawn.CanAttack(self) )
		{
			C.Focus = self;
			C.FireWeaponAt(self);
		}
}

state Dying
{
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType) {}
	function Timer() {}

    function BeginState()
    {
		bHidden = true;
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		Spawn(class'IonCore',,, Location, Rotation);
		ShakeView();
		InitialState = 'Dying';
		if ( SmokeTrail != None )
			SmokeTrail.Destroy();
		SetTimer(0, false);
    }

    function ShakeView()
    {
        local Controller C;
        local PlayerController PC;
        local float Dist, Scale;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            PC = PlayerController(C);
            if ( PC != None && PC.ViewTarget != None )
            {
                Dist = VSize(Location - PC.ViewTarget.Location);
                if ( Dist < DamageRadius * 2.0)
                {
                    if (Dist < DamageRadius)
                        Scale = 1.0;
                    else
                        Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                    C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }
    }

Begin:
    PlaySound(sound'WeaponSounds.redeemer_explosionsound');
    HurtRadius(Damage, DamageRadius*0.125, MyDamageType, MomentumTransfer, Location);
    Sleep(0.5);
    HurtRadius(Damage, DamageRadius*0.300, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.475, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.650, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.825, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*1.000, MyDamageType, MomentumTransfer, Location);
    Destroy();
}

defaultproperties
{
     fDamage=55.000000
     fDamageRadius=1500.000000
     fDeniedScoreAward=50.000000
     ExplosionEffectClass=Class'fpsMonsterPack.AtomicExplosion'
     Speed=1300.000000
     MaxSpeed=1300.000000
     Damage=55.000000
     DamageRadius=1000.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeIceLordDeemer'
     DrawScale=0.400000
}
