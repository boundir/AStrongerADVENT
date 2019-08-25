class AStrongerADVENT_OPTC_Archons extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	PatchCharacters();
	PatchAbilities();
}

static function PatchCharacters()
{
	local X2CharacterTemplateManager			CharacterTemplateMgr;
	local X2CharacterTemplate					CharacterTemplate;
	local array<X2DataTemplate>					TemplateAllDifficulties;
	local X2DataTemplate						Template;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	// Archon Prime
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

static function PatchAbilities()
{
	local X2AbilityTemplateManager			AbilityTemplateMgr;
	local X2AbilityTemplate					AbilityTemplate;
	local array<X2DataTemplate>				TemplateAllDifficulties;
	local X2DataTemplate					Template;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// Archon Melee
	AbilityTemplateMgr.FindDataTemplateAllDifficulties('StandardMeleeLifeLeech', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		AbilityTemplate = X2AbilityTemplate(Template);

		if( AbilityTemplate != none )
		{
			AbilityTemplate.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
			AbilityTemplate.TargetingMethod = class'X2TargetingMethod_MeleePath';
			AbilityTemplate.BuildNewGameStateFn = class'X2Ability'.static.TypicalMoveEndAbility_BuildGameState;
		}
	}

}