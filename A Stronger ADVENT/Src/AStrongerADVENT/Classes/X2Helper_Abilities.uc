class X2Helper_Abilities extends Object config(GameData_SoldierSkills);

var config bool PURIFIER_FLAMETHROWER_GUARANTEED_HIT;

static function HolyWarriorOnMindControlled()
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local X2Condition_UnitEffects ExcludeEffectsCondition;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_UnitEffectsApplying ApplyingEffectsCondition;
	local X2Condition_Visibility GameplayVisibilityCondition;
	local array<name> HolyWarriorAbilities;
	local name AbilityName;

	HolyWarriorAbilities.AddItem('HolyWarriorM1');
	HolyWarriorAbilities.AddItem('HolyWarriorM2');
	HolyWarriorAbilities.AddItem('HolyWarriorM3');

	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_AbilityUnavailable');

	GameplayVisibilityCondition = new class'X2Condition_Visibility';
	GameplayVisibilityCondition.bRequireGameplayVisible = true;
	GameplayVisibilityCondition.bRequireBasicVisibility = true;

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes = class'X2Ability_AdvPriest'.default.HOLYWARRIOR_EXCLUDE_TYPES;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;

	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach HolyWarriorAbilities(AbilityName)
	{
		AbilityTemplateManager.FindDataTemplateAllDifficulties(AbilityName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			AbilityTemplate = X2AbilityTemplate(Template);

			if (AbilityTemplate != none)
			{
				AbilityTemplate.AbilityShooterConditions.Length = 0;
				AbilityTemplate.AbilityTargetConditions.Length = 0;

				AbilityTemplate.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);
				AbilityTemplate.AbilityTargetConditions.AddItem(GameplayVisibilityCondition);
				AbilityTemplate.AbilityTargetConditions.AddItem(UnitTypeCondition);
				AbilityTemplate.AbilityTargetConditions.AddItem(UnitPropertyCondition);
				AbilityTemplate.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);
			}
		}
	}
}

static function PatchValkyrieMeleeAttack()
{
	local X2AbilityTemplateManager AbilityTemplateMgr;
	local X2AbilityTemplate AbilityTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplateMgr.FindDataTemplateAllDifficulties('StandardMeleeLifeLeech', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		AbilityTemplate = X2AbilityTemplate(Template);

		if( AbilityTemplate != none )
		{
			AbilityTemplate.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
			AbilityTemplate.TargetingMethod = class'X2TargetingMethod_MeleePath';
			AbilityTemplate.BuildNewGameStateFn = class'X2Ability'.static.TypicalMoveEndAbility_BuildGameState;
		}
	}
}

static function SpectreVanishIsFreeAction()
{
	local X2AbilityTemplateManager AbilityTemplateMgr;
	local X2AbilityTemplate AbilityTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local int Index;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplateMgr.FindDataTemplateAllDifficulties('Vanish', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		AbilityTemplate = X2AbilityTemplate(Template);

		if( AbilityTemplate != none )
		{
			for (Index = 0; Index < AbilityTemplate.AbilityCosts.Length; ++Index)
			{
				ActionPointCost = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[Index]);

				if(ActionPointCost != none)
				{
					ActionPointCost.bFreeCost = true;
				}
			}

		}
	}
}

static function PurifierFlamethrowerGuaranteedHit()
{
	local X2AbilityTemplateManager AbilityTemplateMgr;
	local X2AbilityTemplate AbilityTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local X2AbilityToHitCalc_StandardAim StandardAim;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplateMgr.FindDataTemplateAllDifficulties('AdvPurifierFlamethrower', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		AbilityTemplate = X2AbilityTemplate(Template);

		if( AbilityTemplate != none )
		{
			StandardAim = new class'X2AbilityToHitCalc_StandardAim';
			StandardAim.bGuaranteedHit = default.PURIFIER_FLAMETHROWER_GUARANTEED_HIT;
			AbilityTemplate.AbilityToHitCalc = StandardAim;
		}
	}
}

static function BlazingPinionsInflictPanic()
{
	local X2AbilityTemplateManager AbilityTemplateMgr;
	local X2AbilityTemplate AbilityTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local X2Effect_Panicked PanicEffect;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplateMgr.FindDataTemplateAllDifficulties('BlazingPinionsStage1', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		AbilityTemplate = X2AbilityTemplate(Template);

		if( AbilityTemplate != none )
		{
			AbilityTemplate.AdditionalAbilities.AddItem('BlazingPinionsPanicPassive');

			PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
			PanicEffect.ApplyChanceFn = class'X2Ability_ASA_Archon'.static.BlazingPinionsPanicApplyChance;
			PanicEffect.VisualizationFn = class'X2Ability_ASA_Archon'.static.BlazingPinionsPanic_PanickedVisualization;
			AbilityTemplate.AddMultiTargetEffect(PanicEffect);
		}
	}
}