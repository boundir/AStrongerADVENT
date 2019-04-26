class X2Codex extends Object;

static event OnPostCharacterTemplatesCreated() {
	local X2CharacterTemplateManager			CharacterTemplateMgr;
	local X2CharacterTemplate					CharacterTemplate;
	local array<X2DataTemplate>					DataTemplates;
	local int i;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	// Codex Prime
	CharacterTemplateMgr.FindDataTemplateAllDifficulties('CodexM4', DataTemplates);
	for( i = 0; i < DataTemplates.Length; ++i )
	{
		CharacterTemplate = X2CharacterTemplate(DataTemplates[i]);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.RemoveItem('TriggerSuperposition');
			CharacterTemplate.Abilities.RemoveItem('Superposition');
			CharacterTemplate.Abilities.AddItem('TriggerSuperpositionPrime');
		}
	}
}