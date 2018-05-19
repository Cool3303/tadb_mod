modifier_item_2013_physical_damage_aura_effect = class({})

local public = modifier_item_2013_physical_damage_aura_effect

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
			ModifyPhysicalDamageOutgoingPercentage(target,10,nil)
		end
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local target = self:GetParent()
		if target:THTD_IsTower() then
			ModifyPhysicalDamageOutgoingPercentage(target,-10,nil)
		end
	end
end