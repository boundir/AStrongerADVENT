//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ASA_ShadowbindTarget extends X2Action_Death;

function Init()
{
	super.Init();

	UnitPawn.AimEnabled = false;
	UnitPawn.AimOffset.X = 0;
	UnitPawn.AimOffset.Y = 0;
}

static function bool AllowOverrideActionDeath(VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	local XComGameStateContext_Ability ShadowbindContext;

	ShadowbindContext = XComGameStateContext_Ability(Context);

	if( ShadowbindContext != none && ShadowbindContext.InputContext.AbilityTemplateName == 'ShadowbindM4' )
	{
		return true;
	}

	return false;
}

simulated function Name ComputeAnimationToPlay()
{
	return 'HL_ShadowbindM4_Target';
}