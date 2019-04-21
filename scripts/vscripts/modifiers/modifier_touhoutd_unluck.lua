modifier_touhoutd_unluck = class({})

local public = modifier_touhoutd_unluck

function public:IsHidden()
	return false
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end

-- function public:GetTexture()
-- 	return "touhoutd/thtd_mokou_03"
-- end