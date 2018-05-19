modifier_item_2008_slow_aura_effect = class({})

local public = modifier_item_2008_slow_aura_effect

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

--------------------------------------------------------------------------------

function public:GetModifierMoveSpeedBonus_Percentage()
	return -10
end

--------------------------------------------------------------------------------