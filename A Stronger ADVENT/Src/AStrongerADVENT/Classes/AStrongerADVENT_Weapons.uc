class AStrongerADVENT_Weapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue PURIFIER_PISTOL_M1_WPN_BASEDAMAGE;
var config WeaponDamageValue PURIFIER_PISTOL_M2_WPN_BASEDAMAGE;
var config WeaponDamageValue PURIFIER_PISTOL_M3_WPN_BASEDAMAGE;

var config WeaponDamageValue SECTOPOD_LIGHTNINGSTORM_BASEDAMAGE;
var config int SECTOPOD_LIGHTNINGSTORM_AIM;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	
	Weapons.AddItem(CreateTemplate_LightningStorm());
	Weapons.AddItem(CreateTemplate_PurifierPistolM1_WPN());
	Weapons.AddItem(CreateTemplate_PurifierPistolM2_WPN());
	Weapons.AddItem(CreateTemplate_PurifierPistolM3_WPN());

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

	static function X2DataTemplate CreateTemplate_PurifierPistolM1_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PurifierPistolM1_WPN');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.
	 
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.ConvPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.PURIFIER_PISTOL_M1_WPN_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.InfiniteAmmo = true;
	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotConvA');	
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG_Advent";

	Template.iPhysicsImpulse = 5;
	
	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_PurifierPistolM2_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PurifierPistolM2_WPN');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.PURIFIER_PISTOL_M2_WPN_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;


	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_PurifierPistolM3_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PurifierPistolM3_WPN');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
	Template.BaseDamage = default.PURIFIER_PISTOL_M3_WPN_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_BEAM_IENVIRONMENTDAMAGE;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}