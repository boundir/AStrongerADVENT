//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_ASA_Muton extends X2Ability_Muton
	config(GameData_SoldierSkills);

var config float WARCRY_RADIUS_METERS;
var config int WARCRY_DURATION;
var config int WARCRY_COOLDOWN;
var config int WARCRY_ACTIONCOST;
var config int WARCRY_MUTON_OFFENSE_BONUS;
var config int WARCRY_MUTON_WILL_BONUS;
var config int WARCRY_MUTON_MOBILITY_BONUS;
var config int WARCRY_OTHER_OFFENSE_BONUS;
var config int WARCRY_OTHER_WILL_BONUS;
var config int WARCRY_OTHER_MOBILITY_BONUS;
var config array <string> WARCRY_MUTON_BONUS;
var config array <string> WARCRY_OTHER_BONUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateAbility_BeastMaster());
	Templates.AddItem(CreateAbility_WarCry());

	return Templates;
}

static function X2AbilityTemplate CreateAbility_BeastMaster()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityTrigger					Trigger;
	local X2Effect_ASA_Beastmaster			BeastMasterEffect;

	// Different template name from LW so it's independent.
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beastmaster_ASA');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///Texture2D'UILibrary_AStrongerADVENT.LWCenturion_AbilityBeastmaster64'";

	Template.AbilityToHitCalc = default.DeadEye;
	TargetStyle = new class 'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class 'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	BeastMasterEffect = new class'X2Effect_ASA_BeastMaster';
	BeastMasterEffect.BuildPersistentEffect (1, true, false);
	BeastMasterEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(BeastMasterEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateAbility_WarCry()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			MultiTargetProperty;
	local X2Effect_ASA_WarCry				StatEffect;
	local X2AbilityTargetStyle				TargetStyle;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local int								i;
	local string							AlienName;

	// Different template name from LW so it's independent.
	`CREATE_X2ABILITY_TEMPLATE(Template, 'WarCry_ASA');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.IconImage = "img:///Texture2D'UILibrary_AStrongerADVENT.LWCenturion_AbilityWarCry64'";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.WARCRY_ACTIONCOST;
	ActionPointCost.bfreeCost = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.WARCRY_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.Deadeye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.WARCRY_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	MultiTargetProperty = new class'X2Condition_UnitProperty';
	MultiTargetProperty.ExcludeAlive = false;
	MultiTargetProperty.ExcludeDead = true;
	MultiTargetProperty.ExcludeHostileToSource = true;
	MultiTargetProperty.ExcludeFriendlyToSource = false;
	MultiTargetProperty.RequireSquadmates = true;
	MultiTargetProperty.ExcludePanicked = true;
	MultiTargetProperty.ExcludeRobotic = true;
	MultiTargetProperty.ExcludeStunned = true;

	Template.AbilityMultiTargetConditions.AddItem(MultiTargetProperty);

	StatEffect = new class'X2Effect_ASA_WarCry';

	StatEffect.BuildPersistentEffect(default.WARCRY_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	StatEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_ASA_WarCry'.default.strWarCryFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);

	StatEffect.DuplicateResponse = eDupe_Refresh;

	ForEach default.WARCRY_MUTON_BONUS(AlienName, i)
	{
		StatEffect.AddCharacterNameHigh (name(AlienName));
	}
	ForEach default.WARCRY_OTHER_BONUS(AlienName, i)
	{
		StatEffect.AddCharacterNameLow (name(AlienName));
	}

	StatEffect.AddPersistentStatChange (eStat_Offense, float (default.WARCRY_MUTON_OFFENSE_BONUS), true);
	StatEffect.AddPersistentStatChange (eStat_Mobility, float (default.WARCRY_MUTON_MOBILITY_BONUS), true);
	StatEffect.AddPersistentStatChange (eStat_Will, float (default.WARCRY_MUTON_WILL_BONUS), true);

	StatEffect.AddPersistentStatChange (eStat_Offense, float (default.WARCRY_OTHER_OFFENSE_BONUS), false);
	StatEffect.AddPersistentStatChange (eStat_Mobility, float (default.WARCRY_OTHER_MOBILITY_BONUS), false);
	StatEffect.AddPersistentStatChange (eStat_Will, float (default.WARCRY_OTHER_WILL_BONUS), false);

	//Template.AddShooterEffect(StatEffect); This would make Centurion gain bonuses from own War Cry
	Template.AddMultiTargetEffect(StatEffect);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = WarCry_BuildVisualization;
	return Template;
}

function WarCry_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		context;
	local StateObjectReference				InteractingUnitRef;
	local VisualizationActionMetadata		EmptyTrack, BuildTrack, TargetTrack;
	local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

	History = `XCOMHISTORY;
	context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
	InteractingUnitRef = context.InputContext.SourceObject;
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
	SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Alien);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
	PlayAnimationAction.Params.AnimName = 'HL_WarCry';
	PlayAnimationAction.bFinishAnimationWait = true;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.GetX2Effect().EffectName == class'X2Effect_ASA_WarCry'.default.EffectName)
		{
			TargetTrack = EmptyTrack;
			UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			if ((UnitState != none) && (EffectState.StatChanges.Length > 0))
			{
				TargetTrack.StateObject_NewState = UnitState;
				TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
				TargetTrack.VisualizeActor = UnitState.GetVisualizer();
				SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
				SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Alien);
			}
		}
	}

}