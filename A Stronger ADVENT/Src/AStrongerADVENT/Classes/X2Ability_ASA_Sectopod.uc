class X2Ability_ASA_Sectopod extends X2Ability
	dependson (XComGameStateContext_Ability) config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(SectopodLightningStorm());
	Templates.AddItem(SectopodLightningStormAttack('SectopodLightningStormAttack_ASA'));

	return Templates;
}

static function X2AbilityTemplate SectopodLightningStorm()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('SectopodLightningStorm_ASA', "img:///UILibrary_PerkIcons.UIPerk_lightningfield", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('SectopodLightningStormAttack_ASA');

	return Template;
}

static function X2AbilityTemplate SectopodLightningStormAttack(name TemplateName = 'SectopodLightningStormAttack_ASA')
{
	local X2AbilityTemplate								Template;
	local X2AbilityToHitCalc_StandardAim				ToHitCalc;
	local X2AbilityTrigger_EventListener				Trigger;
	local X2Effect_Persistent							SectopodLightningStormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource		SectopodLightningStormTargetCondition;
	local X2Condition_UnitProperty						SourceNotConcealedCondition;
	local X2Condition_Visibility						TargetVisibilityCondition;
	local X2Condition_UnitEffects						UnitEffectsCondition;
	local X2Condition_UnitProperty						ExcludeSquadmatesCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningfield";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	ToHitCalc.bReactionFire = true;
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	//  trigger on movement
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
	Template.AbilityTriggers.AddItem(Trigger);

	//  it may be the case that enemy movement caused a concealment break, which made SectopodLightningStorm applicable - attempt to trigger afterwards
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = SectopodLightningStormConcealmentListener;
	Trigger.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	// Adding exclusion condition to prevent friendly SectopodLightningStorm fire when panicked.
	ExcludeSquadmatesCondition = new class'X2Condition_UnitProperty';
	ExcludeSquadmatesCondition.ExcludeSquadmates = true;
	Template.AbilityTargetConditions.AddItem(ExcludeSquadmatesCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	//Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	// Don't trigger if the unit has vanished
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect('Vanish', 'AA_UnitIsConcealed');
	UnitEffectsCondition.AddExcludeEffect('VanishingWind', 'AA_UnitIsConcealed');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.bAllowBonusWeaponEffects = true;
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	//Prevent repeatedly hammering on a unit with SectopodLightningStorm triggers.
	//(This effect does nothing, but enables many-to-many marking of which SectopodLightningStorm attacks have already occurred each turn.)
	SectopodLightningStormTargetEffect = new class'X2Effect_Persistent';
	SectopodLightningStormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	SectopodLightningStormTargetEffect.EffectName = 'SectopodLightningStormTarget';
	SectopodLightningStormTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(SectopodLightningStormTargetEffect);
	
	SectopodLightningStormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	SectopodLightningStormTargetCondition.AddExcludeEffect('SectopodLightningStormTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(SectopodLightningStormTargetCondition);

	Template.CustomFireAnim = 'NO_LightningFieldA';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SectopodLightningStorm_BuildVisualization;
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

// Must be static, because it will be called with a different object (an XComGameState_Ability)
// Used to trigger SectopodLightningStorm when the source's concealment is broken by a unit in melee range (the regular movement triggers get called too soon)
static function EventListenerReturn SectopodLightningStormConcealmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit ConcealmentBrokenUnit;
	local StateObjectReference SectopodLightningStormRef;
	local XComGameState_Ability SectopodLightningStormState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
	if (ConcealmentBrokenUnit == None)
		return ELR_NoInterrupt;

	//Do not trigger if the SectopodLightningStorm Ranger himself moved to cause the concealment break - only when an enemy moved and caused it.
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
	if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
		return ELR_NoInterrupt;

	SectopodLightningStormRef = ConcealmentBrokenUnit.FindAbility('SectopodLightningStormAttack');
	if (SectopodLightningStormRef.ObjectID == 0)
		return ELR_NoInterrupt;

	SectopodLightningStormState = XComGameState_Ability(History.GetGameStateForObjectID(SectopodLightningStormRef.ObjectID));
	if (SectopodLightningStormState == None)
		return ELR_NoInterrupt;
	
	SectopodLightningStormState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
	return ELR_NoInterrupt;
}

simulated function SectopodLightningStorm_BuildVisualization(XComGameState VisualizeGameState)
{
	// Build the first shot of SectopodLightningStorm's visualization
	TypicalAbility_BuildVisualization(VisualizeGameState);
}