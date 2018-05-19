modifier_move_max_speed = class({})

local public = modifier_move_max_speed

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_MOVESPEED_MAX,
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

function public:GetModifierMoveSpeed_Max()
	return 10000
end
