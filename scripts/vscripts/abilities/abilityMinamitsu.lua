function OnMinamitsu01DebuffThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_minamitsu_01_rect ~= nil and caster.thtd_minamitsu_01_rect["rectOrigin"] ~= nil then
		if caster:THTD_IsHidden() then
			for k,v in pairs(caster.thtd_minamitsu_01_rect["effectIndexList"]) do
				ParticleManager:DestroyParticleSystem(v,true)
			end
			caster.thtd_minamitsu_01_rect = 
			{	
				["rectOrigin"]	= nil,
				["rectForward"] = nil,
				["effectIndexList"] = {}
			}
		else
			local enemies = FindUnitsInLine(
					caster:GetTeamNumber(),
					caster.thtd_minamitsu_01_rect["rectOrigin"],
					caster.thtd_minamitsu_01_rect["rectOrigin"]+caster.thtd_minamitsu_01_rect["rectForward"]*2300, 
					nil, 
					300, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				0)
			for k,v in pairs(enemies) do
				local modifier = v:FindModifierByName("modifier_minamitsu_01_slow_buff")
			   	if modifier == nil then
					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_minamitsu_01_slow_buff", {duration=0.2})
				else
					modifier:SetDuration(0.2,false)
				end
			end
		end
	end
end

function OnMinamitsu01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target:GetOrigin()
	local forward = -keys.target:GetForwardVector()

	if caster.thtd_minamitsu_01_rect == nil then
		caster.thtd_minamitsu_01_rect = {}
	end

	if caster.thtd_minamitsu_01_rect["effectIndexList"] ~= nil then
		for k,v in pairs(caster.thtd_minamitsu_01_rect["effectIndexList"]) do
			ParticleManager:DestroyParticleSystem(v,true)
		end
	end

	caster.thtd_minamitsu_01_rect = 
	{	
		["rectOrigin"]	= targetPoint-forward*300,
		["rectForward"] = forward,
		["effectIndexList"] = {}
	}

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_minamitsu/ability_minamitsu_01_ship.vpcf", PATTACH_CUSTOMORIGIN, caster)
   	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
   	ParticleManager:SetParticleControl(effectIndex, 1, forward*500)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local time = 4
	caster:SetContextThink(DoUniqueString("thtd_minamitsu_01_move_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time > 0	then
				time = time - 0.2
				local waterIndex = ParticleManager:CreateParticle("particles/heroes/thtd_minamitsu/ability_minamitsu_01_ship_water.vpcf", PATTACH_CUSTOMORIGIN, caster)
			   	ParticleManager:SetParticleControl(waterIndex, 3, targetPoint+forward*500*(4 - time))
			   	table.insert(caster.thtd_minamitsu_01_rect["effectIndexList"],waterIndex)
				return 0.2
			else
				return nil
			end
			return 0.2
		end,
	0)
end

function OnMinamitsu02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

 	-- local effectIndex = ParticleManager:CreateParticle("particles/heroes/minamitsu/ability_minamitsu_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
	-- ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_minamitsu_attack", Vector(0,0,0), true)

	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/minamitsu/ability_minamitsu_03_body.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 3, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex2 , 4, caster, 5, "follow_origin", Vector(0,0,0), true)

	-- ParticleManager:DestroyParticleSystemTime(effectIndex,7.0)
	ParticleManager:DestroyParticleSystemTime(effectIndex2,7.0)

	if caster.thtd_minamitsu_02_bonus == nil then
		caster.thtd_minamitsu_02_bonus = 1.0
	end

	local bonus = caster:THTD_GetPower()/2 * caster.thtd_minamitsu_02_bonus

	if caster:THTD_IsTower() and caster.thtd_minamitsu_02_bonus == false then
		caster:THTD_AddPower(bonus)
		caster:THTD_AddAttack(bonus)
		caster.thtd_minamitsu_02_bonus = true

		caster:SetContextThink(DoUniqueString("thtd_minamitsu_02_buff_remove"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				caster:THTD_AddPower(-bonus)
				caster:THTD_AddAttack(-bonus)
				caster.thtd_minamitsu_02_bonus = false
			end,
		7.0)
	end
end

function OnMinamitsu02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local target = keys.target

	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),keys.Radius)

    for k,v in pairs(targets) do
    	local damage_table = {
    		ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = caster:THTD_GetPower()*caster:THTD_GetStar(),
			damage_type = keys.ability:GetAbilityDamageType(), 
		    damage_flags = keys.ability:GetAbilityTargetFlags()
		}
		UnitDamageTarget(damage_table) 
    end
   	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_weapon/kunkka_spell_tidebringer_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
   	ParticleManager:SetParticleControl(effectIndex, 0, vecCaster)
   	ParticleManager:SetParticleControlForward(effectIndex, 0, caster:GetForwardVector())
	ParticleManager:SetParticleControl(effectIndex, 18, vecCaster)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnMinamitsu03SpellStart(keys)
	if keys.ability:GetLevel()<1 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.thtd_minamitsu_01_rect == nil then return end
	if caster.thtd_minamitsu_01_rect["rectOrigin"] == nil then return end

	local targetPoint = keys.target_points[1]
	if IsRadInRect(targetPoint,caster.thtd_minamitsu_01_rect["rectOrigin"],300,3300,math.acos(caster.thtd_minamitsu_01_rect["rectForward"].x)) then
		local vecCaster = caster:GetOrigin()
		local distance = GetDistanceBetweenTwoVec2D(vecCaster,targetPoint)
		local speed = distance * 0.03
		local rad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
		local vecHook = caster:GetOrigin()
		local forwardVector = caster:GetForwardVector()
		local timeCount = 0

		local effectIndex = ParticleManager:CreateParticle("particles/heroes/minamitsu/ability_minamitsu_02_body.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(effectIndex, 3, vecHook)
		ParticleManager:SetParticleControlForward(effectIndex, 3, forwardVector)

		caster:SetContextThink(
			DoUniqueString("ability_thdots_minamitsu_02_stage_01"),
				function ()
					if GameRules:IsGamePaused() then
						return 0.03
					end
					timeCount = timeCount + 0.03
					distance = distance - speed
					if distance >= 0 then
						vecHook =  vecHook + Vector(math.cos(rad)*speed,math.sin(rad)*speed,0)
						ParticleManager:SetParticleControl(effectIndex, 3, vecHook)
					else
						ParticleManager:DestroyParticleSystem(effectIndex,true)
						local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/minamitsu/ability_minamitsu_02.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(effectIndex2, 0, vecHook)
						ParticleManager:SetParticleControl(effectIndex2, 3, vecHook)
						Timer.Wait 'OnMinamitsu02Vortex' (0.5,
							function()
								caster:EmitSound("Voice_Thdots_Minamitsu.AbilityMinamitsu022")
								OnMinamitsu02Vortex(keys,caster.thtd_minamitsu_01_rect["rectOrigin"],caster.thtd_minamitsu_01_rect["rectForward"])
							end
						)
						Timer.Wait 'OnMinamitsu02Vortex' (3.2,
							function()
								ParticleManager:SetParticleControl(effectIndex2, 0, caster.thtd_minamitsu_01_rect["rectOrigin"]+caster.thtd_minamitsu_01_rect["rectForward"]*2000)
								ParticleManager:SetParticleControl(effectIndex2, 3, caster.thtd_minamitsu_01_rect["rectOrigin"]+caster.thtd_minamitsu_01_rect["rectForward"]*2000)
							end
						)
						return nil
					end
					return 0.03
				end,
			0.03
		)
	else
		keys.ability:EndCooldown()
	end
end

function OnMinamitsu02Vortex(keys,origin,forward)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = keys.target_points[1]
	local distance = GetDistanceBetweenTwoVec2D(vecCaster,targetPoint)
	local rad = GetRadBetweenTwoVec2D(vecCaster,targetPoint)
	local timeCount = 0
	caster.ability_minamitsu_02_group = {}

	caster:SetContextThink(
		DoUniqueString("ability_thdots_minamitsu_02_stage_02"),
			function ()
				if GameRules:IsGamePaused() then
					return 0.03
				end
				timeCount = timeCount + 0.03
				local targets = THTD_FindUnitsInRadius(caster,targetPoint,340)
			    for k,v in pairs(targets) do
			    	if v:IsNull() == false and v~=nil then
						local damage_table = {
							ability = keys.ability,
							victim = v,
							attacker = caster,
							damage = caster:THTD_GetPower() * caster:THTD_GetStar()/8,
							damage_type = keys.ability:GetAbilityDamageType(), 
						    damage_flags = keys.ability:GetAbilityTargetFlags()
						}
						UnitDamageTarget(damage_table) 
			    		table.insert(caster.ability_minamitsu_02_group,v)

			    		if v:HasModifier("modifier_minamitsu02_pause") == false then
			    			keys.ability:ApplyDataDrivenModifier( caster, v, "modifier_minamitsu02_pause", {} )
			    		end
			    		if v:HasModifier("modifier_minamitsu02_vortex_target") == false then
					    	local vecTarget = v:GetOrigin()
					    	local distance = GetDistanceBetweenTwoVec2D(vecTarget,targetPoint)
					    	local targetRad = GetRadBetweenTwoVec2D(targetPoint,vecTarget)
					    	if distance>30 then
					    		v:SetOrigin(Vector(vecTarget.x - math.cos(targetRad - math.pi/3) * 11 *1.5, vecTarget.y - math.sin(targetRad - math.pi/3) * 11 *1.5, vecTarget.z))
					    	else
					    		v:AddNoDraw()
					    		keys.ability:ApplyDataDrivenModifier( caster, v, "modifier_minamitsu02_vortex_target", {} )
					    		keys.ability:ApplyDataDrivenModifier( caster, v, "modifier_minamitsu02_vortex_pause_target", {} )
					    		v:SetOrigin(v:GetOrigin()+RandomVector(100)+Vector(0,0,128))
					    	end
					    end
				    end
			    end
			    if timeCount >= 1.5 then
			    	Timer.Wait 'OnMinamitsu02Vortex_starge_2' (1.0,
						function()
							caster:EmitSound("Ability.Torrent")
							OnMinamitsu02VortexEnd(keys,origin,forward)
						end
					)
					return nil
			    end
			    return 0.03
			end,
		0.03
	)
end

function OnMinamitsu02VortexEnd(keys,origin,forward)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = origin + forward * 2300
	local speed = 2
	local g = 0.18
	local timeCount = 0

    for k,v in pairs(caster.ability_minamitsu_02_group) do
		if v:IsNull() == false and v~=nil then
			if v.thtd_is_minamitsu_03_damaged ~= true then
				v.thtd_is_minamitsu_03_damaged = true
		    	local random = RandomVector(150)
		    	v:SetOrigin(targetPoint+random)
		    end
	    end
    end

	caster:SetContextThink(
		DoUniqueString("ability_thdots_minamitsu_02_stage_02"),
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				timeCount = timeCount + 0.03
				speed = speed - g 
				if caster.ability_minamitsu_02_group ~= nil then 
				    for k,v in pairs(caster.ability_minamitsu_02_group) do
				    	if v:IsNull() == false and v~=nil then
				    		if v:HasModifier("modifier_minamitsu02_pause") then
				    			v:RemoveModifierByName("modifier_minamitsu02_pause")
				    		end
				    		if v:HasModifier("modifier_minamitsu02_vortex_target") then
				    			v:RemoveNoDraw()
				    			v:RemoveModifierByName("modifier_minamitsu02_vortex_target")
				    		end
				    		if v:HasModifier("modifier_minamitsu02_vortex_pause_target") then
				    			if v:GetOrigin().z >= GetGroundHeight(v:GetOrigin(),nil) then
				    				v:SetOrigin(v:GetOrigin() + Vector(0,0,speed))
				    			end
				    		end
					    end
				    end
				    if timeCount >= 1.0 then
				    	for k2,v2 in pairs(caster.ability_minamitsu_02_group) do
					    	if v2:HasModifier("modifier_minamitsu02_vortex_pause_target") then
					    		v2:RemoveModifierByName("modifier_minamitsu02_vortex_pause_target")
							end
							FindClearSpaceForUnit(v2, v2:GetOrigin(), false)
						end
						return nil
				    end
				end
				return 0.03
			end,
		0.03
	)
end

function OnMinamitsu04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster:HasModifier("modifier_byakuren_03_buff") then
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(15)
	end

	if caster.thtd_minamitsu_01_rect == nil then return end
	if caster.thtd_minamitsu_01_rect["rectOrigin"] == nil then return end

	local origin = caster.thtd_minamitsu_01_rect["rectOrigin"]
	local forward = caster.thtd_minamitsu_01_rect["rectForward"]

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_minamitsu/ability_minamitsu_01_ship.vpcf", PATTACH_CUSTOMORIGIN, caster)
   	ParticleManager:SetParticleControl(effectIndex, 0, origin)
   	ParticleManager:SetParticleControl(effectIndex, 1, forward*1000)
	ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)

	local time = 2
	caster:SetContextThink(DoUniqueString("thtd_minamitsu_04_move_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time > 0	then
				time = time - 0.2
			   	local targets = THTD_FindUnitsInRadius(caster,origin+forward*1000*(2 - time),300)
				for k,v in pairs(targets) do
					local DamageTable = {
			   			ability = keys.ability,
			            victim = v, 
			            attacker = caster,
			            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 6 * GetStarLotusTowerCount(caster:GetOwner()) * 0.5,
			            damage_type = keys.ability:GetAbilityDamageType(), 
			            damage_flags = DOTA_DAMAGE_FLAG_NONE
				   	}
				   	UnitDamageTarget(DamageTable)
				end
				return 0.2
			else
				return nil
			end
			return 0.2
		end,
	0)
end