modifier_item_2011_attack_stun = class({})

local public = modifier_item_2011_attack_stun

local m_modifier_funcs = {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}

function public:IsHidden()
	return true
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end

function public:DeclareFunctions()
	return m_modifier_funcs
end

function public:OnAttackLanded(kv)
	if IsServer() then
		if RandomInt(0,100) < 10 then
			local caster = self:GetCaster()
			local target = kv.target
			
			if not target:HasModifier("modifier_item_2011_stun_lock") then
				target:AddNewModifier(target, nil, "modifier_item_2011_stun_lock", {Duration=2.0})
			   	UnitStunTarget(caster,target,1.0)			
	   		end			
		end
	end
end