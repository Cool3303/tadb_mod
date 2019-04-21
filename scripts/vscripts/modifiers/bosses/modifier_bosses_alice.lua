modifier_bosses_alice = class({})

local public = modifier_bosses_alice

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:OnCreated(kv)
	if IsServer() then
		local caster = self:GetParent()

	end
end

--------------------------------------------------------------------------------

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
			["tag"] = {4, 7}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
	}, 
	[1] = {
		[1] = {			
			["center"] = {2200, 1550},
			["radius"] = 200,
			["tag"] = {2 }
		},
		[2] = {		
			["center"] = {4100, 1600},
			["radius"] = 100,					
			["tag"] = {3 }
		},
		[3] = {			
			["center"] = {4100, 4120},
			["radius"] = 100,		
			["tag"] = {4, 7}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
	}, 
	[2] = {
		[1] = {			
			["center"] = {2200, -1550},
			["radius"] = 200,
			["tag"] = {2 }
		},
		[2] = {		
			["center"] = {4100, -1600},
			["radius"] = 100,					
			["tag"] = {3 }
		},
		[3] = {			
			["center"] = {4100, -4120},
			["radius"] = 100,		
			["tag"] = {5, 6}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
	}, 
	[3] = {
		[1] = {			
			["center"] = {-2200, -1550},
			["radius"] = 200,
			["tag"] = {2 }
		},
		[2] = {		
			["center"] = {-4100, -1600},
			["radius"] = 100,					
			["tag"] = {3 }
		},
		[3] = {			
			["center"] = {-4100, -4120},
			["radius"] = 100,		
			["tag"] = {5, 6}
		},
		[4] = {			
			["center"] = {6750, 4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[5] = {			
			["center"] = {6750, -4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
		[6] = {			
			["center"] = {-6750, -4120},
			["radius"] = 100,		
			["tag"] = {5, 7}
		},
		[7] = {			
			["center"] = {-6750, 4120},
			["radius"] = 100,		
			["tag"] = {4, 6}
		},
	}	
}

function public:OnDestroy(kv)
	if IsServer() then
		local caster = self:GetParent()
		if table.hasvalue(SpawnSystem.GameOverPlayerId, caster.thtd_player_index) then return end

		local count = 0
		local pos = caster:GetOrigin()
		local team = caster:GetTeam()
		local health = caster:GetMaxHealth()*0.3
		local armor = caster:GetPhysicalArmorBaseValue()
		local resist = caster:GetBaseMagicalResistanceValue()
		local id = caster.thtd_player_index
		local movenext = caster.next_move_point 
		local firstmove = caster.first_move_point
		local moveforward = caster.next_move_forward 
		local firstforward = caster.first_move_forward
		local nextcorner = caster.thtd_next_corner
		local firstcorner = caster.thtd_first_corner
		local currentWave = SpawnSystem.CurWave - 50	
		local damageDecrease = math.max(-25*(1+(math.min(GameRules:GetCustomGameDifficulty(),4)-1)*0.5),-currentWave*4)

		-- 异步创建 CreateUnitByNameAsync(string string_1, Vector Vector_2, bool bool_3, handle handle_4, handle handle_5, int int_6, handle handle_7)
		-- Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber, hCallback )
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("SmallAliceSpawn"),
			function()		
				if GameRules:IsGamePaused() then return 0.1 end	
				if count >= 3 then return nil end
				count = count + 1
				local unit = CreateUnitByName(
					"creature_alice_ningyou", 
					pos + RandomVector(300), 
					false, 
					nil, 
					nil, 
					team 
				)
				
				FindClearSpaceForUnit(unit, unit:GetOrigin(), false)	
				
				unit:SetBaseMaxHealth(health)
				unit:SetMaxHealth(health)
				unit:SetHealth(health)
				unit:SetPhysicalArmorBaseValue(armor)
				unit:SetBaseMagicalResistanceValue(resist)
	
				unit.thtd_player_index = id
				unit.thtd_poison_buff = 0
				
				unit:AddNewModifier(unit, nil, "modifier_phased", {duration=9999})
						
				table.insert(THTD_EntitiesRectInner[id],unit)
	
				unit.next_move_point = movenext
				unit.first_move_point = firstmove
				unit.next_move_forward = moveforward
				unit.first_move_forward = firstforward
				unit.thtd_next_corner = nextcorner
				unit.thtd_first_corner = firstcorner
				
				ModifyDamageSpecialPercentage(unit,damageDecrease)
	
				unit:SetContextThink(DoUniqueString("AttackingBase"), 
					function ()
						if unit~=nil and unit:IsNull()==false and unit:IsAlive() and unit.thtd_is_outer ~= true then
							local origin = unit:GetOrigin()
							if not(origin.x < 4432 and origin.x > -4432 and origin.y < 3896 and origin.y > -3896) then
								unit.thtd_is_outer = true
								table.insert(THTD_EntitiesRectOuter,unit)
								for k,v in pairs(THTD_EntitiesRectInner[unit.thtd_player_index]) do
									if v == unit then										
										table.remove(THTD_EntitiesRectInner[unit.thtd_player_index],k)
										break
									end
								end
							end
						end
						unit:MoveToPosition(unit.next_move_point)

						-- 替代触发器
						for k,v in pairs(UnitMoveRect[unit.thtd_player_index]) do
							if GetDistanceBetweenTwoVec2D(unit:GetOrigin(), Vector(v["center"][1],v["center"][2]),0) <= v["radius"] then 
								if unit.current_rect_id ~= k then 
									unit.current_rect_id = k
									local tagIndex = v["tag"][RandomInt(1, #v["tag"])]
									unit.next_move_point = Vector(UnitMoveRect[unit.thtd_player_index][tagIndex]["center"][1],UnitMoveRect[unit.thtd_player_index][tagIndex]["center"][2],0)
									unit:MoveToPosition(unit.next_move_point)
								end
								break
							end								
						end

						return 0.3
					end, 
				0) 

				return 0.15
			end, 
		0) 			
	end
end