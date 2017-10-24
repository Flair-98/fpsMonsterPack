class DarkLocalMessages extends LocalMessage;

var config localized string Messages[5];

static function string GetString (optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object obj)
{
  return Default.Messages[Switch];
}

defaultproperties
{
    Messages(0)="You are nulled!"
    Messages(1)="You are nulled!"
    Messages(2)="You are nulled!"
    Messages(3)="You are nulled!"
    Messages(4)="You are nulled!"
    bIsUnique=True
    bFadeMessage=True
    DrawColor=(R=239,G=148,B=29,A=255),
    StackMode=2
}