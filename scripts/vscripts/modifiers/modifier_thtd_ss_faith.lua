modifier_thtd_ss_faith = class({})

local public = modifier_thtd_ss_faith

function public:IsHidden()
	return false
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end
