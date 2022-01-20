class X2Item_ASA_Ammo extends X2Item config(GameCore);

var config int ACID_ROUND_DMGMOD;
var config int ACID_ROUND_SHRED;
var config bool SHOULD_ACID_BURN_SPREAD;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(CreateAcidRounds());
	
	return Items;
}

static function X2DataTemplate CreateAcidRounds()
{
	local X2AmmoTemplate Template;
	local WeaponDamageValue DamageValue;
	
	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'ASA_AcidRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Venom_Rounds";

	DamageValue.Damage = default.ACID_ROUND_DMGMOD;
	DamageValue.Shred = default.ACID_ROUND_SHRED;
	DamageValue.DamageType = 'Acid';
	Template.AddAmmoDamageModifier(none, DamageValue);

	Template.Abilities.AddItem('ASA_AcidRounds');

	Template.TargetEffects.AddItem(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(1, default.SHOULD_ACID_BURN_SPREAD));

	Template.CanBeBuilt = false;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageBonusLabel, , default.ACID_ROUND_DMGMOD);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.ACID_ROUND_SHRED);

	Template.GameArchetype = "Ammo_Venom.PJ_Venom";

	return Template;
}