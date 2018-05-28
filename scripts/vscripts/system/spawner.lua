if SpawnSystem == nil then
	SpawnSystem = {}
	SpawnSystem.Spawner = {}
	SpawnSystem.AttackingSpawner = {}
	SpawnSystem.DungeonSpawner = {}
	SpawnSystem.Difficulty = 1
	SpawnSystem.TeamNumber = 1
	SpawnSystem.Line = 4
	SpawnSystem.Base = nil
	SpawnSystem.AST = 0
	SpawnSystem.isStop = false
end

THTD_EntitiesRect ={}
THTD_EntitiesRectInner = {
	[0] = {},
	[1] = {},
	[2] = {},
	[3] = {},
}
THTD_EntitiesRectOuter = {
}
TotalWave = 0
function SpawnSystem:InitSpawn()
	SpawnSystem.Spawner = LoadKeyValues("scripts/npc/Spawner.txt")
	for i=1,200 do
		SpawnSystem.Spawner["Attacking"]["Wave"..tostring(50+i)] = 
		{
			["Unit"] = "creature_unlimited",
			["Times"] =	30,
			["BreakTime"] = 15,
			["Count"] = 1,
			["Interval"] = 0.5,
		}
	end
	SpawnSystem.DungeonSpawner = SpawnSystem.Spawner["Dungeon"]
	local PlayerNum  = 0
	for i= 0,9 do
		if PlayerResource:IsValidPlayer(i)  then
			PlayerNum = PlayerNum + 1
		end
	end
	SpawnSystem.TeamNumber = PlayerNum
	

	print("InitSpawn")
	TotalWave = table.nums(SpawnSystem.Spawner["Attacking"])

	print("TotalWave:",TotalWave)
	SpawnSystem:InitAttackSpawn()

	-- for k,v in pairs(G_path_corner) do
	-- 	THTD_EntitiesRect[k] = {}
	-- 	for direct,corner in pairs(v) do
	-- 		if direct == "up" or  direct == "down" or direct == "left" or  direct == "right"  then
	-- 			if corner~=nil then
	-- 				THTD_EntitiesRect[k][corner] = {}
	-- 			end
	-- 		end
	-- 	end
	-- end
end

-- function GetEntitiesByNumberInMatrix(corner1,corner2)
-- 	local entities = {}
-- 	if corner1 == nil then
-- 		for k,v in pairs(THTD_EntitiesRect[corner2]) do
-- 			if string.find(tostring(k),"corner") == nil then
-- 				if v==nil or v:IsNull() or v:IsAlive()==false then
-- 					table.remove(THTD_EntitiesRect[corner2],k)
-- 				else
-- 					table.insert(entities,v)
-- 				end
-- 			end
-- 		end
-- 	else
-- 		for k,v in pairs(THTD_EntitiesRect[corner1][corner2]) do
-- 			if v==nil or v:IsNull() or v:IsAlive()==false then
-- 				table.remove(THTD_EntitiesRect[corner1][corner2],k)
-- 			else
-- 				table.insert(entities,v)
-- 			end
-- 		end
-- 	end

-- 	return entities
-- end

local RestTime = 0                                                                                                                           
function UpdateSpawnerInfo()
	if RestTime <= 0 then RestTime = SpawnSystem.AST end
	if GameRules:IsGamePaused() then return 1 end
	local ent1 = Entities:FindByName(nil, "spanwer_player1")
	RestTime = RestTime -1
	local _wave = ent1.CurWave
	
	return 1
end
SpawnAttackingSpawn = {
	function()
		print("Line:1")
		local spawner = SpawnSystem.AttackingSpawner
		local ent1 = Entities:FindByName(nil, "spanwer_player1")  
		ent1.CurWave = 1
		ent1.firstPoint = "corner_M1408_1056"
		ent1.firstForward = "left"
		table.insert(spawner,ent1 )
	end,
	function()
		print("Line:2")
		local spawner = SpawnSystem.AttackingSpawner
		local ent1 = Entities:FindByName(nil, "spanwer_player2")
		ent1.CurWave = 1
		ent1.firstPoint = "corner_1408_1056"
		ent1.firstForward = "right"
		table.insert(spawner, ent1)
	end,
	function()
		print("Line:3")
		local spawner = SpawnSystem.AttackingSpawner
		local ent1 = Entities:FindByName(nil, "spanwer_player3")
		ent1.CurWave = 1
		ent1.firstPoint = "corner_1408_M1056"
		ent1.firstForward = "right"
		table.insert(spawner, ent1)
	end,
	function()
		print("Line:4")
		local spawner = SpawnSystem.AttackingSpawner
		local ent1 = Entities:FindByName(nil, "spanwer_player4")
		ent1.CurWave = 1
		ent1.firstPoint = "corner_M1408_M1056"
		ent1.firstForward = "left"
		table.insert(spawner, ent1)
	end,
}
function SpawnSystem:GetWave()
	local spawner  = SpawnSystem.AttackingSpawner
	if spawner[1] == nil then
		return 0
	end
	return spawner[1].CurWave or 0
end

function SpawnSystem:StopWave(index)
	local spawner  = SpawnSystem.AttackingSpawner

	THTD_EntitiesRectInner[index-1] = {}
	if spawner[index] == nil then
		return
	end
	spawner[index].isStop = true
end

function SpawnSystem:ResumeWave(index)
	local spawner  = SpawnSystem.AttackingSpawner

	THTD_EntitiesRectInner[index-1] = {}
	if spawner[index] == nil then
		return
	end
	spawner[index].isStop = false
end

function SpawnSystem:SkipWaveTime(index)
	local spawner  = SpawnSystem.AttackingSpawner

	THTD_EntitiesRectInner[index-1] = {}
	if spawner[index] == nil then 
		return
	end
    
    local spawner  = SpawnSystem.AttackingSpawner
    local wave = spawner[index].CurWave - 1
    
    SpawnSystem.Spawner["Attacking"]["Wave"..tostring(wave)]["BreakTime"] = 0
    
    local count = 0
    for k,v in pairs(Entities:FindAllByClassname("npc_dota_creature")) do
        if string.find(v:GetUnitName(), 'creature_') and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == index then
            count = count +1
        end
    end

    if count == 0 then 
        SpawnSystem.Spawner["Attacking"]["Wave"..tostring(wave)]["Times"] = 0
    end
end

thtd_next_bossName_list = 
{
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = nil,
}

function SpawnSystem:InitAttackSpawn()
	-- 绑定刷怪点
	for i=1,SpawnSystem.TeamNumber do
		SpawnAttackingSpawn[i]()
	end
	local GameMode = GameRules:GetGameModeEntity() 

	GameMode:SetContextThink(DoUniqueString("SpawnerInfo"), UpdateSpawnerInfo,0)

	local spawner  = SpawnSystem.AttackingSpawner
	
	local last_time = {
		-SpawnSystem.Spawner["Attacking"]["Wave1"]["BreakTime"],
		-SpawnSystem.Spawner["Attacking"]["Wave1"]["BreakTime"],
		-SpawnSystem.Spawner["Attacking"]["Wave1"]["BreakTime"],
		-SpawnSystem.Spawner["Attacking"]["Wave1"]["BreakTime"],
	}
	for i = 1,table.nums(spawner) do
		if spawner[i] ~= nil then
			-- spawner[i].CurWave = 50
			spawner[i]:SetContextThink(DoUniqueString("AttackSpawn"..tostring(i)) ,
			function() 

  				local newState = GameRules:State_Get()
				if GameRules:IsGamePaused() then return 1 end
				if GameRules:GetGameTime() < 0 or newState < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
					return 1 
				end
			
				local wave = spawner[i].CurWave - 1
				if wave == 0 then wave = 1 end
				for j = 0,9 do 
				end

				local waveinfo2=string.format("%s%s%d","#","waveinfo_",wave)
				local next_wave=string.format("%s%s%d","#","waveinfo_",wave + 1)

				local cur_time = GameRules:GetGameTime() - last_time[i]
				local max_time = SpawnSystem.Spawner["Attacking"]["Wave"..tostring(wave)]["BreakTime"]  +
				 				 SpawnSystem.Spawner["Attacking"]["Wave"..tostring(wave)]["Times"] 		* 
				 				 SpawnSystem.Spawner["Attacking"]["Wave"..tostring(wave)]["Interval"]  

				local uiWaveInfo = 
				{
					["Wave"] =  wave,
					["RemainingTime"] =  math.max(math.floor(max_time - cur_time),0),
					["ProcessPercentage"] =  math.max((max_time - cur_time)/max_time,0)*100,
				}	
				if wave>50 then
					uiWaveInfo["Wave"] = wave-50
				end
				CustomNetTables:SetTableValue("CustomGameInfo", "attacking_process", uiWaveInfo)

				if cur_time >= max_time then
					SpawnSystem.AST = SpawnSystem.Spawner["Attacking"]["Wave".. tostring(spawner[i].CurWave)]["BreakTime"]

					if wave == 49 then
						CustomGameEventManager:Send_ServerToAllClients( "show_message", {msg="spawn_unlimited", duration=193, params={count=1}, color="#0ff"} )
					end
					
					last_time[i] = GameRules:GetGameTime()
					SpawnSystem:StartSpawn(i)
					spawner[i].CurWave =  spawner[i].CurWave  + 1
				end
				return 1
			end, 0) 
		end
	end
end

GameRules.SpawnSystemCurrentBossCount = 0
function SpawnSystem:StartSpawn(index) -- 进攻怪制取
	local spawner  = SpawnSystem.AttackingSpawner
	local wave = spawner[index].CurWave
	local WaveInfo = SpawnSystem.Spawner["Attacking"]["Wave"..tostring(wave)]
	local count = WaveInfo["Count"]
	local times = WaveInfo["Times"]
	local interval = WaveInfo["Interval"]
	local curTimes = 0
	local Base = SpawnSystem.Base
	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetContextThink(DoUniqueString("SpawnAttackingSpawn"..tostring(index)), 
		function()
			if curTimes>times  then return nil end
			if GameRules:IsGamePaused() then  return 1 end

			for i = 1,count do
				if spawner[index].isStop == true then return nil end

				local spawn_unit = WaveInfo["Unit"]
				
				if AcceptExtraMode == true and wave > 50 and wave%4==0 and thtd_next_bossName_list[index]~=nil then
					spawn_unit = "creature_bosses_"..thtd_next_bossName_list[index]
				end

				local unit= CreateUnitByName(spawn_unit, SpawnSystem.AttackingSpawner[index]:GetOrigin() + RandomVector(400), true, nil, nil, DOTA_TEAM_BADGUYS )

				unit.thtd_player_index = index - 1
				unit.thtd_poison_buff = 0

				unit:AddNewModifier(unit, nil, "modifier_phased", {})
				
				if wave > 50 then
					local currentWave = wave - 51
					local health = unit:GetBaseMaxHealth()

					if GameRules:GetCustomGameDifficulty() == 1 then
						health = health + (currentWave - math.floor(currentWave/4)) * 19200
					elseif GameRules:GetCustomGameDifficulty() == 2 then
						health = health + (currentWave - math.floor(currentWave/4)) * 19200
					elseif GameRules:GetCustomGameDifficulty() == 3 then
						health = health + (currentWave - math.floor(currentWave/4)) * 28800
					elseif GameRules:GetCustomGameDifficulty() == 4 then
						if AcceptExtraMode == true then
							health = health + (currentWave - math.floor(currentWave/4)) * 72000
						else
							health = health + (currentWave - math.floor(currentWave/4)) * 38400
						end
					end

					unit:SetBaseMaxHealth(health)
					unit:SetMaxHealth(health)
					unit:SetHealth(unit:GetMaxHealth())

					if GameRules:GetCustomGameDifficulty() == 1 then
						unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+3*math.min(50,currentWave)-10)
						unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+3*math.min(50,currentWave)-10)
					elseif GameRules:GetCustomGameDifficulty() == 2 then
						unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+3*math.min(50,currentWave)-10)
						unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+3*math.min(50,currentWave)-10)
					elseif GameRules:GetCustomGameDifficulty() == 3 then
						unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+6*math.min(25,currentWave)-10)
						unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+6*math.min(25,currentWave)-10)
					elseif GameRules:GetCustomGameDifficulty() == 4 then
						unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+6*math.min(25,currentWave)-10)
						unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+6*math.min(25,currentWave)-10)
					end

					local special = DoUniqueString("thtd_creep_buff")
					local damageDecrease = math.max(-25*(1+(GameRules:GetCustomGameDifficulty()-1)*0.5),-currentWave*4)
					ModifyDamageIncomingPercentage(unit,damageDecrease,special)
				else
					local modifier = unit:AddNewModifier(unit, nil, "modifier_move_speed", nil)
					modifier:SetStackCount(math.floor(wave/4)*20)

					local health = unit:GetBaseMaxHealth()*(1+(GameRules:GetCustomGameDifficulty()-1)*0.5)
				
					unit:SetBaseMaxHealth(health)
					unit:SetMaxHealth(health)
					unit:SetHealth(unit:GetMaxHealth())

					if AcceptExtraMode == true then
						local special = DoUniqueString("thtd_creep_buff")
						local damageDecrease = -wave
						ModifyDamageIncomingPercentage(unit,damageDecrease,special)
					end
				end

				if AcceptExtraMode == true and wave > 50 and wave%4==0 and thtd_next_bossName_list[index]~=nil then
					unit:AddNewModifier(unit, nil, "modifier_bosses_"..thtd_next_bossName_list[index], nil)
				end

				local id = index - 1

				if unit.next_move_point == nil then
					unit.next_move_point = G_path_corner[spawner[index].firstPoint].Vector * 1.5
					table.insert(THTD_EntitiesRectInner[id],unit)

					-- unit.thtd_last_corner = nil
					-- unit.thtd_next_corner = spawner[index].firstPoint
					-- table.insert(THTD_EntitiesRect[spawner[index].firstPoint],unit)
				end

				if unit.next_move_forward == nil then
					unit.next_move_forward = spawner[index].firstForward 
				end

				unit:SetContextThink(DoUniqueString("AttackingBase"), 
				function ()
					if unit~=nil and unit:IsNull()==false and unit:IsAlive() and unit.thtd_is_outer ~= true then
						local origin = unit:GetOrigin()
						if not(origin.x < 4432 and origin.x > -4432 and origin.y < 3896 and origin.y > -3896) then
							unit.thtd_is_outer = true
							table.insert(THTD_EntitiesRectOuter,unit)
						end
					end
					unit:MoveToPosition(unit.next_move_point)
					return 0.1
				end, 0) 
			end
			curTimes = curTimes + 1

			return interval
		end, 0)
end