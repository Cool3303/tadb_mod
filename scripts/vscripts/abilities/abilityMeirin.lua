local thtd_meirin_01_chance = 
{
	[1] = 100,
	[2] = 100,
	[3] = 100,
	[4] = 50,
	[5] = 100,
	[6] = 50,
	[7] = 100,
}

local thtd_meirin_01_activity = 
{
	[1] = 
	{	
		["action"] = ACT_DOTA_ATTACK,
		["duration"] = 0.55,
		func = function(keys)
			local caster = EntIndexToHScript(keys.caster_entindex)
			local target = keys.target
			local damage = caster:THTD_GetPower()
			local vecCaster = caster:GetOrigin()
			local targetPoint = caster:GetOrigin() + caster:GetForwardVector()*800
			--caster:EmitSoundParams("Hero_KeeperOfTheLight.Illuminate.Discharge",1,0.1,2) 

			local targets = 
				FindUnitsInLine(
				caster:GetTeamNumber(), 
				caster:GetOrigin(), 
				caster:GetOrigin() + caster:GetForwardVector()*800, 
				nil, 
				300,
				keys.ability:GetAbilityTargetTeam(), 
				keys.ability:GetAbilityTargetType(), 
				keys.ability:GetAbilityTargetFlags()
			)
			for k,v in pairs(targets) do
				local DamageTable_aoe = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = damage, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable_aoe)
			end

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_meirin/ability_meirin_01_step_1.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, vecCaster+Vector(0,0,32))
			ParticleManager:SetParticleControl(effectIndex, 1, targetPoint+Vector(0,0,32))
			ParticleManager:SetParticleControl(effectIndex, 9, vecCaster+Vector(0,0,32))
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	},
	[2] =
	{	
		["action"] = ACT_DOTA_ATTACK2,
		["duration"] = 0.55,
		func = function(keys)
			local caster = EntIndexToHScript(keys.caster_entindex)
			local vecCaster = caster:GetOrigin()
			local targetPoint = caster:GetOrigin() + caster:GetForwardVector()*800
			local damage = caster:THTD_GetPower()

			--caster:EmitSoundParams("Hero_Tusk.WalrusPunch.Target",1,0.3,2) 

			local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)

			for k,v in pairs(targets) do
				local vVec = v:GetOrigin()
				local vecRad = GetRadBetweenTwoVec2D(targetPoint,vecCaster)

				if(IsPointInCircularSector(vVec.x,vVec.y,math.cos(vecRad),math.sin(vecRad),800,math.pi*2/3,vecCaster.x,vecCaster.y))then
					local damage_table = {
						ability = keys.ability,
						victim = v,
						attacker = caster,
						damage = damage,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = DOTA_DAMAGE_FLAG_NONE
					}
					UnitDamageTarget(damage_table)
				end
			end

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_meirin/ability_meirin_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin())
			ParticleManager:SetParticleControlForward(effectIndex, 1 , caster:GetForwardVector())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	},
	[3] =
	{	
		["action"] = ACT_DOTA_CAST_ABILITY_4,
		["duration"] = 0.55,
		func = function(keys)
			local caster = EntIndexToHScript(keys.caster_entindex)
			local vecCaster = caster:GetOrigin()
			local targetPoint = caster:GetOrigin() + caster:GetForwardVector()*400
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar()

			caster:EmitSoundParams("Hero_EarthShaker.EchoSlamSmall",1,0.5,2) 

			local targets = THTD_FindUnitsInRadius(caster,targetPoint,400)

			for k,v in pairs(targets) do
				local damage_table = {
					ability = keys.ability,
					victim = v,
					attacker = caster,
					damage = damage,
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE
				}
				UnitDamageTarget(damage_table)
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_meirin_01_slow_buff", {duration=0.5})
			end

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_meirin/ability_meirin_01_step_2.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(800,0,0))
			ParticleManager:SetParticleControl(effectIndex, 2, Vector(255,140,0))
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	},
	[4] = 
	{	
		["action"] = ACT_DOTA_CAST_ABILITY_5,
		["duration"] = 0.55,
		func = function(keys)
			local caster = EntIndexToHScript(keys.caster_entindex)
			local vecCaster = caster:GetOrigin()
			local targetPoint = caster:GetOrigin() + caster:GetForwardVector()*800
			local damage = caster:THTD_GetPower() * 2

			--caster:EmitSoundParams("Hero_Tusk.WalrusPunch.Target",1,0.35,2) 

			local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)

			for k,v in pairs(targets) do
				local vVec = v:GetOrigin()
				local vecRad = GetRadBetweenTwoVec2D(targetPoint,vecCaster)

				if(IsPointInCircularSector(vVec.x,vVec.y,math.cos(vecRad),math.sin(vecRad),800,math.pi*2/3,vecCaster.x,vecCaster.y))then
					local damage_table = {
						ability = keys.ability,
						victim = v,
						attacker = caster,
						damage = damage,
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = DOTA_DAMAGE_FLAG_NONE
					}
					UnitDamageTarget(damage_table)
				end
			end

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_meirin/ability_meirin_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin())
			ParticleManager:SetParticleControlForward(effectIndex, 1 , caster:GetForwardVector())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	},
	[5] =
	{	
		["action"] = ACT_DOTA_CAST_ABILITY_4,
		["duration"] = 0.55,
		func = function(keys)
			local caster = EntIndexToHScript(keys.caster_entindex)
			local vecCaster = caster:GetOrigin()
			local targetPoint = caster:GetOrigin() + caster:GetForwardVector()*400
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 2

			--caster:EmitSoundParams("Hero_Tusk.WalrusPunch.Damage",1,0.4,2) 

			local targets = THTD_FindUnitsInRadius(caster,targetPoint,400)

			for k,v in pairs(targets) do
				local damage_table = {
					ability = keys.ability,
					victim = v,
					attacker = caster,
					damage = damage,
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE
				}
				UnitDamageTarget(damage_table)
				UnitStunTarget(caster,v,0.5)
			end

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_meirin/ability_meirin_01_step_3.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(800,0,0))
			ParticleManager:SetParticleControl(effectIndex, 2, Vector(255,140,0))
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	},
	[6] =
	{	
		["action"] = ACT_DOTA_CAST_ABILITY_6,
		["duration"] = 0.55,
		func = function(keys)
			local caster = EntIndexToHScript(keys.caster_entindex)
			local target = keys.target
			local damage = caster:THTD_GetPower() * 4
			local vecCaster = caster:GetOrigin()
			local targetPoint = caster:GetOrigin() + caster:GetForwardVector()*800

			--caster:EmitSoundParams("Hero_KeeperOfTheLight.Illuminate.Discharge",1,0.25,2) 

			local targets = 
				FindUnitsInLine(
				caster:GetTeamNumber(), 
				caster:GetOrigin(), 
				caster:GetOrigin() + caster:GetForwardVector()*800, 
				nil, 
				300,
				keys.ability:GetAbilityTargetTeam(), 
				keys.ability:GetAbilityTargetType(), 
				keys.ability:GetAbilityTargetFlags()
			)
			for k,v in pairs(targets) do
				local DamageTable_aoe = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = damage, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable_aoe)
			end

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_meirin/ability_meirin_01_step_1.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, vecCaster+Vector(0,0,32))
			ParticleManager:SetParticleControl(effectIndex, 1, targetPoint+Vector(0,0,32))
			ParticleManager:SetParticleControl(effectIndex, 9, vecCaster+Vector(0,0,32))
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	},
	[7] = 
	{	
		["action"] = ACT_DOTA_CAST_ABILITY_4,
		["duration"] = 0.55,
		func = function(keys)
			local caster = EntIndexToHScript(keys.caster_entindex)
			local vecCaster = caster:GetOrigin()
			local targetPoint = caster:GetOrigin() + caster:GetForwardVector()*400
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 4
			
			caster:EmitSoundParams("Hero_ElderTitan.EchoStomp",1,0.45,2) 

			local targets = THTD_FindUnitsInRadius(caster,targetPoint,400)

			for k,v in pairs(targets) do
				local damage_table = {
					ability = keys.ability,
					victim = v,
					attacker = caster,
					damage = damage,
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE
				}
				UnitDamageTarget(damage_table)
				UnitStunTarget(caster,v,1.0)
			end
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_meirin/ability_meirin_01_step_4.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(800,0,0))
			ParticleManager:SetParticleControl(effectIndex, 2, Vector(221,160,221))
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	},
}

function OnMeirin01AttackThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if keys.ability:GetLevel() < 1 then return end
	
	if caster.thtd_meirin_01_attack_step == nil then
		caster.thtd_meirin_01_attack_step = 1
	end

	if caster.thtd_meirin_01_hot_duration == nil then
		caster.thtd_meirin_01_hot_duration = 0
	end

	if caster.thtd_meirin_01_chance_increase == nil then
		caster.thtd_meirin_01_chance_increase = 0
	end

	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),500)
	
	caster.thtd_meirin_01_hot_duration = caster.thtd_meirin_01_hot_duration + 0.03
	if #targets > 0 and targets[1]~=nil and targets[1]:IsNull()==false and targets[1]:IsAlive() and caster:HasModifier("modifier_meirin_01_pause") == false then
		keys.target = targets[1]
		local level = caster:FindAbilityByName("thtd_meirin_02"):GetLevel()+2

		if caster.thtd_meirin_01_attack_step <= level and RandomInt(0,100) <= thtd_meirin_01_chance[caster.thtd_meirin_01_attack_step] + caster.thtd_meirin_01_chance_increase and caster.thtd_meirin_01_hot_duration < 2 then
			caster:StartGestureWithPlaybackRate(thtd_meirin_01_activity[caster.thtd_meirin_01_attack_step]["action"],1)
			local func = thtd_meirin_01_activity[caster.thtd_meirin_01_attack_step].func
			caster:EmitSound("Hero_Axe.PreAttack")
			caster:SetContextThink(DoUniqueString("modifier_meirin_01_attack"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					if func then
						func(keys)
					end
					return nil
				end, 
			thtd_meirin_01_activity[caster.thtd_meirin_01_attack_step]["duration"])
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_meirin_01_pause", {duration=thtd_meirin_01_activity[caster.thtd_meirin_01_attack_step]["duration"]})
			caster.thtd_meirin_01_attack_step = caster.thtd_meirin_01_attack_step + 1
		else
			caster.thtd_meirin_01_attack_step = 1
		end
		caster.thtd_meirin_01_hot_duration = 0
	end
end