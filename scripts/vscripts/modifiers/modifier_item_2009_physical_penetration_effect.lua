modifier_item_2009_physical_penetration_effect = class({})

local public = modifier_item_2009_physical_penetration_effect

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
		ModifyPhysicalDamageIncomingPercentage(target,10,nil)
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local target = self:GetParent()
		ModifyPhysicalDamageIncomingPercentage(target,-10,nil)
	end
end