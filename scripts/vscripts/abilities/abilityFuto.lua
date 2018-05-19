function OnFuto01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_futo_01_effct_index == nil then
		caster.thtd_futo_01_effct_index = 1
	end

	if caster.thtd_futo_01_effct_index == 1 then
		local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * ( 1 + GetFuto02Buff(caster)*0.1)
		local targets = 
			FindUnitsInLine(
				caster:GetTeamNumber(), 
				target:GetOrigin(), 
				target:GetOrigin() + 800 * -target:GetForwardVector(), 
				nil, 
				200,
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
		end
	elseif caster.thtd_futo_01_effct_index == 2 then
		if caster.__foto_lock ~= true then 
			caster.__foto_lock = true
			local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1200)

			for i=1,#targets do
				local unit = targets[i]
				if unit~=nil and unit:IsNull()==false and unit~=target and unit:IsAlive() then
					caster:PerformAttack(unit,false,false,false,false,true,false,false)
					local DamageTable = {
				   			ability = keys.ability,
				            victim = unit, 
				            attacker = caster, 
				            damage = caster:THTD_GetStar() * caster:THTD_GetPower() * ( 1 + GetFuto02Buff(caster)*0.1), 
				            damage_type = keys.ability:GetAbilityDamageType(), 
				            damage_flags = DOTA_DAMAGE_FLAG_NONE
				   	}
				   	UnitDamageTarget(DamageTable)
				end
			end
			caster.__foto_lock = false
		end
	elseif caster.thtd_futo_01_effct_index == 3 then
		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)

		for k,v in pairs(targets) do
			local count = 10
			v.thtd_poison_buff = v.thtd_poison_buff + 1
			v:SetContextThink(DoUniqueString("thtd_futo_01_damage_think"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					if count <= 0 then 
						v.thtd_poison_buff = v.thtd_poison_buff - 1
						return nil 
					end
					count = count - 1
					local targets = THTD_FindUnitsInRadius(caster,v:GetOrigin(),300)
					local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5 * ( 1 + GetFuto02Buff(caster)*0.1)
					local DamageTable = {
				   			ability = keys.ability,
				            victim = v, 
				            attacker = caster, 
				            damage = damage, 
				            damage_type = keys.ability:GetAbilityDamageType(), 
				            damage_flags = DOTA_DAMAGE_FLAG_NONE
				   	}
				   	UnitDamageTarget(DamageTable)
					return 0.3
				end, 
			0.3)
		end
	elseif caster.thtd_futo_01_effct_index == 4 then
		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)
		local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 4 * ( 1 + GetFuto02Buff(caster)*0.1)
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

	   	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_futo/ability_thtd_futo_01_fire.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	elseif caster.thtd_futo_01_effct_index == 5 then
		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)
		for k,v in pairs(targets) do
			if v.thtd_is_lock_futo_01_stun ~= true then
				v.thtd_is_lock_futo_01_stun = true
				UnitStunTarget(caster,v,0.5)
	   			v:SetContextThink(DoUniqueString("ability_item_futo_01_stun"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						v.thtd_is_lock_futo_01_stun = false
						return nil
					end,
				1.0)
	   		end
		end
	elseif caster.thtd_futo_01_effct_index == 6 then
		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)
		local damage = keys.attack_damage * 32.0 * ( 1 + GetFuto02Buff(caster)*0.1)
	   	
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
			SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL, v, damage, caster:GetPlayerOwner() )
		end
	end

	caster.thtd_futo_01_effct_index = RandomInt(1,6)
	caster:SetRangedProjectileName("particles/heroes/thtd_futo/ability_futo_base_attack_"..caster.thtd_futo_01_effct_index..".vpcf")
end

function OnFuto02Kill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_futo_02_buff_max_count == nil then
		caster.thtd_futo_02_buff_max_count = 10
	end

	local modifier = caster:FindModifierByName("modifier_futo_02_buff")
	if modifier==nil then
		modifier = keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_futo_02_buff", {Duration = 10.0})
		modifier:SetStackCount(1)
	else
		if modifier:GetStackCount() < caster.thtd_futo_02_buff_max_count then
			modifier:SetStackCount(modifier:GetStackCount()+1)
		end
		modifier:SetDuration(10.0,false)
	end
end

function GetFuto02Buff(caster)
	local modifier = caster:FindModifierByName("modifier_futo_02_buff")
	if modifier~=nil then
		return modifier:GetStackCount()
	end
	return 0
end

function OnFuto03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_futo/ability_thtd_futo_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local count = 40
	caster:SetContextThink(DoUniqueString("thtd_futo_03_spell_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if count <= 0 then return nil end
			count = count - 1
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,500)
			for k,v in pairs(targets) do
				local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.25 * ( 1 + GetFuto02Buff(caster)*0.1)
				if caster:HasModifier("modifier_miko_02_buff") then
					damage = damage * 1.25
				end
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
			return 0.1
		end, 
	0.1)
end