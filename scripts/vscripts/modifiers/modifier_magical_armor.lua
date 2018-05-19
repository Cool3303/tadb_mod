modifier_magical_armor = class({})

local public = modifier_magical_armor

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
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

function public:GetModifierMagicalResistanceBonus()
	return self:GetStackCount()/2*5
end
