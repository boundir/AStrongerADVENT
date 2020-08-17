class X2Helper_Characters extends Object config(GameData_SoldierSkills);

var config array<name> MELEE_RESISTANCE_INCLUDE_UNIT;
var config array<name> MELEE_VULNERABILITY_INCLUDE_UNIT;

static function ApplyMeleeResistance()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local name UnitName;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach default.MELEE_RESISTANCE_INCLUDE_UNIT(UnitName)
	{
		CharacterTemplateMgr.FindDataTemplateAllDifficulties(UnitName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);
			if( CharacterTemplate != none )
			{
				CharacterTemplate.Abilities.AddItem('MeleeResistance');
			}
		}
	}
}

static function ApplyMeleeVulnerability()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local name UnitName;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach default.MELEE_VULNERABILITY_INCLUDE_UNIT(UnitName)
	{
		CharacterTemplateMgr.FindDataTemplateAllDifficulties(UnitName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);
			if( CharacterTemplate != none )
			{
				CharacterTemplate.Abilities.AddItem('VulnerabilityMelee');
			}
		}
	}
}

static function ArchonPrimeIcarusDrop()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateMgr.FindDataTemplateAllDifficulties('ArchonM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ArchonKing_ANIM.Anims.AS_ArchonKing")));
			CharacterTemplate.Abilities.AddItem('IcarusDropGrab');
		}
	}
}

static function MutonCounterAttack()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local array<name> MutonUnits;
	local name UnitName;

	MutonUnits.AddItem('MutonDragonrounds');
	MutonUnits.AddItem('MutonVenomrounds');

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach MutonUnits(UnitName)
	{
		CharacterTemplateMgr.FindDataTemplateAllDifficulties(UnitName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);
			if( CharacterTemplate != none )
			{
				CharacterTemplate.Abilities.AddItem('CounterattackPreparation');
				CharacterTemplate.Abilities.AddItem('CounterattackDescription');
			}
		}
	}
}

static function MutonPrimeAbilities()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateMgr.FindDataTemplateAllDifficulties('MutonM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("MutonM4_ANIM.AS_MutonM2")));
			CharacterTemplate.Abilities.AddItem('Beastmaster_ASA');
			CharacterTemplate.Abilities.AddItem('WarCry_ASA');
		}
	}
}

static function CodexPrimeAbilities()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateMgr.FindDataTemplateAllDifficulties('CodexM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.RemoveItem('TriggerSuperposition');
			CharacterTemplate.Abilities.AddItem('TriggerSuperpositionPrime');
		}
	}
}

static function SpectrePrimeRework()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateMgr.FindDataTemplateAllDifficulties('SpectreM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.RemoveItem('ShadowbindM2');
			CharacterTemplate.Abilities.AddItem('ShadowbindM4');
			CharacterTemplate.strPawnArchetypes.Length = 0;
			CharacterTemplate.strMatineePackages.Length = 0;
			CharacterTemplate.strPawnArchetypes.AddItem("GameUnit_SpectreM4.Archetypes.ARC_GameUnit_SpectreM4");
			CharacterTemplate.strMatineePackages[0] = "CIN_XP_SpectreM4";
		}
	}
}

static function ShadowPrimeAbilities()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterTemplateMgr.FindDataTemplateAllDifficulties('ShadowbindUnitM4', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.RemoveItem('ShadowUnitInitialize');
			CharacterTemplate.Abilities.AddItem('ShadowUnitM4Initialize');
			CharacterTemplate.Abilities.AddItem('ShadowReaction');
		}
	}
}
