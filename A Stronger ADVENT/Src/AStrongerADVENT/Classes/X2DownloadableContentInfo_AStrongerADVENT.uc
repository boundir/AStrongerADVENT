//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_AStrongerADVENT.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_AStrongerADVENT extends X2DownloadableContentInfo config(GameCore);

var config array<name> ANIMSET_ADDITION_TEMPLATES;

static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	local Animset AnimSetToAdd;

	local Animset AnimSet;
	local AnimSequence Sequence;

	AnimSetToAdd = AnimSet(`CONTENT.RequestGameArchetype("ShadowUnit_ANIM.Anims.AS_ShadowUnitM4"));

	// `log("DEBUG Pawn: " $ Pawn,, 'UpdateAnimations');
	// `log("DEBUG Template: " $ UnitState.GetMyTemplateName(),, 'UpdateAnimations');
	// `log("===================================BEFORE============================",, 'UpdateAnimations');
	// foreach Pawn.Mesh.AnimSets(AnimSet)
	// {
	// 	`log("AnimSet: " $ PathName(AnimSet),, 'UpdateAnimations');

	// 	foreach AnimSet.Sequences(Sequence)
	// 	{
	// 		`log("SequenceName: " $ Sequence.SequenceName,, 'UpdateAnimations');
	// 	}
	// }

	if(UnitState.IsSoldier() || UnitState.GetMyTemplateName() == 'ShadowbindUnitM4')
	{
		if (Pawn.Mesh.AnimSets.Find(AnimSetToAdd) == INDEX_NONE)
		{
			Pawn.Mesh.AnimSets.AddItem(AnimSetToAdd);
			Pawn.Mesh.UpdateAnimations();
		}
	}

	AnimSetToAdd = AnimSet(`CONTENT.RequestGameArchetype("ShadowUnit_ANIM.Anims.AS_ShadowGremlin"));

	if(default.ANIMSET_ADDITION_TEMPLATES.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
	{
		if (Pawn.Mesh.AnimSets.Find(AnimSetToAdd) == INDEX_NONE)
		{
			Pawn.Mesh.AnimSets.AddItem(AnimSetToAdd);
			Pawn.Mesh.UpdateAnimations();
		}
	}

	// `log("===================================AFTER============================",, 'UpdateAnimations');
	// foreach Pawn.Mesh.AnimSets(AnimSet)
	// {
	// 	`log("AnimSet: " $ PathName(AnimSet),, 'UpdateAnimations');

	// 	foreach AnimSet.Sequences(Sequence)
	// 	{
	// 		`log("SequenceName: " $ Sequence.SequenceName,, 'UpdateAnimations');
	// 	}
	// }
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
	// Spectre Prime can create a Prime copy
	class'X2Helper_Characters'.static.SpectrePrimeAbilities();
	// Add Animation to XCOM squad when targetted by Shadowbind
	class'X2Helper_Characters'.static.GremlinShadowbindAnimation();
	// Spectre Prime's copy have Prime Reactions
	class'X2Helper_Characters'.static.ShadowPrimeAbilities();

	// Allow Holy Warrior to target Mind Controlled units
	class'X2Helper_Abilities'.static.HolyWarriorOnMindControlled();
	// Archon Valkyrie melee attack can dash and slash
	class'X2Helper_Abilities'.static.PatchValkyrieMeleeAttack();
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