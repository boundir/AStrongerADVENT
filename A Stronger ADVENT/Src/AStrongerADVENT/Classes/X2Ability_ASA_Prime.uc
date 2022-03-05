class X2Ability_ASA_Prime extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PurePassive('UnbreakableWill', "img:///UILibrary_PerkIcons.UIPerk_absorption_fields"));

	return Templates;
}
