function OnMedicine01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if keys.ability:GetLevel() < 1 then return end
	
	local modifier = target:FindModifierByName("modifier_medicine_01_slow")
	if modifier == nil then
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_medicine_01_slow", {Duration = 5.0})
		
		local time = 5.0
		target.thtd_poison_buff = target.thtd_poison_buff + 1
		target:SetContextThink(DoUniqueString("thtd_medicine01_debuff"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if time <= 0 then 
					target.thtd_poison_buff = target.thtd_poison_buff - 1
					return nil 
				end
				
				local damage = caster:THTD_GetStar() * caster:THTD_GetPower() / 2
				local DamageTable = {
					ability = keys.ability,
					victim = target, 
					attacker = caster, 
					damage = damage, 
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
				UnitDamageTarget(DamageTable)
				time = time - 0.5
				return 0.5
			end, 
		0)

		if target.thtd_is_fearing ~= true then			
			target.thtd_is_fearing = true
			local current_next_move_point = target.next_move_point
			local current_next_move_forward = target.next_move_forward		
			target.next_move_point = RotatePosition(target:GetOrigin(), QAngle(0,RandomInt(-70, 70),0), target:GetOrigin() - target:GetForwardVector() * 500)
			target:SetContextThink(DoUniqueString("modifier_medicine_01_debuff"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					target.next_move_point = current_next_move_point
					target.next_move_forward = current_next_move_forward					
					target.thtd_is_fearing = false
					return nil
				end, 
			1.0)
		end
	else
		modifier:SetDuration(10.0,false)
	end
end

function OnMedicine02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	caster.thtd_last_cast_point = targetPoint	
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_medicine/ability_medicine_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local time = 1.5
	caster:SetContextThink(DoUniqueString("modifier_medicine_02_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time <= 0 then return nil end

			local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 1.25
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,400)			
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

				if v.thtd_is_fearing ~= true then
					v.thtd_is_fearing = true

					v.thtd_poison_buff = v.thtd_poison_buff + 1
					local current_next_move_point = v.next_move_point
					local current_next_move_forward = v.next_move_forward

					v.next_move_point = targetPoint	

					v:SetContextThink(DoUniqueString("modifier_medicine_02_debuff"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							v.next_move_point = current_next_move_point
							v.next_move_forward = current_next_move_forward							
							v.thtd_is_fearing = false
							v.thtd_poison_buff = v.thtd_poison_buff - 1
							return nil
						end, 
					time)
				end
			end

			time = time - 0.3
			return 0.3
		end,
	0)
end