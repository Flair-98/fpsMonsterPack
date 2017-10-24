class DarkCriticalEvents extends CriticalEventPlus;

var(Message) localized string msg0;

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
  if ( Switch == 0 )
  {
    return RelatedPRI_1.PlayerName @ Default.msg0;
  }
}

defaultproperties
{
    msg0=" Vorpal'd The MechTitan!!!"
    PosY=0.70
}