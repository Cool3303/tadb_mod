modifier_item_2026_damage = class({})

local public = modifier_item_2026_damage

function public:IsHidden()
	return true
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end