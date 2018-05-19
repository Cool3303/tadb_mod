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
		local damage = caster:THTD_GetPower()
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

	if caster:HasModifier("modifier_touhoutd_release_hidden") then return end

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
	

	flower:SetBaseDamageMax(caster:GetAttackDamage()*GetYuuka03Increase(caster))
	flower:SetBaseDamageMin(caster:GetAttackDamage()*GetYuuka03Increase(caster))

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
					flower:MoveToPositionAggressive(flower:GetOrigin() + Vector(0,-100,0))
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

		illusion:SetBaseDamageMax(caster:GetAttackDamage())
		illusion:SetBaseDamageMin(caster:GetAttackDamage())

		illusion:SetContextThink(DoUniqueString("thtd_yuuka_03_illusion"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if caster==nil or caster:IsNull() or caster:HasModifier("modifier_touhoutd_release_hidden") or caster:IsAlive()==false then 
					illusion:AddNoDraw()
					illusion:ForceKill(true)
					return nil
				elseif illusion:IsAttacking() == false and caster:IsChanneling() == false then
					illusion:MoveToPositionAggressive(illusion:GetOrigin() + Vector(0,-100,0))
				end
				return 0.5
			end, 
		0)
	else
		local midOrigin = (caster:GetAbsOrigin() + targetPoint)/2
		ParticleManager:SetParticleControl(caster.thtd_yuuka_03_illusion.effect, 0, midOrigin)
		ParticleManager:SetParticleControl(caster.thtd_yuuka_03_illusion.effect, 7, midOrigin)
		caster.thtd_yuuka_03_illusion:SetOrigin(targetPoint)
		FindClearSpaceForUnit(caster.thtd_yuuka_03_illusion, targetPoint, false)
	end
end

function OnYuuka03Kill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_yuuka_03_illusion ~= nil and caster.thtd_yuuka_03_illusion:IsNull()==false and caster.thtd_yuuka_03_illusion:IsAlive() then
		local midOrigin = (caster:GetAbsOrigin() + caster.thtd_yuuka_03_illusion:GetAbsOrigin())/2
		local dis = GetDistance(caster,caster.thtd_yuuka_03_illusion)

		local targets = THTD_FindUnitsInRadius(caster,midOrigin,dis/2)
		
		for k,v in pairs(targets) do
			if v~=nil and v:IsNull()==false and v:IsAlive() then
				local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
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
	keys.ability:SetContextNum("ability_yuuka_04_spark_lock",FALSE,0)

	caster.thtd_Yuuka_04_count = 1
	caster.thtd_Yuuka_04_last_distance = 10
	caster.thtd_Yuuka_04_currentForward = caster:GetForwardVector()

	if caster.thtd_yuuka_03_illusion ~= nil and caster.thtd_yuuka_03_illusion:IsNull()==false and caster.thtd_yuuka_03_illusion:IsAlive() then
		local ability = caster.thtd_yuuka_03_illusion:FindAbilityByName("thtd_yuuka_04")
		if ability == nil then
			ability = caster.thtd_yuuka_03_illusion:AddAbility("thtd_yuuka_04")
		end
		ability:SetLevel(1)
		caster.thtd_yuuka_03_illusion:CastAbilityOnPosition(targetPoint,ability,caster:GetPlayerOwnerID())
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
	unit:SetOrigin(vecUnit)

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
	if(unit~=nil)then
		unit:RemoveSelf()
		keys.ability.effectcircle = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectcircle,true)
		keys.ability.effectIndex = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectIndex,true)
		keys.ability.effectIndex_b = -1
		ParticleManager:DestroyParticleSystem(keys.ability.effectIndex_b,true)
	end
	keys.ability:SetContextNum("ability_yuuka_04_spark_lock",TRUE,0)
	caster:StopSound("Sound_THTD.thtd_yuuka_04")
end

function OnYuuka04SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	if(keys.ability:GetContext("ability_yuuka_04_spark_lock")==TRUE)then
		return
	end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint =  vecCaster + caster:GetForwardVector()

	local DamageTargets = 
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

	for _,v in pairs(DamageTargets) do
		local deal_damage = 0
		if caster:GetUnitName() == "yuuka_illusion" then
			if caster.thtd_yuuka_03_owner~=nil then
				deal_damage = caster.thtd_yuuka_03_owner:THTD_GetStar() * 0.5 * caster.thtd_yuuka_03_owner:THTD_GetPower() * 0.2 * GetYuuka03Increase(caster.thtd_yuuka_03_owner)
			end
		else
			deal_damage = caster:THTD_GetStar() * 0.5 * caster:THTD_GetPower() * 0.2 * GetYuuka03Increase(caster)
		end

		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = deal_damage,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = 0
		}
		UnitDamageTarget(damage_table)
	end
	YuukaSparkParticleControl(caster,keys.ability,targetPoint)
end

function GetYuuka03Increase(caster)
	if caster.thtd_yuuka_03_kill_count == nil then
		caster.thtd_yuuka_03_kill_count = 0
	end
	return (1+caster.thtd_yuuka_03_kill_count/200)
end