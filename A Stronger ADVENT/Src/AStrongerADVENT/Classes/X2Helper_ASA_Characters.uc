class X2Helper_ASA_Characters extends Object config(GameData_SoldierSkills);

var config array<name> MELEE_RESISTANCE_INCLUDE_UNIT;
var config array<name> MELEE_VULNERABILITY_INCLUDE_UNIT;

static function ApplyMeleeResistance()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local name UnitName;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach default.MELEE_RESISTANCE_INCLUDE_UNIT(UnitName)
	{
		CharacterTemplateManager.FindDataTemplateAllDifficulties(UnitName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);
			if (CharacterTemplate != none)
			{
				CharacterTemplate.Abilities.AddItem('MeleeResistance');
			}
		}
	}
}

static function ApplyMeleeVulnerability()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local name UnitName;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach default.MELEE_VULNERABILITY_INCLUDE_UNIT(UnitName)
	{
		CharacterTemplateManager.FindDataTemplateAllDifficulties(UnitName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);
			if (CharacterTemplate != none)
			{
				CharacterTemplate.Abilities.AddItem('VulnerabilityMelee');
			}
		}
	}
}

static function ArchonPrimeIcarusDrop()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateManager.FindDataTemplateAllDifficulties('ArchonM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if (CharacterTemplate != none)
		{
			CharacterTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ArchonKing_ANIM.Anims.AS_ArchonKing")));
			CharacterTemplate.Abilities.AddItem('IcarusDropGrab');
		}
	}
}

static function MutonCounterAttack()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local array<name> MutonUnits;
	local name UnitName;

	MutonUnits.AddItem('MutonDragonrounds');
	MutonUnits.AddItem('MutonVenomrounds');

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach MutonUnits(UnitName)
	{
		CharacterTemplateManager.FindDataTemplateAllDifficulties(UnitName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);
			if (CharacterTemplate != none)
			{
				CharacterTemplate.Abilities.AddItem('CounterattackPreparation');
				CharacterTemplate.Abilities.AddItem('CounterattackDescription');
			}
		}
	}
}

static function MutonPrimeAbilities()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateManager.FindDataTemplateAllDifficulties('MutonM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if (CharacterTemplate != none)
		{
			CharacterTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("AStrongerADVENT_Content.MutonM4.Anims.AS_MutonM2")));
			CharacterTemplate.Abilities.AddItem('Beastmaster_ASA');
			CharacterTemplate.Abilities.AddItem('WarCry_ASA');
		}
	}
}

static function CodexPrimeAbilities()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateManager.FindDataTemplateAllDifficulties('CodexM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if (CharacterTemplate != none)
		{
			CharacterTemplate.Abilities.RemoveItem('TriggerSuperposition');
			CharacterTemplate.Abilities.AddItem('TriggerSuperpositionPrime');
		}
	}
}

static function SpectrePrimeRework()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateManager.FindDataTemplateAllDifficulties('SpectreM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if (CharacterTemplate != none)
		{
			CharacterTemplate.Abilities.RemoveItem('ShadowbindM2');
			CharacterTemplate.Abilities.AddItem('ShadowbindM4');

			CharacterTemplate.strPawnArchetypes.Length = 0;
			CharacterTemplate.strMatineePackages.Length = 0;

			CharacterTemplate.strPawnArchetypes.AddItem("AStrongerADVENT_Content.SpectreM4.Archetypes.ARC_GameUnit_SpectreM4");
			CharacterTemplate.strMatineePackages.AddItem("CIN_XP_SpectreM4");
			CharacterTemplate.DefaultLoadout = 'SpectreM4_Loadout';
		}
	}
}

static function PriestStasisShield()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local array<name> PriestUnits;
	local name UnitName;

	PriestUnits.AddItem('AdvPriestM1');
	PriestUnits.AddItem('AdvPriestM2');
	PriestUnits.AddItem('AdvPriestM3');

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach PriestUnits(UnitName)
	{
		CharacterTemplateManager.FindDataTemplateAllDifficulties(UnitName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);

			if (CharacterTemplate != none)
			{
				CharacterTemplate.Abilities.AddItem('StasisShield');
			}
		}
	}
}

static function ShadowPrimeAbilities()
{
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateManager.FindDataTemplateAllDifficulties('ShadowbindUnitM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if (CharacterTemplate != none)
		{
			CharacterTemplate.Abilities.RemoveItem('ShadowUnitInitialize');
			CharacterTemplate.Abilities.AddItem('ShadowUnitM4Initialize');
			CharacterTemplate.Abilities.AddItem('ShadowReaction');
		}
	}
}
