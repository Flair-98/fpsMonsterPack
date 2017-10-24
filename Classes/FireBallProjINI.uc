//=============================================================================
//=============================================================================
class FireBallProjINI extends Projectile;

var xEmitter Flame, FlameTrail;
var class<xEmitter> FlameClass, FlameTrailClass;
var class<Emitter> FlameExplosionClass;
var float Scaling;
var bool bScaled;

replication
{
	reliable if(Role == ROLE_Authority)
		Scaling;
}

simulated function PostBeginPlay()
{
	//No fire underwater.
	if(PhysicsVolume.bWaterVolume)
	{
		Destroy();
		return;
	}

	Super.PostBeginPlay();

	if(Level.Netmode != NM_DedicatedServer)
	{
		Flame = spawn(FlameClass, self);
		Flame.SetBase(self);
	}

	Timer();
	SetTimer(0.1, true);

}

simulated function PostNetBeginPlay()
{
	Velocity = Vector(Rotation) * Speed;

	if(Instigator != None)
		Velocity += 0.5 * Instigator.Velocity;
}

//Change the size of the fireball depending on how charged up the weapon was when it fired.
simulated function ScaleBall()
{
	Damage *= 0.7 + (Scaling / 3.333333);
	MomentumTransfer *= Scaling;

	DamageRadius *= 0.5 + (Scaling / 2);
	Velocity /= 0.5 + (Scaling / 2);
	SetCollisionSize(CollisionRadius * (0.5 + (Scaling / 2)), CollisionHeight * (0.5 + (Scaling / 2)));

	ForceScale *= 0.5 + (Scaling / 2);
	ForceRadius *= 0.5 + (Scaling / 2);

	LightBrightness *= 0.5 + (Scaling / 2);

	if(Flame != None)
	{
		FireBallEmitter(Flame).Scale(Scaling);

		if(Level.Netmode != NM_DedicatedServer && !Level.bDropDetail && Level.DetailMode != DM_Low)
		{
			FlameTrail = spawn(FlameTrailClass, self);
			FlameTrail.SetBase(Flame);
			FireBallEmitter(FlameTrail).Scale(Scaling);
		}
	}

	bScaled = true;
}

//Burn things as the fireball flies past, apply scaling some time after the fireball has been launched and fade out slowly.
simulated function Timer()
{
	if(!bScaled && Scaling != 0)
		ScaleBall();

	if(Role == ROLE_Authority)
		HurtRadius(Damage / 3, CollisionRadius * 10, MyDamageType, MomentumTransfer, Location);

	if(Flame != None)
	{
		FireBallEmitter(Flame).Fade();

		if(FlameTrail != None)
			FireBallEmitter(FlameTrail).Fade();
	}

	LightBrightness -= 0.5 + (Scaling / 2);
	Damage -= 0.2 * Scaling;
	MomentumTransfer -= 30 * Scaling;

	if(Damage < 0.5 * Scaling)
		Destroy();
}

//No fire underwater.
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	if(NewVolume.bWaterVolume)
	{
		PlaySound(sound'GeneralAmbience.steamfx4', SLOT_Interact, TransientSoundVolume * (LightBrightness / Default.LightBrightness),,, 4 / (0.5 + (Scaling / 2)));

		if(Level.Netmode != NM_DedicatedServer && !Level.bDropDetail)
		{
			if(Scaling > 5)
				Spawn(class'SteamEmitter');
			else
				Spawn(class'LightSteamEmitter');
		}

		Destroy();
	}
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if(Other != instigator && (!Other.IsA('Projectile') || Other.bProjTarget)) 
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Emitter FlameExplosion;
	local float Opacity;

	if(EffectIsRelevant(Location,false) && Level.Netmode != NM_DedicatedServer)
	{
		FlameExplosion = spawn(FlameExplosionClass,,, HitLocation + HitNormal*16);
		Opacity = LightBrightness / (Default.LightBrightness * (0.5 + (Scaling / 2)));
		FireBallExplosionEmitter(FlameExplosion).Scale(Scaling, Opacity);

		if(!Level.bDropDetail)
			Spawn(class'FireBallSmokeRing', self,, HitLocation + HitNormal*16, rotator(HitNormal));

		if(Scaling < 3)
			Spawn(class'LinkScorch', self,, Location, rotator(-HitNormal));
		else if(Scaling < 6)
			Spawn(class'LinkBoltScorch', self,, Location, rotator(-HitNormal));
		else if(Scaling < 8)
			Spawn(class'ShockAltDecal', self,, Location, rotator(-HitNormal));
		else
			Spawn(class'RocketMark', self,, Location, rotator(-HitNormal));
	}

	PlaySound(sound'WeaponSounds.BExplosion5',, TransientSoundVolume * (LightBrightness / Default.LightBrightness),,, 4 / (0.5 + (Scaling / 2)));
	BlowUp(HitLocation);
	Destroy();
}

simulated function Destroyed()
{
	if(Flame != None)
		Flame.Destroy();

	if(FlameTrail != None)
		FlameTrail.Destroy();
}

defaultproperties
{
     FlameClass=Class'fpsMonsterPack.TracerINI'
     FlameTrailClass=Class'fpsMonsterPack.FireBallTrailEmitter'
     FlameExplosionClass=Class'fpsMonsterPack.FireBallExplosionEmitter'
     Speed=1300.000000
     MaxSpeed=1300.000000
     TossZ=0.000000
     Damage=50.000000
     DamageRadius=64.000000
     MomentumTransfer=2000.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeFireChuckerFire'
     LightType=LT_Steady
     LightHue=32
     LightSaturation=128
     LightBrightness=64.000000
     LightRadius=16.000000
     DrawType=DT_None
     bDynamicLight=True
     AmbientSound=Sound'GeneralAmbience.firefx1'
     LifeSpan=10.000000
     bFullVolume=True
     SoundVolume=255
     SoundPitch=56
     SoundRadius=128.000000
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
}
