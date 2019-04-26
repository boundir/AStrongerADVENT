class X2Spectres extends Object;

static event OnPostCharacterTemplatesCreated() {
	local X2CharacterTemplateManager			CharacterTemplateMgr;
	local X2CharacterTemplate					CharacterTemplate;
	local array<X2DataTemplate>					DataTemplates;
	local int i;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	// Spectre Prime
	CharacterTemplateMgr.FindDataTemplateAllDifficulties('SpectreM4', DataTemplates);
	for( i = 0; i < DataTemplates.Length; ++i )
	{
		CharacterTemplate = X2CharacterTemplate(DataTemplates[i]);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.RemoveItem('ShadowbindM2');
			CharacterTemplate.Abilities.AddItem('ShadowbindM4');
		}
	}

	// Shadowbound Unit Prime
	CharacterTemplateMgr.FindDataTemplateAllDifficulties('ShadowbindUnitM4', DataTemplates);
	for( i = 0; i < DataTemplates.Length; ++i )
	{
		CharacterTemplate = X2CharacterTemplate(DataTemplates[i]);
		if( CharacterTemplate != none )
		{
			CharacterTemplate.Abilities.AddItem('ShadowReaction');
		}
	}
}