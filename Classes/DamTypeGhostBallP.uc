class DamTypeGhostBallP extends VehicleDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth )
{
    HitEffects[0] = class'HitSmoke';

    if( VictimHealth <= 0 )
        HitEffects[1] = class'HitFlameBig';
    else if ( FRand() < 0.8 )
        HitEffects[1] = class'HitFlame';
}

defaultproperties
{
     VehicleClass=Class'Onslaught.ONSHoverTank'
     DeathString="%o was killed by a mysterious alien creature."
     FemaleSuicide="%o fired her gun prematurely."
     MaleSuicide="%o fired his gun prematurely."
	bAlwaysSevers=True
     bDetonatesGoop=True
     bKUseOwnDeathVel=True
     bDelayedDamage=True
     bThrowRagdoll=True
     bFlaming=True
     KDamageImpulse=2000.000000
     KDeathVel=800.000000
     KDeathUpKick=50.000000
     VehicleDamageScaling=1.750000
     VehicleMomentumScaling=1.300000
}
