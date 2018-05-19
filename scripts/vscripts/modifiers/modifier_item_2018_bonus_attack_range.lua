modifier_item_2018_bonus_attack_range = class({})

local public = modifier_item_2018_bonus_attack_range

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}

function public:IsHidden()
	return true
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end

function public:DeclareFunctions()
	return m_modifier_funcs
end

function public:GetModifierAttackRangeBonus()
	return 200
end
