class AStrongerADVENT_Weapons extends X2Item config(StrongerADVENT);

var config WeaponDamageValue SECTOPOD_LIGHTNINGSTORM_BASEDAMAGE;
var config int SECTOPOD_LIGHTNINGSTORM_AIM;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	
	Weapons.AddItem(CreateTemplate_LightningStorm());

	return Weapons;
}

static function X2DataTemplate CreateTemplate_LightningStorm()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LightningStorm');
	Template.WeaponPanelImage = "_Sword"; // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.Sword";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_Utility;
	Template.Tier = 0;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 20;

	Template.iRange = 0;
	Template.BaseDamage = default.SECTOPOD_LIGHTNINGSTORM_BASEDAMAGE;
	Template.Aim = default.SECTOPOD_LIGHTNINGSTORM_AIM;
	Template.BaseDamage.DamageType = 'Melee';

	Template.Abilities.AddItem('SectopodLightningStorm');
	
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}