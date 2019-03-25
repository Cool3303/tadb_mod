function OnKogasa01SpellStart(keys)
	local caster = keys.caster
	local targetPoint = keys.target_points[1]
	local count = 5

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)

	caster:EmitSound("Sound_THTD.thtd_kogasa_01")
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
	for k,v in pairs(targets) do
		local DamageTable = {
   			ability = keys.ability,
            victim = v, 
            attacker = caster, 
            damage = damage, 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	if caster:HasModifier("modifier_byakuren_03_buff") then
	   		DamageTable.damage = damage * 2
	   	end
		UnitDamageTarget(DamageTable)
		   
		local modifier = v:FindModifierByName("modifier_kogasa_upgrade_debuff")
		if modifier==nil then		
			modifier = v:FindModifierByName("modifier_kogasa_debuff")
		end
		if modifier==nil then			
			if caster:HasModifier("modifier_byakuren_03_buff") then
				keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_kogasa_upgrade_debuff", nil)
			else
				keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_kogasa_debuff", nil)
			end
		else
			modifier:SetDuration(5.0,false)
		end		
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/kogasa/ability_kogasa_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end