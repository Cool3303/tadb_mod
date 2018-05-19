function OnYoumu01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_youmu_01_attack_count == nil then
		caster.thtd_youmu_01_attack_count = 0
	end

	if caster.thtd_youmu_01_chance == nil then
		caster.thtd_youmu_01_chance = 30
	end

	caster:SetMana(caster:GetMana()+1)

	caster.thtd_youmu_01_attack_count = caster.thtd_youmu_01_attack_count + 1

	if caster.thtd_youmu_01_attack_count >= 8 then
		caster.thtd_youmu_01_attack_count = 0
		caster:EmitSound("Hero_Magnataur.ShockWave.Particle")

		local targetPoint = caster:GetOrigin() + caster:GetForwardVector() * 1000
		Youmu01Damage(keys,targetPoint,caster:GetOrigin())

		if caster:FindAbilityByName("thtd_youmu_02") ~= nil and RandomInt(0,100) < caster.thtd_youmu_01_chance then
			local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/youmu/youmu_01_blink_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
			ParticleManager:SetParticleControlForward(effectIndex, 0 , target:GetForwardVector())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			targetPoint = target:GetOrigin() - target:GetForwardVector() * 1000
			Youmu01Damage(keys,targetPoint,target:GetOrigin())
		end
	end
end

function Youmu01Damage(keys,targetPoint,vecCaster)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 2

	local targets = 
		FindUnitsInLine(
			caster:GetTeamNumber(), 
			caster:GetOrigin(), 
			targetPoint, 
			nil, 
			360,
			keys.ability:GetAbilityTargetTeam(), 
			keys.ability:GetAbilityTargetType(), 
			keys.ability:GetAbilityTargetFlags()
		)
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
	   	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/youmu/youmu_01_blink_effect_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_youmu/ability_youmu_01_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, vecCaster+Vector(0,0,32))
	ParticleManager:SetParticleControl(effectIndex, 1, targetPoint+Vector(0,0,32))
	ParticleManager:SetParticleControl(effectIndex, 9, vecCaster+Vector(0,0,32))
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnYoumu03Damage(keys,targetPoint,vecCaster)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/youmu/youmu_04_circle.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local rad = 210*math.pi/180

	local count = 0

	caster:EmitSound("Sound_THTD.thtd_youmu_01")

	caster:SetContextThink(DoUniqueString("thtd_youmu_03_spell_start"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			rad = rad + 210*math.pi/180
			local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/youmu/youmu_04_sword_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
			local effect2VecForward = Vector(targetPoint.x+math.cos(rad)*500,targetPoint.y+math.sin(rad)*500,vecCaster.z)
			ParticleManager:SetParticleControl(effectIndex, 0, vecCaster)
			ParticleManager:SetParticleControl(effectIndex, 1, effect2VecForward)
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			vecCaster = effect2VecForward

			local damage = caster:THTD_GetPower() * caster:THTD_GetStar() / 10 * 4

			local targets = THTD_FindUnitsInRadius(caster,targetPoint,550)

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

				if count%5 == 0 then
				   	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/youmu/youmu_02_effect_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(effectIndex2, 0, v:GetOrigin())
					ParticleManager:DestroyParticleSystem(effectIndex2,false)
				end
			end

			if count>20 then
				return nil
			end
			count = count + 1
			return 0.12
		end, 
	0)
end

function OnYoumu03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = keys.target_points[1]

	if caster.thtd_youmu_01_chance == nil then
		caster.thtd_youmu_01_chance = 30
	end

	OnYoumu03Damage(keys,targetPoint,vecCaster)

	if caster:FindAbilityByName("thtd_youmu_02") ~= nil and RandomInt(0,100) < caster.thtd_youmu_01_chance then
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/youmu/youmu_01_blink_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin() + RandomVector(300))
		ParticleManager:SetParticleControlForward(effectIndex, 0 , caster:GetForwardVector())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		targetPoint = targetPoint + RandomVector(150)
		OnYoumu03Damage(keys,targetPoint,vecCaster)
	end
end