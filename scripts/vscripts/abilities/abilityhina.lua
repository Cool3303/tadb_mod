function OnHina01Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster:FindAbilityByName("thtd_hina_02"):GetLevel() < 1 then return end

	local targets = THTD_FindUnitsInRadius(caster,caster:GetAbsOrigin(),1200)
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 4	
	for k,v in pairs(targets) do		
		if v~=nil and v:IsNull()==false and v:IsAlive() then			
			local DamageTable = {
				ability = keys.ability,
				victim = v, 
				attacker = caster, 
				damage = damage, 
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = DOTA_DAMAGE_FLAG_NONE
			}							
			UnitDamageTarget(DamageTable)				
		end
	end
end
