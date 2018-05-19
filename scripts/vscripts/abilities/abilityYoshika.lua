function OnYoshika01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)

	for k,v in pairs(targets) do
		local count = 0
		local debuff_count = 1
		if caster:HasModifier("modifier_miko_02_buff") then
			debuff_count = 2
		end
		v.thtd_poison_buff = v.thtd_poison_buff + debuff_count
		v:SetContextThink(DoUniqueString("thtd_yoshika01_debuff"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if count > 25 then 
					v.thtd_poison_buff = v.thtd_poison_buff - debuff_count
					return nil 
				end
				count = count + 1
				local damage = caster:THTD_GetStar() * caster:THTD_GetPower() / 5

				local DamageTable = {
						ability = keys.ability,
				        victim = v, 
				        attacker = caster, 
				        damage = damage, 
				        damage_type = keys.ability:GetAbilityDamageType(), 
				        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
				return 0.2
			end, 
		0.2)

	   	local modifier = caster:FindModifierByName("modifier_yoshika_01_slow")
	   	if modifier==nil then
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_yoshika_01_slow", nil)
		else
			modifier:SetDuration(5.0,false)
		end
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yoshika/ability_yoshika_01.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	
end

function OnYoshika02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local inners = THTD_FindUnitsInner(caster)

	for k,v in pairs(inners) do
		if v.thtd_poison_buff ~= nil and v.thtd_poison_buff > 0 then
			local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * v.thtd_poison_buff * 0.5

			local DamageTable = {
					ability = keys.ability,
			        victim = v, 
			        attacker = caster, 
			        damage = damage, 
			        damage_type = keys.ability:GetAbilityDamageType(), 
			        damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yoshika/ability_yoshika_02.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	end
end