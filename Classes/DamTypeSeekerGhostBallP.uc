class DamTypeSeekerGhostBallP extends VehicleDamageType
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
     DeathString="%o got chased down by a mysterious flying object."
     FemaleSuicide="%o fired her gun prematurely."
     MaleSuicide="%o fired his gun prematurely."
	bAlwaysSevers=True
     bDetonatesGoop=True
     bKUseOwnDeathVel=True
     bDelayedDamage=True
     bThrowRagdoll=True
     bFlaming=True
     KDamageImpulse=1500.000000
     KDeathVel=700.000000
     KDeathUpKick=150.000000
     VehicleDamageScaling=0.650000
     VehicleMomentumScaling=1.100000
}
