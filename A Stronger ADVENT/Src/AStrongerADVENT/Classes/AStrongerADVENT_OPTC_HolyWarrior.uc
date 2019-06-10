class AStrongerADVENT_OPTC_HolyWarrior extends X2DownloadableContentInfo config(GameData_Soldierskills);

static event OnPostTemplatesCreated()
{

	local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					AbilityTemplate;
	local X2Condition_UnitEffects			ExcludeEffectsCondition;
	local X2Condition_UnitType				UnitTypeCondition;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_UnitEffectsApplying	ApplyingEffectsCondition;
	local X2Condition_Visibility			GameplayVisibilityCondition;

	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('HolyWarriorM1');
	if (AbilityTemplate != none)
	{
		AbilityTemplate.AbilityShooterConditions.Length = 0;

		ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
		ApplyingEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_AbilityUnavailable');
		AbilityTemplate.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

		AbilityTemplate.AbilityTargetConditions.Length = 0;

		GameplayVisibilityCondition = new class'X2Condition_Visibility';
		GameplayVisibilityCondition.bRequireGameplayVisible = true;
		GameplayVisibilityCondition.bRequireBasicVisibility = true;

		AbilityTemplate.AbilityTargetConditions.AddItem(GameplayVisibilityCondition);
		//AbilityTemplate.AbilityTargetConditions.AddItem(class'X2Ability'.default.GameplayVisibilityCondition);

		UnitTypeCondition = new class'X2Condition_UnitType';
		UnitTypeCondition.ExcludeTypes = class'X2Ability_AdvPriest'.default.HOLYWARRIOR_EXCLUDE_TYPES;
		AbilityTemplate.AbilityTargetConditions.AddItem(UnitTypeCondition);

		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeDead = true;
		UnitPropertyCondition.ExcludeHostileToSource = true;
		UnitPropertyCondition.ExcludeFriendlyToSource = false;
		UnitPropertyCondition.ExcludeRobotic = true;
		UnitPropertyCondition.FailOnNonUnits = true;
		UnitPropertyCondition.ExcludeCivilian = true;
		AbilityTemplate.AbilityTargetConditions.AddItem(UnitPropertyCondition);

		ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
		ExcludeEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');
		AbilityTemplate.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);
	}

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('HolyWarriorM2');
	if (AbilityTemplate != none)
	{
		AbilityTemplate.AbilityShooterConditions.Length = 0;

		ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
		ApplyingEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_AbilityUnavailable');
		AbilityTemplate.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

		AbilityTemplate.AbilityTargetConditions.Length = 0;

		GameplayVisibilityCondition.bRequireGameplayVisible = true;
		GameplayVisibilityCondition.bRequireBasicVisibility = true;

		AbilityTemplate.AbilityTargetConditions.AddItem(GameplayVisibilityCondition);
		//AbilityTemplate.AbilityTargetConditions.AddItem(class'X2Ability'.default.GameplayVisibilityCondition);

		UnitTypeCondition = new class'X2Condition_UnitType';
		UnitTypeCondition.ExcludeTypes = class'X2Ability_AdvPriest'.default.HOLYWARRIOR_EXCLUDE_TYPES;
		AbilityTemplate.AbilityTargetConditions.AddItem(UnitTypeCondition);

		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeDead = true;
		UnitPropertyCondition.ExcludeHostileToSource = true;
		UnitPropertyCondition.ExcludeFriendlyToSource = false;
		UnitPropertyCondition.ExcludeRobotic = true;
		UnitPropertyCondition.FailOnNonUnits = true;
		UnitPropertyCondition.ExcludeCivilian = true;
		AbilityTemplate.AbilityTargetConditions.AddItem(UnitPropertyCondition);

		ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
		ExcludeEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');
		AbilityTemplate.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);
	}

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('HolyWarriorM3');
	if (AbilityTemplate != none)
	{
		AbilityTemplate.AbilityShooterConditions.Length = 0;

		ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
		ApplyingEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_AbilityUnavailable');
		AbilityTemplate.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

		AbilityTemplate.AbilityTargetConditions.Length = 0;

		GameplayVisibilityCondition.bRequireGameplayVisible = true;
		GameplayVisibilityCondition.bRequireBasicVisibility = true;

		AbilityTemplate.AbilityTargetConditions.AddItem(GameplayVisibilityCondition);
		//AbilityTemplate.AbilityTargetConditions.AddItem(class'X2Ability'.default.GameplayVisibilityCondition);

		UnitTypeCondition = new class'X2Condition_UnitType';
		UnitTypeCondition.ExcludeTypes = class'X2Ability_AdvPriest'.default.HOLYWARRIOR_EXCLUDE_TYPES;
		AbilityTemplate.AbilityTargetConditions.AddItem(UnitTypeCondition);

		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeDead = true;
		UnitPropertyCondition.ExcludeHostileToSource = true;
		UnitPropertyCondition.ExcludeFriendlyToSource = false;
		UnitPropertyCondition.ExcludeRobotic = true;
		UnitPropertyCondition.FailOnNonUnits = true;
		UnitPropertyCondition.ExcludeCivilian = true;
		AbilityTemplate.AbilityTargetConditions.AddItem(UnitPropertyCondition);

		ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
		ExcludeEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');
		AbilityTemplate.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);
	}

	return;

}
	