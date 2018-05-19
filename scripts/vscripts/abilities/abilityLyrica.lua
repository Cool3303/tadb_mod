
-- 敏捷 * 星级 * (1+音符数*0.5) * 1.5
-- 余震伤害
-- 敏捷 * 星级 * (1+音符数*0.5) * 1.5
-- 每个音符对应触发一次效果

function OnLyrica01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_lyrica_increase_damage == nil then
		caster.thtd_lyrica_increase_damage = 1.0
	end

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)

	for k,v in pairs(targets) do
		local DamageTable = {
				ability = keys.ability,
		        victim = v, 
		        attacker = caster, 
		        damage = caster:THTD_GetStar() * caster:THTD_GetPower(), 
		        damage_type = keys.ability:GetAbilityDamageType(), 
		        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	if v.thtd_prismriver_01_comboName == nil then
			v.thtd_prismriver_01_comboName = ""
			v.thtd_prismriver_01_comboCount = 0
		end

		v.thtd_prismriver_01_comboName = v.thtd_prismriver_01_comboName.."lyrica"
		v.thtd_prismriver_01_comboCount = v.thtd_prismriver_01_comboCount + 1

		if v.thtd_prismriver_01_comboCount >= 3 then
			if v.thtd_prismriver_01_comboName == "merlinlunasalyrica" then
				OnMerlinLunasaLyrica(keys,caster,v)
			elseif v.thtd_prismriver_01_comboName == "lunasamerlinlyrica" then
				OnLunasaMerlinLyrica(keys,caster,v)
			end
			v.thtd_prismriver_01_comboName = ""
			v.thtd_prismriver_01_comboCount = 0
		end

	   	UnitDamageTarget(DamageTable)
	end
	
	caster:EmitSound("Sound_THTD.thtd_lyrica_01")

	if caster:FindAbilityByName("thtd_lyrica_02"):GetLevel() >= 1 then
		for k,v in pairs(targets) do
			local damage = caster:THTD_GetStar() * caster:THTD_GetPower()
			local damageincrease = 1

			if v:HasModifier("modifier_lunasa_01_debuff") then
				damageincrease = damageincrease + 0.5
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/lunasa/ability_lunasa_music_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end

			if v:HasModifier("modifier_merlin_01_debuff") then
				damageincrease = damageincrease + 0.5
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/merlin/ability_merlin_music_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end

			damage = damage * damageincrease * caster.thtd_lyrica_increase_damage

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

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lyrica/ability_lyrica_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnMerlinLunasaLyrica(keys,caster,target)
	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower()

	for k,v in pairs(targets) do
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
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lyrica/ability_lyrica_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnLunasaMerlinLyrica(keys,caster,target)
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 4.

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}

   	UnitDamageTarget(DamageTable)
end