modifier_attack_speed = class({})

local public = modifier_attack_speed

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
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

function public:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end
