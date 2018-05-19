modifier_item_2010_magical_penetration_effect = class({})

local public = modifier_item_2010_magical_penetration_effect

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
		ModifyMagicalDamageIncomingPercentage(target,10,nil)
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local target = self:GetParent()
		ModifyMagicalDamageIncomingPercentage(target,-10,nil)
	end
end