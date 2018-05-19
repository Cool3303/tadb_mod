modifier_cooldown_reduce = class({})

local public = modifier_cooldown_reduce

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
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

function public:GetModifierPercentageCooldown()
	return self:GetStackCount()
end
