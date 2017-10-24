class DamTypeSuperGhostBallP extends VehicleDamageType
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
     DeathString="%o was killed by a huge mysterious alien creature."
     FemaleSuicide="%o fired her mkII laser prematurely."
     MaleSuicide="%o fired his mkII laser prematurely."
	bAlwaysSevers=True
     bDetonatesGoop=True
     bKUseOwnDeathVel=True
     bDelayedDamage=True
     bThrowRagdoll=True
     bFlaming=True
     GibPerterbation=0.250000
     KDamageImpulse=10000.000000
     KDeathVel=8000.000000
     KDeathUpKick=1200.000000
     VehicleDamageScaling=2.750000
     VehicleMomentumScaling=1.700000
}
