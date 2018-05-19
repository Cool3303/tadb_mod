modifier_item_2005_attack_aura_effect = class({})

local public = modifier_item_2005_attack_aura_effect

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
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

--------------------------------------------------------------------------------

function public:GetModifierBaseDamageOutgoing_Percentage()
	return 50
end

--------------------------------------------------------------------------------