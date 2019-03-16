function OnYuuka01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * GetYuuka03Increase(caster)

	if caster.thtd_yuuka_seeds == nil then
		caster.thtd_yuuka_seeds = {}
	end

	caster:EmitSound("Sound_THTD.thtd_yuuka_01")

	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)

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

	for k,v in pairs(caster.thtd_yuuka_seeds) do
		if v~=nil and GetDistanceBetweenTwoVec2D(v, caster:GetOrigin()) <= 800 then
			Yuuka02CreatePlant(keys,v,k)
			caster.thtd_yuuka_seeds[k] = nil
		end
	end
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/ability_yuuka_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, vecCaster)
	ParticleManager:SetParticleControl(effectIndex, 1, vecCaster)
	ParticleManager:SetParticleControl(effectIndex, 2, vecCaster)
	ParticleManager:SetParticleControl(effectIndex, 3, vecCaster)
	ParticleManager:SetParticleControl(effectIndex, 7, vecCaster)
	ParticleManager:DestroyParticleSystemTime(effectIndex,5.0)
	
end

function OnYuuka02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local forward = caster:GetForwardVector()

	if caster.thtd_yuuka_03_illusion ~= nil and caster.thtd_yuuka_03_illusion:IsNull()==false and caster.thtd_yuuka_03_illusion:IsAlive() then
		forward = (caster.thtd_yuuka_03_illusion:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	end

	if caster:THTD_IsHidden() then return end

	if caster.thtd_yuuka_seeds == nil then
		caster.thtd_yuuka_seeds = {}
	end

	local num = RandomInt(0,300)

	local randomVector = caster:GetOrigin() + forward * 300 + RandomVector(num) + Vector(0,0,32)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/ability_yuuka_02_seed.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, randomVector)

	caster.thtd_yuuka_seeds[effectIndex] = randomVector
	caster:EmitSound("Sound_THTD.thtd_yuuka_02")

	caster:GetOwner():SetContextThink(DoUniqueString("thtd_yuuka_02_seed_release"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster~=nil and caster:IsNull()==false and caster:IsAlive() then
				caster.thtd_yuuka_seeds[effectIndex] = nil
			end
			ParticleManager:DestroyParticleSystem(effectIndex,true)
			return nil
		end, 
	10.0)
end

function Yuuka02CreatePlant(keys,vec,seed)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local flower = CreateUnitByName(
		"yuuka_flower", 
		vec, 
		false, 
		caster:GetOwner(), 
		caster:GetOwner(), 
		caster:GetTeam() 
	)

	ParticleManager:DestroyParticleSystem(seed,true)
	
	flower.thtd_spawn_unit_owner = caster
	flower:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
	keys.ability:ApplyDataDrivenModifier(caster, flower, "modifier_yuuka_02_flower", nil)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/ability_yuuka_01_spawn.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, vec)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	
	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/ability_yuuka_01_flower.vpcf", PATTACH_CUSTOMORIGIN, flower)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, flower, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 1, flower, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 2, flower, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 3, flower, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex2,5.0)
		
	flower:SetBaseDamageMax(caster:GetAverageTrueAttackDamage(caster)*GetYuuka03Increase(caster))
	flower:SetBaseDamageMin(caster:GetAverageTrueAttackDamage(caster)*GetYuuka03Increase(caster))

	local count = 0
	flower:SetContextThink(DoUniqueString("thtd_yuuka_02_plant"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if count > 10 then 
				flower:AddNoDraw()
				flower:ForceKill(true)
				return nil
			else
			    if flower:IsAttacking() == false then
					flower:MoveToPositionAggressive(flower:GetOrigin() + flower:GetForwardVector() * 100)
				end
			end
			count = count + 1
			return 0.5
		end, 
	0)
end

-- 在本体和分身之间创建花田，若花田内有单位死亡，则增加花和花妈的属性

function Yuuka03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_yuuka_03_illusion == nil or caster.thtd_yuuka_03_illusion:IsNull() or caster.thtd_yuuka_03_illusion:IsAlive()==false then
		local illusion = CreateUnitByName(
			"yuuka_illusion", 
			targetPoint, 
			false, 
			caster:GetOwner(), 
			caster:GetOwner(), 
			caster:GetTeam() 
		)
		caster.thtd_yuuka_03_illusion = illusion
		illusion.thtd_yuuka_03_owner = caster
		ParticleManager:DestroyParticleSystem(seed,true)

		illusion:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
		keys.ability:ApplyDataDrivenModifier(caster, illusion, "modifier_yuuka_03_illusion", nil)

		local midOrigin = (caster:GetAbsOrigin() + targetPoint)/2
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/ability_yuuka_03.vpcf", PATTACH_CUSTOMORIGIN, illusion)
		ParticleManager:SetParticleControl(effectIndex, 0, midOrigin)
		ParticleManager:SetParticleControl(effectIndex, 7, midOrigin)

		illusion.effect = effectIndex

		illusion:SetBaseDamageMax(caster:GetAverageTrueAttackDamage(caster))
		illusion:SetBaseDamageMin(caster:GetAverageTrueAttackDamage(caster))

		illusion:SetContextThink(DoUniqueString("thtd_yuuka_03_illusion"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if caster==nil or caster:IsNull() or caster:THTD_IsHidden() or caster:IsAlive()==false then 
					illusion:AddNoDraw()
					illusion:ForceKill(true)
					return nil				
				elseif illusion:IsAttacking() == false and caster:IsChanneling() == false and caster:THTD_IsAggressiveLock()==false then
					illusion:MoveToPositionAggressive(illusion:GetOrigin() + illusion:GetForwardVector() * 100)
					illusion:THTD_SetAggressiveLock()
				end
				return 0.5
			end, 
		0)
	else
		local midOrigin = (caster:GetAbsOrigin() + targetPoint)/2
		ParticleManager:SetParticleControl(caster.thtd_yuuka_03_illusion.effect, 0, midOrigin)
		ParticleManager:SetParticleControl(caster.thtd_yuuka_03_illusion.effect, 7, midOrigin)
		caster.thtd_yuuka_03_illusion:SetAbsOrigin(targetPoint)
		FindClearSpaceForUnit(caster.thtd_yuuka_03_illusion, targetPoint, false)
	end
end

function OnYuuka03Kill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_yuuka_03_illusion ~= nil and caster.thtd_yuuka_03_illusion:IsNull()==false and caster.thtd_yuuka_03_illusion:IsAlive() then
		local midOrigin = (caster:GetAbsOrigin() + caster.thtd_yuuka_03_illusion:GetAbsOrigin())/2
		local dis = GetDistanceBetweenTwoEntity(caster,caster.thtd_yuuka_03_illusion)

		local targets = THTD_FindUnitsInRadius(caster,midOrigin,dis/2)	
		local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.6
		for k,v in pairs(targets) do
			if v~=nil and v:IsNull()==false and v:IsAlive() then				
				local DamageTable = {
					ability = keys.ability,
			        victim = v, 
			        attacker = caster, 
			        damage = damage/10, 
			        damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
			   	if v:HasModifier("modifier_thtd_yuuka_03_death") == false then
					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thtd_yuuka_03_death", nil)
			   	end
			end
		end
	end
end

local thtd_yuuka_03_star_bonus = 
{
	[3] = 100,
	[4] = 200,
	[5] = 400,
}


function OnYuuka03Death(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.unit

	if caster == nil or caster:IsNull() or caster:IsAlive() ==false then
		return
	end
	
	if caster.thtd_yuuka_03_kill_count == nil then
		caster.thtd_yuuka_03_kill_count = 0
	end

	if caster.thtd_yuuka_03_kill_count < thtd_yuuka_03_star_bonus[caster:THTD_GetStar()] then
		caster.thtd_yuuka_03_kill_count = caster.thtd_yuuka_03_kill_count + 1
		local modifier = caster:FindModifierByName("modifier_yuuka_03_kill_count")
		if modifier~=nil then
			modifier:SetStackCount(caster.thtd_yuuka_03_kill_count)
		end
	end
end

function OnYuuka04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	caster.cool_down_bonus_count = 0
	if caster.ability_dummy_unit~=nil then
		caster.ability_dummy_unit:RemoveSelf()
		keys.ability.effectcircle = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectcircle,true)
		keys.ability.effectIndex = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectIndex,true)
		keys.ability.effectIndex_b = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectIndex_b,true)		
	end

	local unit = CreateUnitByName(
		"npc_dota2x_unit_yuuka04_spark"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	
	keys.ability.effectcircle = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/yuuka_04_spark_circle.vpcf", PATTACH_CUSTOMORIGIN, unit)
	keys.ability.effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/yuuka_04_spark.vpcf", PATTACH_CUSTOMORIGIN, unit)
	keys.ability.effectIndex_b = ParticleManager:CreateParticle("particles/heroes/thtd_yuuka/ability_yuuka_04_spark_wind.vpcf", PATTACH_CUSTOMORIGIN, unit)
	keys.ability:SetContextNum("ability_yuuka_04_spark_unit",unit:GetEntityIndex(),0)

	YuukaSparkParticleControl(caster,keys.ability,targetPoint)
	keys.ability:SetContextNum("ability_yuuka_04_spark_lock",0,0)

	caster.thtd_Yuuka_04_count = 1
	caster.thtd_Yuuka_04_last_distance = 10
	caster.thtd_Yuuka_04_currentForward = caster:GetForwardVector()	
	caster.ability_dummy_unit = unit

	if caster.thtd_yuuka_03_illusion ~= nil and caster.thtd_yuuka_03_illusion:IsNull()==false and caster.thtd_yuuka_03_illusion:IsAlive() then
		local ability = caster.thtd_yuuka_03_illusion:FindAbilityByName("thtd_yuuka_04")
		if ability == nil then
			ability = caster.thtd_yuuka_03_illusion:AddAbility("thtd_yuuka_04")
		end
		if ability:GetLevel() ~= 1 then 
			ability:SetLevel(1)
		end		
		ability:EndCooldown()		
		local count = 1
		caster.thtd_yuuka_03_illusion:SetContextThink(DoUniqueString("thtd_yuuka_02_plant"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if count > 50 then return nil end
				if not ability:IsCooldownReady() then return nil end
				caster.thtd_yuuka_03_illusion:CastAbilityOnPosition(targetPoint,ability,caster:GetPlayerOwnerID())
				count = count + 1
				return 0.1
			end, 
		0)		
	end
end

function YuukaSparkParticleControl(caster,ability,targetPoint)
	local unitIndex = ability:GetContext("ability_yuuka_04_spark_unit")
	local unit = EntIndexToHScript(unitIndex)

	if(ability.targetPoint == targetPoint)then
		return
	else
		ability.targetPoint = targetPoint
	end

	if(unit == nil or ability.effectIndex == -1 or ability.effectcircle == -1)then
		return
	end

	forwardRad = GetRadBetweenTwoVec2D(targetPoint,caster:GetOrigin()) 
	vecForward = Vector(math.cos(math.pi/2 + forwardRad),math.sin(math.pi/2 + forwardRad),0)
	unit:SetForwardVector(vecForward)
	vecUnit = caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,160)
	vecColor = Vector(255,255,255)
	unit:SetAbsOrigin(vecUnit)

	ParticleManager:SetParticleControl(ability.effectcircle, 0, caster:GetOrigin())
	
	local effect2ForwardRad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint) 
	local effect2VecForward = Vector(math.cos(effect2ForwardRad)*1400,math.sin(effect2ForwardRad)*1400,0) + caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,108)
	
	ParticleManager:SetParticleControl(ability.effectIndex, 0, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 92,caster:GetForwardVector().y * 92,150))
	ParticleManager:SetParticleControl(ability.effectIndex, 1, effect2VecForward)
	ParticleManager:SetParticleControl(ability.effectIndex, 2, vecColor)
	local forwardRadwind = forwardRad + math.pi
	ParticleManager:SetParticleControl(ability.effectIndex, 8, Vector(math.cos(forwardRadwind),math.sin(forwardRadwind),0))
	ParticleManager:SetParticleControl(ability.effectIndex, 9, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 100,caster:GetForwardVector().y * 100,108))

	ParticleManager:SetParticleControl(ability.effectIndex_b, 0, caster:GetOrigin() + Vector(caster:GetForwardVector().x * 92,caster:GetForwardVector().y * 92,150))
	ParticleManager:SetParticleControlForward(ability.effectIndex_b, 3, Vector(math.cos(forwardRadwind),math.sin(forwardRadwind),0))
end

function OnYuuka04SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unitIndex = keys.ability:GetContext("ability_yuuka_04_spark_unit")

	local unit = EntIndexToHScript(unitIndex)
	if unit~=nil then
		unit:RemoveSelf()
		keys.ability.effectcircle = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectcircle,true)
		keys.ability.effectIndex = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectIndex,true)
		keys.ability.effectIndex_b = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectIndex_b,true)
	end
	keys.ability:SetContextNum("ability_yuuka_04_spark_lock",1,0)
	caster:StopSound("Sound_THTD.thtd_yuuka_04")
	caster.ability_dummy_unit = nil
end

function OnYuuka04SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	if (keys.ability:GetContext("ability_yuuka_04_spark_lock")==1) then
		return
	end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint =  vecCaster + caster:GetForwardVector()
	
	local nextForward,maxCount = FindYuuka04MaxCountEnemeiesForward(keys)
	if nextForward ~= nil then
		local forward = GetYuuka04ForwardMove(caster.thtd_Yuuka_04_currentForward,nextForward,caster.thtd_Yuuka_04_count * math.pi/180)
		local distance = GetDistanceBetweenTwoVec2D(forward, nextForward)

		if caster.thtd_Yuuka_04_last_distance <= distance then
			caster.thtd_Yuuka_04_count = caster.thtd_Yuuka_04_count * -1
		end
		caster.thtd_Yuuka_04_last_distance = distance

		local NowDamageTargets = 
			FindUnitsInLine(
				caster:GetTeamNumber(), 
				caster:GetOrigin(), 
				caster:GetOrigin() + keys.DamageLenth * caster.thtd_Yuuka_04_currentForward, 
				nil, 
				keys.DamageWidth,
				keys.ability:GetAbilityTargetTeam(), 
				keys.ability:GetAbilityTargetType(), 
				keys.ability:GetAbilityTargetFlags()
			)

		local NowCount = 0

		for k,v in pairs(NowDamageTargets) do
			if v~=nil and v:IsNull()==false and v:IsAlive() then
				NowCount = NowCount + 1
			end
		end

		if distance > math.sin(math.pi/18) and distance < 1.86 and NowCount~=maxCount then
			caster:SetForwardVector(forward)
			caster.thtd_Yuuka_04_currentForward = forward
		end
	else
		caster:SetForwardVector(caster.thtd_Yuuka_04_currentForward)
	end	

	local targetPoint =  vecCaster + caster.thtd_Yuuka_04_currentForward

	if caster.thtd_effect_count == nil then 
		caster.thtd_effect_count = 1
	end

	if caster.thtd_effect_count >= 10 then 
		local attacker = caster
		if caster.thtd_yuuka_03_owner~=nil then
			attacker = caster.thtd_yuuka_03_owner
		end
		local deal_damage = attacker:THTD_GetStar() * attacker:THTD_GetPower() * 2 * GetYuuka03Increase(attacker)		

		local DamageTargets = 
			FindUnitsInLine(
				attacker:GetTeamNumber(), 
				caster:GetOrigin(), 
				caster:GetOrigin() + keys.DamageLenth * caster.thtd_Yuuka_04_currentForward, 
				nil, 
				keys.DamageWidth,
				keys.ability:GetAbilityTargetTeam(), 
				keys.ability:GetAbilityTargetType(), 
				keys.ability:GetAbilityTargetFlags()
			)

		for _,v in pairs(DamageTargets) do
			local damage_table = {
				ability = keys.ability,
				victim = v,
				attacker = attacker,
				damage = deal_damage,
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = DOTA_DAMAGE_FLAG_NONE
			}
			UnitDamageTarget(damage_table)
		end
		caster.thtd_effect_count = 1
	else 
		caster.thtd_effect_count = caster.thtd_effect_count + 1
	end
	YuukaSparkParticleControl(caster,keys.ability,targetPoint)
end

function GetYuuka03Increase(caster)
	if caster.thtd_yuuka_03_kill_count == nil then
		caster.thtd_yuuka_03_kill_count = 0
	end
	return (1+caster.thtd_yuuka_03_kill_count/200)
end

function FindYuuka04MaxCountEnemeiesForward(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local forwardVector = caster.thtd_Yuuka_04_currentForward

	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),keys.DamageLenth)

	if #targets <= 0 then
		return nil,0
	end

	local maxCount = 0
	for i=1,120 do
		local sparkRad = math.pi * i/60
		local count = 0
		for k,v in pairs(targets) do
			if v~=nil and v:IsNull()==false and v:IsAlive() then
				if IsRadInRect(v:GetOrigin(),caster:GetOrigin(),keys.DamageWidth,keys.DamageLenth,sparkRad) then
					count = count + 1
				end
			end
		end
		if count > maxCount then
			forwardVector = Vector(math.cos(sparkRad),math.sin(sparkRad),forwardVector.z)
			maxCount = count
		end
	end

	return forwardVector,maxCount
end

function GetYuuka04ForwardMove(forward,nextForward,rad)
	local forwardVector = Vector(math.cos(rad)*forward.x - math.sin(rad)*forward.y,
								 forward.y*math.cos(rad) + forward.x*math.sin(rad),
								0)
	return forwardVector
end