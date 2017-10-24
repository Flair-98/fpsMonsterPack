class GiantGasBagBelch extends GasBagBelch;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SmokeTrail.SetDrawScale(SmokeTrail.DrawScale*2.5);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A;
	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);

	A=spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}
	A=spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		A=Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     Damage=50.000000
     DamageRadius=230.000000
     DrawScale=0.600000
}
