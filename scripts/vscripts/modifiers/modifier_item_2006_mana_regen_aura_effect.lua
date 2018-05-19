modifier_item_2006_mana_regen_aura_effect = class({})

local public = modifier_item_2006_mana_regen_aura_effect

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:OnCreated(kv)
	if IsServer() then
		local target = self:GetParent()
		if target:THTD_IsTower() then
			target.thtd_mana_regen_percentage = target.thtd_mana_regen_percentage + 20
		end
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local target = self:GetParent()
		if target:THTD_IsTower() then
			target.thtd_mana_regen_percentage = target.thtd_mana_regen_percentage - 20
		end
	end
end