modifier_touhoutd_pause = class({})

local public = modifier_touhoutd_pause

local m_modifier_states = {
	[MODIFIER_STATE_STUNNED] = true,
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

function public:CheckState()
	return m_modifier_states
end
