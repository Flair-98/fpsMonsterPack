//=============================================================================
// SeekerGhostballProjectile
//=============================================================================
class SeekerGhostballProjectile extends Projectile;

var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;
var  xEmitter SmokeTrail;
var Effects Corona;
var byte FlockIndex;
var SeekerGhostballProjectile Flock[2];

var() float    FlockRadius;
var() float    FlockStiffness;
var() float FlockMaxForce;
var() float    FlockCurlForce;
var bool bCurl;
var vector Dir;

var() int DetectRadius;

var Actor Seeking;
var vector InitialDir;
var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view

replication
{
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        Seeking, InitialDir;
        //FlockIndex, bCurl;
}

simulated function Destroyed()
{
     if ( SmokeTrail != None )
          SmokeTrail.mRegen = False;
     Super.Destroyed();
}

simulated function PostBeginPlay()
{
     if ( Level.NetMode != NM_DedicatedServer)
     {
          SmokeTrail = Spawn(class'SeekerGhostBallPTrail',self);
     }

     Dir = vector(Rotation);
     Velocity = speed * Dir;
     if (PhysicsVolume.bWaterVolume)
     {
          bHitWater = True;
          Velocity=0.6*Velocity;
     }
    if ( Level.bDropDetail )
     {
          bDynamicLight = false;
          LightType = LT_None;
     }

     SetTimer(0.1,true);
}

simulated function PostNetBeginPlay()
{
     local SeekerGhostballProjectile R;
     local int i;

     Super.PostNetBeginPlay();

     if ( FlockIndex != 0 )
     {
         SetTimer(0.1, true);

         // look for other rockets
         if ( Flock[1] == None )
         {
               foreach DynamicActors(class'SeekerGhostballProjectile',R)
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
}

simulated function Landed( vector HitNormal )
{
     Explode(Location,HitNormal);
}

//event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
    // local vector Moment;


          if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
               Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
     HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
     MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local SeekerChunk NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<7; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewChunk = Spawn( class 'SeekerChunk',, '', Start, rot);
		}
	}
        PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
        if ( EffectIsRelevant(Location,false) )
        {
           Spawn(class'GhostBallPExplosion',,,HitLocation + HitNormal*16,rotator(HitNormal));
           Spawn(class'ExplosionCrap',,, HitLocation, rotator(HitNormal));
           if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
               Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
        }
        BlowUp(HitLocation);
	  ShakeView();
        Destroy();

}

    function ShakeView()
    {
        local Controller C;
        local PlayerController PC;
        local float Dist, Scale;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            PC = PlayerController(C);
            if ( PC != None && PC.ViewTarget != None )
            {
                Dist = VSize(Location - PC.ViewTarget.Location);
                if ( Dist < DamageRadius * 2.0)
                {
                    if (Dist < DamageRadius)
                        Scale = 1.0;
                    else
                        Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                    C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }
    }

//VisibleCollidingActors ( class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc, optional bool bIgnoreHidden );

function Tick(float DeltaTime)
{
     local Pawn Enemy;
     local int Checks;
     Checks = 0;


            foreach VisibleCollidingActors( class'Pawn', Enemy, DetectRadius, Location )
            {
              if(enemy.Role == ROLE_Authority
        && enemy != self
        && (enemy.IsA('Pawn')
            || enemy.IsA('ONSPowerCore')
            || enemy.IsA('DestroyableObjective')
            || enemy.bProjTarget)
        && !enemy.IsA('Monster')
        && enemy != Instigator)
               {
                  if(Seeking == Enemy || enemy.health <= 0);
                     break;
                  if(Enemy == none)
                     Seeking = none;
                  else
                     Seeking = Enemy;
               }
            }
            if(Enemy == none)
               Seeking = none;
            Seeking = Enemy;
}
simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

    Acceleration = vect(0,0,0);

    Super.Timer();

    if ( (Seeking != None) && (Seeking != Instigator))
    {
       if(Pawn(Seeking).Health >= 0)
       {
          // Do normal guidance to target.
          ForceDir = Normal(Seeking.Location - Location);

          if( (ForceDir Dot InitialDir) > 0 )
          {
               VelMag = VSize(Velocity);

               ForceDir = Normal(ForceDir * 0.7 * VelMag + Velocity);
               Velocity =  VelMag * ForceDir;
               Acceleration += 4 * ForceDir;
          }
          // Update rocket so it faces in the direction its going.
          SetRotation(rotator(Velocity));
       }
    }
}

defaultproperties
{
     ShakeRotMag=(Z=80.000000)
     ShakeRotRate=(Z=1200.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=7.000000)
     ShakeOffsetRate=(Z=170.000000)
     ShakeOffsetTime=5.000000
     FlockRadius=48.000000
     FlockStiffness=-40.000000
     FlockMaxForce=600.000000
     FlockCurlForce=450.000000
     DetectRadius=5120
     Speed=1400.000000
     MaxSpeed=1800.000000
     Damage=50.000000
     DamageRadius=180
     MomentumTransfer=9000.000000
     MyDamageType=Class'DamTypeSeekerGhostBallP'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=195
     LightBrightness=255.000000
     LightRadius=25.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=150.000000
     DrawScale=0.400000
     AmbientGlow=96
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
