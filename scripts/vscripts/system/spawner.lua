if SpawnSystem == nil then
	SpawnSystem = {}
	SpawnSystem.Spawner = {}  --刷怪基本数据
	SpawnSystem.AttackingSpawner = {}  --每个玩家的刷怪信息
	SpawnSystem.GameOverPlayerId = {} --失败玩家id
	SpawnSystem.CurWave = 0
	SpawnSystem.CurTime = 0
	SpawnSystem.IsUnLimited = false
	SpawnSystem.ReachToWave = nil	
	SpawnSystem.SpawnOrigin =  -- 玩家出生地点
	{
		[1] = Vector(-3424,2816,144),
		[2] = Vector(3424,2816,144),
		[3] = Vector(3424,-2816,144),
		[4] = Vector(-3424,-2816,144)
	}	
end


THTD_EntitiesRectInner = { [0] = {}, [1] = {}, [2] = {},[3] = {} }  -- 内圈怪按玩家逄
THTD_EntitiesRectOuter = { }  -- 外圈怪统一算
thtd_bosses_list = 
{
	"alice",
	"aya",
	"hina",
	"kaguya",
	"keine",
	"kisume",
	"marisa",
	"minoriko",
	"mokou",
	"rumia",
	"yuugi",
}

function SpawnSystem:GetCount()	
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return 0 end
	local i = 0
	for _, spawnerLine in pairs(spawner) do	
		if spawnerLine.hero.is_game_over == false and spawnerLine.hero:IsStunned() == false then
			i = i + 1			
		end
	end		
	return i
end


function RefreshItemListNetTable(hero)
	if hero == nil or hero:IsNull() or hero:IsAlive() == false or hero:IsStunned() then return end    	
	-- if hero.thtd_game_info["food_count"] > THTD_MAX_FOOD then SpawnSystem:GameOver(hero) end
	hero.thtd_hero_damage_list = {}
	for k,v in pairs(hero.thtd_hero_tower_list) do		
		hero.thtd_hero_damage_list[tostring(v:GetEntityIndex())] = math.floor(v.thtd_tower_damage)	
	end	
	local steamid = PlayerResource:GetSteamID(hero:GetPlayerOwnerID())	
	CustomNetTables:SetTableValue("TowerListInfo", "damagelist"..tostring(steamid), hero.thtd_hero_damage_list)	
	CustomNetTables:SetTableValue("CustomGameInfo", "game_info"..tostring(steamid), hero.thtd_game_info)
end

function RefreshItemListNetTableAll()	
	if SpawnSystem.AttackingSpawner == nil or #SpawnSystem.AttackingSpawner == 0 then return end
	for k,v in pairs(SpawnSystem.AttackingSpawner) do		
		RefreshItemListNetTable(v.hero)
	end
end

function RefreshTowerPowerAttackEquip(hero)	
	if hero == nil or hero:IsNull() or hero:IsAlive() == false then return end
    if hero:THTD_IsTower() then hero = hero:GetOwner() end
    if hero.is_game_over or hero:IsStunned() then return end
    for index,tower in pairs(hero.thtd_hero_tower_list) do
		if tower ~= nil and tower:IsNull() == false and tower:IsAlive() then
			if tower:GetUnitName() ~= "minoriko" and tower:GetUnitName() ~= "sizuha" then
				-- 攻击刷新
				local attack = math.floor(tower:THTD_GetAttack())
				if attack ~= tower:GetModifierStackCount("common_thdots_base_attack_buff", tower) then
					tower:SetModifierStackCount("common_thdots_base_attack_buff", tower, attack)
				end

				-- 属性刷新
				if tower:THTD_GetPower() ~= tower:GetModifierStackCount("common_thdots_base_power_buff", tower) then
					tower:SetModifierStackCount("common_thdots_base_power_buff", tower, tower:THTD_GetPower())
				end

				-- 装备刷新
				tower:THTD_EquipRefresh()
			end
        end
    end
end

function RefreshTowerPowerAttackEquipAll()	
	if SpawnSystem.AttackingSpawner == nil or #SpawnSystem.AttackingSpawner == 0 then return end
	for k,v in pairs(SpawnSystem.AttackingSpawner) do		
		RefreshTowerPowerAttackEquip(v.hero)
	end
end


-- 刷怪准备，DOTA_GAMERULES_STATE_PRE_GAME 时调用
function SpawnSystem:PreSpawn()
	-- 载入刷怪数据
	SpawnSystem.Spawner = LoadKeyValues("scripts/npc/Spawner.txt")

	-- 显示准备倒计时
	local maxTime = math.floor(GameRules:GetGameTime() + 0.5) + 30
	local uiWaveInfo = 
	{
		["Wave"] =  0,
		["RemainingTime"] =  maxTime		
	}	
	local GameMode = GameRules:GetGameModeEntity() 	
	GameMode:SetContextThink(DoUniqueString("PreSpawn") ,
		function()
			if GameRules:IsGamePaused() then return 0.1 end
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return nil end
			if uiWaveInfo["RemainingTime"] == 0 then
				CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="item_locked_tip", duration=60, params={}, color="#ff0"})
				return nil 
			end
			uiWaveInfo["RemainingTime"] =  math.max(math.floor(maxTime - GameRules:GetGameTime()),0)
			SpawnSystem.CurTime = uiWaveInfo["RemainingTime"]
			CustomNetTables:SetTableValue("CustomGameInfo", "attacking_process", uiWaveInfo)			
			RefreshItemListNetTableAll()
			if (GameRules:IsCheatMode() and IsInToolsMode() == false) or server_key == "Invalid_NotOnDedicatedServer" then
				SpawnSystem:GameEnd()
				return nil
			end			

			-- 初始化刷怪点
			if uiWaveInfo["RemainingTime"] <= 25 and SpawnSystem:GetCount() == 0 then 
				SpawnSystem:SpawnLine()				
				SpawnSystem:RefreshCreepMaxCount()				

				-- 通知提示
				local difficulty = GameRules:GetCustomGameDifficulty()
				if difficulty == 7 or difficulty == 9 then 
					CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="fast_game_on", duration=25, params={}, color="#ff0"})
				end		
				if difficulty >= 8 then 
					CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="challenge_game_on", duration=25, params={}, color="#ff0"})
				end	

				GameRules:SendCustomMessage("<font color='yellow'>在商店附近右键背包物品点击整理地面物品，整理自己所有地面物品并跳过锁定的物品</font>", DOTA_TEAM_GOODGUYS, 0)	
			end

			-- 同步UI数据			
			RefreshTowerPowerAttackEquipAll()
			RefreshItemListNetTableAll()

			return 1
		end,
	0)
end

-- 绑定刷怪点
function SpawnSystem:SpawnLine()
	local spawner = SpawnSystem.AttackingSpawner
	local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
	if heroes == nil or #heroes == 0 then return end
	table.sort(heroes, function(a,b) return (a.thtd_player_id < b.thtd_player_id) end)	
	local j = 1	
	for _,hero in pairs(heroes) do		
    	if hero.is_game_over == false and hero:IsStunned() == false then
			local entity = Entities:FindByName(nil, "spanwer_player"..tostring(j))
			if entity ~= nil then				
				entity.hero = hero
				hero.thtd_spawn_id = j
				hero.spawn_position = SpawnSystem.SpawnOrigin[j]				
				if GetDistanceBetweenTwoVec2D(hero:GetAbsOrigin(), hero.spawn_position) > 1000 then 
					hero:SetAbsOrigin(hero.spawn_position) 
					hero.shop:SetAbsOrigin(hero.spawn_position)
				end
				if j == 1 then
					entity.firstPoint = "corner_M1408_1056"
					entity.firstForward = "left"
					entity.index = j
				elseif j == 2 then
					entity.firstPoint = "corner_1408_1056"
					entity.firstForward = "right"
					entity.index = j
				elseif j == 3 then
					entity.firstPoint = "corner_1408_M1056"
					entity.firstForward = "right"
					entity.index = j
				elseif j == 4 then
					entity.firstPoint = "corner_M1408_M1056"
					entity.firstForward = "left"
					entity.index = j
				end	
				table.insert(spawner, entity)
				j = j + 1				
			end
		end
	end
end


-- 刷怪开始，DOTA_GAMERULES_STATE_GAME_IN_PROGRESS 时调用
function SpawnSystem:InitSpawn()
	local spawner = SpawnSystem.AttackingSpawner

	local max_time = 0
	local left_time = 0
	local uiWaveInfo = 
	{
		["Wave"] = 1,
		["RemainingTime"] = max_time	
	}	
	local wave = 0
	local difficulty = GameRules:GetCustomGameDifficulty()
	local GameMode = GameRules:GetGameModeEntity()	
	GameMode:SetContextThink(DoUniqueString("AttackSpawn"),
		function()			
			if GameRules:IsGamePaused() then return 0.1 end	

			-- 每波开始
			if left_time <= 0 then
				SpawnSystem:WaveEndForEach()				

				if SpawnSystem.ReachToWave ~= nil then 
					SpawnSystem.CurWave = SpawnSystem.ReachToWave + 50
					SpawnSystem.ReachToWave = nil	
				elseif SpawnSystem.CurWave == 50 and difficulty >= 8 then 					
					SpawnSystem.CurWave = 50 + 68					
				elseif difficulty == 10 and SpawnSystem.CurWave < 50 then 
					SpawnSystem.CurWave = SpawnSystem.CurWave + 2
				else						
					SpawnSystem.CurWave = SpawnSystem.CurWave + 1
				end				
				wave = SpawnSystem.CurWave

				-- 难1至难5胜利
				if difficulty < 6 and wave > (80+(difficulty-1)*10) then
					http.api.giveGamePoint() 
					SpawnSystem:GameEnd()					
					return nil
				end

				-- 无尽前提示
				if wave == 50 then
					CustomGameEventManager:Send_ServerToAllClients( "show_message", {msg="spawn_unlimited", duration=193, params={count=20+10*math.min(difficulty,5)}, color="#0ff"} )
					if difficulty >= 8 then
						CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="challenge_game_on", duration=404, params={}, color="#ff0"})
					end
				end	
				
				-- 进入无尽
				if wave > 50 and SpawnSystem.IsUnLimited == false then 
					SpawnSystem:StartUnlimited()
				end	

				-- 100波以后取消刷文文
				if wave == 150 then
					for k,v in pairs(thtd_bosses_list) do
						if v == "aya" then
							table.remove(thtd_bosses_list, k)
							break
						end
					end
				end

				-- 每波怪的计时
				if wave <= 51 then
					max_time = math.floor(SpawnSystem.Spawner["Attacking"]["Wave".. tostring(wave)]["BreakTime"]  +
										  SpawnSystem.Spawner["Attacking"]["Wave".. tostring(wave)]["Times"] 	 * 
										  SpawnSystem.Spawner["Attacking"]["Wave".. tostring(wave)]["Interval"]  + 0.5)	
				elseif max_time > 30 then 
					max_time = math.floor(SpawnSystem.Spawner["Attacking"]["Wave51"]["BreakTime"]  +
										  SpawnSystem.Spawner["Attacking"]["Wave51"]["Times"] 	 * 
										  SpawnSystem.Spawner["Attacking"]["Wave51"]["Interval"]  + 0.5)						
				end		
				if (difficulty == 7 or difficulty == 9) and wave <= 49 then
					max_time = max_time - 20
				end
				if difficulty == 10 and wave <= 49 then
					max_time = 66
				end
				if difficulty >= 8 and wave == 50 then 
					max_time = max_time + 210				
				end
				left_time = max_time					

				SpawnSystem:ClearRemovedSpawner()
				SpawnSystem:StartSpawn()						
			end
			
			-- 挑战模式在50波给两次无尽三幻神重置机会
			if difficulty >= 8 and wave == 50 then 
				if left_time == 210 then 
					SpawnSystem:WaveEndForEach()
					SpawnSystem:StartUnlimited() 
				end
				if left_time == 210 or left_time == 140 or left_time == 70 then
					CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="extra_bonus_nazrin", duration=60, params={count=1}, color="#0ff"} )
					CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="extra_bonus_minoriko_limit", duration=60, params={count=1}, color="#0ff"} )
					CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="extra_bonus_lily", duration=60, params={count=1}, color="#0ff"} )
					SpawnSystem:PreChallenge()
				end
			end

			-- 更新进度
			left_time = left_time - 0.5			
			uiWaveInfo["Wave"] = wave				
			uiWaveInfo["RemainingTime"] = math.floor(left_time)			
			CustomNetTables:SetTableValue("CustomGameInfo", "attacking_process", uiWaveInfo)
			SpawnSystem.CurTime = uiWaveInfo["RemainingTime"]
	
			-- 检查漏怪
			if not SpawnSystem:CreepCheck() then			
				return nil
			end

			-- 同步UI数据
			RefreshTowerPowerAttackEquipAll()
			RefreshItemListNetTableAll()			

			return 0.5
		end, 
	0) 
	
end

-- 进入无尽相关设置
function SpawnSystem:StartUnlimited()
	SpawnSystem.IsUnLimited = true 
	local entities = Entities:FindAllByClassname("npc_dota_creature")
	for k,v in pairs(entities) do
		local findNum =  string.find(v:GetUnitName(), 'creature')
		if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() then
			v:ForceKill(false)
		end
	end	
	local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
	for k,v in pairs(heroes) do
		if v~=nil and v:IsNull()==false and v:IsAlive() and v.is_game_over == false and v:IsStunned() == false then
			v.thtd_game_info["creature_kill_count"] = 0
		end
	end
	SpawnSystem:RefreshCreepMaxCount()
end

-- 漏怪检查,返回是否可接受范围内
function SpawnSystem:CreepCheck()
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return true end	
	local wave = SpawnSystem.CurWave
	local difficulty = GameRules:GetCustomGameDifficulty()
	
	CheckPlayerConnect()

	-- 无尽前
	if not SpawnSystem.IsUnLimited then
		local count = 0
		for _,inner in pairs(THTD_EntitiesRectInner) do
			if inner ~= nil then count = count + #inner end
		end
		if THTD_EntitiesRectOuter ~= nil then count = count + #THTD_EntitiesRectOuter end
		local isEndGame = false
		for spawnerIndex,spawnerLine in pairs(spawner) do
			local hero = spawnerLine.hero    
			if hero.is_game_over == false and hero:IsStunned() == false then
				hero.thtd_game_info["creep_count"] = count
				if count > hero.thtd_game_info["creep_count_max"] and isEndGame == false then 
					isEndGame = true
				end
			end
		end
		if isEndGame then 
			RefreshItemListNetTableAll()
			SpawnSystem:GameEnd()
			return false
		else
			return true
		end
	end

	-- 无尽波数	
	for spawnerIndex,spawnerLine in pairs(spawner) do
		local hero = spawnerLine.hero    
		if hero.is_game_over == false and hero:IsStunned() == false then
			local count = 0

			if spawnerLine.nextBossName=="kaguya" then 
				local entities = Entities:FindAllByClassname("npc_dota_creature")
				for k,v in pairs(entities) do
					local findNum =  string.find(v:GetUnitName(), 'creature_unlimited')
					if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == hero.thtd_player_id then
						count = count + 1
					end
					local findNum2 =  string.find(v:GetUnitName(), 'creature_alice')
					if findNum2 ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == hero.thtd_player_id and v.thtd_is_outer then
						count = count + 1
					end
					local findNum3 =  string.find(v:GetUnitName(), 'creature_bosses')
					if findNum3 ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == hero.thtd_player_id then
						count = count + 1
					end
				end
			else 					
				if THTD_EntitiesRectInner[hero.thtd_player_id]~= nil then 						
					for k,v in pairs(THTD_EntitiesRectInner[hero.thtd_player_id]) do	
						if v~=nil and v:IsNull()==false and v:IsAlive() then
							if v:GetUnitName()=="creature_alice_ningyou" then 
								if v.thtd_is_outer then count = count + 1 end
							else
								count = count + 1
							end
						end
					end
				end
				if THTD_EntitiesRectOuter ~= nil then 
					for k,v in pairs(THTD_EntitiesRectOuter) do					
						if v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == hero.thtd_player_id then
							count = count + 1
						end					
					end				
				end
			end
			
			hero.thtd_game_info["creep_count"] = count
			if count > hero.thtd_game_info["creep_count_max"] then
				hero.thtd_gameover = true
				http.api.giveGamePoint(hero)
				SpawnSystem:GameOver(hero)
				if SpawnSystem:GetCount() == 0 then return false end
			end	
		end
	end

	return true
end

-- 指定玩家游戏结束
function SpawnSystem:GameOver(hero)
	if hero~=nil and hero:IsNull()==false and hero:IsAlive() and hero.is_game_over == false and hero:IsStunned() == false then
		RefreshItemListNetTable(hero)
		hero:THTD_DropItemAll()
		
		local wave = SpawnSystem.CurWave
		local entities = Entities:FindAllByClassname("npc_dota_creature")
		local killed = false		
		for k,v in pairs(entities) do
			killed = false
			if SpawnSystem.IsUnLimited then 
				local findNum = string.find(v:GetUnitName(), 'creature_unlimited')
				local findNum2 = string.find(v:GetUnitName(), 'creature_alice')
				local findNum3 =  string.find(v:GetUnitName(), 'creature_bosses')
				if (findNum ~= nil or findNum2 ~= nil or findNum3 ~= nil) and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == hero.thtd_player_id then
					v:ForceKill(false)
					killed = true
				end
			else
				local findNum =  string.find(v:GetUnitName(), 'creature')
				if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == hero.thtd_player_id then
					v:ForceKill(false)
					killed = true
				end
			end

			if killed==false and SpawnSystem:GetCount() > 1 and v~=nil and v:IsNull()==false and v:IsAlive() and v:THTD_IsTower() and v:GetOwner() == hero then
				v:THTD_DropItemAll()							
				v:THTD_DestroyLevelEffect()
				v:RemoveModifierByName("modifier_touhoutd_no_health_bar")										
				hero:AddItem(v.thtd_item)
				hero:THTD_DropItemAll()
				v:SetAbsOrigin(Vector(0,0,0))
				v:AddNoDraw() 
				v:AddNewModifier(hero, nil, "modifier_touhoutd_release_hidden", {})	
				for _,u in pairs(entities) do
					if u~=nil and u:IsNull()==false and u:IsAlive() and u.thtd_spawn_unit_owner~=nil and u.thtd_spawn_unit_owner==v then 
						u:AddNoDraw()
						u:ForceKill(false)
					end
				end
			end
		end	
		hero.is_game_over = true
		table.insert(SpawnSystem.GameOverPlayerId, hero.thtd_player_id)
		UnitStunTarget(hero,hero,-1)
		hero:SetAbsOrigin(Vector(0,0,0))
		hero:AddNoDraw()
		THTD_EntitiesRectInner[hero.thtd_player_id] = {}
		if wave > 120 then
			CheckRank(hero)
			CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="power_game_end_info", duration=30, params={wave=hero.thtd_game_info["max_wave"],damage=hero.thtd_game_info["max_wave_damage"],name=PlayerResource:GetPlayerName(hero:GetPlayerID())}, color="#ff0"})					
		end
		SpawnSystem:RefreshCreepMaxCount()	
	end

	if SpawnSystem:GetCount() == 0 then	SpawnSystem:GameEnd() end
end

-- 全部游戏结束
function SpawnSystem:GameEnd()
	local difficulty = GameRules:GetCustomGameDifficulty()
	local wave = SpawnSystem.CurWave

	if difficulty < 6 and wave > (80+(difficulty-1)*10) then 		
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		return
	end

	if wave > 120 then
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("thtd_end_game"), 
			function()
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				return nil
			end,
		30)					
	else
		Entities:FindByName(nil, "dota_goodguys_fort"):ForceKill(false)		
	end					
	return
end

-- 检查是否能上排行榜
function CheckRank(hero)
	if GameRules.players_max_wave[hero.thtd_player_id] == nil or GameRules.players_max_wave[hero.thtd_player_id].id == nil then return end	
	if hero.thtd_game_info["max_wave"] <= GameRules.players_max_wave[hero.thtd_player_id].wave then return end
	if GameRules.is_team_mode then 
		if GameRules.players_team_rank_ok == false then return end
		if #GameRules.players_team_rank > 0 and hero.thtd_game_info["max_wave"] <= GameRules.players_team_rank[#GameRules.players_team_rank].wave then return end
	else
		if GameRules.players_rank_ok == false then return end
		if #GameRules.players_rank > 0 and hero.thtd_game_info["max_wave"] <= GameRules.players_rank[#GameRules.players_rank].wave then return end
	end	
	
	local wavedata = {}
	wavedata["id"] = GameRules.players_max_wave[hero.thtd_player_id].id
	wavedata["account"] = tostring(PlayerResource:GetSteamAccountID(hero.thtd_player_id))
	wavedata["wave"] = hero.thtd_game_info["max_wave"]
	wavedata["damage"] = hero.thtd_game_info["max_wave_damage"] / 10000
	wavedata["username"] = PlayerResource:GetPlayerName(hero.thtd_player_id)
	for i=1,12 do
		if i <= #hero.cards then 
			wavedata["card"..tostring(i)] = hero.cards[i]
		else
			wavedata["card"..tostring(i)] = ""
		end
	end
	
	local toplist
	if GameRules.is_team_mode then
		toplist = GameRules.players_team_rank_data	
	else
		toplist = GameRules.players_rank_data
	end
	local toDelList = {}
	local isTop = true
	local groupMaxWave = 0
	local SameRankDps = 6 --阵容前几相同即为同阵容

	if #toplist > 0 then
		for i=1,#toplist do
			local topdata = toplist[i]
			if GameRules.players_max_wave[hero.thtd_player_id].id ~= topdata["_id"] then				 
				local sameCount = 0
				local usedIndex = ""
				for x=1,SameRankDps do
					for y=1,SameRankDps do
						if string.find(usedIndex,tostring(y)) == nil and wavedata["card"..tostring(x)] ~= "" and topdata["card"..tostring(y)] ~= "" and topdata["card"..tostring(y)] ~= nil and wavedata["card"..tostring(x)]["itemname"] == topdata["card"..tostring(y)]["itemname"] then
							sameCount = sameCount + 1
							usedIndex = usedIndex..tostring(y)
							break
						end					
					end
				end

				if sameCount ~= SameRankDps then
					if wavedata["card1"] ~= "" and topdata["card1"] ~= "" and topdata["card1"] ~= nil and wavedata["card1"]["itemname"] == topdata["card1"]["itemname"] then
						if wavedata["card1"]["damage"] / (10000 * wavedata["damage"]) >= 0.7 and topdata["card1"]["damage"] / (10000 * topdata["damage"]) >= 0.7 then
							sameCount = SameRankDps
						end						
					end
				end

				if sameCount ~= SameRankDps then
					local topDamage1 = 0
					local topDamage2 = 0
					local topNum = 0
					for x=1,12 do
						if wavedata["card"..tostring(x)] ~= "" then
							topDamage1 = topDamage1 + wavedata["card"..tostring(x)]["damage"]
						end
						if topdata["card"..tostring(x)] ~= "" and topdata["card"..tostring(x)] ~= nil then
							topDamage2 = topDamage2 + topdata["card"..tostring(x)]["damage"]
						end						
						if topDamage1 / (10000 * wavedata["damage"]) >= 0.9 and topDamage2 / (10000 * topdata["damage"]) >= 0.9 then
							topNum = x
							break
						end					
					end
					if topNum > 0 then
						usedIndex = ""
						sameCount = 0
						for x=1,topNum do
							for y=1,topNum do
								if string.find(usedIndex,tostring(y)) == nil and wavedata["card"..tostring(x)] ~= "" and topdata["card"..tostring(y)] ~= "" and topdata["card"..tostring(y)] ~= nil and wavedata["card"..tostring(x)]["itemname"] == topdata["card"..tostring(y)]["itemname"] then
									sameCount = sameCount + 1
									usedIndex = usedIndex..tostring(y)
									break
								end					
							end
						end	
						if sameCount == topNum then sameCount = SameRankDps end
					end
				end

				if sameCount == SameRankDps then
					if wavedata["wave"] <= topdata["wave"] then
						if isTop ~= false then isTop = false end
						if groupMaxWave == 0 then groupMaxWave = topdata["wave"] end
					else
						table.insert(toDelList, i)				
					end				
				end
			end
		end
	end
	
	for k,v in pairs(toDelList) do
		if GameRules.is_team_mode then
			http.api.resetTeamRank(v)
		else
			http.api.resetRank(v)
		end
	end
	print("---------- the same rank : ", json.encode(toDelList))

	if not isTop then
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "thtd_upload_rank", {code = 0, msg = "你打破了自己的历史记录，但没有超过该阵容的最高波数 "..groupMaxWave.."，请再接再厉!"})				
		return	
	end

	if GameRules.players_max_wave[hero.thtd_player_id].id == "-1" then	
		http.api.saveFirstWaveData(hero.thtd_player_id, wavedata)
	else
		http.api.saveWaveData(hero.thtd_player_id, wavedata)
	end
end

-- 检查玩家是否掉线
function CheckPlayerConnect()
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return end		
	for spawnerIndex,spawnerLine in pairs(spawner) do	
		local hero = spawnerLine.hero
		if (hero:GetPlayerOwner() == nil or hero:GetPlayerOwner():IsNull()) then
			if hero.thtd_game_info["is_player_connected"] then 
				hero.thtd_game_info["is_player_connected"] = false
				CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="player_disconnect", duration=15, params={count=1}, color="#0ff"} )
				CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="{d:count}", duration=15, params={count=hero.thtd_player_id+1}, color="#ff0"})			
				CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="pause_game", duration=15, params={}, color="#ff0"})
				PauseGame(true)
			end
		else
			if not hero.thtd_game_info["is_player_connected"] then hero.thtd_game_info["is_player_connected"] = true end			
		end	
	end
end

-- 每波刷怪结束各线路数据更新
function SpawnSystem:WaveEndForEach()
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return end	
	local wave = SpawnSystem.CurWave
	local difficulty = GameRules:GetCustomGameDifficulty()
	for spawnerIndex,spawnerLine in pairs(spawner) do
		local hero = spawnerLine.hero    
		if hero.is_game_over == false and hero:IsStunned() == false then
			-- 伤害清零，收益卡结算，统计更新			
			hero.thtd_rumia_kill_count = 0
			hero.thtd_yuyuko_kill_count = 0
			hero.thtd_patchouli_kill_count = 0
			local isMaxWave = false
			local towerShinki = nil

			if wave > 120 and hero.use_item2001 ~= true and hero.thtd_game_info["creep_count"] <= 20 and hero.is_change_card ~= true then 
				isMaxWave = true 
			end			
			if isMaxWave then
				local totalDamage = 0
				local minDamage = 24000 + (wave - 51 - math.floor((wave - 51)/4)) * 72000				
				minDamage = math.floor(minDamage*(1.018^(wave - 121))/1000) * 1000
				if minDamage > 2000000000 then minDamage = 2000000000 end
				minDamage = (minDamage / 100) * 25
				for k,v in pairs(hero.thtd_hero_tower_list) do
					if v~=nil and v:IsNull()==false then
						totalDamage = totalDamage + v.thtd_tower_damage
					end
				end				
				if totalDamage < minDamage then
					isMaxWave = false
					GameRules:SendCustomMessage("<font color='red'>结束时当前阵容总伤害量低于80%总血量的这一波不计入有效波数。</font>", DOTA_TEAM_GOODGUYS, 0)		
				end
			elseif wave > 120 and hero.thtd_game_info["creep_count"] > 20 then 
				GameRules:SendCustomMessage("<font color='red'>结束时漏怪数量超过20的这一波不计入有效波数。</font>", DOTA_TEAM_GOODGUYS, 0)
			end
			
			if isMaxWave then
				hero.thtd_game_info["max_wave"] = wave - 50
				hero.thtd_game_info["max_wave_damage"] = 0
				hero.cards = {}					
			end
			for k,v in pairs(hero.thtd_hero_tower_list) do		
				if v~=nil and v:IsNull()==false and v:IsAlive() then
					if isMaxWave then
						hero.thtd_game_info["max_wave_damage"] = hero.thtd_game_info["max_wave_damage"] + v.thtd_tower_damage/100						
						local card = {} 
						card["itemname"] = v.thtd_item:GetAbilityName()
						card["star"] = v:THTD_GetStar()
						card["damage"] = math.floor(v.thtd_tower_damage/100)
						card["power"] = math.floor(v:THTD_GetPower() or 0)
						card["attack"] = math.floor(v:THTD_GetAttack() or 0)
						card["equip"] = {}
						for i=0,5 do
							local targetItem = v:GetItemInSlot(i)
							if targetItem~=nil and targetItem:IsNull()==false then	
								table.insert(card["equip"], targetItem:GetAbilityName())
							end
						end
						if #card["equip"] == 0 then card["equip"] = nil end
						table.insert(hero.cards, card)
					end					
					if not SpawnSystem.IsUnLimited then
						if v:GetUnitName() == "toramaru" and GameRules:GetCustomGameDifficulty() ~= 10 then							
							PlayerResource:ModifyGold(v:GetPlayerOwnerID(),math.floor(v.thtd_tower_damage),true,DOTA_ModifyGold_CreepKill)
							SendOverheadEventMessage(v:GetPlayerOwner(),OVERHEAD_ALERT_GOLD,v,math.floor(v.thtd_tower_damage),v:GetPlayerOwner() )
						elseif v:GetUnitName() == "shinki" and v.thtd_shinki_01_lock == false then
							if towerShinki == nil or towerShinki:THTD_GetStar() < v:THTD_GetStar() then 
								towerShinki = v
							end
						end						
					end
					v.thtd_tower_damage = 0
				end
			end
			if isMaxWave then
				hero.thtd_game_info["max_wave_damage"] = math.floor(hero.thtd_game_info["max_wave_damage"] + 0.5)
				table.sort(hero.cards, function(a,b) return a["damage"] > b["damage"] end) --坑：使用 a.damage >= b.damage 会失败
			end
			hero.use_item2001 = false	

			if towerShinki ~= nil then 
				OnShinkiGainCard(towerShinki)
				if difficulty == 10 then OnShinkiGainCard(towerShinki) end
			end

			-- 清空空值
			local inner = THTD_EntitiesRectInner[hero.thtd_player_id]
			if inner ~= nil then
				for i = #inner, 1, -1 do
					if inner[i]==nil or inner[i]:IsNull() or inner[i]:IsAlive()==false then 
						table.remove(inner, i)	
					end
				end
			end

			if SpawnSystem.IsUnLimited == false and wave >= 30 and wave < 50 and GameRules:GetCustomGameDifficulty() == 10 then
				for i=1,4 do					
					local item = CreateItem("item_1006", nil, nil)
					item.owner_player_id = hero.thtd_player_id
					item:SetPurchaser(hero)
					item:SetPurchaseTime(1.0)
					local pos = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, (i-1) * 130, 150)					
					CreateItemOnPositionSync(pos, item)
				end	
			end
		end
	end

	-- 清空空值
	if THTD_EntitiesRectOuter ~= nil then 
		for i = #THTD_EntitiesRectOuter, 1, -1 do
			if THTD_EntitiesRectOuter[i]==nil or THTD_EntitiesRectOuter[i]:IsNull() or THTD_EntitiesRectOuter[i]:IsAlive()==false then 
				table.remove(THTD_EntitiesRectOuter, i)	
			end
		end
	end
end

-- 挑战模式在50波时额外重置时间
function SpawnSystem:PreChallenge()
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return end	
	for spawnerIndex,spawnerLine in pairs(spawner) do
		local hero = spawnerLine.hero    
		if hero.is_game_over == false and hero:IsStunned() == false then
			hero.thtd_minoriko_02_change = 0
			PlayerResource:ModifyGold(hero:GetPlayerOwnerID(),3500,true,DOTA_ModifyGold_CreepKill)
			for k,v in pairs(hero.thtd_hero_tower_list) do
				if v~=nil and v:IsNull()==false and v:IsAlive() then
					if v:THTD_IsTower() and v:THTD_GetLevel()<THTD_MAX_LEVEL then
						v:THTD_SetLevel(THTD_MAX_LEVEL)
					end
				end
			end			
		end
	end
end


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

-- 代替触发器
local UnitMoveRectAll = {
	[1] = {			
		["center"] = {-2200, 1550},
		["radius"] = 200,
		["tag"] = {
			["left"] = {
				{
					["forward"] = "left",
					["index"] = 2
				},
			}, 
		}
	},
	[2] = {		
		["center"] = {-4100, 1600},
		["radius"] = 100,					
		["tag"] = {
			["left"] = {
				{
					["forward"] = "up",
					["index"] = 3
				},
			}, 
		}
	},
	[3] = {			
		["center"] = {-4100, 4120},
		["radius"] = 100,	
		["tag"] = {
			["up"] = {
				{
					["forward"] = "left",
					["index"] = 4
				},
				{
					["forward"] = "right",
					["index"] = 5
				},
			}, 
		}				
	},
	[4] = {			
		["center"] = {-6750, 4120},
		["radius"] = 100,		
		["tag"] = { }
	},
	[5] = {			
		["center"] = {10, 4120},
		["radius"] = 100,		
		["tag"] = { }
	},	
}


-- 刷怪
function SpawnSystem:StartSpawn()	
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return end	
	local difficulty = GameRules:GetCustomGameDifficulty()

	local wave = SpawnSystem.CurWave
	local waveInfo = nil
	if wave <= 51 then
		waveInfo = SpawnSystem.Spawner["Attacking"]["Wave"..tostring(wave)]
	else
		waveInfo = SpawnSystem.Spawner["Attacking"]["Wave51"]
	end

	local count = waveInfo["Count"]
	local times = waveInfo["Times"]
	local interval = waveInfo["Interval"]	
	
	for spawnerIndex,spawnerLine in pairs(spawner) do
		local hero = spawnerLine.hero    
		if hero.is_game_over == false and hero:IsStunned() == false then 
			local player = hero:GetPlayerOwner()
			local playerId = hero:GetPlayerOwnerID()
			-- 刷新BOSS信息并重置秋
			if difficulty >= 5 then
				if wave > 50 and wave%4 == 3 then									
					hero.thtd_minoriko_02_change = 0
					PlayerResource:ModifyGold(playerId,3500,true,DOTA_ModifyGold_CreepKill)
					for k,v in pairs(hero.thtd_hero_tower_list) do
						if v~=nil and v:IsNull()==false and v:IsAlive() then
							if v:THTD_IsTower() and v:THTD_GetLevel()<THTD_MAX_LEVEL then
								v:THTD_SetLevel(THTD_MAX_LEVEL)
							end
						end
					end
					CustomGameEventManager:Send_ServerToPlayer(player,"show_message", {msg="extra_bonus_nazrin", duration=60, params={count=1}, color="#0ff"} )
					CustomGameEventManager:Send_ServerToPlayer(player,"show_message", {msg="extra_bonus_minoriko_limit", duration=60, params={count=1}, color="#0ff"} )
					CustomGameEventManager:Send_ServerToPlayer(player,"show_message", {msg="extra_bonus_lily", duration=60, params={count=1}, color="#0ff"} )
					
					spawnerLine.nextBossName = thtd_bosses_list[RandomInt(1, #thtd_bosses_list)]
					CustomGameEventManager:Send_ServerToPlayer(player,"show_message", {msg="extra_bosses_"..spawnerLine.nextBossName, duration=60, params={count=1}, color="#0ff"} )						
				end
			end

			local curTimes = 0
			spawnerLine:SetContextThink(DoUniqueString("SpawnAttackingSpawn"..tostring(spawnerIndex)), 
				function()
					if GameRules:IsGamePaused() then return 0.1 end
					if curTimes > times  then return nil end				
		
					for i = 1, count do
						if hero.is_game_over or hero:IsStunned() then return nil end
		
						local spawn_unit = waveInfo["Unit"]
						
						if difficulty >= 5 and wave > 50 and wave%4 == 0 and spawnerLine.nextBossName ~= nil then
							spawn_unit = "creature_bosses_"..spawnerLine.nextBossName
						end
		
						local unit= CreateUnitByName(spawn_unit, spawnerLine:GetOrigin() + RandomVector(400), true, nil, nil, DOTA_TEAM_BADGUYS )
		
						unit.thtd_player_index = hero.thtd_player_id
						unit.thtd_poison_buff = 0
		
						unit:AddNewModifier(unit, nil, "modifier_phased", {})
						
						if wave > 50 then
							local currentWave = wave - 51
							local health = unit:GetBaseMaxHealth()
		
							if difficulty == 1 then
								health = health + (currentWave - math.floor(currentWave/4)) * 19200
							elseif difficulty == 2 then
								health = health + (currentWave - math.floor(currentWave/4)) * 19200
							elseif difficulty == 3 then
								health = health + (currentWave - math.floor(currentWave/4)) * 28800
							elseif difficulty == 4 then
								health = health + (currentWave - math.floor(currentWave/4)) * 38400
							else
								health = health + (currentWave - math.floor(currentWave/4)) * 72000						
							end
		
							--真无尽模式每波额外增加 1.8%，100波 990万，150波 3300万，200波 1.08亿（等于原版2000波）					
							if wave > 120 then health = math.floor(health*(1.018^(wave - 121))/1000) * 1000 end
							if health > 2000000000 then health = 2000000000 end --达到数值上限
		
							unit:SetBaseMaxHealth(health)
							unit:SetMaxHealth(health)
							unit:SetHealth(unit:GetMaxHealth())
		
							if difficulty == 1 then
								unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+3*math.min(50,currentWave)-10)
								unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+3*math.min(50,currentWave)-10)
							elseif difficulty == 2 then
								unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+3*math.min(50,currentWave)-10)
								unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+3*math.min(50,currentWave)-10)
							elseif difficulty == 3 then
								unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+6*math.min(25,currentWave)-10)
								unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+6*math.min(25,currentWave)-10)
							else
								unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+6*math.min(25,currentWave)-10)
								unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+6*math.min(25,currentWave)-10)
							end		
							
							local damageDecrease = math.max(-25*(1+(math.min(difficulty,4)-1)*0.5),-currentWave*4)
							ModifyDamageIncomingPercentage(unit,damageDecrease)
						else
							local modifier = unit:AddNewModifier(unit, nil, "modifier_move_speed", nil)
							modifier:SetStackCount(math.floor(wave/4)*20)
		
							local health = unit:GetBaseMaxHealth()*(1+(math.min(difficulty,4)-1)*0.5)
						
							unit:SetBaseMaxHealth(health)
							unit:SetMaxHealth(health)
							unit:SetHealth(unit:GetMaxHealth())
		
							if difficulty >= 5 then								
								local damageDecrease = -wave
								ModifyDamageIncomingPercentage(unit,damageDecrease)
							end
						end
		
						if difficulty >= 5 and wave > 50 and wave%4 == 0 and spawnerLine.nextBossName ~= nil then
							unit:AddNewModifier(unit, nil, "modifier_bosses_"..spawnerLine.nextBossName, nil)
						end					
		
						if unit.next_move_point == nil then
							unit.next_move_point = G_path_corner[spawnerLine.firstPoint].Vector * 1.5
							table.insert(THTD_EntitiesRectInner[hero.thtd_player_id], unit)
							unit.first_move_point = G_path_corner[spawnerLine.firstPoint].Vector * 1.5
						end
		
						if unit.next_move_forward == nil then
							unit.next_move_forward = spawnerLine.firstForward 
							unit.first_move_forward = spawnerLine.firstForward 
						end
		
						unit:SetContextThink(DoUniqueString("AttackingBase"), 
							function ()
								if GameRules:IsGamePaused() then return 0.1 end
								if unit == nil or unit:IsNull() or unit:IsAlive() == false then return nil end
		
								if unit.thtd_is_outer ~= true then
									local origin = unit:GetOrigin()
									if not(origin.x < 4432 and origin.x > -4432 and origin.y < 3896 and origin.y > -3896) then
										unit.thtd_is_outer = true
										table.insert(THTD_EntitiesRectOuter,unit)
										for k,v in pairs(THTD_EntitiesRectInner[hero.thtd_player_id]) do
											if v == unit then										
												table.remove(THTD_EntitiesRectInner[hero.thtd_player_id],k)
												break
											end
										end
									end
								end
								unit:MoveToPosition(unit.next_move_point)

								-- 替代触发器
								-- for k,v in pairs(UnitMoveRect[unit.thtd_player_index]) do
								-- 	if GetDistanceBetweenTwoVec2D(unit:GetOrigin(), Vector(v["center"][1],v["center"][2]),0) <= v["radius"] then 
								-- 		if unit.current_rect_id ~= k then 
								-- 			unit.current_rect_id = k
								-- 			local tagIndex = v["tag"][RandomInt(1, #v["tag"])]
								-- 			unit.next_move_point = Vector(UnitMoveRect[unit.thtd_player_index][tagIndex]["center"][1],UnitMoveRect[unit.thtd_player_index][tagIndex]["center"][2],0)
								-- 			unit:MoveToPosition(unit.next_move_point)
								-- 		end
								-- 		break
								-- 	end								
								-- end

								return 0.5
							end, 
						0) 
					end
		
					curTimes = curTimes + 1
		
					return interval
				end, 
			0)
		end
	end	
end

-- 清除已移除刷怪点
function SpawnSystem:ClearRemovedSpawner()	
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return end
	for i = #spawner, 1, -1 do
		if spawner[i].hero.is_game_over or spawner[i].hero:IsStunned() then
			THTD_EntitiesRectInner[spawner[i].hero.thtd_player_id] = {}
			table.remove(spawner, i)			
		end
	end	
end

-- 刷新漏怪最大数
function SpawnSystem:RefreshCreepMaxCount()
	local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
	for _,hero in pairs(heroes) do	
		if SpawnSystem.IsUnLimited then 
			hero.thtd_game_info["creep_count_max"] = 30
		else			
			hero.thtd_game_info["creep_count_max"] = 40 * SpawnSystem:GetCount()
		end
	end
end



-- 神绮技能

local shinki_01_draw_card_type = 
{
	[1] = {
		["Level1"] = 1,
	},
	[2] = {
		["Level1"] = 2,
	},
	[3] = {
		["Level2"] = 3,
	},
	[4] = {
		["Level2"] = 3,
		["Level3"] = 1,
	},
	[5] = {
		["Level3"] = 5,
	},
}

function OnShinkiGainCard(caster)
	local hero = caster:GetOwner()
	local count = 0
	for k,v in pairs(shinki_01_draw_card_type[caster:THTD_GetStar()]) do
		if k == "Level1" then
			local drawList = {}

			drawList[1] = {}
			for k,v in pairs(towerNameList) do
				if v["quality"] == 1 and v["cardname"] ~= "BonusEgg" then
					table.insert(drawList[1],k)
				end
			end

			for i=1,v do
				local item = CreateItem(drawList[1][RandomInt(1,#drawList[1])], nil, nil)
				if item ~= nil then		
					item.owner_player_id = hero.thtd_player_id
					item:SetPurchaser(hero)
					item:SetPurchaseTime(1.0)
					local origin = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, count * 130, -150)					
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_shinki/ability_shinki_01.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(effectIndex, 0, origin - Vector(0,0,750))
					ParticleManager:DestroyParticleSystem(effectIndex,false)
					caster:SetContextThink(DoUniqueString("thtd_shinki_01_effect_wait"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							CreateItemOnPositionSync(origin,item)
							return nil
						end,
					3.0)
					count = count + 1
				end
			end
			
		elseif k == "Level2" then
			local drawList = {}

			drawList[1] = {}
			drawList[2] = {}

			for k,v in pairs(towerNameList) do
				if v["quality"] == 1 and v["cardname"] ~= "BonusEgg" then
					table.insert(drawList[1],k)
				elseif v["quality"] == 2 and v["cardname"] ~= "BonusEgg" and v["cardname"] ~= "item_2021" and v["cardname"] ~= "item_2022" then
					table.insert(drawList[2],k)
				end
			end

			for i=1,v do
				local chance = RandomInt(0,100)
				local item = nil
				if chance <=20 then
					if #drawList[2] > 0 then
						item = CreateItem(drawList[2][RandomInt(1,#drawList[2])], nil, nil)						
					end
				elseif chance > 20 then
					if #drawList[1] > 0 then
						item = CreateItem(drawList[1][RandomInt(1,#drawList[1])], nil, nil)						
					end
				end

				if item~=nil then		
					item.owner_player_id = hero.thtd_player_id
					item:SetPurchaser(hero)
					item:SetPurchaseTime(1.0)
					local origin
					if string.sub(item:GetAbilityName(), 1, 6) == "item_2" then
						origin = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, count * 130, 0)	
					else						
						origin = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, count * 130, -150)		
					end	
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_shinki/ability_shinki_01.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(effectIndex, 0, origin - Vector(0,0,750))
					ParticleManager:DestroyParticleSystem(effectIndex,false)
					caster:SetContextThink(DoUniqueString("thtd_shinki_01_effect_wait"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							CreateItemOnPositionSync(origin,item)
							return nil
						end,
					3.0)
					count = count + 1
				end
			end

		elseif k == "Level3" then
			local drawList = {}

			drawList[2] = {}
			drawList[3] = {}
			drawList[4] = {}

			for k,v in pairs(towerNameList) do
				if v["quality"] == 2 and v["cardname"] ~= "BonusEgg" and v["cardname"] ~= "item_2021" and v["cardname"] ~= "item_2022" then
					table.insert(drawList[2],k)
				elseif v["quality"] == 3 and v["cardname"] ~= "BonusEgg" and v["cardname"] ~= "item_2023" and v["cardname"] ~= "item_2024" then
					table.insert(drawList[3],k)
				elseif v["quality"] == 4 and v["cardname"] ~= "BonusEgg" then
					table.insert(drawList[4],k)
				end
			end

			for i=1,v do
				local chance = RandomInt(1,100)

				if caster.thtd_chance_count == nil then 
					caster.thtd_chance_count = {}
				end
				if caster.thtd_chance_count["shinki_SSR"] == nil then 
					caster.thtd_chance_count["shinki_SSR"] = 0
				end
				if caster.thtd_chance_count["shinki_SSR"] >= 20 then 
					chance = 0
				end
				if chance > 5 then
					caster.thtd_chance_count["shinki_SSR"] = caster.thtd_chance_count["shinki_SSR"] + 1
				end

				local item = nil
				if chance <=5 then
					caster.thtd_chance_count["shinki_SSR"] = 0
					if #drawList[4] > 0 then
						item = CreateItem(drawList[4][RandomInt(1,#drawList[4])], nil, nil)						
					end
				elseif chance <= 25 then
					if #drawList[3] > 0 then
						item = CreateItem(drawList[3][RandomInt(1,#drawList[3])], nil, nil)
					end
				elseif chance > 25 then
					if #drawList[2] > 0 then
						item = CreateItem(drawList[2][RandomInt(1,#drawList[2])], nil, nil)
					end
				end

				if item~=nil then
					item.owner_player_id = hero.thtd_player_id
					item:SetPurchaser(hero)
					item:SetPurchaseTime(1.0)
					local origin
					if string.sub(item:GetAbilityName(), 1, 6) == "item_2" then
						origin = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, count * 130, 0)
					else
						if item:THTD_GetCardQuality() == 4 then 
							origin = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, count * 130, -150*2)
						else
							origin = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, count * 130, -150)
						end
					end
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_shinki/ability_shinki_01.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(effectIndex, 0, origin - Vector(0,0,750))
					ParticleManager:DestroyParticleSystem(effectIndex,false)
					caster:SetContextThink(DoUniqueString("thtd_shinki_01_effect_wait"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							CreateItemOnPositionSync(origin,item)
							return nil
						end,
					3.0)
					count = count + 1
				end
			end
		end
	end
end
