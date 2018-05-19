function OnHourainingyou01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local count = 0

	local seed = RandomInt(1,100)
	if seed >= 40 then
		local DamageTable = {
	   			ability = keys.ability,
	            victim = target, 
	            attacker = caster, 
	            damage = caster:THTD_GetStar() * caster:THTD_GetPower(), 
	            damage_type = keys.ability:GetAbilityDamageType(), 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)

		if target.thtd_is_lock_hourainingyou_01_stun ~= true then
			target.thtd_is_lock_hourainingyou_01_stun = true
		   	UnitStunTarget(caster,target,0.5)
		   	target:SetContextThink(DoUniqueString("ability_hourainingyou_01"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					target.thtd_is_lock_hourainingyou_01_stun = false
					return nil
				end,
			2.0)
		end
	end
end