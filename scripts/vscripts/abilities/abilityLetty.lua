function OnLetty01SpellStart(keys)
	local caster = keys.caster
	local targetPoint = keys.target_points[1]

	if caster.thtd_letty_01_strom_count == nil then
		caster.thtd_letty_01_strom_count = 2
	end

	local count_effect = caster.thtd_letty_01_strom_count
	local count = caster.thtd_letty_01_strom_count
	
	caster:SetContextThink(DoUniqueString("thtd_letty01_spell_start_effect"), 
		function()
			for i=1,20 do
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/letty/ability_letty_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, targetPoint + Vector(math.cos(math.pi/4*i),math.sin(math.pi/4*i),0)*200 + RandomVector(100))
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end
			count_effect = count_effect - 1
			caster:EmitSound("Sound_THTD.thtd_letty_01")
			if count_effect > 0 then
				return 1.0
			else
				return nil
			end
		end,
	0)

	caster:SetContextThink(DoUniqueString("thtd_letty01_spell_start"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetPower(), 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
			end

			count = count - 1
			if count > 0 then
				return 1.0
			else
				return nil
			end
		end, 
	0)
end