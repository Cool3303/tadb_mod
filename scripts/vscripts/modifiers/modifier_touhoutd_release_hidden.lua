modifier_touhoutd_release_hidden = class({})

local public = modifier_touhoutd_release_hidden

local m_modifier_states = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
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