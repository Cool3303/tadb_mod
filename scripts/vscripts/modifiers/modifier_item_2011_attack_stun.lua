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
			
			if target.thtd_is_lock_item_2011_stun ~= true then
				target.thtd_is_lock_item_2011_stun = true
	   			UnitStunTarget(caster,target,1.0)
	   			target:SetContextThink(DoUniqueString("ability_item_2011_stun"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						target.thtd_is_lock_item_2011_stun = false
						return nil
					end,
				2.0)
	   		end
		end
	end
end