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
		   
		if not target:HasModifier("thtd_hourainingyou_01_lock") then 
			keys.ability:ApplyDataDrivenModifier(caster, target, "thtd_hourainingyou_01_lock", {Duration = 2.0})	
		   	UnitStunTarget(caster,target,0.5)		   
		end
	end
end