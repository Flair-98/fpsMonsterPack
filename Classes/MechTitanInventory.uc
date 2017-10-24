Class MechTitanInventory Extends Inventory;

Var Pawn PawnOwner;
Var Material ModifierOverlay;
Var Int Modifier;
Var Sound NullEntropySound;

Function GiveTo(Pawn Other, Optional Pickup Pickup)
{

	If(Other == None)
	{
		destroy();
		Return;
	}
	PawnOwner = Other;

	PawnOwner.SetPhysics(PHYS_None);
	enable('Tick');

	If(Modifier < 7)
	{
		LIfeSpan = (Modifier / 3) + ((7 - Modifier) * 0.1);
		SetTimer(0.1, True);
	}
	Else
		LIfeSpan = (Modifier / 3);

	If(PawnOwner.Controller != None && PlayerController(PawnOwner.Controller) != None)
		PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(Class'DarkLocalMessages', 4);
	PawnOwner.PlaySound(NullEntropySound,,1.5 * PawnOwner.TransientSoundVolume,,PawnOwner.TransientSoundRadius);
	PawnOwner.setOverlayMaterial(ModifierOverlay, LIfeSpan, True);

	Super.GiveTo(Other);
}

Function Tick(Float deltaTime)
{

	If(PawnOwner != None && PawnOwner.Physics != PHYS_NONE)
		PawnOwner.setPhysics(PHYS_NONE);
}

Function destroyed()
{
	disable('Tick');
	If(PawnOwner != None && PawnOwner.Physics == PHYS_NONE)
		PawnOwner.SetPhysics(PHYS_Falling);
	Super.destroyed();
}

Function Timer()
{
	If(LIfeSpan <= (7 - Modifier) * 0.1)
	{
		SetTimer(0, True);
		disable('Tick');
		PawnOwner.SetPhysics(PHYS_Falling);
	}
}

DefaultProperties
{
     ModifierOverlay=Shader'MutantSkins.Shaders.MutantGlowShader'
     NullEntropySound=SoundGroup'WeaponSounds.Translocator.TranslocatorModuleRegeneration'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
