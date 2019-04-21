modifier_touhoutd_luck = class({})

local public = modifier_touhoutd_luck

-- 增伤与设定的数据极为不符，改为自己处理
-- local m_modifier_funcs=
-- {
-- 	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
-- }

function public:IsHidden()
	return false
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end

function public:GetTexture()
	return "touhoutd/thtd_mokou_03"
end

-- 待增加创建时的特效

-- function public:DeclareFunctions()
-- 	return m_modifier_funcs
-- end

-- function public:GetModifierDamageOutgoing_Percentage()
-- 	return self:GetStackCount()
-- end