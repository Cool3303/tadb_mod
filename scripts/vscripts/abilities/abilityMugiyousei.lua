function OnMugiyousei01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower()
	local count = 0

	target.thtd_poison_buff = target.thtd_poison_buff + 1
	target:SetContextThink(DoUniqueString("thtd_mugiyousei01_attack"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if count > 5 then 
				target.thtd_poison_buff = target.thtd_poison_buff - 1
				return nil 
			end
			count = count + 1
			local DamageTable = {
		   			ability = keys.ability,
		            victim = target, 
		            attacker = caster, 
		            damage = damage, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
			return 1.0
		end, 
	1.0)
end