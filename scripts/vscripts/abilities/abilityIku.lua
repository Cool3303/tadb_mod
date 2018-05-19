function OnIku01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()
	local damage = 50 * 2^caster:THTD_GetStar()

	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_iku_01_stun_duration == nil then
		caster.thtd_iku_01_stun_duration = 0.5
	end

	if caster.thtd_iku_01_attack_count == nil then
		caster.thtd_iku_01_attack_count = 0
	end

	caster.thtd_iku_01_attack_count = caster.thtd_iku_01_attack_count + 1

	if caster.thtd_iku_01_attack_count >= 8 then
		caster.thtd_iku_01_attack_count = 0
		caster:EmitSound("Sound_THTD.thtd_iku_01")
		
		local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)
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
		   	if v.thtd_is_lock_iku_01_stun ~= true then
				v.thtd_is_lock_iku_01_stun = true
		   		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_iku_01_debuff", {Duration = caster.thtd_iku_01_stun_duration})
	   			v:SetContextThink(DoUniqueString("ability_item_iku_01_stun"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						v.thtd_is_lock_iku_01_stun = false
						return nil
					end,
				1.5)
	   		end
		end

		local effectIndex = ParticleManager:CreateParticle("particles/heroes/iku/ability_iku_01_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end

function OnIku02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local count = 0

	Iku02CreateEffect(keys)
	caster:EmitSound("Sound_THTD.thtd_iku_02")

	caster:SetContextThink(DoUniqueString("thtd_iku02_lightning"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if count > 60 then return nil end
			count = count + 1
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)
			
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetStar()*caster:THTD_GetPower()*0.15, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
			end
			return 0.05
		end, 
	0)
end

function Iku02CreateEffect(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local vec = caster:GetOrigin() + 700*caster:GetForwardVector() + Vector(0,0,128)

	local particle = ParticleManager:CreateParticle("particles/thd2/heroes/iku/ability_iku_04_light_b.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(particle,0,vec)
	ParticleManager:SetParticleControlForward(particle,0,caster:GetForwardVector())
	ParticleManager:SetParticleControl(particle,2,vec)
	ParticleManager:SetParticleControl(particle,3,vec)
	ParticleManager:SetParticleControl(particle,4,-caster:GetForwardVector())
	ParticleManager:SetParticleControl(particle,5,-caster:GetForwardVector())

	ParticleManager:DestroyParticleSystemTime(particle,3.0)

	particle = ParticleManager:CreateParticle("particles/thd2/heroes/iku/ability_iku_04_model.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(particle,0,caster:GetOrigin()+caster:GetForwardVector()*350 + Vector(0,0,128))
	ParticleManager:SetParticleControlForward(particle,0,caster:GetForwardVector())
	
	ParticleManager:DestroyParticleSystemTime(particle,3.0)
end