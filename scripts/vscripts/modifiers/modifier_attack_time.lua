modifier_attack_time = class({})

local public = modifier_attack_time

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
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

function public:GetModifierBaseAttackTimeConstant()
	return self:GetStackCount()*0.1
end
