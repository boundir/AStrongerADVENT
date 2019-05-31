//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class AStrongerADVENT_Ability_Priest extends X2Ability_AdvPriest
	config(GameData_SoldierSkills);


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateHolyWarrior_ASA('HolyWarriorM1_ASA', default.HOLYWARRIOR_M1_MOBILITY, default.HOLYWARRIOR_M1_OFFENSE, default.HOLYWARRIOR_M1_CRIT, default.HOLYWARRIOR_M1_HP));
	Templates.AddItem(CreateHolyWarrior_ASA('HolyWarriorM2_ASA', default.HOLYWARRIOR_M2_MOBILITY, default.HOLYWARRIOR_M2_OFFENSE, default.HOLYWARRIOR_M2_CRIT, default.HOLYWARRIOR_M2_HP));
	Templates.AddItem(CreateHolyWarrior_ASA('HolyWarriorM3_ASA', default.HOLYWARRIOR_M3_MOBILITY, default.HOLYWARRIOR_M3_OFFENSE, default.HOLYWARRIOR_M3_CRIT, default.HOLYWARRIOR_M3_HP));

	return Templates;
}


static function X2DataTemplate CreateHolyWarrior_ASA(name AbilityName, int MobilityChange, int AimChange, int CritChange, int HPChange)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Effect_PersistentStatChange HolyWarriorEffect;
	local X2Condition_UnitEffects ExcludeEffectsCondition;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Condition_UnitEffectsApplying ApplyingEffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_holywarrior";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.AdditionalAbilities.AddItem('HolyWarriorDeath');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.HOLYWARRIOR_ACTIONPOINTCOST;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.HOLYWARRIOR_COOLDOWN_LOCAL;
	Cooldown.NumGlobalTurns = default.HOLYWARRIOR_COOLDOWN_GLOBAL;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();	// Discuss with Jake/Design what exclusions are allowed here

	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(default.HolyWarriorEffectName, 'AA_AbilityUnavailable');
	// ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlling');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes = default.HOLYWARRIOR_EXCLUDE_TYPES;
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectsCondition.AddExcludeEffect(default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);

	HolyWarriorEffect = new class'X2Effect_PersistentStatChange';
	HolyWarriorEffect.EffectName = default.HolyWarriorEffectName;
	HolyWarriorEffect.DuplicateResponse = eDupe_Ignore;
	HolyWarriorEffect.BuildPersistentEffect(1, true, false, true);
	HolyWarriorEffect.bRemoveWhenTargetDies = true;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Mobility, MobilityChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Offense, AimChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_CritChance, CritChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_ShieldHP, HPChange);
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'HL_Psi_MindControl';
//BEGIN AUTOGENERATED CODE: Template Overrides 'HolyWarriorM1'
//BEGIN AUTOGENERATED CODE: Template Overrides 'HolyWarriorM2'
//BEGIN AUTOGENERATED CODE: Template Overrides 'HolyWarriorM3'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
//END AUTOGENERATED CODE: Template Overrides 'HolyWarriorM3'
//END AUTOGENERATED CODE: Template Overrides 'HolyWarriorM2'
//END AUTOGENERATED CODE: Template Overrides 'HolyWarriorM1'
	Template.bShowActivation = true;

	//	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}