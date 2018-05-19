modifier_item_2025_damage = class({})

local public = modifier_item_2025_damage

function public:IsHidden()
	return true
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end