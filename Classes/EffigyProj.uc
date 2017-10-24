class EffigyProj extends RedeemerProjectile config(fpsMonsterPack);

var config float fDamage;
var config float fDamageRadius;
var config float fDeniedScoreAward;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Damage = fDamage;
}

simulated function PostBeginPlay()
{
	DamageRadius = fDamageRadius;
	super.PostBeginPlay();
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if ((Damage > 0) && ((EventInstigator == None) || (EventInstigator.Controller == None) || (Instigator == None) || (Instigator.Controller == None) || !EventInstigator.Controller.SameTeamAs(Instigator.Controller)) )
	{
		if ( (EventInstigator == None) || DamageType.Default.bVehicleHit || (DamageType == class'Crushed') )
			BlowUp(Location);
		else
		{
			/*if ( PlayerController(Controller) != None )
				PlayerController(Controller).PlayRewardAnnouncement('Denied',1, true);*/
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

defaultproperties
{
     fDamage=75.000000
     fDamageRadius=800.000000
     fDeniedScoreAward=25.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeDeemer'
}
