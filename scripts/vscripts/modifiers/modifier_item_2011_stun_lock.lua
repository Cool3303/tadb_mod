modifier_item_2011_stun_lock = class({})

local public = modifier_item_2011_stun_lock

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
	return "item_2011"
end