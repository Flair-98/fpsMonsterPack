Class MechTitanFallOut Extends SpeedTrail;

Var Bool timerSet;
Var Int affectedRadius,radDamage;

Event PostBeginPlay()
{
	If (!timerSet)
	{
		SetTimer(5.0,True);
		timerSet = True;
	}
	Super.PostBeginPlay();
}

Simulated Function Timer()
{
	Local pawn P;
	Local Vector fakeMomentum;

	Foreach VisibleCollidingActors( Class 'Pawn', P, affectedRadius)
	{
		If (MonsterController(P.Controller) != None)
			If (FriendlyMonsterController(P.Controller) == None)
				Return;
		fakeMomentum = Vect(0,0,0);
		P.TakeDamage(radDamage, Pawn(Self.Owner), P.Location, fakeMomentum, Class'DamTypeFallOut');
	}
}

DefaultProperties
{
     mParticleType=PT_Sprite
     mMaxParticles=20
     mLIfeRange(0)=2.000000
     mLIfeRange(1)=3.000000
     mRegenRange(0)=200.000000
     mRegenRange(1)=200.000000
     mSpeedRange(1)=20.000000
     mPosRelative=True
     mMassRange(1)=0.100000
     mRandOrient=True
     mSizeRange(0)=300.000000
     mSizeRange(1)=450.000000
     mGrowthRate=0.500000
     mColorRange(0)=(B=31,G=67,R=52)
     mColorRange(1)=(B=34,G=85,R=67)
     mAttenKa=0.300000
     bLightChanged=True
     AmbientSound=Sound'GeneralAmbience.texture12'
     LIfeSpan=360.000000
     Skins(0)=Texture'EpicParticles.Smoke.StellarFog1aw'
     SoundVolume=190
     SoundRadius=32.000000
}
