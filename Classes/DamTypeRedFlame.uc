class DamTypeRedFlame extends DamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
    
    if( VictemHealth <= 0 && FRand() < 0.2 )
        HitEffects[1] = class'HitFlameBig';
    else if ( FRand() < 0.8 )
        HitEffects[1] = class'HitFlame';
}

defaultproperties
{
     DeathString="%o is gone."
     FemaleSuicide="A Red Flame blew itself up."
     MaleSuicide="A Red Flame Monster blew itself up."
     bDetonatesGoop=True
     KDamageImpulse=20000.000000
}
