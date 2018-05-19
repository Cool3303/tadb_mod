modifier_thtd_ss_kill = class({})

local public = modifier_thtd_ss_kill

function public:IsHidden()
	return true
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end
