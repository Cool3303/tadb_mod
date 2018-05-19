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
end

CustomEvent.on = function( event, func )
	if IsInToolsMode() then
		if CustomEvent[event] == nil then
			CustomGameEventManager:RegisterListener(event, function(a,b)
				CustomEvent[event](b)
			end)
		end
		CustomEvent[event] = func
	else
		CustomGameEventManager:RegisterListener(event, function(a,b)
			func(b)
		end)
	end
end

-- 按键按下
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

CustomEvent.on('avalon_custom_control_mouse_move',function( data )
	local hero = CustomEvent:GetHero(data)

	if hero and hero.thtd_close_star == true then
		local mouse_pos = data.mouse_pos
		local pos = Vector(mouse_pos["0"],mouse_pos["1"],mouse_pos["2"])

		local targets = FindUnitsInRadius(
				hero:GetTeamNumber(), 
				pos, 
				nil, 
				50, 
				DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_NONE, 
				FIND_CLOSEST, 
				false
			)

		if targets[1] ~= nil and targets[1]:THTD_IsTower() and (targets[1] ~= hero.focusTarget or hero.focusTarget == nil) then
			targets[1]:THTD_CreateLevelEffect()
			hero.focusTarget = targets[1]
		end

		hero.focusTarget = targets[1]
	end
end)


-- 选择难度
PlayersSelectedDifficulty = {}

CustomEvent.on('custom_game_select_difficulty', function(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end

	PlayersSelectedDifficulty[data.PlayerID] = data.level or 0
	CustomNetTables:SetTableValue("CustomGameInfo", "PlayersSelectedDifficulty", PlayersSelectedDifficulty );
end)

-- 完成状态
local PlayersCompleteStatus = {}

CustomEvent.on('custom_game_complete_select_cards', function(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player ==nil then return end
	if PlayersCompleteStatus[data.PlayerID] == 1 then return end

	local mode = data["mode"] -- 选择的模式

	if mode == "Free" and CanSelectFreeMode(data.PlayerID) then -- 自由选择
		local cards = data["cards"] -- 选择的卡组
		for k,v in pairs(cards) do
			local itemTable = 
			{
				["itemName"] = k,
				["quality"]= towerNameList[k]["quality"],
				["count"]= v,
			}
			table.insert(towerPlayerList[data.PlayerID+1],itemTable)
		end
		PrintTable(towerPlayerList[data.PlayerID+1])

		if not HasTouhouVIP(data.PlayerID) then
			ServerEvent( "save_selected_cards", data.PlayerID, {cards=cards} )
		end
	
	elseif mode == "AutoRandom" or not CanSelectFreeMode(data.PlayerID) then -- 自动随机
		if HasAutoRandomExtensionPacks(data.PlayerID) then
			towerPlayerList[data.PlayerID+1] = {}
			for k,v in pairs(towerNameList) do
				local itemTable = 
				{
					["itemName"] = k,
					["quality"]= towerNameList[k]["quality"],
					["count"]= 5,
				}
				if itemTable["quality"] == 1 then
					itemTable["count"] = 10
				end
				if string.find(itemTable["itemName"], 'item_20') ~= nil then
					if itemTable["itemName"] == "item_2021" or itemTable["itemName"] == "item_2022" 
					or itemTable["itemName"] == "item_2023" or itemTable["itemName"] == "item_2024" then
						itemTable["count"] = 1
					else
						itemTable["count"] = 4
					end
				end
				if v["kind"] ~= "BonusEgg" then
					table.insert(towerPlayerList[data.PlayerID+1],itemTable)
				end
			end
		else
			local cardpool = GetPlayerCardPool(data.PlayerID)
			for k,v in pairs(cardpool) do
				local itemTable = 
				{
					["itemName"] = k,
					["quality"]= towerNameList[k]["quality"],
					["count"]= 5,
				}
				if itemTable["quality"] == 1 then
					itemTable["count"] = 10
				end
				if string.find(itemTable["itemName"], 'item_20') ~= nil then
					if itemTable["itemName"] == "item_2021" or itemTable["itemName"] == "item_2022" 
					or itemTable["itemName"] == "item_2023" or itemTable["itemName"] == "item_2024" then
						itemTable["count"] = 1
					else
						itemTable["count"] = 4
					end
				end
				table.insert(towerPlayerList[data.PlayerID+1],itemTable)
			end
		end
		PrintTable(towerPlayerList[data.PlayerID+1])
	end

	PlayersCompleteStatus[data.PlayerID] = 1
	CustomNetTables:SetTableValue("CustomGameInfo", "PlayersCompleteStatus", PlayersCompleteStatus );
end)