//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_ASA_Spectre extends X2Ability_Spectre
	config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateShadowbindM4('ShadowbindM4', 'ShadowbindUnitM4'));
	Templates.AddItem(CreateShadowbindReaction());
	Templates.AddItem(CreateShadowUnitM4Initialize());

	return Templates;
}

static function X2DataTemplate CreateShadowbindM4(name AbilityTemplateName, name UnitToSpawnName)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_UnitImmunities UnitImmunityCondition;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Effect_ASA_SpawnShadowbindUnit SpawnShadowbindUnit;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Effect_OverrideDeathAction DeathActionEffect;
	local X2Effect_Persistent UnconsciousEffect;
	local X2Condition_UnitType UnitTypeCondition;
	local array<name> SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityTemplateName);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadowbind";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.SHADOWBIND_COOLDOWN_LOCAL;
	Cooldown.NumGlobalTurns = default.SHADOWBIND_COOLDOWN_GLOBAL;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_UnblockedNeighborTile');
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost');
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	// The Target must be alive and a humanoid
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeImpaired = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Unconscious');
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_ParthenogenicPoison'.default.EffectName);
	Template.AddTargetEffect(RemoveEffects);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_ASA_ShadowbindTarget';
	DeathActionEffect.EffectName = 'ShadowbindUnconcious';
	Template.AddTargetEffect(DeathActionEffect);

	UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect();
	UnconsciousEffect.bRemoveWhenSourceDies = false;
	UnconsciousEffect.VisualizationFn = ShadowbindUnconsciousVisualization;
	Template.AddTargetEffect(UnconsciousEffect);

	SpawnShadowbindUnit = new class'X2Effect_ASA_SpawnShadowbindUnit';
	SpawnShadowbindUnit.BuildPersistentEffect(1, true, false, true);
	SpawnShadowbindUnit.bRemoveWhenTargetDies = false;
	SpawnShadowbindUnit.UnitToSpawnName = UnitToSpawnName;
	Template.AddTargetEffect(SpawnShadowbindUnit);

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = ShadowbindM4_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	Template.CinescriptCameraType = "Spectre_Shadowbind";

	Template.CustomFireAnim = 'HL_Shadowbind';

	return Template;
}

simulated function ShadowbindM4_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local VisualizationActionMetadata ShadowMetaData, CosmeticUnitMetaData;
	local XComGameState_Unit ShadowUnit, ShadowbindTargetUnit, TargetUnitState, CosmeticUnit;
	local UnitValue ShadowUnitValue;
	local X2Effect_ASA_SpawnShadowbindUnit SpawnShadowEffect;
	local int j;
	local name SpawnShadowEffectResult;
	local X2Action_Fire SourceFire;
	local X2Action_MoveBegin SourceMoveBegin;
	local Actor SourceUnit;
	local array<X2Action> TransformStopParents;
	local VisualizationActionMetadata SourceMetaData, TargetMetaData;
	local X2Action_MoveTurn MoveTurnAction;
	local X2Action_PlayShadowbindAnimation AddAnimAction, AnimAction;
	local X2Action_ASA_ShadowbindTarget TargetShadowbind;
	local XComGameState_Item ItemState;
	local X2GremlinTemplate GremlinTemplate;
	local Array<X2Action> FoundNodes;
	local int ScanNodes;
	local X2Action_MarkerNamed JoinAction;
	local XGUnit GremlinUnit;
	local XComUnitPawn GremlinPawn;
	

	TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	TargetMetaData.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	TargetMetaData.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID);
	TargetMetaData.VisualizeActor = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);
	TargetUnitState = XComGameState_Unit(TargetMetaData.StateObject_OldState);

	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_MarkerNamed', FoundNodes);
	for( ScanNodes = 0; ScanNodes < FoundNodes.Length; ++ScanNodes )
	{
		JoinAction = X2Action_MarkerNamed(FoundNodes[ScanNodes]);
		if( JoinAction.MarkerName == 'Join' )
		{
			break;
		}
	}

	// Find the Fire and MoveBegin for the Source
	SourceFire = X2Action_Fire(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', , Context.InputContext.SourceObject.ObjectID));
	SourceUnit = SourceFire.Metadata.VisualizeActor;

	SourceMoveBegin = X2Action_MoveBegin(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveBegin', SourceUnit));

	// Find the Target's Shadowbind
	TargetShadowbind = X2Action_ASA_ShadowbindTarget(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ASA_ShadowbindTarget', , Context.InputContext.PrimaryTarget.ObjectID));

	SourceMetaData.StateObject_OldState = SourceFire.Metadata.StateObject_OldState;
	SourceMetaData.StateObject_NewState = SourceFire.Metadata.StateObject_NewState;
	SourceMetaData.VisualizeActor = SourceFire.Metadata.VisualizeActor;

	if (Context.InputContext.MovementPaths.Length > 0)
	{
		// If moving, need to set the facing and pre/post transforms
		MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(SourceMetaData, Context, true, , SourceFire.ParentActions));
		MoveTurnAction.m_vFacePoint = `XWORLD.GetPositionFromTileCoordinates(TargetUnitState.TileLocation);
		MoveTurnAction.ForceSetPawnRotation = true;

		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, MoveTurnAction);

		TransformStopParents.AddItem(MoveTurnAction);

		ASA_SpectreMoveInsertTransform(VisualizeGameState, SourceMetaData, SourceMoveBegin.ParentActions, TransformStopParents);
	}

	// Line up the Source's Fire, Target's React, and Shadow's anim
	if( TargetShadowbind != None && TargetShadowbind.ParentActions.Length != 0 )
	{
		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, , TargetShadowbind.ParentActions);
	}
	
	VisMgr.DisconnectAction(TargetShadowbind);
	VisMgr.ConnectAction(TargetShadowbind, VisMgr.BuildVisTree, false, , SourceFire.ParentActions);

	SpawnShadowEffectResult = 'AA_UnknownError';
	for (j = 0; j < Context.ResultContext.TargetEffectResults.Effects.Length; ++j)
	{
		SpawnShadowEffect = X2Effect_ASA_SpawnShadowbindUnit(Context.ResultContext.TargetEffectResults.Effects[j]);

		if (SpawnShadowEffect != none)
		{
			SpawnShadowEffectResult = Context.ResultContext.TargetEffectResults.ApplyResults[j];
			break;
		}
	}

	if (SpawnShadowEffectResult == 'AA_Success')
	{
		ShadowbindTargetUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
		`assert(ShadowbindTargetUnit != none);
		ShadowbindTargetUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, ShadowUnitValue);

		ShadowMetaData.StateObject_OldState = History.GetGameStateForObjectID(ShadowUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		ShadowMetaData.StateObject_NewState = ShadowMetaData.StateObject_OldState;
		ShadowUnit = XComGameState_Unit(ShadowMetaData.StateObject_NewState);
		`assert(ShadowUnit != none);
		ShadowMetaData.VisualizeActor = History.GetVisualizer(ShadowUnit.ObjectID);
		
		SpawnShadowEffect.AddSpawnVisualizationsToTracks(Context, ShadowUnit, ShadowMetaData, ShadowbindTargetUnit);

		AnimAction = X2Action_PlayShadowbindAnimation(class'X2Action_PlayShadowbindAnimation'.static.AddToVisualizationTree(ShadowMetaData, Context, true, TargetShadowbind));
		AnimAction.Params.AnimName = 'HL_ShadowbindM4_TargetShadow';
		AnimAction.Params.BlendTime = 0.0f;

		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, AnimAction);

		AddAnimAction = X2Action_PlayShadowbindAnimation(class'X2Action_PlayShadowbindAnimation'.static.AddToVisualizationTree(ShadowMetaData, Context, false, TargetShadowbind));
		AddAnimAction.bFinishAnimationWait = false;
		AddAnimAction.Params.AnimName = 'ADD_HL_ShadowbindM4_FadeIn';
		AddAnimAction.Params.Additive = true;
		AddAnimAction.Params.BlendTime = 0.0f;

		VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, AddAnimAction);

		// Look for a gremlin that got copied
		ItemState = ShadowUnit.GetSecondaryWeapon();
		
		GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
		if( GremlinTemplate != none )
		{
			// This is a newly spawned unit so it should have its own gremlin
			CosmeticUnit = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.CosmeticUnitRef.ObjectID));

			History.GetCurrentAndPreviousGameStatesForObjectID(CosmeticUnit.ObjectID, CosmeticUnitMetaData.StateObject_OldState, CosmeticUnitMetaData.StateObject_NewState, , VisualizeGameState.HistoryIndex);
			CosmeticUnitMetaData.VisualizeActor = CosmeticUnit.GetVisualizer();

			GremlinUnit = XGUnit(CosmeticUnitMetaData.VisualizeActor);
			if( GremlinUnit != none )
			{
				`log("GOT THE XGUNIT",, 'GremlinShadowbindPlayAnim');
				GremlinPawn = GremlinUnit.GetPawn();

				if( GremlinPawn != none )
				{
					`log("GOT THE PAWN",, 'GremlinShadowbindPlayAnim');
					GremlinPawn.Mesh.UpdateAnimations();
				}
			}

			AddAnimAction = X2Action_PlayShadowbindAnimation(class'X2Action_PlayShadowbindAnimation'.static.AddToVisualizationTree(CosmeticUnitMetaData, Context, false, TargetShadowbind));
			AddAnimAction.bFinishAnimationWait = false;
			AddAnimAction.Params.AnimName = 'ADD_HL_ShadowbindM4_FadeIn';
			AddAnimAction.Params.Additive = true;
			AddAnimAction.Params.BlendTime = 0.0f;

			VisMgr.ConnectAction(JoinAction, VisMgr.BuildVisTree, false, AddAnimAction);
		}
	}
}

private function ASA_SpectreMoveInsertTransform(XComGameState VisualizeGameState, VisualizationActionMetadata ActionMetaData, array<X2Action> TransformStartParents, array<X2Action> TransformStopParents)
{
	local X2Action_PlayShadowbindAnimation AnimAction;

	AnimAction = X2Action_PlayShadowbindAnimation(class'X2Action_PlayShadowbindAnimation'.static.AddToVisualizationTree(ActionMetaData, VisualizeGameState.GetContext(), true, , TransformStartParents));
	AnimAction.Params.AnimName = 'HL_Transform_Start';

	AnimAction = X2Action_PlayShadowbindAnimation(class'X2Action_PlayShadowbindAnimation'.static.AddToVisualizationTree(ActionMetaData, VisualizeGameState.GetContext(), true, , TransformStopParents));
	AnimAction.Params.AnimName = 'HL_Transform_Stop';
}

static function X2AbilityTemplate CreateShadowbindReaction()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_RunBehaviorTree ReactionEffect;
	local X2Effect_GrantActionPoints AddAPEffect;
	local array<name> SkipExclusions;
	local X2Condition_UnitProperty UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShadowReaction');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	// The unit must be alive and not stunned
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeStunned = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	AddAPEffect = new class'X2Effect_GrantActionPoints';
	AddAPEffect.NumActionPoints = 1;
	AddAPEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(AddAPEffect);

	ReactionEffect = new class'X2Effect_RunBehaviorTree';
	ReactionEffect.BehaviorTreeName = 'ShadowReaction';
	Template.AddTargetEffect(ReactionEffect);

	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate CreateShadowUnitM4Initialize()
{
	local X2AbilityTemplate Template;
	local X2Effect_ASA_ShadowUnitM4 ShadowUnitEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShadowUnitM4Initialize');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ShadowUnitEffect = new class'X2Effect_ASA_ShadowUnitM4';
	ShadowUnitEffect.BuildPersistentEffect(1, true, true, true);
	ShadowUnitEffect.bRemoveWhenTargetDies = true;
	Template.AddShooterEffect(ShadowUnitEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}