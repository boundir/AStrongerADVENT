//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_ASA_Archon extends X2Ability_Archon config(GameData_SoldierSkills);

var config int STAFFCONTROL_AIM;
var config int BLAZING_PINIONS_PANIC_INCREASE_PER_HP_LOST;
var config int BLAZING_PINIONS_PANIC_BASE_CHANCE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateStaffControl());
	Templates.AddItem(PurePassive('BlazingPinionsPanicPassive', "img:///UILibrary_DLC2Images.UIPerk_beserker_faithbreaker"));

	return Templates;
}

static function X2AbilityTemplate CreateStaffControl()
{
	local X2AbilityTemplate Template;
	local X2Effect_ToHitModifier HitModEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'StaffControl');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Success, default.STAFFCONTROL_AIM, Template.LocFriendlyName, , true, false, true, true);
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.EffectName = 'StaffcontrolAim';
	Template.AddTargetEffect(HitModEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

function name BlazingPinionsPanicApplyChance(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	//  this mimics the panic hit roll without actually BEING the panic hit roll
	local XComGameState_Unit TargetUnit;
	local name ImmuneName;
	local float MaxHealth, CurrentHealth, HealthLost;
	local int TargetRoll, RandRoll;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		foreach class'X2AbilityToHitCalc_PanicCheck'.default.PanicImmunityAbilities(ImmuneName)
		{
			if (TargetUnit.FindAbility(ImmuneName).ObjectID != 0)
			{
				return 'AA_UnitIsImmune';
			}
		}
		
		MaxHealth = TargetUnit.GetMaxStat(eStat_HP);
		CurrentHealth = TargetUnit.GetCurrentStat(eStat_HP);
		HealthLost = MaxHealth - CurrentHealth;

		TargetRoll = default.BLAZING_PINIONS_PANIC_BASE_CHANCE + HealthLost * default.BLAZING_PINIONS_PANIC_INCREASE_PER_HP_LOST;
		RandRoll = `SYNC_RAND(100);
		if (RandRoll < TargetRoll)
		{
			return 'AA_Success';
		}
	}

	return 'AA_EffectChanceFailed';
}

static function BlazingPinionsPanic_PanickedVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState == none)
	{
		return;
	}

	if (!UnitState.IsCivilian() && EffectApplyResult != 'AA_Success')
	{
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), class'X2Effect_Panicked'.default.EffectFailedFriendlyName, '', eColor_Good, class'UIUtilities_Image'.const.UnitStatus_Panicked);
	}
}