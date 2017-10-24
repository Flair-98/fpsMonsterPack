class DamTypeFireChucker extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth )
{
	HitEffects[0] = class'HitFlameBig';
}

//A convenient place to change the victim's skin to a burnt looking one.
static function class<Emitter> GetPawnDamageEmitter(vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail)
{
	if(Damage >= Victim.Health + Damage)
		Victim.SetOverlayMaterial(Texture'BarrensTerrain.Ground.rock09BA', 60, true);

	return none;
}

defaultproperties
{
     FemaleSuicide="%o shouldn't have played with fire."
     MaleSuicide="%o shouldn't have played with fire."
     bDetonatesGoop=True
     bCausesBlood=False
     bDelayedDamage=True
     GibModifier=0.000000
}
