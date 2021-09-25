//--------------------------------------------------------------------------------------- 
//  FILE:         X2Effect_ASA_Beastmaster.uc
//  AUTHOR:       John Lumpkin (Pavonis Interactive)
//  MODIFICATION: Boundir
//  PURPOSE:      Creates Beastmaster effect, which makes Centurions immune to damage from Berserkers
//--------------------------------------------------------------------------------------- 
class X2Effect_ASA_Beastmaster extends X2Effect_BonusArmor config(GameData_SoldierSkills);

var config array<name> BEASTMASTER_INCLUDE_GROUP;

function int GetDefendingDamageModifier (XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int	DamageMod;

	DamageMod = 0;

	if(default.BEASTMASTER_INCLUDE_UNIT.Find(Attacker.GetMyTemplate().CharacterGroupName) != INDEX_NON)
	{
		DamageMod = -CurrentDamage;
	}

	return DamageMod;
}

