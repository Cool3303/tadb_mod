function OnMarisa01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local unit = CreateUnitByName(
		"npc_dota2x_unit_marisa04_spark"
		,caster:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	
	keys.ability.effectcircle = ParticleManager:CreateParticle("particles/heroes/marisa/marisa_04_spark_circle.vpcf", PATTACH_CUSTOMORIGIN, unit)
	keys.ability.effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/marisa/marisa_04_spark.vpcf", PATTACH_CUSTOMORIGIN, unit)
	keys.ability.effectIndex_b = ParticleManager:CreateParticle("particles/thd2/heroes/marisa/marisa_04_spark_wind_b.vpcf", PATTACH_CUSTOMORIGIN, unit)
	keys.ability:SetContextNum("ability_marisa_04_spark_unit",unit:GetEntityIndex(),0)

	MarisaSparkParticleControl(caster,keys.ability,targetPoint)
	keys.ability:SetContextNum("ability_marisa_04_spark_lock",FALSE,0)

	caster.thtd_marisa_01_count = 1
	caster.thtd_marisa_01_last_distance = 10
	caster.thtd_marisa_01_currentForward = caster:GetForwardVector()
end

function MarisaSparkParticleControl(caster,ability,targetPoint)
	local unitIndex = ability:GetContext("ability_marisa_04_spark_unit")
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

function OnMarisa01SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local unitIndex = keys.ability:GetContext("ability_marisa_04_spark_unit")

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
	keys.ability:SetContextNum("ability_marisa_04_spark_lock",TRUE,0)

	if keys.ability:GetAbilityName() == "thtd_marisa_03" then
		caster:StopSound("Sound_THTD.thtd_marisa_03")
	else
		caster:StopSound("Sound_THTD.thtd_marisa_01")
	end
end



function FindMarisa01MaxCountEnemeiesForward(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local forwardVector = caster.thtd_marisa_01_currentForward

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

function GetMarisa01ForwardMove(forward,nextForward,rad)
	local forwardVector = Vector(math.cos(rad)*forward.x - math.sin(rad)*forward.y,
								 forward.y*math.cos(rad) + forward.x*math.sin(rad),
								0)
	return forwardVector
end

function OnMarisa01SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	if(keys.ability:GetContext("ability_marisa_04_spark_lock")==TRUE)then
		return
	end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()

	if keys.ability:GetAbilityName() == "thtd_marisa_03" then
		local nextForward,maxCount = FindMarisa01MaxCountEnemeiesForward(keys)

		if nextForward ~= nil then
			local forward = GetMarisa01ForwardMove(caster.thtd_marisa_01_currentForward,nextForward,caster.thtd_marisa_01_count * math.pi/180)
			local distance = GetDistanceBetweenTwoVec2D(forward, nextForward)

			if caster.thtd_marisa_01_last_distance <= distance then
				caster.thtd_marisa_01_count = caster.thtd_marisa_01_count * -1
			end
			caster.thtd_marisa_01_last_distance = distance

			local NowDamageTargets = 
				FindUnitsInLine(
					caster:GetTeamNumber(), 
					caster:GetOrigin(), 
					caster:GetOrigin() + keys.DamageLenth * caster.thtd_marisa_01_currentForward, 
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
				caster.thtd_marisa_01_currentForward = forward
			end
		else
			caster:SetForwardVector(caster.thtd_marisa_01_currentForward)
		end
	end

	local targetPoint =  vecCaster + caster.thtd_marisa_01_currentForward

	local DamageTargets = 
		FindUnitsInLine(
			caster:GetTeamNumber(), 
			caster:GetOrigin(), 
			caster:GetOrigin() + keys.DamageLenth * caster.thtd_marisa_01_currentForward, 
			nil, 
			keys.DamageWidth,
			keys.ability:GetAbilityTargetTeam(), 
			keys.ability:GetAbilityTargetType(), 
			keys.ability:GetAbilityTargetFlags()
		)

	for _,v in pairs(DamageTargets) do
		local deal_damage = caster:THTD_GetStar() * 0.35 * caster:THTD_GetPower() * 0.2
		if keys.ability:GetAbilityName() == "thtd_marisa_03" then
			deal_damage = deal_damage * 2
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
	MarisaSparkParticleControl(caster,keys.ability,targetPoint)
end

-- 0.1Ãë´´½¨Ò»¸öÐÇÐÇ£¬Ò»´Î´´½¨2¸ö

local marisa_star_table = 
{
	"particles/heroes/thtd_marisa/ability_marisa_02.vpcf",
	"particles/heroes/thtd_marisa/ability_marisa_02_pink.vpcf",
	"particles/heroes/thtd_marisa/ability_marisa_02_blue.vpcf",
	"particles/heroes/thtd_marisa/ability_marisa_02_normal.vpcf",
}

function OnMarisa02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()

	if keys.ability:GetLevel() < 1 then return end

   	local count = 2

   	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),750)

   	caster:SetContextThink(DoUniqueString("thtd_marisa02_projectile"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if #targets > 0 then
					local index = RandomInt(1,#targets)
					local info = 
					{
						Target = targets[index],
						Source = caster,
						Ability = keys.ability,	
						EffectName = marisa_star_table[RandomInt(1,#marisa_star_table)],
				        iMoveSpeed = 1400,
						vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
						bDrawsOnMinimap = false,                          -- Optional
					    bDodgeable = true,                                -- Optional
					  	bIsAttack = false,                                -- Optional
					    bVisibleToEnemies = true,                         -- Optional
					    bReplaceExisting = false,                         -- Optional
					    flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
						bProvidesVision = true,                           -- Optional
						iVisionRadius = 400,                              -- Optional
						iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
					}
					local projectile = ProjectileManager:CreateTrackingProjectile(info)
					ParticleManager:DestroyLinearProjectileSystem(projectile,false)
					caster:EmitSound("Hero_Marisa.PreAttack")
					
					if count > 0 then
						count = count - 1
						return 0.1
					end
				end
				return nil
			end, 
		0.1)
end

function OnMarisa02SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	target:EmitSound("Hero_Marisa.ProjectileImpact")

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = caster:THTD_GetPower() / 2, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
   	if target:IsAlive() == false then
   		caster:SetMana(caster:GetMana()+1)
   	end
 end