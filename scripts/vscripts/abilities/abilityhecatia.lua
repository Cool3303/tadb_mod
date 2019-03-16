local thtd_hecatia_model_list = 
{
	[1] = "models/new_touhou_model/hecatia/hecatia_earth/hecatia_earth.vmdl",
	[2] = "models/new_touhou_model/hecatia/hecatia_moon/hecatia_moon.vmdl",
	[3] = "models/new_touhou_model/hecatia/hecatia.vmdl",
}

local HECATIA_TYPE_EARTH = 1
local HECATIA_TYPE_MOON = 2
local HECATIA_TYPE_OTHERWORLD = 3

function OnHecatia01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_hecatia_ball_table == nil then
		caster.thtd_hecatia_ball_table = {}
		caster.thtd_hecatia_ball_table["earth"] = nil
		caster.thtd_hecatia_ball_table["moon"] = nil
		caster.thtd_hecatia_ball_table["otherworld"] = nil
	end

	caster.thtd_hecatia_01_think_count = 0
	
	if caster.thtd_hecatia_ball_table["earth"] == nil then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_01_earth.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, targetPoint + Vector(0,0,128))
		ParticleManager:SetParticleControl(effectIndex, 1, Vector(0.4,0,0))
		ParticleManager:SetParticleControl(effectIndex, 2, Vector(200,0,0))

		caster.thtd_hecatia_ball_table["earth"] = 
		{
			["Vector"] = targetPoint + Vector(0,0,128),
			["EffectIndex"] = effectIndex
		}
	else
		caster.thtd_hecatia_ball_table["earth"]["Vector"] = targetPoint + Vector(0,0,128)
	end
end

function OnHecatia02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_hecatia_ball_table == nil then
		caster.thtd_hecatia_ball_table = {}
		caster.thtd_hecatia_ball_table["earth"] = nil
		caster.thtd_hecatia_ball_table["moon"] = nil
		caster.thtd_hecatia_ball_table["otherworld"] = nil
	end	

	caster.thtd_hecatia_01_think_count = 0

	if caster.thtd_hecatia_ball_table["moon"] == nil then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_01_moon.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, targetPoint + Vector(0,0,128))
		ParticleManager:SetParticleControl(effectIndex, 1, Vector(0.3,0,0))
		ParticleManager:SetParticleControl(effectIndex, 2, Vector(150,0,0))

		caster.thtd_hecatia_ball_table["moon"] = 
		{
			["Vector"] = targetPoint + Vector(0,0,128),
			["EffectIndex"] = effectIndex
		}
	else
		caster.thtd_hecatia_ball_table["moon"]["Vector"] = targetPoint + Vector(0,0,128)
	end
end

function OnHecatia03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	
	if caster.thtd_hecatia_ball_table == nil then
		caster.thtd_hecatia_ball_table = {}
		caster.thtd_hecatia_ball_table["earth"] = nil
		caster.thtd_hecatia_ball_table["moon"] = nil
		caster.thtd_hecatia_ball_table["otherworld"] = nil
	end

	caster.thtd_hecatia_01_think_count = 0
	
	if caster.thtd_hecatia_ball_table["otherworld"] == nil then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_01_otherworld.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, targetPoint + Vector(0,0,128))
		ParticleManager:SetParticleControl(effectIndex, 1, Vector(0.4,0,0))
		ParticleManager:SetParticleControl(effectIndex, 2, Vector(200,0,0))

		caster.thtd_hecatia_ball_table["otherworld"] = 
		{
			["Vector"] = targetPoint + Vector(0,0,128),
			["EffectIndex"] = effectIndex,
		}
	else
		caster.thtd_hecatia_ball_table["otherworld"]["Vector"] = targetPoint + Vector(0,0,128)
	end
end

function HecatiaRemoveAllBall(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_hecatia_ball_table == nil then
		caster.thtd_hecatia_ball_table = {}
		caster.thtd_hecatia_ball_table["earth"] = nil
		caster.thtd_hecatia_ball_table["moon"] = nil
		caster.thtd_hecatia_ball_table["otherworld"] = nil
	end

	if caster.thtd_hecatia_ball_table["earth"] ~= nil then
		local effectIndex = caster.thtd_hecatia_ball_table["earth"]["EffectIndex"]
		ParticleManager:DestroyParticleSystem(effectIndex,true)
	end
	if caster.thtd_hecatia_ball_table["moon"] ~= nil then
		local effectIndex = caster.thtd_hecatia_ball_table["moon"]["EffectIndex"]
		ParticleManager:DestroyParticleSystem(effectIndex,true)
	end
	if caster.thtd_hecatia_ball_table["otherworld"] ~= nil then
		local effectIndex = caster.thtd_hecatia_ball_table["otherworld"]["EffectIndex"]
		ParticleManager:DestroyParticleSystem(effectIndex,true)
	end
	if caster.thtd_hecatia_ball_midOrigin ~= nil then
		caster.thtd_hecatia_ball_midOrigin = nil
	end
	if caster.thtd_hecatia_01_think_count ~= nil then
		caster.thtd_hecatia_01_think_count = nil
	end

	caster.thtd_hecatia_ball_table = {}
end

local MIN_RADIUS = 300
function OnHecatia01Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.thtd_hecatia_ball_table == nil then
		caster.thtd_hecatia_ball_table = {}
		caster.thtd_hecatia_ball_table["earth"] = nil
		caster.thtd_hecatia_ball_table["moon"] = nil
		caster.thtd_hecatia_ball_table["otherworld"] = nil
	end
	if caster.cast_factor == nil then 
		caster.cast_factor = 10  -- 卡顿优化，每0.3秒释放一次技能（原0.03）
	end

	if caster.thtd_hecatia_01_think_count == nil then
		caster.thtd_hecatia_01_think_count = 0
	end

	if caster.thtd_hecatia_01_think_count < 360 then
		caster.thtd_hecatia_01_think_count = caster.thtd_hecatia_01_think_count + 1
	else
		caster.thtd_hecatia_01_think_count = 0
	end

	if caster==nil or caster:IsNull()==true or caster:IsAlive()==false or caster:THTD_IsHidden() then
		HecatiaRemoveAllBall(keys)
	end

	if caster:FindAbilityByName("thtd_hecatia_04"):GetLevel() >= 1 and caster.thtd_hecatia_04_lock ~= true then
		OnHecatiaTriggerTriangle(keys)
	end

	if caster.thtd_hecatia_ball_table ~= nil then
		if caster.thtd_hecatia_ball_table["earth"] ~= nil then
			if caster.thtd_hecatia_ball_table["otherworld"] ~= nil then
				local effectIndex = caster.thtd_hecatia_ball_table["earth"]["EffectIndex"]
				local distance = math.max(MIN_RADIUS,GetDistanceBetweenTwoVec2D(caster.thtd_hecatia_ball_table["earth"]["Vector"], 
															caster.thtd_hecatia_ball_table["otherworld"]["Vector"]))

				local midOrigin = (caster.thtd_hecatia_ball_table["earth"]["Vector"] + caster.thtd_hecatia_ball_table["otherworld"]["Vector"])/2
				local point = midOrigin + 
					Vector(
						math.cos(caster.thtd_hecatia_01_think_count * math.pi/180)*distance,
						math.sin(caster.thtd_hecatia_01_think_count * math.pi/180)*distance,
						0)

				ParticleManager:SetParticleControl(effectIndex, 0, point)
				caster.thtd_hecatia_ball_table["earth"]["CurPoint"] = point
				if caster.thtd_hecatia_ball_midOrigin == nil then 	
					caster.thtd_hecatia_ball_midOrigin = midOrigin
				end
			else
				local effectIndex = caster.thtd_hecatia_ball_table["earth"]["EffectIndex"]
				local distance = math.max(MIN_RADIUS,GetDistanceBetweenTwoVec2D(caster:GetOrigin(), caster.thtd_hecatia_ball_table["earth"]["Vector"]))
				local point = caster:GetOrigin() + 
					Vector(
						math.cos(caster.thtd_hecatia_01_think_count * math.pi/180)*distance,
						math.sin(caster.thtd_hecatia_01_think_count * math.pi/180)*distance,
						128)
				ParticleManager:SetParticleControl(effectIndex, 0, point)
				caster.thtd_hecatia_ball_table["earth"]["CurPoint"] = point				
			end
			if caster.cast_factor >= 10 then 
				OnHecatiaEarthHit(keys)					
			end					
		end

		if caster.thtd_hecatia_ball_table["moon"] ~= nil then
			if caster.thtd_hecatia_ball_table["earth"] ~= nil then
				local effectIndex = caster.thtd_hecatia_ball_table["moon"]["EffectIndex"]
				local distance = math.max(MIN_RADIUS,GetDistanceBetweenTwoVec2D(caster.thtd_hecatia_ball_table["earth"]["Vector"], 
															caster.thtd_hecatia_ball_table["moon"]["Vector"]))
				local curPoint = caster.thtd_hecatia_ball_table["earth"]["Vector"]

				if caster.thtd_hecatia_ball_table["earth"]["CurPoint"] ~= nil then
					curPoint = caster.thtd_hecatia_ball_table["earth"]["CurPoint"]
				end

				local point = curPoint + 
					Vector(
						math.cos(caster.thtd_hecatia_01_think_count * math.pi/90)*distance,
						math.sin(caster.thtd_hecatia_01_think_count * math.pi/90)*distance,
						0)

				ParticleManager:SetParticleControl(effectIndex, 0, point)
				caster.thtd_hecatia_ball_table["moon"]["CurPoint"] = point
			else
				local effectIndex = caster.thtd_hecatia_ball_table["moon"]["EffectIndex"]
				local distance = math.max(MIN_RADIUS,GetDistanceBetweenTwoVec2D(caster:GetOrigin(), caster.thtd_hecatia_ball_table["moon"]["Vector"]))
				local point = caster:GetOrigin() + 
					Vector(
						math.cos(caster.thtd_hecatia_01_think_count * math.pi/90)*distance,
						math.sin(caster.thtd_hecatia_01_think_count * math.pi/90)*distance,
						128)
				ParticleManager:SetParticleControl(effectIndex, 0, point)
				caster.thtd_hecatia_ball_table["moon"]["CurPoint"] = point
			end
			if caster.cast_factor >= 10 then 
				OnHecatiaMoonHit(keys)			
			end				
		end

		if caster.thtd_hecatia_ball_table["otherworld"] ~= nil then
			if caster.thtd_hecatia_ball_table["earth"] ~= nil then
				local effectIndex = caster.thtd_hecatia_ball_table["otherworld"]["EffectIndex"]
				local distance = math.max(MIN_RADIUS,GetDistanceBetweenTwoVec2D(caster.thtd_hecatia_ball_table["earth"]["Vector"], 
															caster.thtd_hecatia_ball_table["otherworld"]["Vector"]))

				local midOrigin = (caster.thtd_hecatia_ball_table["earth"]["Vector"] + caster.thtd_hecatia_ball_table["otherworld"]["Vector"])/2
				local point = midOrigin + 
					Vector(
						math.cos((caster.thtd_hecatia_01_think_count + 180) * math.pi/180)*distance,
						math.sin((caster.thtd_hecatia_01_think_count + 180) * math.pi/180)*distance,
						0)

				ParticleManager:SetParticleControl(effectIndex, 0, point)
				caster.thtd_hecatia_ball_table["otherworld"]["CurPoint"] = point
				if caster.thtd_hecatia_ball_midOrigin == nil then 	
					caster.thtd_hecatia_ball_midOrigin = midOrigin
				end
			else
				local effectIndex = caster.thtd_hecatia_ball_table["otherworld"]["EffectIndex"]
				local distance = math.max(MIN_RADIUS,GetDistanceBetweenTwoVec2D(caster:GetOrigin(), caster.thtd_hecatia_ball_table["otherworld"]["Vector"]))
				local point = caster:GetOrigin() + 
					Vector(
						math.cos((caster.thtd_hecatia_01_think_count + 180) * math.pi/180)*distance,
						math.sin((caster.thtd_hecatia_01_think_count + 180) * math.pi/180)*distance,
						128)
				ParticleManager:SetParticleControl(effectIndex, 0, point)
				caster.thtd_hecatia_ball_table["otherworld"]["CurPoint"] = point
			end
			if caster.cast_factor >= 10 then 
				OnHecatiaOtherworldHit(keys)
			end
		end
	end

	if caster.cast_factor >= 10 then 
		caster.cast_factor = 1
	else
		caster.cast_factor = caster.cast_factor + 1
	end
end

function OnHecatiaEarthHit(keys)	
	local caster = EntIndexToHScript(keys.caster_entindex)
	local earthOrigin = caster.thtd_hecatia_ball_table["earth"]["CurPoint"]	
	if caster.thtd_hecatia_change_type == HECATIA_TYPE_EARTH then
		local targets = THTD_FindUnitsInRadius(caster,earthOrigin,350)
		local damage = caster:THTD_GetPower()*caster:THTD_GetStar()
		for k,v in pairs(targets) do
			if v.thtd_hecatia_earth_hit_lock ~= true then
				v.thtd_hecatia_earth_hit_lock = true
				v:SetContextThink(DoUniqueString("ability_hecatia_hit_delay"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						v.thtd_hecatia_earth_hit_lock = false
						return nil
					end,
				2.0)
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thtd_hecatia_01_debuff", {Duration = 1.0})				
				local DamageTable = {
					ability = keys.ability,
					victim = v, 
					attacker = caster, 
					damage = damage, 
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE,					
				}
				UnitDamageTarget(DamageTable)

				if caster.thtd_hecatia_triangle_count == nil or caster.thtd_hecatia_triangle_count == 0 then
					if caster.thtd_hecatia_ball_midOrigin~=nil then
						OnHecatiaCreateTriangle(keys,caster.thtd_hecatia_ball_midOrigin+Vector(math.cos(RandomFloat(-math.pi,-math.pi/3))*500,math.sin(RandomFloat(-math.pi,-math.pi/3))*500,64))
					end
				end
			end
		end		
	else		
		local targets = THTD_FindUnitsInRadius(caster,earthOrigin,500)
		local damage = caster:THTD_GetPower()*caster:THTD_GetStar()*3
		for k,v in pairs(targets) do
			local targetOrigin = v:GetOrigin()
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_earth_rain.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex , 0, targetOrigin)
			ParticleManager:DestroyParticleSystemTime(effectIndex,0.5)
			
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

function OnHecatiaMoonHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local moonOrigin = caster.thtd_hecatia_ball_table["moon"]["CurPoint"]
	if caster.thtd_hecatia_change_type == HECATIA_TYPE_MOON then
		local targets = THTD_FindUnitsInRadius(caster,moonOrigin,250)
		local damage = caster:THTD_GetPower()*caster:THTD_GetStar()
		for k,v in pairs(targets) do
			if v.thtd_hecatia_moon_hit_lock ~= true then
				v.thtd_hecatia_moon_hit_lock = true
				v:SetContextThink(DoUniqueString("ability_hecatia_hit_delay"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						v.thtd_hecatia_moon_hit_lock = false
						return nil
					end,
				2.0)

				local forward = (v:GetAbsOrigin()-Vector(moonOrigin.x,moonOrigin.y,0)):Normalized()
				v:SetAbsOrigin(v:GetOrigin()+forward*100)
				FindClearSpaceForUnit(v, v:GetOrigin(), false)

				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_moon_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex , 0, moonOrigin+Vector(0,0,64))
				ParticleManager:DestroyParticleSystem(effectIndex,false)			
				
				local DamageTable = {
					ability = keys.ability,
					victim = v, 
					attacker = caster, 
					damage = damage, 
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE,					
				}
				UnitDamageTarget(DamageTable)
			end

			if caster.thtd_hecatia_triangle_count == nil or caster.thtd_hecatia_triangle_count == 1 then
				if caster.thtd_hecatia_ball_midOrigin~=nil then
					OnHecatiaCreateTriangle(keys,caster.thtd_hecatia_ball_midOrigin+Vector(math.cos(RandomFloat(-math.pi/3,math.pi/3))*500,math.sin(RandomFloat(-math.pi/3,math.pi/3))*500,64))
				end
			end	
		end	
	else		
		local targets = THTD_FindUnitsInRadius(caster,moonOrigin,350)
		if #targets > 0 then 
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_moon_reflex.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex , 0, caster:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex , 1, moonOrigin+Vector(0,0,64))
			ParticleManager:SetParticleControl(effectIndex , 9, caster:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			local targets = THTD_FindUnitsInRadius(caster,moonOrigin,350)
			local damage = caster:THTD_GetPower()*caster:THTD_GetStar()*3
			for k,v in pairs(targets) do
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_moon_reflex.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex , 0, caster.thtd_hecatia_ball_table["moon"]["CurPoint"]+Vector(0,0,64))
				ParticleManager:SetParticleControlEnt(effectIndex , 1, v, 5, "attach_hitloc", Vector(0,0,0), true)
				ParticleManager:SetParticleControl(effectIndex , 9, caster.thtd_hecatia_ball_table["moon"]["CurPoint"]+Vector(0,0,64))
				ParticleManager:DestroyParticleSystem(effectIndex,false)				
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

function OnHecatiaOtherworldHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local otherworldOrigin = caster.thtd_hecatia_ball_table["otherworld"]["CurPoint"]
	if caster.thtd_hecatia_change_type == HECATIA_TYPE_OTHERWORLD then
		local targetsFirst = THTD_FindUnitsInRadius(caster,otherworldOrigin,350)
		if #targetsFirst > 0 then 
			if caster.thtd_hecatia_otherworld_think_lock ~= true then
				caster.thtd_hecatia_otherworld_think_lock = true
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_otherworld.vpcf", PATTACH_CUSTOMORIGIN, nil)
				local time = 3.0				
				local clearGroup = {}
				caster:SetContextThink(DoUniqueString("ability_hecatia_otherworld_think"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						if time <= 0 or caster==nil or caster:IsNull()==true or caster:IsAlive()==false or caster:THTD_IsHidden() then
							for k,v in pairs(clearGroup) do
								if v~=nil and v:IsNull()==false and v:IsAlive() then
									FindClearSpaceForUnit(v, v:GetOrigin(), false)
								end								
							end			
							clearGroup = {}			
							caster.thtd_hecatia_otherworld_think_lock = false
							ParticleManager:DestroyParticleSystem(effectIndex,true)
							return nil
						end

						local cur_origin = caster.thtd_hecatia_ball_table["otherworld"]["CurPoint"]
						local targets = THTD_FindUnitsInRadius(caster,cur_origin,500)
						clearGroup = targets
						for k,v in pairs(targets) do
							local forward = (Vector(cur_origin.x,cur_origin.y,0)-v:GetAbsOrigin()):Normalized()
							v:SetAbsOrigin(v:GetOrigin()+forward*100)
							UnitStunTarget(caster,v,0.2)							
							local damage = caster:THTD_GetPower()*caster:THTD_GetStar()*0.3		
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

						ParticleManager:SetParticleControl(effectIndex , 0, cur_origin)
						ParticleManager:SetParticleControl(effectIndex , 2, cur_origin)
						time = time - 0.3
						return 0.3
					end,
				0)

				if caster.thtd_hecatia_triangle_count == nil or caster.thtd_hecatia_triangle_count == 2 then
					if caster.thtd_hecatia_ball_midOrigin~=nil then
						OnHecatiaCreateTriangle(keys,caster.thtd_hecatia_ball_midOrigin+Vector(math.cos(RandomFloat(math.pi/3,math.pi))*500,math.sin(RandomFloat(math.pi/3,math.pi))*500,64))
					end
				end
			end
		end
	else
		local targetsFirst = THTD_FindUnitsInRadius(caster,otherworldOrigin,350)
		if #targetsFirst > 0 then 
			if caster.thtd_hecatia_otherworld_hit_lock ~= true then
				caster.thtd_hecatia_otherworld_hit_lock = true
				caster.thtd_hecatia_otherworld_hit_list = {}
				caster:SetContextThink(DoUniqueString("ability_hecatia_hit_delay"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						caster.thtd_hecatia_otherworld_hit_lock = false					
						return nil
					end,
				0.5)

				for i=1,12 do
					local forward1 = Vector(math.cos(i*math.pi/6),math.sin(i*math.pi/6),0)
					local forward2 = Vector(math.cos(i*math.pi/6+math.pi/2),math.sin(i*math.pi/6+math.pi/2),0)
					local info = 
					{
							Ability = keys.ability,
							EffectName = "particles/heroes/thtd_hecatia/ability_hecatia_otherworld_projectile.vpcf",
							vSpawnOrigin = otherworldOrigin + forward1 * 100 + Vector(0,0,128),
							fDistance = 350,
							fStartRadius = 150,
							fEndRadius = 150,
							Source = caster,
							bHasFrontalCone = false,
							bReplaceExisting = false,
							iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
							iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
							iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							fExpireTime = GameRules:GetGameTime() + 10.0,
							bDeleteOnHit = false,
							vVelocity = forward2 * 500,
							bProvidesVision = true,
							iVisionRadius = 1000,
							iVisionTeamNumber = caster:GetTeamNumber()
					}
					local projectile = ProjectileManager:CreateLinearProjectile(info)
					ParticleManager:DestroyLinearProjectileSystem(projectile,false)
				end

			end
		end
	end
end

function OnHecatiaProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target	

	for k,v in pairs(caster.thtd_hecatia_otherworld_hit_list) do
		if v == target then 
			return
		end
	end
	
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 5
	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_NONE,		
   	}
	UnitDamageTarget(DamageTable)
	table.insert(caster.thtd_hecatia_otherworld_hit_list, target)
end

function OnHecatia04Think(keys)
	if GameRules:IsGamePaused() then return end
	if keys.ability:GetLevel() < 1 then return end

	local caster = EntIndexToHScript(keys.caster_entindex)
	local randomType = RandomInt(1,3)

	caster:SetModel(thtd_hecatia_model_list[randomType])
	caster:SetOriginalModel(thtd_hecatia_model_list[randomType])

	caster.thtd_hecatia_change_type = randomType	
end

function OnHecatiaCreateTriangle(keys,point)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster:FindAbilityByName("thtd_hecatia_04"):GetLevel() < 1 then return end
	
	if caster.thtd_hecatia_triangle_count == nil then
		caster.thtd_hecatia_triangle_count = 0
	end

	if caster.thtd_hecatia_triangle_table == nil then
		caster.thtd_hecatia_triangle_table = {}
	end

	if caster.thtd_hecatia_triangle_count < 3 then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_04_triangle.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(effectIndex , 0, point)
		ParticleManager:SetParticleControl(effectIndex , 3, point)
		-- ParticleManager:DestroyParticleSystem(effectIndex,false)
		caster.thtd_hecatia_triangle_count = caster.thtd_hecatia_triangle_count + 1
		caster.thtd_hecatia_triangle_table[caster.thtd_hecatia_triangle_count] = {}
		caster.thtd_hecatia_triangle_table[caster.thtd_hecatia_triangle_count]["EffectIndex"] = effectIndex
		caster.thtd_hecatia_triangle_table[caster.thtd_hecatia_triangle_count]["Origin"] = point
	end
end

function OnHecatiaTriggerTriangle(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	if caster.thtd_hecatia_triangle_count == nil then
		caster.thtd_hecatia_triangle_count = 0
	end

	if caster.thtd_hecatia_triangle_table == nil then
		caster.thtd_hecatia_triangle_table = {}
	end

	if caster.thtd_hecatia_triangle_count >= 3 then
		local time = 5
		local count = 0
		local triangleTable = caster.thtd_hecatia_triangle_table
		caster.thtd_hecatia_04_lock = true

		caster:SetContextThink(DoUniqueString("ability_hecatia_triangle_think"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if time <= 0 or caster==nil or caster:IsNull()==true or caster:IsAlive()==false or caster:THTD_IsHidden() then
					ParticleManager:DestroyParticleSystem(caster.thtd_hecatia_triangle_table[1]["EffectIndex"],true)
					ParticleManager:DestroyParticleSystem(caster.thtd_hecatia_triangle_table[2]["EffectIndex"],true)
					ParticleManager:DestroyParticleSystem(caster.thtd_hecatia_triangle_table[3]["EffectIndex"],true)
					triangleTable = {}
					caster.thtd_hecatia_triangle_table = {}
					caster.thtd_hecatia_triangle_count = 0
					caster.thtd_hecatia_04_lock = false
					return nil
				end

				if count < 3 then
					count = count + 1

					local countNext = count + 1
					if countNext > 3 then
						countNext = 1
					end

					local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_04_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

					ParticleManager:SetParticleControl(effectIndex , 0, triangleTable[count]["Origin"])
					ParticleManager:SetParticleControl(effectIndex , 1, triangleTable[countNext]["Origin"])
					ParticleManager:SetParticleControl(effectIndex , 9, triangleTable[count]["Origin"])
					ParticleManager:DestroyParticleSystem(effectIndex,false)

					local distance = GetDistanceBetweenTwoVec2D(triangleTable[count]["Origin"], triangleTable[countNext]["Origin"])
					local speed = 3000
					local delayTime = distance / speed

					time = time - delayTime
					return delayTime
				else
					local center,radius = GetCircleCenterAndRadius(triangleTable[1]["Origin"],triangleTable[2]["Origin"],triangleTable[3]["Origin"]) 
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_04_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

					ParticleManager:SetParticleControl(effectIndex , 0, triangleTable[1]["Origin"])
					ParticleManager:SetParticleControl(effectIndex , 1, caster.thtd_hecatia_ball_midOrigin)
					ParticleManager:SetParticleControl(effectIndex , 9, triangleTable[1]["Origin"])
					ParticleManager:DestroyParticleSystem(effectIndex,false)

		            local distance = GetDistanceBetweenTwoVec2D(triangleTable[1]["Origin"], caster.thtd_hecatia_ball_midOrigin)
					local speed = 3000
					local delayTime = distance / speed

					caster:SetContextThink(DoUniqueString("ability_hecatia_04_delay"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							local targets = THTD_FindUnitsInRadius(caster,center,radius)
							for k,v in pairs(targets) do
								local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hecatia/ability_hecatia_04_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

								ParticleManager:SetParticleControl(effectIndex , 0, caster.thtd_hecatia_ball_midOrigin)
								ParticleManager:SetParticleControlEnt(effectIndex , 1, v, 5, "attach_hitloc", Vector(0,0,0), true)
								ParticleManager:SetParticleControl(effectIndex , 9, caster.thtd_hecatia_ball_midOrigin)
								ParticleManager:DestroyParticleSystem(effectIndex,false)

								local damage = caster:THTD_GetPower()*caster:THTD_GetStar()*10

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
							return nil
						end,
					delayTime)

					count = 0

					time = time - 1.0
					return 1.0
				end
				time = time - 1.0
				return 1.0
			end,
		0)
	end
end

function GetHecatiaBallCount(caster)
	if caster.thtd_hecatia_ball_table == nil then return 0 end
	local count = 0
	if caster.thtd_hecatia_ball_table["earth"] ~= nil then 
		count = count + 1
	end
	if caster.thtd_hecatia_ball_table["moon"] ~= nil then 
		count = count + 1
	end
	if caster.thtd_hecatia_ball_table["otherworld"] ~= nil then 
		count = count + 1
	end
	return count
end