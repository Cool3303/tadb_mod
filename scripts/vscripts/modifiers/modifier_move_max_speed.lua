modifier_move_max_speed = class({})

local public = modifier_move_max_speed

local m_modifier_funcs=
{
	-- MODIFIER_PROPERTY_MOVESPEED_MAX,  -- 7.20失效
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
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

function public:GetModifierMoveSpeed_AbsoluteMax()
	return 10000
end

function public:GetModifierMoveSpeed_Absolute()
	local caster = self:GetCaster()
	return caster:GetBaseMoveSpeed()
end
