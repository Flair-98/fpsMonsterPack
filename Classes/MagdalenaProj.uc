class MagdalenaProj extends Projectile config(fpsMonsterPack);

var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;
var Effects Corona;
var byte FlockIndex;
var MagdalenaProj Flock[2];
var() float	FlockRadius;
var() float	FlockStiffness;
var() float FlockMaxForce;
var() float	FlockCurlForce;
var bool bCurl;
var Emitter SmokeTrail;
var config float fDamage;

replication
{
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        FlockIndex, bCurl;
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Damage = fDamage;
}

simulated function PostBeginPlay()
{
	local vector Dir;
	if ( bDeleteMe || IsInState('Dying') )
		return;

	Dir = vector(Rotation);
	Velocity = speed * Dir;

	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'blastemittertrail',self,,Location - 40 * Dir, Rotation);
		SmokeTrail.SetBase(self);
	Super.PostBeginPlay();
}
}

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.Destroy();
	Super.Destroyed();
}

	
simulated function PostNetBeginPlay()
{
	local MagdalenaProj R;
	local int i;
	//local PlayerController PC;

	Super.PostNetBeginPlay();

	if ( FlockIndex != 0 )
	{
	    SetTimer(0.1, true);

	    // look for other rockets
	    if ( Flock[1] == None )
	    {
			ForEach DynamicActors(class'MagdalenaProj',R)
				if ( R.FlockIndex == FlockIndex )
				{
					Flock[i] = R;
					if ( R.Flock[0] == None )
						R.Flock[0] = self;
					else if ( R.Flock[0] != self )
						R.Flock[1] = self;
					i++;
					if ( i == 2 )
						break;
				}
		}
	}
    if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	/*else
	{
		PC = Level.GetLocalPlayerController();
		if ( (Instigator != None) && (PC == Instigator.Controller) )
			return;
		if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}*/
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
		Explode(HitLocation, vector(rotation)*-1 );
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}



    

simulated function Explode(vector HitLocation, vector HitNormal)
{
	//local PlayerController PC;
        local class<MonsterINI> nmc; //new monster class
	local blueskaarjbaby newMonster;
	
	if (Role == ROLE_Authority)
	    {
	        nmc = class'blueskaarjbaby';
	        newMonster = blueskaarjbaby(Spawn(nmc,,,Location+((nmc.Default.CollisionHeight+128)*vect(0,0,1)),Rotation));
	        }
	PlaySound(Sound'WeaponSounds.BaseGunTech.BWeaponSpawn1',,2.1*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'suck',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	//PC = Level.GetLocalPlayerController(); //these 3 lines of code seem to be what is causing trouble with linux online.
		//if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        //Spawn(class'suck',,, HitLocation + HitNormal*20, rotator(HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

simulated function Timer()
{
    local vector ForceDir, CurlDir;
    local float ForceMag;
    local int i;
    local vector Dir;

	Velocity =  Default.Speed * Normal(Dir * 0.5 * Default.Speed + Velocity);

	// Work out force between flock to add madness
	for(i=0; i<2; i++)
	{
		if(Flock[i] == None)
			continue;

		// Attract if distance between rockets is over 2*FlockRadius, repulse if below.
		ForceDir = Flock[i].Location - Location;
		ForceMag = FlockStiffness * ( (2 * FlockRadius) - VSize(ForceDir) );
		Acceleration = Normal(ForceDir) * Min(ForceMag, FlockMaxForce);

		// Vector 'curl'
		CurlDir = Flock[i].Velocity Cross ForceDir;
		if ( bCurl == Flock[i].bCurl )
			Acceleration += Normal(CurlDir) * FlockCurlForce;
		else
			Acceleration -= Normal(CurlDir) * FlockCurlForce;
	}
}

defaultproperties
{
     fDamage=20.000000
     Speed=800.000000
     MaxSpeed=800.000000
     Damage=75.000000
     MomentumTransfer=60000.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeMagda'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_Sprite
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     CullDistance=7500.000000
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=10.000000
     Texture=Texture'fpsMonsterPack.blueFlare'
     Skins(0)=Texture'fpsMonsterPack.blueFlare'
     AmbientGlow=96
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
}
