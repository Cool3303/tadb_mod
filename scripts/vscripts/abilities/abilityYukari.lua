-- 代替触发器
local UnitMoveRect = {
	[0] = {
		[1] = {			
			["center"] = {-2200, 1550},
			["radius"] = 200,
			["tag"] = {2}
		},
		[2] = {		
			["center"] = {-4100, 1600},
			["radius"] = 100,					
			["tag"] = {3}
		},
		[3] = {			
			["center"] = {-4100, 4120},
			["radius"] = 100,		
			["tag"] = {4}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4}
		},
	}, 
	[1] = {
		[1] = {			
			["center"] = {2200, 1550},
			["radius"] = 200,
			["tag"] = {2}
		},
		[2] = {		
			["center"] = {4100, 1600},
			["radius"] = 100,					
			["tag"] = {3}
		},
		[3] = {			
			["center"] = {4100, 4120},
			["radius"] = 100,		
			["tag"] = {4}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4}
		},
	}, 
	[2] = {
		[1] = {			
			["center"] = {2200, -1550},
			["radius"] = 200,
			["tag"] = {2}
		},
		[2] = {		
			["center"] = {4100, -1600},
			["radius"] = 100,					
			["tag"] = {3}
		},
		[3] = {			
			["center"] = {4100, -4120},
			["radius"] = 100,		
			["tag"] = {6}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4}
		},
	}, 
	[3] = {
		[1] = {			
			["center"] = {-2200, -1550},
			["radius"] = 200,
			["tag"] = {2}
		},
		[2] = {		
			["center"] = {-4100, -1600},
			["radius"] = 100,					
			["tag"] = {3}
		},
		[3] = {			
			["center"] = {-4100, -4120},
			["radius"] = 100,		
			["tag"] = {6}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4}
		},
	}	
}

function OnYukari01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_yukari_01_hidden_table == nil then
		caster.thtd_yukari_01_hidden_table = {}
	end

	if target.thtd_yukari_01_hidden_count == nil then
		target.thtd_yukari_01_hidden_count = 0
	end

	if caster.thtd_yukari_01_stock == nil then
		caster.thtd_yukari_01_stock = 3
	end

	if #caster.thtd_yukari_01_hidden_table < caster.thtd_yukari_01_stock and target.thtd_yukari_01_hidden_count < 2 then
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_yukari_01_hidden", nil)
		target:AddNoDraw()
		target.thtd_is_yukari_01_hidden = true
		target.thtd_yukari_01_hidden_count = target.thtd_yukari_01_hidden_count + 1
		table.insert(caster.thtd_yukari_01_hidden_table,target)

		target:SetContextThink(DoUniqueString("thtd_yukari_01_death"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if caster==nil or caster:IsNull() or caster:IsAlive() == false then
					target:RemoveNoDraw()
					target:RemoveModifierByName("modifier_yukari_01_hidden")
					target.thtd_is_yukari_01_hidden = false
					return nil
				end
				return 1.0
			end, 
		1.0)
	end

	local unit = CreateUnitByName(
		"npc_thdots_unit_yukari01_unit"
		,target:GetOrigin()
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_02_vortex_2.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleControl(effectIndex, 0, unit:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	unit:EmitSound("Hero_ObsidianDestroyer.AstralImprisonment")

	unit:SetContextThink(DoUniqueString("thtd_yukari_01_release"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if unit:IsAlive() then
				unit:ForceKill(false)
				return 0.5
			else
				unit:AddNoDraw()
				return nil
			end
		end, 
	1.0)
end

function OnYukari02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_yukari_01_hidden_table == nil then
		caster.thtd_yukari_01_hidden_table = {}
	end

	if #caster.thtd_yukari_01_hidden_table > 0 then
		for k,v in pairs(caster.thtd_yukari_01_hidden_table) do
			if v~=nil and v:IsNull()==false and v:IsAlive() then
				OnYukari02SpellDropUnit(keys,v)
				table.remove(caster.thtd_yukari_01_hidden_table,k)
				break
			else
				table.remove(caster.thtd_yukari_01_hidden_table,k)
			end
		end
	end
end

function OnYukari02SpellDropUnit(keys,unit)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local g = -5
	local high = 500
	local v = 0
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
	local currentOrigin = targetPoint + Vector(0,0,high)
	local minHigh = caster:GetOrigin().z
	local isRemove = false

	unit:SetAbsOrigin(currentOrigin)
	unit.thtd_is_yukari_01_hidden = false
	if GetDistanceBetweenTwoVec2D(unit.first_move_point, targetPoint) < 2000 then 
		unit.next_move_point = unit.first_move_point
		unit.next_move_forward = unit.first_move_forward
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_02_body.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 3, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	EmitSoundOnLocationWithCaster(currentOrigin,"Hero_ObsidianDestroyer.AstralImprisonment.End",caster)

	caster:SetContextThink(DoUniqueString("ability_yuuka_02"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			v = v + g
			currentOrigin = currentOrigin + Vector(0,0,v)
			if unit~=nil and unit:IsNull()==false and unit:IsAlive() then
				if GetDistanceBetweenTwoVec2D(unit:GetOrigin(),currentOrigin) < 100 and isRemove == false then
					unit:RemoveNoDraw()
					isRemove = true
				end
				unit:SetAbsOrigin(currentOrigin)
			end

			if currentOrigin.z >= minHigh then
				return 0.02
			else
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_02_down.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 3, currentOrigin)
				ParticleManager:DestroyParticleSystem(effectIndex,false)
				EmitSoundOnLocationWithCaster(currentOrigin,"Ability.TossImpact",caster)

				if unit~=nil and unit:IsNull()==false and unit:IsAlive() then
					unit:RemoveModifierByName("modifier_yukari_01_hidden")
					FindClearSpaceForUnit(unit, currentOrigin, false)
				end
				if caster~=nil then
					local targets = THTD_FindUnitsInRadius(caster,currentOrigin,300)
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
		   				UnitStunTarget(caster,v,0.5)
					end
				end
				return nil
			end
		end, 
	0)
end


-- 无比丑陋
function OnYukari03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local targetPoint = keys.target_points[1]

	local e1 = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_04_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(e1, 0, caster:GetOrigin())

	local e2 = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_04_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(e2, 0, targetPoint)

	caster:EmitSound("Hero_Enigma.BlackHole.Cast.Chasm")
	caster:EmitSound("Hero_Enigma.Black_Hole")

	local isFirst = false

	caster:SetContextThink(DoUniqueString("OnYuuka03SpellStart"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			ParticleManager:DestroyParticleSystem(e1,true)
			ParticleManager:DestroyParticleSystem(e2,true)
			local targets = 
				FindUnitsInRadius(
					caster:GetTeamNumber(), 
					caster:GetOrigin(), 
					nil, 
					2000, 
					keys.ability:GetAbilityTargetTeam(), 
					keys.ability:GetAbilityTargetType(), 
					keys.ability:GetAbilityTargetFlags(), 
					FIND_ANY_ORDER, 
					false
				)

			for k,v in pairs(targets) do
				if v:THTD_IsTower() and (v:GetUnitName()=="yukari" or v:GetUnitName()=="ran" or v:GetUnitName()=="chen") then
					if v:THTD_IsHidden() == false then
						local vecOrigin = v:GetOrigin()
						v:SetAbsOrigin(targetPoint)
						v:AddNoDraw()
						local unit = CreateUnitByName(
							"npc_thdots_unit_yukari01_unit"
							,vecOrigin
							,false
							,caster
							,caster
							,caster:GetTeam()
						)
						local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
						ability_dummy_unit:SetLevel(1)
						local effectIndex = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_02_vortex_2.vpcf", PATTACH_CUSTOMORIGIN, unit)
						ParticleManager:SetParticleControl(effectIndex, 0, unit:GetOrigin())
						ParticleManager:DestroyParticleSystem(effectIndex,false)

						unit:SetContextThink(DoUniqueString("thtd_yukari_01_release"), 
							function()
								if GameRules:IsGamePaused() then return 0.03 end
								if unit:IsAlive() then
									unit:ForceKill(false)
									return 0.5
								else
									unit:AddNoDraw()
									return nil
								end
							end, 
						1.0)

						v:SetContextThink(DoUniqueString("FindClearSpaceForUnit"), 
							function()
								if GetDistanceBetweenTwoVec2D(v:GetOrigin(),targetPoint) < 100 then
									v:RemoveNoDraw()
									FindClearSpaceForUnit(v, targetPoint, false)
									v:THTD_DestroyLevelEffect()
									v:THTD_CreateLevelEffect()
									return nil
								end
								return 0.03
							end,
						0.03)

						v:SetContextThink(DoUniqueString("thtd_yukari_03_back"), 
								function()
									if isFirst == false then
										isFirst = true
										local e1 = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_04_magical.vpcf", PATTACH_CUSTOMORIGIN, nil)
										ParticleManager:SetParticleControl(e1, 0, targetPoint)
										ParticleManager:DestroyParticleSystemTime(e1,1.0)

										local e2 = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_04_magical.vpcf", PATTACH_CUSTOMORIGIN, nil)
										ParticleManager:SetParticleControl(e2, 0, vecCaster)
										ParticleManager:DestroyParticleSystemTime(e2,1.0)

										caster:EmitSound("Hero_Enigma.BlackHole.Cast.Chasm")
										caster:EmitSound("Hero_Enigma.Black_Hole")
									end
									v:SetContextThink(DoUniqueString("OnYuuka03SpellEnd"), 
										function()
											if GameRules:IsGamePaused() then return 0.03 end
											if v:THTD_IsHidden() == false then
												local unit = CreateUnitByName(
													"npc_thdots_unit_yukari01_unit"
													,v:GetOrigin()
													,false
													,caster
													,caster
													,caster:GetTeam()
												)
												local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
												ability_dummy_unit:SetLevel(1)
												local effectIndex = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_02_vortex_2.vpcf", PATTACH_CUSTOMORIGIN, unit)
												ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
												ParticleManager:DestroyParticleSystem(effectIndex,false)

												v:SetAbsOrigin(vecOrigin)
												v:AddNoDraw()
												v:EmitSound("Hero_Enigma.Black_Hole.Stop")
												caster:StopSound("Hero_Enigma.BlackHole.Cast.Chasm")
												caster:StopSound("Hero_Enigma.Black_Hole")

												unit:SetContextThink(DoUniqueString("thtd_yukari_01_release"), 
													function()
														if GameRules:IsGamePaused() then return 0.03 end
														if unit:IsAlive() then
															unit:ForceKill(false)
															return 0.5
														else
															unit:AddNoDraw()
															return nil
														end
													end, 
												1.0)

												v:SetContextThink(DoUniqueString("FindClearSpaceForUnit"), 
													function()
														if GetDistanceBetweenTwoVec2D(v:GetOrigin(),vecOrigin) < 100 then
															v:RemoveNoDraw()
															FindClearSpaceForUnit(v, vecOrigin, false)
															v:THTD_DestroyLevelEffect()
															v:THTD_CreateLevelEffect()
															return nil
														end
														return 0.03
													end,
												0.03)
											end
										return nil
									end,
								1.0)
								return nil
							end,
						3.0)
					end
				end
			end

			caster:StopSound("Hero_Enigma.BlackHole.Cast.Chasm")
			caster:StopSound("Hero_Enigma.Black_Hole")
			caster:EmitSound("Hero_Enigma.Black_Hole.Stop")
			return nil
		end,
	1.0)
end


local thtd_yukari_04_train_spwan = 
{
	[1] = 
	{
		["spawn"]	= Vector(-1408,1056,136) * 1.5 + Vector(500,0,0),
		["firstPoint"]	= Vector(-1408,1056,136) * 1.5,
		["firstForward"] = "left",
		["forward"] = Vector(-1,0,0),
	},
	[2] = 
	{
		["spawn"]	= Vector(1408,1056,136) * 1.5 + Vector(-500,0,0),
		["firstPoint"]	= Vector(1408,1056,136) * 1.5,
		["firstForward"] = "right",
		["forward"] = Vector(1,0,0),
	},
	[3] = 
	{
		["spawn"]	= Vector(1408,-1056,136) * 1.5 + Vector(-500,0,0),
		["firstPoint"]	= Vector(1408,-1056,136) * 1.5,
		["firstForward"] = "right",
		["forward"] = Vector(-1,0,0),
	},
	[4] = 
	{
		["spawn"]	= Vector(-1408,-1056,136) * 1.5 + Vector(500,0,0),
		["firstPoint"]	= Vector(-1408,-1056,136) * 1.5,
		["firstForward"] = "left",
		["forward"] = Vector(1,0,0),
	},
}

function OnYukari04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_yukari_tram_count == nil then
		caster.thtd_yukari_tram_count = 4
	end
	
	local originSpawn = thtd_yukari_04_train_spwan[caster:GetOwner():GetPlayerOwnerID()+1]["spawn"]
	local originPoint = thtd_yukari_04_train_spwan[caster:GetOwner():GetPlayerOwnerID()+1]["firstPoint"]
	local originForward = thtd_yukari_04_train_spwan[caster:GetOwner():GetPlayerOwnerID()+1]["firstForward"]
	local forward = thtd_yukari_04_train_spwan[caster:GetOwner():GetPlayerOwnerID()+1]["forward"]

	caster:EmitSound("Sound_THTD.thtd_yukari_04")

	local train = CreateUnitByName(
		"yukari_train", 
		originSpawn, 
		false, 
		caster:GetOwner(), 
		caster:GetOwner(), 
		caster:GetTeam() 
	)
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yukari/ability_yukari_04_door.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, originSpawn-forward*400)
	ParticleManager:SetParticleControl(effectIndex, 3, originSpawn-forward*400)
	ParticleManager:SetParticleControlForward(effectIndex, 3, forward)
	ParticleManager:SetParticleControl(effectIndex, 4, originSpawn-forward*400)
	ParticleManager:SetParticleControlForward(effectIndex, 4, forward)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	train:AddNewModifier(train, nil, "modifier_move_max_speed", nil)
	train:SetAbsOrigin(originSpawn)
	train:SetForwardVector(forward)
	train.next_move_point = originPoint
	train.firstForward = originForward
	train.next_corner_table = {}
	train.FirstTrain = nil

	local timecount = 100
	train:SetContextThink(DoUniqueString("AttackingBase"), 
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			if timecount > 0 then
				local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 3.3
				local targets = THTD_FindUnitsInRadius(caster,train:GetOrigin(),200)

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
	   				UnitStunTarget(caster,v,0.5)
				end
				local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_04_boom.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex2, 3, train:GetOrigin()-train:GetForwardVector()*100)
				ParticleManager:DestroyParticleSystem(effectIndex2,false)
				timecount = timecount - 1
				train:MoveToPosition(train.next_move_point)
				if timecount%10 == 0 then
					train:EmitSound("Sound_THTD.thtd_yukari_04.loop")
				end

				-- 替代触发器
				-- local id = caster:GetPlayerOwnerID()
				-- for k,v in pairs(UnitMoveRect[id]) do
				-- 	if GetDistanceBetweenTwoVec2D(train:GetOrigin(), Vector(v["center"][1],v["center"][2]),0) <= v["radius"] then 
				-- 		if train.current_rect_id ~= k then 
				-- 			train.current_rect_id = k
				-- 			local tagIndex = v["tag"][RandomInt(1, #v["tag"])]
				-- 			train.next_move_point = Vector(UnitMoveRect[id][tagIndex]["center"][1],UnitMoveRect[id][tagIndex]["center"][2],0)
				-- 			train:MoveToPosition(train.next_move_point)
				-- 		end
				-- 		break
				-- 	end								
				-- end

				return 0.3
			else
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yukari/ability_yukari_04_door.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, train:GetOrigin())
				ParticleManager:SetParticleControl(effectIndex, 3, train:GetOrigin())
				ParticleManager:SetParticleControlForward(effectIndex, 3, train:GetForwardVector())
				ParticleManager:SetParticleControl(effectIndex, 4, train:GetOrigin())
				ParticleManager:SetParticleControlForward(effectIndex, 4, train:GetForwardVector())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
				train:ForceKill(true)
				train:AddNoDraw()
				return nil
			end
		end, 
	0) 

	local count = caster.thtd_yukari_tram_count
	caster:SetContextThink(DoUniqueString("OnYukari04SpellStart"), 
		function()
			local nexttrain = CreateUnitByName(
				"yukari_train", 
				originSpawn, 
				false, 
				caster:GetOwner(), 
				caster:GetOwner(), 
				caster:GetTeam() 
			)

			nexttrain:AddNewModifier(nexttrain, nil, "modifier_move_max_speed", nil)
			nexttrain:SetAbsOrigin(originSpawn)
			nexttrain.next_move_point = originPoint
			nexttrain.firstForward = originForward
			nexttrain.FirstTrain = train
			nexttrain:SetForwardVector(forward)

			local nexttimecount = 100
			nexttrain:SetContextThink(DoUniqueString("AttackingBase"), 
				function ()
					if GameRules:IsGamePaused() then return 0.03 end
					if nexttimecount > 0 and nexttrain~=nil and nexttrain:IsNull()==false and nexttrain:IsAlive() then
						local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 3.3
						local targets = THTD_FindUnitsInRadius(caster,nexttrain:GetOrigin(),200)
						
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
			   				UnitStunTarget(caster,v,0.5)
						end
						local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/yukari/ability_yukari_04_boom.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(effectIndex2, 3, nexttrain:GetOrigin()-nexttrain:GetForwardVector()*100)
						ParticleManager:DestroyParticleSystem(effectIndex2,false)
						nexttimecount = nexttimecount - 1
						if nexttrain.next_move_point ~= nil then
							nexttrain:MoveToPosition(nexttrain.next_move_point)
						end

						-- 替代触发器
						-- local id = caster:GetPlayerOwnerID()
						-- for k,v in pairs(UnitMoveRect[id]) do
						-- 	if GetDistanceBetweenTwoVec2D(nexttrain:GetOrigin(), Vector(v["center"][1],v["center"][2]),0) <= v["radius"] then 
						-- 		if nexttrain.current_rect_id ~= k then 
						-- 			nexttrain.current_rect_id = k
						-- 			local tagIndex = v["tag"][RandomInt(1, #v["tag"])]
						-- 			nexttrain.next_move_point = Vector(UnitMoveRect[id][tagIndex]["center"][1],UnitMoveRect[id][tagIndex]["center"][2],0)
						-- 			nexttrain:MoveToPosition(nexttrain.next_move_point)
						-- 		end
						-- 		break
						-- 	end								
						-- end

						return 0.3
					else
						nexttrain:ForceKill(true)
						nexttrain:AddNoDraw()
						return nil
					end
				end, 
			0) 

			if count > 0 then
				count = count - 1
				return 0.2
			else
				return nil
			end
		end,
	0)
end