//=============================================================================
// rocket.
//=============================================================================
class BenderProj extends Projectile config(fpsMonsterPack);


var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;
var Effects Corona;
var byte FlockIndex;
var BenderProj Flock[2];
var() float	FlockRadius;
var() float	FlockStiffness;
var() float FlockMaxForce;
var() float	FlockCurlForce;
var bool bCurl;
var xEmitter SmokeTrail;
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
	local Rotator R;
	if ( bDeleteMe || IsInState('Dying') )
		return;
	Velocity = Vector(Rotation);
	 Velocity *= Speed;
	 
	     R = Rotation;
	     R.Roll = Rand(65536);
    SetRotation(R);
	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	local BenderProj R;
	local int i;
	local PlayerController PC;

	Super.PostNetBeginPlay();

	if ( FlockIndex != 0 )
	{
	    SetTimer(0.1, true);

	    // look for other rockets
	    if ( Flock[1] == None )
	    {
			ForEach DynamicActors(class'BenderProj',R)
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
	else
	{
		PC = Level.GetLocalPlayerController();
		if ( (Instigator != None) && (PC == Instigator.Controller) )
			return;
		if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
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

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'fpsMonsterPack.vaseB1',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
			spawn(class'BeerGoo',,,HitLocation + HitNormal*16 );
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local GlassChunk NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewChunk = Spawn( class 'GlassChunk',, '', Start, rot);
		}
	}
    Destroy();
}

defaultproperties
{
     fDamage=10.000000
     Speed=800.000000
     MaxSpeed=8000.000000
     Damage=20.000000
     DamageRadius=10.000000
     MomentumTransfer=60000.000000
     MyDamageType=Class'fpsMonsterPack.DamTypeBender'
     ExplosionDecal=Class'XEffects.RocketMark'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'fpsMonMesh.All.BenderBrau2'
     CullDistance=7500.000000
     bDynamicLight=True
     LifeSpan=10.000000
     DrawScale3D=(X=1.500000,Y=1.500000,Z=1.850000)
     Skins(0)=Texture'fpsMonTex.INI.Bbeer2'
     AmbientGlow=96
     Style=STY_Additive
     FluidSurfaceShootStrengthMod=6.000000
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=5.000000
}
