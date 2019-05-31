class AStrongerADVENT_Character_Shadow extends X2Character_DefaultCharacters config(GameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateTemplate_ShadowbindUnit('ShadowbindUnitM4'));
	
	return Templates;
}
