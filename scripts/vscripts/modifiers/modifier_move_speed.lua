modifier_move_speed = class({})

local public = modifier_move_speed

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
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

function public:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end
