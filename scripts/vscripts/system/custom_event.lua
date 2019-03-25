if CustomEvent == nil then
	CustomEvent = {}
end

function CustomEvent:GetHero(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player then
		local hero = player:GetAssignedHero()
		if hero then
			return hero
		end
	end
	return nil
end

CustomEvent.on = function( event, func )	
	CustomGameEventManager:RegisterListener(event, function(a,b) func(b) end)	
end


-- 按键按下, todo
CustomEvent.on('avalon_key_pressed',function( data )
	local hero = CustomEvent:GetHero( data )
	if hero then
		local key = data.key
		if type(key) == "string" then
			local is_key_pressed = false
			for k,v in pairs(hero.press_key) do
				if v == key then
					is_key_pressed = true
				end
			end
			if is_key_pressed == false then
				table.insert(hero.press_key,key)
			end
		end
		local press_key = ""
		for k,v in pairs(hero.press_key) do
			if v ~= nil then
				press_key = press_key..v
			end
		end

		if press_key == "6" then
			ParticleManager:DestroyParticleSystem(hero.thtd_emoji_effect,true)
			hero.thtd_emoji_effect = ParticleManager:CreateParticle("particles/thtd/emoji/thtd_msg_hongliange.vpcf", PATTACH_CUSTOMORIGIN, hero) 
			ParticleManager:SetParticleControlEnt(hero.thtd_emoji_effect , 0, hero, 5, "attach_emoji", Vector(0,0,0), true)
			ParticleManager:SetParticleControl(hero.thtd_emoji_effect, 3, Vector(1,0,0))
			ParticleManager:DestroyParticleSystemTime(hero.thtd_emoji_effect,5.0)
		elseif press_key == "7" then
			ParticleManager:DestroyParticleSystem(hero.thtd_emoji_effect,true)
			hero.thtd_emoji_effect = ParticleManager:CreateParticle("particles/thtd/emoji/thtd_msg_hongliange.vpcf", PATTACH_CUSTOMORIGIN, hero) 
			ParticleManager:SetParticleControlEnt(hero.thtd_emoji_effect , 0, hero, 5, "attach_emoji", Vector(0,0,0), true)
			ParticleManager:SetParticleControl(hero.thtd_emoji_effect, 3, Vector(2,0,0))
			ParticleManager:DestroyParticleSystemTime(hero.thtd_emoji_effect,5.0)
		elseif press_key == "8" then
			ParticleManager:DestroyParticleSystem(hero.thtd_emoji_effect,true)
			hero.thtd_emoji_effect = ParticleManager:CreateParticle("particles/thtd/emoji/thtd_msg_hongliange.vpcf", PATTACH_CUSTOMORIGIN, hero) 
			ParticleManager:SetParticleControlEnt(hero.thtd_emoji_effect , 0, hero, 5, "attach_emoji", Vector(0,0,0), true)
			ParticleManager:SetParticleControl(hero.thtd_emoji_effect, 3, Vector(3,0,0))
			ParticleManager:DestroyParticleSystemTime(hero.thtd_emoji_effect,5.0)
		elseif press_key == "9" then
			ParticleManager:DestroyParticleSystem(hero.thtd_emoji_effect,true)
			hero.thtd_emoji_effect = ParticleManager:CreateParticle("particles/thtd/emoji/thtd_msg_hongliange.vpcf", PATTACH_CUSTOMORIGIN, hero) 
			ParticleManager:SetParticleControlEnt(hero.thtd_emoji_effect , 0, hero, 5, "attach_emoji", Vector(0,0,0), true)
			ParticleManager:SetParticleControl(hero.thtd_emoji_effect, 3, Vector(4,0,0))
			ParticleManager:DestroyParticleSystemTime(hero.thtd_emoji_effect,5.0)
		elseif press_key == "0" then
			ParticleManager:DestroyParticleSystem(hero.thtd_emoji_effect,true)
			hero.thtd_emoji_effect = ParticleManager:CreateParticle("particles/thtd/emoji/thtd_msg_hongliange.vpcf", PATTACH_CUSTOMORIGIN, hero) 
			ParticleManager:SetParticleControlEnt(hero.thtd_emoji_effect , 0, hero, 5, "attach_emoji", Vector(0,0,0), true)
			ParticleManager:SetParticleControl(hero.thtd_emoji_effect, 3, Vector(5,0,0))
			ParticleManager:DestroyParticleSystemTime(hero.thtd_emoji_effect,5.0)
		end
	end
end)


-- 按键松开
CustomEvent.on('avalon_key_released',function( data )
	local hero = CustomEvent:GetHero( data )

	if hero then
		local key = data.key
		if type(key) == "string" then
			for k,v in pairs(hero.press_key) do
				if v == key then
					table.remove(hero.press_key,k)
				end
			end
		end
	end
end)


-- 选择难度
PlayersSelectedDifficulty = {}
CustomEvent.on('custom_game_select_difficulty', function(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	PlayersSelectedDifficulty[data.PlayerID] = data.level or 0	
	CustomNetTables:SetTableValue("CustomGameInfo", "PlayersSelectedDifficulty", PlayersSelectedDifficulty )
end)


-- 完成状态
local PlayersCompleteStatus = {}
local isUpdate = false
CustomEvent.on('custom_game_complete_select_cards', function(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end
	if PlayersCompleteStatus[data.PlayerID] == 1 then return end
	
	for k,v in pairs(data["cards"]) do
		local itemTable = 
		{
			["itemName"] = k,
			["quality"]= towerNameList[k]["quality"],
			["count"]= v,
		}
		table.insert(towerPlayerList[data.PlayerID+1],itemTable)
	end	

	PlayersCompleteStatus[data.PlayerID] = 1
	CustomNetTables:SetTableValue("CustomGameInfo", "PlayersCompleteStatus", PlayersCompleteStatus )
	SetNetTableTowerPlayerList(data.PlayerID)
	
	if isUpdate == false then 
		CustomNetTables:SetTableValue("CustomGameInfo", "thtd_power_table", thtd_power_table)
		CustomNetTables:SetTableValue("CustomGameInfo", "thtd_attack_table", thtd_attack_table)	

		local playerAccounts = {}
		for i=0,PlayerResource:GetPlayerCount()-1 do
			if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then 
				playerAccounts[i] = tostring(PlayerResource:GetSteamAccountID(i))
			end			
		end		
		CustomNetTables:SetTableValue("CustomGameInfo", "thtd_player_account", playerAccounts)
				
		isUpdate = true
	end
end)


-- 投票踢人
local playerVote =
{
	vote_time = 0,
	vote_player = -1,
	kicked_player = -1,	
	kicked_line = -1,
	agree_players = {}	
}

CustomEvent.on('custom_game_kick_vote', function(data)
	if SpawnSystem.CurWave > 50 + 20 then 
		GameRules:SendCustomMessage("<font color='red'>无尽20波以后不能发起踢人投票</font>", DOTA_TEAM_GOODGUYS, 1)
		return 
	end
	local player = PlayerResource:GetPlayer(data.PlayerID)	
	if player ==nil then return end
	local hero = player:GetAssignedHero()
	if hero.is_game_over or hero:IsStunned() then return end	
	
	if playerVote.kicked_player ~= - 1 and (math.floor(GameRules:GetGameTime()) - playerVote.vote_time) < 60 then
		CustomGameEventManager:Send_ServerToPlayer(player, "show_message", {msg="player_in_vote", duration=10, params={count=playerVote.kicked_player+1}, color="#ff0"})
		return 
	end

	local kicked_player = -1
	local spawner = SpawnSystem.AttackingSpawner	
	if spawner == nil or #spawner == 0 then return end	
	for _, spawnerLine in pairs(spawner) do	
		if spawnerLine.index == data.line_index then
			kicked_player = spawnerLine.hero.thtd_player_id
			break
		end
	end		
	if kicked_player == -1 then return end	
	
	playerVote.vote_time = math.floor(GameRules:GetGameTime())
	playerVote.vote_player = data.PlayerID
	playerVote.kicked_player = kicked_player
	playerVote.kicked_line = data.line_index
	playerVote.agree_players = {}	
	CustomGameEventManager:Send_ServerToAllClients("kick_player", {vote_player=playerVote.vote_player, kicked_player=playerVote.kicked_player, kicked_line = playerVote.kicked_line})	
end)

CustomEvent.on('custom_game_kick_accept', function(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)	
	if player ==nil then return end
	local hero = player:GetAssignedHero()
	if hero.is_game_over or hero:IsStunned() then return end
	if playerVote.kicked_player == -1 then return end
	
	if data.accept == 1 then 
		table.insert(playerVote.agree_players, data.PlayerID)						
		local agrees = playerVote.agree_players			
		if #agrees >= (GetValidVotePlayerCount() - 1) then 
			KickPlayer()
		end		
	else		
		playerVote.vote_time = 0
		playerVote.vote_player = -1
		playerVote.kicked_player = -1
		playerVote.kicked_line = - 1
		playerVote.agree_players = {}
		CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="player_vote_no_pass", duration=10, params={count=data.PlayerID+1}, color="#ff0"})		
	end
end)

function KickPlayer()
	local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
	for index,hero in pairs(heroes) do
		if hero~=nil and hero:IsNull()==false and hero:IsAlive() and hero.is_game_over==fasle and hero:IsStunned()==false and hero.thtd_player_id == playerVote.kicked_player then
			SpawnSystem:GameOver(hero)	
			CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="player_vote_pass", duration=10, params={count=playerVote.kicked_player+1}, color="#ff0"})
			break			
		end
	end	
	playerVote.vote_time = 0
	playerVote.vote_player = -1
	playerVote.kicked_player = -1
	playerVote.kicked_line = - 1
	playerVote.agree_players = {}
end

function GetValidVotePlayerCount()
	local count = 0
	local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
	for index,hero in pairs(heroes) do
		if hero~=nil and hero:IsNull()==false and hero:IsAlive() and hero.is_game_over==false and hero:IsStunned() == false and hero.thtd_game_info["is_player_connected"] then
			count = count + 1
		end
	end
	return count
end



-- 选择初始卡
CustomEvent.on('custom_game_select_start_card', function(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)	
	if player ==nil then return end	
	local hero = player:GetAssignedHero()
	if hero:GetLevel() >= 6 then 
		CustomGameEventManager:Send_ServerToPlayer(player, "select_start_card_finish", {})		
		return 
	end
	if hero:GetNumItemsInInventory()>=9 then 
		CustomGameEventManager:Send_ServerToPlayer(player, "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return 
	end
	local item = CreateItem(data.ItemName, nil, nil)	
	if item ~= nil then 
		item.owner_player_id = hero.thtd_player_id
		item.is_bonus_item = true
		hero:AddItem(item)
		if data.ItemName == "item_0003" then hero:AddItem(CreateItem("item_0088", nil, nil)) end
		for i=1,5 do
			hero:HeroLevelUp(false)
		end
		-- hero:SetAbilityPoints(0)		
		CustomGameEventManager:Send_ServerToPlayer(player, "select_start_card_finish", {})
	end
end)

-- 选择初始奖励卡
CustomEvent.on('custom_game_select_bonus_card', function(data)	
	local player = PlayerResource:GetPlayer(data.PlayerID)	
	if player ==nil then return end	
	local hero = player:GetAssignedHero()
	if hero:GetLevel() >= 9 then return end		
	if hero:GetNumItemsInInventory()>=8 then 
		CustomGameEventManager:Send_ServerToPlayer(player, "select_bonus_card_no_finish", {})
		CustomGameEventManager:Send_ServerToPlayer(player, "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return 
	end
	local item = CreateItem(data.ItemName, nil, nil)	
	if item ~= nil then
		item.owner_player_id = hero.thtd_player_id
		item.is_bonus_item = true
		hero:AddItem(item)	
		local cardName = item:THTD_GetCardName()
		if item:THTD_IsCardHasVoice() == true then EmitSoundOnClient(THTD_GetVoiceEvent(cardName,"spawn"),player) end	
		if item:THTD_IsCardHasPortrait() == true then
			local portraits= item:THTD_GetPortraitPath(cardName)			
			local effectIndex = ParticleManager:CreateParticle(portraits, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(effectIndex, 0, Vector(-58,-80,0))
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(80,0,0))
			ParticleManager:DestroyParticleSystemTime(effectIndex,6.0)
			effectIndex = ParticleManager:CreateParticle("particles/portraits/portraits_ssr_get_screen_effect.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:DestroyParticleSystemTime(effectIndex,4.0)
			hero:EmitSound("Sound_THTD.thtd_draw_ssr")				
		end	
		for i=1,3 do
			hero:HeroLevelUp(false)
		end		
		if data.ItemName == "item_2023" or data.ItemName == "item_2024" or data.ItemName == "item_0096" then 
			local item2004 = CreateItem("item_2004", nil, nil)
			if item2004 ~= nil then 
				item2004.owner_player_id = hero.thtd_player_id
				item2004.is_bonus_item = true
				hero:AddItem(item2004)
			end
		end
	end	
end)

-- 御币选择卡片
CustomEvent.on('select_card', function(data)	
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player==nil then return end
	local caster = player:GetAssignedHero()
	if caster == nil then return end
	local itemName = data.itemname
	if itemName ~= nil and THTD_GetItemCountByName(data.PlayerID,itemName) > 0 then 
		if caster.thtd_last_select_item~=nil and caster.thtd_last_select_item:IsNull()==false then			
			OnItemDestroyed(caster, caster.thtd_last_select_item, false)
			caster:THTD_AddCardPoolItem(itemName)
		end
	end
end)


-- AI选择
CustomEvent.on('custom_game_choose_ai', function(data)		
	local caster = EntIndexToHScript(data.entity) 	
	if caster == nil then return end
	if data.result == 1 or data.result == true then
		caster["thtd_"..data.name.."_0"..tostring(data.skill).."_cast"] = true
	else
		caster["thtd_"..data.name.."_0"..tostring(data.skill).."_cast"] = false
	end	
end)

CustomEvent.on('custom_game_command', function(data)	
	if data["cmd"] == "wave" then
		SpawnSystem.ReachToWave = data["param"]
		CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="reach_to_wave", duration=20, params={count=data["param"]}, color="#ff0"})	
		return
	end
	
	if data["cmd"] == "add" then
		PlayerResource:ModifyGold(data["PlayerID"], 95000 , true, DOTA_ModifyGold_Unspecified) 
		local player = PlayerResource:GetPlayer(data["PlayerID"])	
		local itemName = "item_"..data["param"]
		if string.len(itemName) ~= 9 then return end
		local item = CreateItem(itemName, nil, nil)	
		if player ~= nil and item ~= nil then
			local hero = player:GetAssignedHero()
			if hero:GetNumItemsInInventory() < 9 then 
				item.owner_player_id = hero.thtd_player_id
				hero:AddItem(item)
			end
		end
		return
	end	

	if data["cmd"] == "tp" then		
		local pos = string.split(data["param"], ",")
		if pos == nil or #pos < 2 then return end	
		local vec = Vector(tonumber(pos[1]), tonumber(pos[2]), 144)
		if vec ~= nil then
			local player = PlayerResource:GetPlayer(data["PlayerID"])	
			local hero = player:GetAssignedHero()
			hero:SetAbsOrigin(vec)
		end
		return 
	end

	if data["cmd"] == "clearrank" then	
		http.api.clearSameRank()
		return
	end

	if data["cmd"] == "levelup" then	
		local player = PlayerResource:GetPlayer(data["PlayerID"])
		if player then
			local hero = player:GetAssignedHero()
			for k,v in pairs(hero.thtd_hero_tower_list) do
				if v~=nil and v:IsNull()==false and v:IsAlive() and v:THTD_IsTower() then
					v:THTD_SetAbilityLevelUp()
					v:THTD_SetAbilityLevelUp()
					v:THTD_SetAbilityLevelUp()
					v:THTD_SetAbilityLevelUp()
					if v:THTD_GetStar() < 5 then
						v:THTD_SetStar(5)
					end 
					if v:THTD_GetLevel() < THTD_MAX_LEVEL then
						v:THTD_SetLevel(THTD_MAX_LEVEL)
					end
				end
			end
		end
	end
end)

CustomEvent.on('custom_game_save_cardgroup', function(data)	
	local playerid = data.PlayerID	
	if GameRules.players_card_group[playerid] == nil or GameRules.players_card_group[playerid]["_id"] == nil then 			
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_cardgroup", {code = 0, msg = "卡组信息不存在，请等待获取卡组完成。"})
		return 
	end

	if GameRules.players_card_group[playerid]["_id"] == "-1" then
		http.api.saveFirstCardGroup(playerid, data.groupkey, data.groupdata) 
	else
		http.api.saveCardGroup(playerid, data.groupkey, data.groupdata) 
	end

	local steamid = tostring(PlayerResource:GetSteamID(playerid))
	GameRules.players_card_group[playerid][data.groupkey] = data.groupdata
	CustomNetTables:SetTableValue("CustomGameInfo", "PlayerCardGroup"..steamid, GameRules.players_card_group[playerid])
end)

-- 重连时重试获取用户卡组信息
CustomEvent.on('custom_game_load_cardgroup', function(data)	
	http.api.getCardGroup(data.PlayerID)
end)

CustomEvent.on('custom_game_rank_detail', function(data)	
	local playerid = data.PlayerID
	local rankdata = {}
	rankdata['index'] = data.index	
	if tostring(PlayerResource:GetSteamID(playerid)) == tostring(GameRules.players_rank_data[data.index]._name) then 
		rankdata['is_local_player'] = 1
	else
		rankdata['is_local_player'] = 0
	end
	local playerRankData
	if data.type == 1 then
		playerRankData = GameRules.players_rank_data[data.index]
	else
		playerRankData = GameRules.players_team_rank_data[data.index]
	end
	for k,v in pairs(playerRankData) do
		if string.sub(k,1,4) == "card" then
			rankdata[k] = v
		end
	end
	if data.type == 1 then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_rank_detail", rankdata)
	else
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_team_rank_detail", rankdata)
	end
	rankdata = {}
end)

CustomEvent.on('custom_game_rank_reset', function(data)	
	if data.index > 0 then
		if data.type == 1 then
			http.api.resetRank(data.index, data.PlayerID)
		else
			http.api.resetTeamRank(data.index, data.PlayerID)
		end
	else
		if data.type == 1 then
			local total = #GameRules.players_rank
			local count = 1
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("ResetRankAll"),
				function()
					http.api.resetRank(count, data.PlayerID)
					count = count + 1
					if count > total then 
						return nil 
					else
						return 1.0
					end
				end,
			0)
		else
			local total = #GameRules.players_team_rank
			local count = 1
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("ResetRankAll"),
				function()
					http.api.resetTeamRank(count, data.PlayerID)
					count = count + 1
					if count > total then 
						return nil 
					else
						return 1.0
					end
				end,
			0)
		end
	end	
end)
