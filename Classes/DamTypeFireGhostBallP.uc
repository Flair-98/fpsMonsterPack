class DamTypeFireGhostBallP extends VehicleDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth )
{
    HitEffects[0] = class'HitSmoke';

    if( VictimHealth <= 0 )
        HitEffects[1] = class'HitFlameHuge';
    else if ( FRand() < 0.8 )
        HitEffects[1] = class'HitFlameBig';
}
defaultproperties
{
     VehicleClass=Class'Onslaught.ONSHoverTank'
     DeathString="%o got burned to fucking hell by a mysterious alien creature."
     FemaleSuicide="%o fired her gun prematurely."
     MaleSuicide="%o fired his gun prematurely."
	bAlwaysSevers=True
     bDetonatesGoop=True
     bDelayedDamage=True
     bThrowRagdoll=True
     bFlaming=True
	GibPerterbation=0.150000
	KDamageImpulse=20000.000000
     VehicleDamageScaling=1.750000
     VehicleMomentumScaling=1.300000
}
