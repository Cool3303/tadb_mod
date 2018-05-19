function OnByakuren01SpellStartUp(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_byakuren_01_attack_time == nil then
		caster.thtd_byakuren_01_attack_time = 1.0
	end

	if caster.thtd_byakuren_01_extra_damage == nil then
		caster.thtd_byakuren_01_extra_damage = 1.0
	end

	if caster.thtd_byakuren_01_attack_time > 0.21 then
		caster.thtd_byakuren_01_attack_time = caster.thtd_byakuren_01_attack_time - 0.1
		local modifier = caster:FindModifierByName("modifier_attack_time")
		if modifier ~= nil then
			modifier:SetStackCount(caster.thtd_byakuren_01_attack_time*10)
		else
			modifier = caster:AddNewModifier(caster, nil, "modifier_attack_time", {})
			modifier:SetStackCount(caster.thtd_byakuren_01_attack_time*10)
		end
		caster.thtd_byakuren_01_extra_damage = caster.thtd_byakuren_01_attack_time / 1.0
	end

	local ability = caster:FindAbilityByName("thtd_byakuren_04")
	if ability:GetLevel() > 0 then
		if caster.thtd_byakuren_01_attack_time > 1.0  then
			if caster:HasModifier("modifier_byakuren_04_magic_buff") == false then
				ability:ApplyDataDrivenModifier(caster,caster,"modifier_byakuren_04_magic_buff", nil)
			end
		elseif caster.thtd_byakuren_01_attack_time == 1.0 then
			if caster:HasModifier("modifier_byakuren_04_magic_buff") then
				caster:RemoveModifierByName("modifier_byakuren_04_magic_buff")
			end
		elseif caster.thtd_byakuren_01_attack_time < 1.0 then
			if caster:HasModifier("modifier_byakuren_04_magic_buff") then
				caster:RemoveModifierByName("modifier_byakuren_04_magic_buff")
			end
		end
	end
end

function OnByakuren01SpellStartDown(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_byakuren_01_attack_time == nil then
		caster.thtd_byakuren_01_attack_time = 1.0
	end

	if caster.thtd_byakuren_01_extra_damage == nil then
		caster.thtd_byakuren_01_extra_damage = 1.0
	end

	if caster.thtd_byakuren_01_attack_time < 1.8 then
		caster.thtd_byakuren_01_attack_time = caster.thtd_byakuren_01_attack_time + 0.1
		local modifier = caster:FindModifierByName("modifier_attack_time")
		if modifier ~= nil then
			modifier:SetStackCount(caster.thtd_byakuren_01_attack_time*10)
		else
			modifier = caster:AddNewModifier(caster, nil, "modifier_attack_time", {})
			modifier:SetStackCount(caster.thtd_byakuren_01_attack_time*10)
		end
		caster.thtd_byakuren_01_extra_damage = caster.thtd_byakuren_01_attack_time / 1.0
	end


	local ability = caster:FindAbilityByName("thtd_byakuren_04")
	if caster:FindAbilityByName("thtd_byakuren_04"):GetLevel() > 0 then
		if caster.thtd_byakuren_01_attack_time > 1.0  then
			if caster:HasModifier("modifier_byakuren_04_magic_buff") == false then
				ability:ApplyDataDrivenModifier(caster,caster,"modifier_byakuren_04_magic_buff", nil)
			end
		elseif caster.thtd_byakuren_01_attack_time == 1.0 then
			if caster:HasModifier("modifier_byakuren_04_magic_buff") then
				caster:RemoveModifierByName("modifier_byakuren_04_magic_buff")
			end
		elseif caster.thtd_byakuren_01_attack_time < 1.0 then
			if caster:HasModifier("modifier_byakuren_04_magic_buff") then
				caster:RemoveModifierByName("modifier_byakuren_04_magic_buff")
			end
		end
	end
end

function OnByakuren01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	
	if caster.thtd_byakuren_01_attack_time == nil then
		caster.thtd_byakuren_01_attack_time = 1.0
	end

	if caster.thtd_byakuren_01_extra_damage == nil then
		caster.thtd_byakuren_01_extra_damage = 1.0
	end


	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)
	local friends = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1500)

	for k,v in pairs(targets) do
		local damage_table = {
			victim = v,
			attacker = caster,
			damage = caster:THTD_GetPower()*caster:THTD_GetStar()*caster.thtd_byakuren_01_extra_damage*(1+GetStarLotusBuffedTowerCount(friends)*0.1),
			ability = keys.ability,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		if caster.thtd_byakuren_01_attack_time == 1.0 then
			damage_table.damage_type = DAMAGE_TYPE_PURE
		elseif caster.thtd_byakuren_01_attack_time > 1.0 then
			damage_table.damage_type = DAMAGE_TYPE_MAGICAL
		elseif caster.thtd_byakuren_01_attack_time < 1.0 then
			damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
		end
		UnitDamageTarget(damage_table)
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(particle,0,target:GetOrigin()+Vector(0,0,64))
	ParticleManager:DestroyParticleSystem(particle,false)
end

function OnByakuren03SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	if keys.ability:GetLevel() < 1 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1500)

	for k,v in pairs(targets) do
		if v:HasModifier("modifier_byakuren_03_buff") == false then
			if IsStarLotusTower(v) then
				if v.thtd_byakuren_03_religious_count == nil then
					v.thtd_byakuren_03_religious_count = 0
				end
				v.thtd_byakuren_03_religious_count = v.thtd_byakuren_03_religious_count + 1
				SendOverheadEventMessage(v:GetPlayerOwner(), OVERHEAD_ALERT_BONUS_POISON_DAMAGE, v, v.thtd_byakuren_03_religious_count, v:GetPlayerOwner() )
				if v.thtd_byakuren_03_religious_count > 6000 then
					keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_byakuren_03_buff", nil)
				end
			end
		end 
	end
end

local thtd_byakuren_04_point = 
{
	[1] = Vector(-340,-145,32),
	[2] = Vector(340,-145,32),
	[3] = Vector(-185,220,32),
	[4] = Vector(185,220,32),
}

function OnByakuren04AttackLanded(keys)
	if keys.ability:GetLevel() < 1 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_byakuren_01_attack_time == nil then
		caster.thtd_byakuren_01_attack_time = 1.0
	end

	if caster.thtd_byakuren_01_extra_damage == nil then
		caster.thtd_byakuren_01_extra_damage = 1.0
	end

	if caster.thtd_byakuren_01_attack_time > 1.0 then
		local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)
		local count = 1
		for k,v in pairs(targets) do
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_byakuren/ability_byakuren_04_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+thtd_byakuren_04_point[count])
			ParticleManager:SetParticleControl(effectIndex, 1, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 3, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 9, caster:GetOrigin()+thtd_byakuren_04_point[count])
			ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_byakuren/ability_byakuren_04_item.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+thtd_byakuren_04_point[count])
			ParticleManager:DestroyParticleSystemTime(effectIndex,1.0)

			local friends = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1500)
			local damage_table = {
				victim = v,
				attacker = caster,
				damage = caster:THTD_GetPower()*caster:THTD_GetStar()*caster.thtd_byakuren_01_extra_damage*(6+GetStarLotusBuffedTowerCount(friends)),
				ability = keys.ability,
				damage_type = DAMAGE_TYPE_MAGICAL, 
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
			}
			UnitDamageTarget(damage_table)

			count = count + 1
			if count > 4 then
				break
			end
		end
	end

	if caster.thtd_byakuren_01_attack_time == 1.0 then
		if caster.thtd_byakuren_04_attack_count == nil then
			caster.thtd_byakuren_04_attack_count = 0
		end
		local friends = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1500)
		caster.thtd_byakuren_04_attack_count = caster.thtd_byakuren_04_attack_count + 1
		if caster.thtd_byakuren_04_attack_count > 6 / (1 + GetStarLotusBuffedTowerCount(friends)*0.2) then
			caster.thtd_byakuren_04_attack_count = 0

			local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)
			for k,v in pairs(targets) do
				local damage_table = {
					victim = v,
					attacker = caster,
					damage = caster:THTD_GetPower()*caster:THTD_GetStar()*caster.thtd_byakuren_01_extra_damage*6,
					ability = keys.ability,
					damage_type = DAMAGE_TYPE_PURE, 
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
				}
				UnitDamageTarget(damage_table)
				local particle = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_02.vpcf",PATTACH_CUSTOMORIGIN,caster)
				ParticleManager:SetParticleControl(particle,0,v:GetOrigin())
				ParticleManager:SetParticleControl(particle,1,v:GetOrigin())
				ParticleManager:DestroyParticleSystem(particle,false)
			end
		end
	end

	if caster:HasModifier("modifier_byakuren_04_physical_buff") == false then
		local chance = RandomInt(0,100)
		if chance < 10 then
			if caster.thtd_byakuren_01_attack_time < 1.0 then
				if caster.thtd_byakuren_04_bonus_lock ~= true then
					local friends = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1500)
					local bonus = caster:THTD_GetPower() * GetStarLotusBuffedTowerCount(friends) * 0.2
					caster:THTD_AddPower(bonus)
					caster:THTD_AddAttack(bonus)
					caster.thtd_byakuren_04_bonus_lock = true

					caster:SetContextThink(DoUniqueString("thtd_byakuren_04_bonus_remove"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							caster:THTD_AddPower(-bonus)
							caster:THTD_AddAttack(-bonus)
							caster.thtd_byakuren_04_bonus_lock = false
						end,
					5.0)
				end

				local particle = ParticleManager:CreateParticle("particles/heroes/thtd_byakuren/ability_byakuren_04_phy.vpcf",PATTACH_CUSTOMORIGIN,caster)
				ParticleManager:SetParticleControl(particle,0,caster:GetOrigin()+Vector(0,0,32))
				ParticleManager:DestroyParticleSystemTime(particle,1.7)

				keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_byakuren_04_pose", {Duration = 1.7})
				keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_byakuren_04_physical_buff", {Duration = 5.0})
			end
		end
	end
end