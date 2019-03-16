function OnYuugi01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)

	for k,v in pairs(targets) do
		local damage_table = {
			victim = v,
			attacker = caster,
			damage = caster:THTD_GetPower()*caster:THTD_GetStar()*RandomInt(math.min(5,#targets),math.max(15,#targets)),
			ability = keys.ability,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		UnitDamageTarget(damage_table)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuugi/ability_yuugi_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(1000,1000,1000))
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnYuugi02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if RandomInt(0,100) < 30 then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuugi/ability_yuugi_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)

	 	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),250)
	 	for k,v in pairs(targets) do
	 		local damage_table = {
				victim = v,
				attacker = caster,
				damage = caster:THTD_GetPower()*caster:THTD_GetStar()*2,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
			}
			UnitDamageTarget(damage_table)
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_yuugi_02_pause_unit", {Duration = 0.48})
	 		OnYuugi02KnockBack(v,(v:GetAbsOrigin()-target:GetAbsOrigin()):Normalized())
	 	end
	end
end

function OnYuugi02KnockBack(target,forward)
	local time = 0.48
	target:SetContextThink(DoUniqueString("ability_yuugi_02_knockback"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time <= 0 then
				FindClearSpaceForUnit(target, target:GetOrigin(), false)
				return nil
			end
			target:SetAbsOrigin(target:GetOrigin()+forward*10)
			time = time - 0.03
			return 0.03
		end,
	0.03)
end

function OnYuugi03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,500)

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/yugi/yugi_slam.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	for k,v in pairs(targets) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_yuugi_03_pause_unit", {Duration = 2.0})

		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuggi/ability_yuugi_03.vpcf", PATTACH_CUSTOMORIGIN, v)
		ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
		ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)

		local time = 2.0
		local vOrigin = v:GetOrigin()

		v:SetContextThink(DoUniqueString("ability_yuugi_03_stop_move"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if GetDistanceBetweenTwoVec2D(v:GetOrigin(), vOrigin) > 100 then
					local damage_table = {
						victim = v,
						attacker = caster,
						damage = caster:THTD_GetPower()*caster:THTD_GetStar()*20,
						ability = keys.ability,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
					}
					UnitDamageTarget(damage_table)
					return nil
				end
				if time <= 0 then
					return nil
				end
				time = time - 0.03
				return 0.03
			end,
		0.03)
	end
end