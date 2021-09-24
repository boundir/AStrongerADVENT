//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_AStrongerADVENT.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_AStrongerADVENT extends X2DownloadableContentInfo;

static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	local Animset AnimSetToAdd;

	AnimSetToAdd = AnimSet(`CONTENT.RequestGameArchetype("ShadowUnit_ANIM.Anims.AS_ShadowUnitM4"));

	if(UnitState.IsSoldier() || UnitState.GetMyTemplateName() == 'ShadowbindUnitM4')
	{
		if (Pawn.Mesh.AnimSets.Find(AnimSetToAdd) == INDEX_NONE)
		{
			Pawn.Mesh.AnimSets.AddItem(AnimSetToAdd);
			Pawn.Mesh.UpdateAnimations();
		}
	}
}

static event OnPostTemplatesCreated()
{
	// Add Melee Resistance to Berserkers
	class'X2Helper_Characters'.static.ApplyMeleeResistance();
	// Add Melee Vulnerability to Sectoids
	class'X2Helper_Characters'.static.ApplyMeleeVulnerability();
	// Add Icarus Drop to Archon Prime
	class'X2Helper_Characters'.static.ArchonPrimeIcarusDrop();
	// Add BeastMaster and War Cry to Muton Prime
	class'X2Helper_Characters'.static.MutonPrimeAbilities();
	// Add CounterAttack to ABA Muton variants
	class'X2Helper_Characters'.static.MutonCounterAttack();
	// Add TriggerSuperpositionPrime to Codex Prime
	class'X2Helper_Characters'.static.CodexPrimeAbilities();
	// Spectre Prime can create a Prime copy, add a new red look
	class'X2Helper_Characters'.static.SpectrePrimeRework();
	// Spectre Prime's copy have Prime Reactions
	class'X2Helper_Characters'.static.ShadowPrimeAbilities();

	// Allow Holy Warrior to target Mind Controlled units
	class'X2Helper_Abilities'.static.HolyWarriorOnMindControlled();
	// Archon Valkyrie melee attack can dash and slash
	class'X2Helper_Abilities'.static.PatchValkyrieMeleeAttack();
	// Archon Valkyrie melee attack can dash and slash
	class'X2Helper_Abilities'.static.SpectreVanishIsFreeAction();
	// Archon Valkyrie melee attack can dash and slash
	class'X2Helper_Abilities'.static.PurifierFlamethrowerGuaranteedHit();

	// Gives Spectre tier 2 secondary weapon HorrorM4
	class'X2Helper_Items'.static.PatchSpectreSecondaryWeapon();

	// Add Perk to cache
	AddPerkContentToCache();
}

static function AddPerkContentToCache()
{
	local XComContentManager Content;

    Content = `CONTENT;
    Content.BuildPerkPackageCache();
    Content.CachePerkContent('ASA_Perk_Horror');
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);

	switch(Type)
	{
		case 'STAFFCONTROLAIM':
			OutString = string(class'X2Ability_ASA_Archon'.default.STAFFCONTROL_AIM);
			return true;
	}
	return false;
}