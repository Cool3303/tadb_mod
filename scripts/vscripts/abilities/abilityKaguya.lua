function OnKaguya01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local count = 3 + caster.thtd_kaguya_01_count
	caster:SetContextThink(DoUniqueString("thtd_kaguya01_spell_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if count <= 0 then 
				return nil
			end
			OnKaguya01SpellThink(keys,count)
			count = count - 1
			return 0.7
		end, 
	0)
end

function OnKaguya01SpellThink(keys,count)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	for i=1,count*5 do
		local forwardVector = caster:GetForwardVector()
		local rollRad = i*math.pi*2/(count*5)
		local forwardCos = forwardVector.x
		local forwardSin = forwardVector.y
		local damageVector =  Vector(math.cos(rollRad)*forwardCos - math.sin(rollRad)*forwardSin,
								 forwardSin*math.cos(rollRad) + forwardCos*math.sin(rollRad),
								 0) * count*100 + targetPoint

		local effectIndex
		if((i*count*5)%3==0)then
			effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/kaguya/ability_kaguya01_light.vpcf", PATTACH_CUSTOMORIGIN, nil)
		elseif((i*count*5)%3==1)then
			effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/kaguya/ability_kaguya01_light_green.vpcf", PATTACH_CUSTOMORIGIN, nil)
		elseif((i*count*5)%3==2)then
			effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/kaguya/ability_kaguya01_light_red.vpcf", PATTACH_CUSTOMORIGIN, nil)
		end		
		
		ParticleManager:SetParticleControl(effectIndex, 0, damageVector)
		ParticleManager:SetParticleControl(effectIndex, 1, damageVector)
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		
		local targets = THTD_FindUnitsInRadius(caster,damageVector,350)
		for k,v in pairs(targets) do
			local damage = caster:THTD_GetPower()*caster:THTD_GetStar()*0.5
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
end

function OnKaguya02SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if keys.ability:GetLevel() < 1 then return end
	if GameRules:IsGamePaused() then return end

	if caster.thtd_kaguya_modifier_num == nil then
		caster.thtd_kaguya_modifier_num = 1
	end

	if caster.thtd_kaguya_modifier_num == 1 then
		caster.thtd_kaguya_modifier_num = 2
		local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)

		for k,v in pairs(targets) do
			if v:HasModifier("modifier_thdots_kaguya02_debuff") == false and v:HasModifier("modifier_thdots_kaguya02_buff") == false then
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thdots_kaguya02_debuff", {Duration = 2.0})
			end
		end
	else
		caster.thtd_kaguya_modifier_num = 1
		local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)
		
		for k,v in pairs(targets) do
			if v:HasModifier("modifier_thdots_kaguya02_debuff") == false and v:HasModifier("modifier_thdots_kaguya02_buff") == false then
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thdots_kaguya02_buff", {Duration = 2.0})
			end
		end
	end
end

function OnKaguya03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_kaguya_03_roll == false then
		caster.thtd_kaguya_03_roll = true
	else
		caster.thtd_kaguya_03_roll = false
	end
end

function OnKaguya03SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if keys.ability:GetLevel() < 1 then return end
	if GameRules:IsGamePaused() then return end
	if caster:HasModifier("modifier_touhoutd_release_hidden") then 
		OnKaguya03ReleaseBall(keys)
		return 
	end

	if caster.thtd_kaguya_03_treasure_table == nil then
		caster.thtd_kaguya_03_treasure_table = {}
	end

	if caster.thtd_kaguya_03_think_count == nil then
		caster.thtd_kaguya_03_think_count = 0
	end

	if caster.thtd_kaguya_03_think_count < 360 then
		caster.thtd_kaguya_03_think_count = caster.thtd_kaguya_03_think_count + 1
	else
		caster.thtd_kaguya_03_think_count = 0
	end
	
	for i=1,4 do
		if caster.thtd_kaguya_03_treasure_table[i] == nil then
			caster.thtd_kaguya_03_treasure_table[i] = {}
		end
		if caster.thtd_kaguya_03_treasure_table[i]["effectIndex"] == nil then
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_kaguya/thtd_kaguya_03_"..i..".vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(1/12,0,0))
			ParticleManager:SetParticleControl(effectIndex, 2, Vector(500/12,0,0))
			caster.thtd_kaguya_03_treasure_table[i]["effectIndex"] = effectIndex
		end

		if caster.thtd_kaguya_03_roll ~= false then 
			caster.thtd_kaguya_03_treasure_table[i]["origin"] = caster:GetOrigin() + 
				Vector(
					math.cos(i*2*math.pi/4 + caster.thtd_kaguya_03_think_count * math.pi/180)*400,
					math.sin(i*2*math.pi/4 + caster.thtd_kaguya_03_think_count * math.pi/180)*400,
					150)
		end
	end

	local friends = THTD_FindFriendlyUnitsAll(caster)
	local enemies = THTD_FindUnitsAll(caster)

	-- 旋转宝具
	for i=1,4 do
		if caster.thtd_kaguya_03_treasure_table[i]["effectIndex"] ~= nil then
			ParticleManager:SetParticleControl(caster.thtd_kaguya_03_treasure_table[i]["effectIndex"], 0, caster.thtd_kaguya_03_treasure_table[i]["origin"] )
		end
		local buff = "modifier_kaguya_03_"..i.."_buff"
		local debuff = "modifier_kaguya_03_"..i.."_debuff"

		for k,v in pairs(friends) do
			if GetDistanceBetweenTwoVec2D(caster.thtd_kaguya_03_treasure_table[i]["origin"], v:GetOrigin()) > 200 then
				if v:HasModifier(buff) then
					v:RemoveModifierByName(buff)
				end
			else
				if v:HasModifier(buff) == false then
					keys.ability:ApplyDataDrivenModifier(caster, v, buff, {})
				end
			end
		end

		for k,v in pairs(enemies) do
			if GetDistanceBetweenTwoVec2D(caster.thtd_kaguya_03_treasure_table[i]["origin"], v:GetOrigin()) > 200 then
				if v:HasModifier(debuff) then
					v:RemoveModifierByName(debuff)
				end
			else
				if v:HasModifier(debuff) == false then
					keys.ability:ApplyDataDrivenModifier(caster, v, debuff, {})
				end
				local damage = caster:THTD_GetPower()*caster:THTD_GetStar()/16
				if i == 2 then
					damage = damage * 1.5
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
		end
	end
end


function OnKaguya03ReleaseBall(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target:GetOrigin()
	
	if caster.thtd_kaguya_03_treasure_table ~= nil then
		local friends = THTD_FindFriendlyUnitsAll(caster)
		local enemies = THTD_FindUnitsAll(caster)

		for i=1,4 do
			local buff = "modifier_kaguya_03_"..i.."_buff"
			local debuff = "modifier_kaguya_03_"..i.."_debuff"
			for k,v in pairs(friends) do
				if v:HasModifier(buff) then
					v:RemoveModifierByName(buff)
				end
			end
			for k,v in pairs(enemies) do
				if v:HasModifier(debuff) then
					v:RemoveModifierByName(debuff)
				end
			end

			if caster.thtd_kaguya_03_treasure_table[i]["effectIndex"] ~= nil then
				ParticleManager:DestroyParticleSystem(caster.thtd_kaguya_03_treasure_table[i]["effectIndex"],true)
				caster.thtd_kaguya_03_treasure_table[i]["effectIndex"] = nil
			end
		end
	end
end

function OnCreatedKaguya03_3_debuff(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	ModifyDamageIncomingPercentage(keys.target,keys.incoming_percent,nil)
end
function OnRemoveKaguya03_3_debuff(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	ModifyDamageIncomingPercentage(keys.target,-keys.incoming_percent,nil)
end