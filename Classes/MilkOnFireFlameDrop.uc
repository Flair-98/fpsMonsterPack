//-----------------------------------------------------------
//   all credit goes to rosebum
//-----------------------------------------------------------
class MilkOnFireFlameDrop extends MilkOnFireFlame;

simulated function Tick(float Delta)
{
    Super.Tick(Delta);
if (LifeSpan <= 1.0)
   setdrawscale(default.drawscale*0.10);
else if (LifeSpan <= 2.0)
   setdrawscale(default.drawscale*0.20);
else if (LifeSpan <= 3.0)
   setdrawscale(default.drawscale*0.30);
else if (LifeSpan <= 4.0)
   setdrawscale(default.drawscale*0.40);
else if (LifeSpan <= 5.0)
   setdrawscale(default.drawscale*0.50);
else if (LifeSpan <= 6.0)
   setdrawscale(default.drawscale*0.60);
else if (LifeSpan <= 7.0)
   setdrawscale(default.drawscale*0.70);
else if (LifeSpan <= 8.0)
   setdrawscale(default.drawscale*0.80);
else if (LifeSpan <= 9.0)
   setdrawscale(default.drawscale*0.90);
}

defaultproperties
{
     mSpeedRange(1)=85.000000
     LifeSpan=25.000000
     SoundVolume=50
     SoundPitch=64
     SoundRadius=10.000000
     bBounce=True
}
