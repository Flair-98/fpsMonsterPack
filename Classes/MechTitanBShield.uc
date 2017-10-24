Class MechTitanBShield extEnds ShieldEffect3rd;

Var Int ShieldHealth;

Event TakeDamage(Int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	ShieldHealth -= Damage;
	If (ShieldHealth < 1)
		Destroy();
	PlaySound(Sound'GeneralAmbience.electricalfx20',Slot_Pain);
}

Simulated Function Touch(actor Other)
{
	If (MechTitanBLaser(Other) != None || MechTitanBProjectile(Other)!= None)
		Return;

	Super.Touch(Other);

	If (Projectile(Other) != None)
		Projectile(Other).Explode(Other.Location,(Normal(Other.Owner.Location-Other.Location)));
}

DefaultProperties
{
     ShieldHealth=50000
     AimedOffset=(X=0.000000,Y=0.000000)
     StaticMesh=StaticMesh'XEffects.EffectsSphere144'
     bHidden=False
     DrawScale=8.000000
     PrePivot=(Z=10.000000)
//     Skins(0)=Texture'ShieldFB'
     CollisionRadius=375.000000
     CollisionHeight=300.000000
     bCollideActors=True
     bProjTarget=True
     bUseCylinderCollision=True
}
