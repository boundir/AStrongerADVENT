class AStrongerADVENT_OPTC_Sectoids extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager			CharacterTemplateMgr;
	local X2CharacterTemplate					CharacterTemplate;
	local array<X2DataTemplate>					DataTemplates;
	local int i;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	// Sectoid Soldier
	CharacterTemplateMgr.FindDataTemplateAllDifficulties('SectoidTrooper', DataTemplates);
	for( i = 0; i < DataTemplates.Length; ++i )
	{
		CharacterTemplate = X2CharacterTemplate(DataTemplates[i]);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.AddItem('VulnerabilityMelee');
		}
	}
	// Sectoid Soldier Prime
	CharacterTemplateMgr.FindDataTemplateAllDifficulties('SectoidTrooperM4', DataTemplates);
	for( i = 0; i < DataTemplates.Length; ++i )
	{
		CharacterTemplate = X2CharacterTemplate(DataTemplates[i]);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.AddItem('VulnerabilityMelee');
		}
	}
}