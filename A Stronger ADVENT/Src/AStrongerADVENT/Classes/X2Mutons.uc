class X2Mutons extends Object;

static event OnPostCharacterTemplatesCreated() {
	local X2CharacterTemplateManager			CharacterTemplateMgr;
	local X2CharacterTemplate					CharacterTemplate;
	local array<X2DataTemplate>					DataTemplates;
	local int i;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	// Muton Pyro
	CharacterTemplateMgr.FindDataTemplateAllDifficulties('MutonDragonrounds', DataTemplates);
	for( i = 0; i < DataTemplates.Length; ++i )
	{
		CharacterTemplate = X2CharacterTemplate(DataTemplates[i]);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.AddItem('CounterattackPreparation');
			CharacterTemplate.Abilities.AddItem('CounterattackDescription');
		}
	}
	// Muton Infector
	CharacterTemplateMgr.FindDataTemplateAllDifficulties('MutonVenomrounds', DataTemplates);
	for( i = 0; i < DataTemplates.Length; ++i )
	{
		CharacterTemplate = X2CharacterTemplate(DataTemplates[i]);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.AddItem('CounterattackPreparation');
			CharacterTemplate.Abilities.AddItem('CounterattackDescription');
		}
	}
}