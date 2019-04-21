if CTHTDGameMode == nil then
	CTHTDGameMode = class({})
end

require( "util")
require( "common")
require( "system/spawner")
require( "system/items")
require( "system/tower")
require( "system/damage")
require( "system/custom_event")
require( "system/combo")
require( "ai/common")
require( "trigger/PassCorner")

function Precache( context )

	PrecacheEveryThingFromKV( context )

	PrecacheResource( "particle", "particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf",context )
	PrecacheResource( "particle", "particles/thtd/msg/thtd_msg_level.vpcf",context )
	PrecacheResource( "particle", "particles/thtd/msg/thtd_msg_star.vpcf",context )
	PrecacheResource( "particle", "particles/thtd/msg/thtd_msg_food.vpcf",context )
	PrecacheResource( "particle", "particles/common/thtd_food_msg.vpcf",context )

	PrecacheResource( "particle_folder", "particles/portraits", context )

	PrecacheResource( "particle", "particles/heroes/lily/ability_lily_01_a.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/lily/ability_lily_02.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_cirno/ability_cirno_02.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/letty/ability_letty_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/kogasa/ability_kogasa_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/kogasa/ability_kogasa_01_debuff.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/lyrica/ability_lyrica_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/lunasa/ability_lunasa_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/lunasa/ability_lunasa_buff.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/merlin/ability_merlin_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/merlin/ability_merlin_buff.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/rumia/ability_rumia_02_projectile.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/satori/ability_satori_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/iku/ability_iku_lightning.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/iku/ability_iku_01_explosion.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_marisa/ability_marisa_02.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_marisa/ability_marisa_02_pink.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_marisa/ability_marisa_02_blue.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_marisa/ability_marisa_02_normal.vpcf",context )
	PrecacheResource( "particle", "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/tenshi/ability_tenshi_03.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_patchouli/ability_patchouli_01_agni_shine.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_patchouli/ability_patchouli_01_bury_in_lake.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_patchouli/ability_patchouli_01_mercury_poison.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_reisen/ability_reisen_03.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_yuyuko/ability_yuyuko_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_yuyuko/ability_yuyuko_04.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/thtd_youmu/ability_youmu_01_laser.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/youmu/youmu_02_effect_explosion.vpcf",context )
	PrecacheResource( "particle", "particles/thd2/heroes/youmu/youmu_01_blink_effect.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/youmu/youmu_04_circle.vpcf",context )
	PrecacheResource( "particle", "particles/thd2/heroes/youmu/youmu_04_sword_effect.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/rin/ability_rin_02_body_c.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/rin/ability_rin_01_projectile.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/rin/ability_rin_01.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/moluo/abiilty_moluo_014.vpcf",context )
	PrecacheResource( "particle", "particles/thd2/heroes/utsuho/ability_utsuho03_effect.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/lyrica/ability_lyrica_music_buff.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/lunasa/ability_lunasa_music_buff.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/merlin/ability_merlin_music_buff.vpcf",context )

	PrecacheResource( "particle", "particles/heroes/byakuren/ability_byakuren_02.vpcf",context )
	PrecacheResource( "particle", "particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf",context )
	PrecacheResource( "particle", "particles/thd2/items/item_yatagarasu.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/daiyousei/ability_daiyousei_02.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/cirno/ability_cirno_02.vpcf",context )	

	PrecacheResource( "particle", "particles/heroes/yumemi/ability_yumemi_04_exolosion.vpcf",context )	
	PrecacheResource( "particle", "particles/thd2/items/item_donation_box.vpcf",context )	
	PrecacheResource( "particle", "particles/thtd_item/ability_item_2022.vpcf",context )	

	PrecacheResource( "particle", "particles/thtd/emoji/thtd_msg_hongliange.vpcf",context )
	PrecacheResource( "particle", "particles/thd2/environment/death/act_hero_die.vpcf",context )

	PrecacheResource( "soundfile", "soundevents/custom_game/ui.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/custom_game/store.vsndevts", context )

	-- bosses
	PrecacheResource( "particle", "particles/heroes/minoriko/ability_minoriko_04.vpcf",context )
	PrecacheResource( "particle", "particles/bosses/thtd_keine/ability_bosses_keine.vpcf",context )
	PrecacheResource( "particle", "particles/thd2/heroes/rumia/ability_rumia01_effect.vpcf",context )
	PrecacheResource( "particle", "particles/heroes/marisa/marisa_01_rocket_a.vpcf",context )

end

function Activate()
	GameRules.THTDGameMode = CTHTDGameMode()
	GameRules.THTDGameMode:InitGameMode()
end


function CTHTDGameMode:InitGameMode()
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1734.0)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(self:SettingExp())
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(THTD_MAX_LEVEL)
	GameRules:SetStartingGold(1500)
	GameRules:SetGoldPerTick(0)
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
	GameRules:SetSameHeroSelectionEnabled(true)
 	GameRules:SetHeroSelectionTime(10)
 	GameRules:SetPreGameTime(30)
 	GameRules:SetStrategyTime(0)
 	GameRules:SetShowcaseTime(0)
 	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
 	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
 	GameRules:GetGameModeEntity():SetGoldSoundDisabled(true)

	ListenToGameEvent('entity_killed', Dynamic_Wrap(CTHTDGameMode, 'OnEntityKilled'), self)    	
  	ListenToGameEvent('player_chat', Dynamic_Wrap(CTHTDGameMode, 'OnPlayerSay'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(CTHTDGameMode, 'OnGameRulesStateChange'), self)

	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(CTHTDGameMode, 'ExecuteOrder'), self)
  	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(CTHTDGameMode, 'ItemAddedToInventory'), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(CTHTDGameMode, 'DamageFilter'), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(CTHTDGameMode, 'ModifierFilter'), self)		
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(CTHTDGameMode, 'OnModifyGoldFilter'), self)

	LinkLuaModifier("modifier_magical_armor", "modifiers/modifier_magical_armor", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_move_speed", "modifiers/modifier_move_speed", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_move_max_speed", "modifiers/modifier_move_max_speed", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_speed", "modifiers/modifier_attack_speed", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_time", "modifiers/modifier_attack_time", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_cooldown_reduce", "modifiers/modifier_cooldown_reduce", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2005_attack_aura", "modifiers/modifier_item_2005_attack_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2005_attack_aura_effect", "modifiers/modifier_item_2005_attack_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2006_mana_regen_aura", "modifiers/modifier_item_2006_mana_regen_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2006_mana_regen_aura_effect", "modifiers/modifier_item_2006_mana_regen_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2008_slow_aura", "modifiers/modifier_item_2008_slow_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2008_slow_aura_effect", "modifiers/modifier_item_2008_slow_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2009_physical_penetration", "modifiers/modifier_item_2009_physical_penetration", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2009_physical_penetration_effect", "modifiers/modifier_item_2009_physical_penetration_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2010_magical_penetration", "modifiers/modifier_item_2010_magical_penetration", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2010_magical_penetration_effect", "modifiers/modifier_item_2010_magical_penetration_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2011_attack_stun", "modifiers/modifier_item_2011_attack_stun", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2011_stun_lock", "modifiers/modifier_item_2011_stun_lock", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2012_magical_damage_aura", "modifiers/modifier_item_2012_magical_damage_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2012_magical_damage_aura_effect", "modifiers/modifier_item_2012_magical_damage_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2013_physical_damage_aura", "modifiers/modifier_item_2013_physical_damage_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2013_physical_damage_aura_effect", "modifiers/modifier_item_2013_physical_damage_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2014_damage_aura", "modifiers/modifier_item_2014_damage_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2014_damage_aura_effect", "modifiers/modifier_item_2014_damage_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2018_bonus_attack_range", "modifiers/modifier_item_2018_bonus_attack_range", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2020_damage", "modifiers/modifier_item_2020_damage", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2025_damage", "modifiers/modifier_item_2025_damage", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_item_2026_damage", "modifiers/modifier_item_2026_damage", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier("modifier_touhoutd_root", "modifiers/modifier_touhoutd_root", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_touhoutd_pause", "modifiers/modifier_touhoutd_pause", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_touhoutd_release_hidden", "modifiers/modifier_touhoutd_release_hidden", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_touhoutd_building", "modifiers/modifier_touhoutd_building", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_thtd_ss_faith", "modifiers/modifier_thtd_ss_faith", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_thtd_ss_kill", "modifiers/modifier_thtd_ss_kill", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_touhoutd_luck", "modifiers/modifier_touhoutd_luck", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_touhoutd_unluck", "modifiers/modifier_touhoutd_unluck", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier("modifier_bosses_alice", "modifiers/bosses/modifier_bosses_alice", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_aya", "modifiers/bosses/modifier_bosses_aya", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_hina", "modifiers/bosses/modifier_bosses_hina", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_kaguya", "modifiers/bosses/modifier_bosses_kaguya", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_keine", "modifiers/bosses/modifier_bosses_keine", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_kisume", "modifiers/bosses/modifier_bosses_kisume", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_marisa", "modifiers/bosses/modifier_bosses_marisa", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_minoriko", "modifiers/bosses/modifier_bosses_minoriko", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_mokou", "modifiers/bosses/modifier_bosses_mokou", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_rumia", "modifiers/bosses/modifier_bosses_rumia", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_bosses_yuugi", "modifiers/bosses/modifier_bosses_yuugi", LUA_MODIFIER_MOTION_NONE)	

	GameRules.game_info = {				
		ver = "190501",		
		game_code = "null",	
		game_msg = "",
		rank_limit = 1,	
		max_food = THTD_MAX_FOOD,
		admin = http.config.admin,
		new_card_limit = 0,
		luck_card = "",
		crit = 1
	}	
	CustomNetTables:SetTableValue("CustomGameInfo", "game_info", GameRules.game_info)
	CustomNetTables:SetTableValue("CustomGameInfo", "thtd_tower_list", towerNameList)	
	print("\n---------- InitGameMode Finished ----------")
end

function CTHTDGameMode:SettingExp()
	-- 总和5400
	-- 经验分配规则 保底 1X每只30点 2X每只20点，3X每只10点，4X每只6点，5X每只3点
	-- 单吃一个兵经验 300点 200点 100点 60点 30点
	-- 经验获取率1X 100% 2X 2/3 3X 1/3 4X 1/5 5X 1/10 
	-- 素材培养 （1000+素材卡牌经验/5）* 星级

	local HERO_EXP_TABLE = {0}
	local exp = {200,300,400,500,600,700,800,900,1000}
	local xp = 0

	for i = 2, THTD_MAX_LEVEL-1 do
		HERO_EXP_TABLE[i]=HERO_EXP_TABLE[i-1]+exp[i-1]
	end

	return HERO_EXP_TABLE
end

local itemReplaceOrigin = 
{
	[1] = Vector(-2100,3340,144),
	[2] = Vector(1830,3340,144),
	[3] = Vector(1830,-2300,144),
	[4] = Vector(-2100,-2300,144)
}

function CTHTDGameMode:OnDotaItemPickedUp(keys)		
	local item = EntIndexToHScript(keys.ItemEntityIndex)
	if item == nil then return end
	if item.locked_by_player_id == nil or item.locked_by_player_id == keys.PlayerID or item.card_poor_player_id == keys.PlayerID then return end
	local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")	
	for _,hero in pairs(heroes) do	
		if hero.thtd_player_id == item.locked_by_player_id and hero.is_game_over == true then return end
	end

	local picker = nil
	if keys.HeroEntityIndex ~= nil then 
		picker = EntIndexToHScript(keys.HeroEntityIndex)
	elseif keys.UnitEntityIndex ~= nil then 
		picker = EntIndexToHScript(keys.UnitEntityIndex) 	
	end		
	if picker == nil then return end	
	CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="item_is_locked", duration=5, params={}, color="#fff"})
	picker:DropItemAtPositionImmediate(item, picker:GetOrigin())
end

function CTHTDGameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	local stateText = {
		[0] = "DOTA_GAMERULES_STATE_INIT",
		[1] = "DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD",
		[2] = "DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP",
		[3] = "DOTA_GAMERULES_STATE_HERO_SELECTION",
		[4] = "DOTA_GAMERULES_STATE_STRATEGY_TIME",
		[5] = "DOTA_GAMERULES_STATE_TEAM_SHOWCASE",
		[6] = "DOTA_GAMERULES_STATE_PRE_GAME",
		[7] = "DOTA_GAMERULES_STATE_GAME_IN_PROGRESS",
		[8] = "DOTA_GAMERULES_STATE_POST_GAME",
		[9] = "DOTA_GAMERULES_STATE_DISCONNECT",		
	}
	print("-------- Now State: ", stateText[newState])
	if newState ==  DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then	
		self:GameStateCustomGameSetup()		
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("WaitForUiLoaded"),
			function()
				http.api.getGameConfig(GameRules.game_info.admin, 5)
				return nil
			end,
		1.0)

	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then	
		ListenToGameEvent('npc_spawned', Dynamic_Wrap( CTHTDGameMode, 'OnNpcSpawned' ), self )		
		ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(CTHTDGameMode, 'OnDotaItemPickedUp'), self)
		ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(CTHTDGameMode, 'OnDotaNonPlayerUsedAbility'), self)		

		if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) > 1 then 
			GameRules.is_team_mode = true
		else
			GameRules.is_team_mode = false
		end		

  		-------- 选取游戏难度 --------
  		local level = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0}
		for k,v in pairs(PlayersSelectedDifficulty) do
			level[v] = (level[v] or 0) + 1
		end
		local difficulty = 0
		for k,v in pairs(level) do
			if k ~= difficulty and level[k] > level[difficulty] then
				difficulty = k
			end
		end		
		difficulty = difficulty+1		
		GameRules:SetCustomGameDifficulty(difficulty)

		for i=0, PlayerResource:GetPlayerCount()-1 do			
			if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
				PlayerResource:ModifyGold(i, math.min(difficulty-1,3)*1000 , true, DOTA_ModifyGold_Unspecified) 
			end
		end		

  	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then 
		SpawnSystem:PreSpawn()	
		for i=0, PlayerResource:GetPlayerCount()-1 do
			if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then 
				if GameRules.players_card_group[i]["_id"] == nil then
					GameRules:SendCustomMessage("<font color='red'>获取玩家 "..PlayerResource:GetPlayerName(i).." 数据失败，该玩家将无法获得游戏积分！</font>", DOTA_TEAM_GOODGUYS, 0)	  				
				end
			end			
		end
		GameRules.players_rank_ok = false
		GameRules.players_rank = {}
		GameRules.players_rank_data = {}
		http.api.getRank(3)

		GameRules.players_team_rank_ok = false
		GameRules.players_team_rank = {}
		GameRules.players_team_rank_data = {}
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("getRankDelay"),
			function()
				http.api.getTeamRank(3)
				return nil
			end,
		1.0)

		GameRules.players_max_wave = {}
		local total = PlayerResource:GetPlayerCount()
		local count = 0
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("GetPlayersWaveData"),
			function()
				if PlayerResource:GetTeam(count) == DOTA_TEAM_GOODGUYS then
					http.api.getWaveData(count, 5)					
				end
				count = count + 1
				if count >= total then 					
					return nil 
				else
					return 1.0
				end
			end,
		2.0)

		-- 解除地图购买上限
		SendToServerConsole("dota_max_physical_items_purchase_limit 59999")		


	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then  			
		SpawnSystem:InitSpawn()
		for i=0, PlayerResource:GetPlayerCount()-1 do			
			if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then 
				if GameRules.players_status[i].ban == 1 then
					GameRules:SendCustomMessage("<font color='red'>由于 "..PlayerResource:GetPlayerName(i).." 因"..GameRules.players_status[i].reason.."被举报加入黑名单，已将其踢出游戏！</font>", DOTA_TEAM_GOODGUYS, 0)	  				
					local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
					for _,hero in pairs(heroes) do	
						if hero.thtd_player_id == i then 
							SpawnSystem:GameOver(hero)
							break
						end
					end		
				elseif GameRules.players_status[i].vip == 1 then
					GameRules:SendCustomMessage("<font color='yellow'>欢迎贡献者 "..PlayerResource:GetPlayerName(i).."，特别奖励持续到 "..GameRules.players_status[i].end_time.."</font>", DOTA_TEAM_GOODGUYS, 0)	
				end
			end			
		end		
		-- PrintTable(GameRules.players_max_wave)
		GameRules:SendCustomMessage("<font color='yellow'>按主键盘数字键 6 至 0 发表情，按字母键 i 切换第一视角，按 F9 暂停/恢复游戏</font>", DOTA_TEAM_GOODGUYS, 0)	
	end
	  
end

function CTHTDGameMode:GameStateCustomGameSetup()	
	for i=0, PlayerResource:GetPlayerCount()-1 do
		local player = PlayerResource:GetPlayer(i)
		if player then
			CreateHeroForPlayer("npc_dota_hero_lina", player):RemoveSelf()			
		end
	end

	GameRules.players_status = { }
	GameRules.players_card_group = { }

	local total = PlayerResource:GetPlayerCount()
	local count = 0
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("WaitForUiLoaded"),
		function()
			if PlayerResource:GetTeam(count) == DOTA_TEAM_GOODGUYS then
				GameRules.players_status[count] = {                        
					["end_time"] = "",
					["reason"] = "",					
					["vip"] = 0,
					["ban"] = 0         
				}
				http.api.getBlackOrWhitePlayer(count, 3)
				GameRules.players_card_group[count] = { }
				http.api.getCardGroup(count, 3)
			end
			count = count + 1
			if count >= total then 
				return nil 
			else
				return 1.0
			end
		end,
	2.0)
end

function CTHTDGameMode:OnNpcSpawned(keys)
	local hero = EntIndexToHScript(keys.entindex)
	if hero:GetUnitName() == "npc_dota_hero_lina" and hero.isFirstSpawn ~= false then			
		hero.isFirstSpawn = false
		hero.thtd_hero_tower_list = {}
		hero.thtd_hero_damage_list ={}
		hero.thtd_combo_voice_array = {}		
		hero.press_key = {}
		hero.thtd_emoji_effect = nil
		hero.thtd_has_skin = false		

		hero.thtd_game_info = {}		
		hero.thtd_game_info["creep_count"] = 0
		hero.thtd_game_info["creep_count_max"] = 0
		hero.thtd_game_info["food_count"] = 0		
		hero.thtd_game_info["creature_kill_count"] = 0
		hero.thtd_game_info["max_wave_damage"] = 0
		hero.thtd_game_info["max_wave"] = 0
		hero.thtd_game_info["is_player_connected"] = 0
	
		hero.thtd_chance_count = {}		
		hero.thtd_ai_time = 0
		hero.is_game_over = false
		
		local heroPlayerID = hero:GetPlayerOwnerID()
		hero.thtd_player_id = heroPlayerID	
		hero.spawn_position = SpawnSystem.SpawnOrigin[heroPlayerID+1]	
		hero:SetAbsOrigin(hero.spawn_position)	
		hero:SetContextThink(DoUniqueString("SetSpawn") ,
			function()
				if GameRules:IsGamePaused() then return 0.1 end				
				if GetDistanceBetweenTwoVec2D(hero:GetOrigin(), hero.spawn_position) > 1000 then				
					hero:SetAbsOrigin(hero.spawn_position)
					PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)										
					return 0.5			
				else		
					PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)								
				end
				return nil
			end,
		0.5)		

		hero:SetModelScale(1.4)
		UnitNoPathingfix( hero,hero,-1)

		hero:AddNewModifier(hero, nil, "modifier_phased", nil)
		
		for i=0,6 do
			local ability=hero:GetAbilityByIndex(i)
			if ability ~= nil then
				ability:SetLevel(1)
			end
		end		

		local shop = CreateUnitByName(
			"minoriko_shop", 
			SpawnSystem.ShopEntitiesOrigin[hero:GetPlayerOwnerID()+1], 
			false, 
			hero, 
			hero, 
			hero:GetTeam() 
		)
		shop:SetControllableByPlayer(hero:GetPlayerOwnerID(), true) 
		shop:SetHasInventory(true)
		shop.hero = hero
		hero.shop = shop			
		shop:SetContextThink(DoUniqueString("shop_think"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				shop:MoveToPosition(shop:GetOrigin()+SpawnSystem.ShopEntitiesForward[hero:GetPlayerOwnerID()+1])
				return nil				
			end,
		1.0)

		if GameRules:GetCustomGameDifficulty() == 8 then 
			hero:SetContextThink(DoUniqueString("SetSpawn") ,
				function()
					if GameRules:IsGamePaused() then return 0.1 end	
					if SpawnSystem.IsUnLimited then return nil end			
					THTD_ModifyGoldEx(heroPlayerID, math.min(SpawnSystem.CurWave * 30, 700) , true, DOTA_ModifyGold_Unspecified)	
					return 1
				end,
			10)
		end	

		hero:SetContextThink(DoUniqueString("thtd_ai_think"), 
			function()					
				hero.thtd_ai_time = GameRules:GetGameTime()
				if GameRules:IsGamePaused() then return 0.1 end
				if hero.is_game_over == true then return nil end				
				for k,v in pairs(hero.thtd_hero_tower_list) do
					if v~=nil and v:IsNull()==false and v:IsAlive() and v:THTD_IsHidden() == false and v.thtd_close_ai ~= true and v:HasModifier("modifier_touhoutd_building") == false then
						local func = v["THTD_"..v:GetUnitName().."_thtd_ai"]
						if func then
							func(v)
						elseif v:IsAttacking() == false and v:THTD_IsAggressiveLock() == false then
							v:MoveToPositionAggressive(v:GetOrigin() + v:GetForwardVector() * 100)
							v:THTD_SetAggressiveLock()
						end
					end
				end
				return 0.3
			end, 
		0)
		
		return
	end		
end

function CTHTDGameMode:OnEntityKilled(keys)
	-- 储存被击杀的单位
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- 储存杀手单位
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )

	local id = killedUnit.thtd_player_index

	local findNum =  string.find(killedUnit:GetUnitName(), 'creature')
	if findNum ~= nil then
		if not SpawnSystem.IsUnLimited then
			local expRange = 1500
			local targets = {}
			if killerEntity:THTD_IsTower() then
				targets = THTD_FindFriendlyUnitsInRadius(killerEntity,killedUnit:GetOrigin(),expRange)
			elseif killerEntity.thtd_spawn_unit_owner ~= nil then
				targets = THTD_FindFriendlyUnitsInRadius(killerEntity.thtd_spawn_unit_owner,killedUnit:GetOrigin(),expRange)
			end
			local expUnits = {}
			for k,v in pairs(targets) do
				if v ~= nil and v:IsNull()==false and v:THTD_IsTower() and v:THTD_GetLevel() < THTD_MAX_LEVEL then 
					table.insert(expUnits,v)
				end
			end
			targets = {}

			local factor = 1
			if GameRules:GetCustomGameDifficulty() == 8 then 
				factor = 1.5
			end
			local totalNum = #expUnits
			if totalNum > 0 then
				for k,v in pairs(expUnits) do
					v:THTD_AddExp(math.floor(factor * killedUnit:GetDeathXP() / totalNum + 0.5))
				end
			end
		end

		if killedUnit.thtd_is_outer == true then 
			for k,v in pairs(THTD_EntitiesRectOuter) do
				if v == killedUnit then
					table.remove(THTD_EntitiesRectOuter, k) 
					break
				end
			end
		elseif id ~= nil then
			for k,v in pairs(THTD_EntitiesRectInner[id]) do
				if v == killedUnit then 
					table.remove(THTD_EntitiesRectInner[id], k)
					break
				end
			end
		end

		killedUnit:AddNoDraw()

		local effectIndex = ParticleManager:CreateParticle("particles/thd2/environment/death/act_hero_die.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    ParticleManager:SetParticleControl(effectIndex, 0, killedUnit:GetOrigin())
	    ParticleManager:SetParticleControl(effectIndex, 1, killedUnit:GetOrigin())
	    ParticleManager:DestroyParticleSystem(effectIndex,false)

		if killerEntity:GetUnitName()=="npc_dota_hero_lina" then
			killerEntity.thtd_game_info["creature_kill_count"] = killerEntity.thtd_game_info["creature_kill_count"] + 1
		elseif killerEntity.thtd_istower == true or (killerEntity:GetOwner()~=nil and killerEntity:GetOwner():GetUnitName()=="npc_dota_hero_lina") then
			local hero = killerEntity:GetOwner()
			hero.thtd_game_info["creature_kill_count"] = hero.thtd_game_info["creature_kill_count"] + 1
		end
	end
end

function CTHTDGameMode:OnPlayerSay(keys)	
	-- if tostring(PlayerResource:GetSteamID(keys.playerid)) ~= GameRules.game_info.admin then return end	

	local text = keys.text

	if string.sub(text,1,6) == "-color" then
		local colorValue = string.sub(text, 8, 11)	
		CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="item_locked_tip", duration=10, params={}, color=colorValue})
	end	

	if string.sub(text,1,3) == "-id" then
		GameRules:SendCustomMessage("<font color='yellow'>"..tostring(PlayerResource:GetSteamID(keys.playerid)).."</font>", DOTA_TEAM_GOODGUYS, 0)	
	end	

	if string.sub(text,1,4) == "-pos" then
		local player = PlayerResource:GetPlayer(keys.playerid)
		local hero = player:GetAssignedHero()
		local pos = hero:GetAbsOrigin()
		print("------- Current Position (x, y, z):")
		print(math.floor(pos.x + 0.5))
		print(math.floor(pos.y + 0.5))
		print(math.floor(pos.z + 0.5))
		GameRules:SendCustomMessage("X: "..tostring(math.floor(pos.x + 0.5)).."，Y："..tostring(math.floor(pos.y + 0.5)).."，Z："..tostring(math.floor(pos.z + 0.5)), DOTA_TEAM_GOODGUYS, 0)
	end

	if string.sub(text,1,5) == "-wave" then
		local num = tonumber(string.sub(text, 7, 9))
		if num ~= nil and num > -49 then 
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="wave", param=num})					
		end			
	end

	if string.sub(text,1,5) == "-boss" then
		local num = string.sub(text, 7, 20)		
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="boss", param=num})	
	end

	if string.sub(text,1,4) == "-add" then
		local num = string.sub(text, 6, 9)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="add", param=num})
	end

	if string.sub(text,1,3) == "-tp" then
		local num = string.sub(text, 5, 20)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="tp", param=num})
	end	

	if string.sub(text,1,10) == "-clearrank" then		
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="clearrank", param={}})
	end	

	if string.sub(text,1,8) == "-lv" then		
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="lv", param={}})
	end	
end

function CTHTDGameMode:ExecuteOrder( keys )	
	if table.hasvalue(SpawnSystem.GameOverPlayerId, keys.issuer_player_id_const) then return false end	
	
	-- PrintTable(keys)
	local order_type  = keys.order_type	

	if order_type == 32 then
		local ability = EntIndexToHScript(keys.entindex_ability)
		if ability ~= nil and ability:IsItem() then		
			if keys.entindex_target == 1 then
				ability.locked_by_player_id = keys.issuer_player_id_const
			else
				local tower = ability:THTD_GetTower()
				if tower ~= nil then
					for i=0,8 do
						local targetItem = tower:GetItemInSlot(i)
						if targetItem~=nil and targetItem:IsNull()==false then	
							GameRules:SendCustomMessage("<font color='red'>卡牌存在保留装备时，请插拔将装备丢掉之后再回收解锁。</font>", DOTA_TEAM_GOODGUYS, 0)
							return false
						end
					end
				end
				ability.locked_by_player_id = nil
			end
			return true

			-- temp
			-- if ability:IsSellable() then	
			-- 	if ability.is_bonus_item == true then 
			-- 		GameRules:SendCustomMessage("<font color='red'>开局初始卡不能出售。</font>", DOTA_TEAM_GOODGUYS, 0)
			-- 		return false
			-- 	end		
			-- 	if ability.owner_player_id ~= nil and ability.owner_player_id ~= keys.issuer_player_id_const then
			-- 		GameRules:SendCustomMessage("<font color='red'>不能出售来自队友的物品。</font>", DOTA_TEAM_GOODGUYS, 0)
			-- 		return false
			-- 	end	
			-- 	if ability.locked_by_player_id ~= nil then
			-- 		local player = PlayerResource:GetPlayer(keys.issuer_player_id_const)
			-- 		if player then 
			-- 			CustomGameEventManager:Send_ServerToPlayer(player , "show_message", {msg="item_is_locked", duration=5, params={}, color="#fff"} )
			-- 		end
			-- 		return false
			-- 	end
			-- 	-- GameRules:SendCustomMessage(tostring(ability:GetCost()), DOTA_TEAM_GOODGUYS, 0)
			-- 	PlayerResource:ModifyGold(keys.issuer_player_id_const, ability:GetCost() / 2 , true, DOTA_ModifyGold_Unspecified)
			-- 	OnItemDestroyed(EntIndexToHScript(keys.units["0"]), ability, false)
			-- else
			-- 	GameRules:SendCustomMessage("<font color='blue'>该物品无法出售。</font>", DOTA_TEAM_GOODGUYS, 0)
			-- end
		end
		return false
	end
	
	if order_type == DOTA_UNIT_ORDER_MOVE_ITEM then		
		if keys.entindex_target > 8 then
			local orderUnit = EntIndexToHScript(keys.units["0"])
			if orderUnit:GetNumItemsInStash() > 0 then
				for i=9,15 do
					local targetItem = orderUnit:GetItemInSlot(i)
					if targetItem ~= nil and targetItem:IsNull()==false then
						orderUnit:EjectItemFromStash(targetItem)
						local box = targetItem:GetContainer()
						box:SetAbsOrigin(orderUnit.spawn_position)
					end
				end
			end				
			
			-- local count = GameRules:NumDroppedItems()			
			-- if count > 0 then 
			-- 	for i=0, count-1 do
			-- 		local item = GameRules:GetDroppedItem(i)					
			-- 		local containedItem = item:GetContainedItem()
			-- 		item:SetAbsOrigin(Vector(-1870,3340,144))
			-- 		print(containedItem:GetAbilityName())
			-- 	end
			-- end
			local sortedItemPos = {}
			local iH = 0
			local iV = 0
			local items = Entities:FindAllByClassname("dota_item_drop")
			table.sort(items, function(a,b) 
				local aItem = a:GetContainedItem()
				local bItem = b:GetContainedItem()
				-- if aItem ~= nil and bItem == nil then return true end
				-- if aItem == nil and bItem ~= nil then return false end
				-- if aItem == nil and bItem == nil then return true end
				local aData = towerNameList[aItem:GetAbilityName()]
				local bData = towerNameList[bItem:GetAbilityName()]							
				if aData ~= nil and bData == nil then return true end
				if aData == nil and bData ~= nil then return false end
				if aData == nil and bData == nil then return true end
				if aData["cardname"] == "BonusEgg" and bData["cardname"] ~= "BonusEgg" then return true end
				if aData["cardname"] ~= "BonusEgg" and bData["cardname"] == "BonusEgg" then return false end
				if string.sub(aData["cardname"],1,5) == "item_" and string.sub(bData["cardname"],1,5) ~= "item_" then return true end
				if string.sub(aData["cardname"],1,5) ~= "item_" and string.sub(bData["cardname"],1,5) == "item_" then return false end
				return (aData["quality"] > bData["quality"])			
			end)	
			for _,v in pairs(items) do
				local containedItem = v:GetContainedItem()				 			
				if containedItem.locked_by_player_id == nil and (containedItem.owner_player_id == keys.issuer_player_id_const or (containedItem:GetPurchaser() ~= nil and containedItem:GetPurchaser():GetPlayerOwnerID() == keys.issuer_player_id_const)) then 				
					local itemName = containedItem:GetAbilityName()
					if sortedItemPos[itemName] == nil then 
						local id = THTD_GetSpawnIdFromPlayerId(keys.issuer_player_id_const)					
						sortedItemPos[itemName] = GetSpawnLineOffsetVector(id, itemReplaceOrigin[id], iH * 200, iV * 200)										
						if iH < 9 then 							
							iH = iH + 1
						else							
							iH = 0
							iV = iV + 1
						end						
					end
					v:SetAbsOrigin(sortedItemPos[itemName])
					THTD_ItemSetScale(containedItem)
				end				
			end	
			sortedItemPos = {}

			return false

			-- local ability = EntIndexToHScript(keys.entindex_ability)			
			-- orderUnit:SetContextThink(DoUniqueString("eject_item"),
			-- 	function() 
			-- 		if GameRules:IsGamePaused() then return 0.03 end
			-- 		orderUnit:EjectItemFromStash(ability)					
			-- 		local box = ability:GetContainer()
			-- 		box:SetAbsOrigin(orderUnit.spawn_position)
			-- 		return nil
			-- 	end,
			-- 0.2)
		end
		return true	
	end		

	if order_type == DOTA_UNIT_ORDER_SELL_ITEM then		
		local ability = EntIndexToHScript(keys.entindex_ability)
		if ability ~= nil and ability:IsItem() then	
			if ability.is_bonus_item == true then 
				GameRules:SendCustomMessage("<font color='red'>开局初始卡不能出售。</font>", DOTA_TEAM_GOODGUYS, 0)
				return false
			end			
			if ability.locked_by_player_id ~= nil then
				local player = PlayerResource:GetPlayer(keys.issuer_player_id_const)
				if player then 
					CustomGameEventManager:Send_ServerToPlayer(player , "show_message", {msg="item_is_locked", duration=5, params={}, color="#fff"} )
				end
				return false
			end	
			OnItemDestroyed(EntIndexToHScript(keys.units["0"]), ability, true)
		end	
		local gold = ability:GetCost()
		if gold ~= nil and gold > 0 then
			gold = math.floor(gold/2)
			local current_gold = PlayerResource:GetGold(keys.issuer_player_id_const)
			if gold + current_gold > 99999 then
				thtd_extra_gold[keys.issuer_player_id_const] = thtd_extra_gold[keys.issuer_player_id_const] + (gold - (99999-current_gold))
				THTD_RefreshExtraGold(keys.issuer_player_id_const)
			elseif thtd_extra_gold[keys.issuer_player_id_const] > 0 then
				local add_gold = math.min(thtd_extra_gold[keys.issuer_player_id_const], 99999-(gold+current_gold))		
				thtd_extra_gold[keys.issuer_player_id_const] = thtd_extra_gold[keys.issuer_player_id_const] - add_gold			
				PlayerResource:ModifyGold(keys.issuer_player_id_const, add_gold, true, DOTA_ModifyGold_Unspecified)
				THTD_RefreshExtraGold(keys.issuer_player_id_const)
			end
		end
		return true
	end

	if order_type == DOTA_UNIT_ORDER_GIVE_ITEM then	
		local item = EntIndexToHScript(keys.entindex_ability)
		local target = 	EntIndexToHScript(keys.entindex_target)		
		local count = 0
		for i=0,8 do
			local targetItem = target:GetItemInSlot(i)
			if targetItem~=nil and targetItem:IsNull()==false then count = count + 1 end
		end
		if count>=9 then 
			local player = PlayerResource:GetPlayer(keys.issuer_player_id_const)
			if player then 
				CustomGameEventManager:Send_ServerToPlayer(player, "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
			end					
			return false
		else 
			return true
		end
	end	

	if order_type == DOTA_UNIT_ORDER_DROP_ITEM then	
		local item = EntIndexToHScript(keys.entindex_ability)
		if THTD_HasItemScale(item) then 
			if item.item_set_scale ~= true then 
				item.item_set_scale = true
				local count = 600
				item:SetContextThink(DoUniqueString("item_set_scale"),
					function() 
						if GameRules:IsGamePaused() then return 0.03 end
						if item:GetContainer() ~= nil then 
							THTD_ItemSetScale(item)
							item.item_set_scale = nil			
							return nil
						end
						if count <= 0 then 
							item.item_set_scale = nil			
							return nil
						end
						count = count - 1
						return 0.1					
					end,
				0.1)
			end		
		end
		return true			
	end

	return true
end

function CTHTDGameMode:ItemAddedToInventory( keys )	
	local hInventoryParent = EntIndexToHScript(keys.inventory_parent_entindex_const)

	local iItemIndex = keys.item_entindex_const
	local hItem = EntIndexToHScript(iItemIndex)
	local itemName = hItem:GetAbilityName()

	if itemName == "item_tpscroll" or itemName == "item_enchanted_mango" then
		return false
	end

	if itemName == "item_2024" then		
		AddGoldPerTick(hInventoryParent,hItem)		
	end	
	
	-- if GameRules:GetCustomGameDifficulty() > 5 then 
	-- 	CheckItemShare(hInventoryParent,hItem)
	-- end

	return true
end

function AddGoldPerTick(caster,item)
	if SpawnSystem.IsUnLimited then return end
	if GameRules:GetCustomGameDifficulty() == 8 then return end
	if caster==nil or caster:IsNull() then return end
	if item.thtd_isUsed == true then return end
	local hero = nil
	if caster:THTD_IsTower() or caster:GetUnitName() == "minoriko_shop" then
		hero = caster:GetOwner()
	elseif caster:GetUnitName() == "npc_dota_hero_lina" then
		hero = caster
	end
	if hero~=nil then		
		if hero.thtd_pertick_is_open ~= true then
			hero.thtd_pertick_is_open = true
			item.thtd_isUsed = true			
			hero:SetContextThink(DoUniqueString("thtd_pertick_gold_think"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					if SpawnSystem.IsUnLimited then return nil end
					THTD_ModifyGoldEx(hero:GetPlayerOwnerID(), math.min(3 * SpawnSystem.CurWave, 120) , true, DOTA_ModifyGold_Unspecified)					
					return 1.0
				end,
			1.0)
		end
	end
end

function CheckItemShare(caster,item)
	if caster == nil or item == nil then return end	
	local cardName = item:THTD_GetCardName()
	if cardName == "BonusEgg" or cardName == "minoriko" or cardName == "sizuha" or cardName == "lily" or cardName == "nazrin" or cardName == "toramaru" or cardName == "luna" or item:THTD_GetCardQuality() == 1 then return end

	local playerId = caster:GetPlayerOwnerID()
	if item.owner_player_id ~= playerId and item.card_poor_player_id ~= playerId then 
		GameRules:SendCustomMessage("<font color='red'>单人排行榜不能使用队友的卡牌和装备。</font>", DOTA_TEAM_GOODGUYS, 0)
		caster:SetContextThink(DoUniqueString("thtd_pertick_gold_think"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				caster:DropItemAtPositionImmediate(item, caster:GetOrigin())
				return nil
			end,
		0.2)
	end	
end

function CTHTDGameMode:ModifierFilter(keys)
	-- duration: 9
	-- entindex_ability_const: 108
	-- entindex_caster_const: 391
	-- entindex_parent_const: 142
	-- name_const: modifier_lycan_howl

	if keys.entindex_parent_const == nil then
		return true
	end

	local caster = EntIndexToHScript(keys.entindex_caster_const)
	local unit = EntIndexToHScript(keys.entindex_parent_const)   

	if unit~=nil and unit:IsNull()==false then
		local modifierName = keys.name_const

		if THTD_IsUniqueSlowBuff(modifierName) == true then
			if unit:THTD_HasUniqueSlowBuff() or unit:HasModifier("modifier_bosses_aya") then
				return false
			else
				return true
			end
		end

		if modifierName == "modifier_lycan_howl" then
			local caster = EntIndexToHScript(keys.entindex_caster_const)			
			if unit:GetPlayerOwnerID() ~= caster:GetPlayerOwnerID() then return false end
		end
		if modifierName == "modifier_lycan_shapeshift" then			
			if not GameRules:IsDaytime() then 
				keys.duration = keys.duration + caster:FindAbilityByName("lycan_shapeshift"):GetSpecialValueFor("speed")
			end
		end
		
		if modifierName == "modifier_keeper_of_the_light_will_o_wisp" then 
			local DamageTable = {
				ability = caster:FindAbilityByName("keeper_of_the_light_will_o_wisp"),
				victim = unit, 
				attacker = caster, 
				damage = caster:THTD_GetPower() * caster:THTD_GetStar() * caster:FindAbilityByName("keeper_of_the_light_will_o_wisp"):GetSpecialValueFor("hit_count"), 
				damage_type = DAMAGE_TYPE_PHYSICAL, 
				damage_flags = DOTA_DAMAGE_FLAG_NONE
			}				
			UnitDamageTarget(DamageTable)	
		end

		if modifierName == "modifier_ogre_magi_bloodlust" then 
			if caster.thtd_last_cast_unit ~= unit then 
				caster.thtd_last_cast_unit = unit
			end
		end			

	end
	return true
end

function CTHTDGameMode:DamageFilter(keys)	
	-- damage: 24
	-- damagetype_const: 1
	-- entindex_attacker_const: 503
	-- entindex_inflictor_const: 500 技能，普通攻击没有这个
	-- entindex_victim_const: 434	
	if keys.damage <= 0 then return false end
	if keys.entindex_attacker_const == nil or keys.entindex_victim_const == nil then return true end
	
	local target = EntIndexToHScript(keys.entindex_victim_const)
	if target.thtd_damage_lock == true then	return false end
	local unit = EntIndexToHScript(keys.entindex_attacker_const)
	local ability = nil --普通攻击
	if keys.entindex_inflictor_const ~= nil then ability = EntIndexToHScript(keys.entindex_inflictor_const) end --技能时

	local unitName = unit:GetUnitName()
	local health = target:GetHealth()

	if unitName == "npc_dota_hero_lina" then 
		if target:HasModifier("modifier_bosses_kaguya") and keys.damage > health then
			target:SetHealth(1)
			target:RemoveModifierByName("modifier_bosses_kaguya")
			return false			
		end
		return true
	end

	local tower = nil
	if unit:THTD_IsTower() then
		tower = unit
	elseif unit.thtd_spawn_unit_owner ~= nil and unit.thtd_spawn_unit_owner:THTD_IsTower() then
		tower = unit.thtd_spawn_unit_owner
	end		
	if tower == nil then		
		return true
	end
	if tower.thtd_tower_damage == nil then 
		tower.thtd_tower_damage = 0
	end	

	-- dota2自带技能处理
	if unitName == "alice_falanxi_ningyou" then	
		-- 上限处理，取双抗为0的伤害	
		if keys.damage > 180000 and keys.damage > target:GetMaxHealth() * 0.05 then 
			keys.damage = target:GetMaxHealth() * 0.05
		end
	elseif unitName == "kagerou" then			
		local armor = target:GetPhysicalArmorValue()
		local damageFactor = 1.0
		if armor > 0 then 
			damageFactor = 1 - (0.052 * armor /(0.9 + 0.048 * armor))  -- 7.20版本护甲计算			
		else			
			damageFactor = 1 - (0.052 * armor /(0.9 - 0.048 * armor))  -- 7.20版本负护甲计算			
		end		
		local crit = 1
		if unit:HasModifier("modifier_lycan_shapeshift") and RandomInt(1,100) <= unit:FindAbilityByName("lycan_shapeshift"):GetSpecialValueFor("crit_chance") then 
			crit = unit:FindAbilityByName("lycan_shapeshift"):GetSpecialValueFor("crit_multiplier") / 100			
		end
		if unit:GetAttackTarget() == target then 			
			keys.damage = keys.damage + crit * damageFactor * unit:THTD_GetPower() * unit:THTD_GetStar() * unit:FindAbilityByName("lycan_feral_impulse"):GetSpecialValueFor("bonus_hp_regen")	
		else			
			keys.damage = keys.damage + crit * damageFactor * unit:THTD_GetPower() * unit:THTD_GetStar() * unit:FindAbilityByName("lycan_feral_impulse"):GetSpecialValueFor("bonus_hp_regen") * unit:FindAbilityByName("sven_great_cleave"):GetSpecialValueFor("great_cleave_damage") / 100			
		end					
	elseif unitName == "wriggle" then	
		if ability ~= nil then
			if ability:GetAbilityName() == "death_prophet_exorcism" then				
				local armor = target:GetPhysicalArmorValue()
				local damageFactor = 1.0
				if armor > 0 then 
					damageFactor = 1 - (0.052 * armor /(0.9 + 0.048 * armor))  -- 7.20版本护甲计算			
				else			
					damageFactor = 1 - (0.052 * armor /(0.9 - 0.048 * armor))  -- 7.20版本负护甲计算			
				end							
				keys.damage = keys.damage + damageFactor * unit:THTD_GetPower() * unit:THTD_GetStar() * unit:FindAbilityByName("death_prophet_exorcism"):GetSpecialValueFor("heal_percent")				
			end
		end
	elseif unitName == "inaba" then
		local armor = target:GetPhysicalArmorValue()
		local damageFactor = 1.0
		if armor > 0 then 
			damageFactor = 1 - (0.052 * armor /(0.9 + 0.048 * armor))  -- 7.20版本护甲计算			
		else			
			damageFactor = 1 - (0.052 * armor /(0.9 - 0.048 * armor))  -- 7.20版本负护甲计算			
		end	
		keys.damage = keys.damage + damageFactor * unit:THTD_GetPower() * unit:THTD_GetStar()
		keys.damage = keys.damage + damageFactor * target:GetMaxHealth() * unit:FindAbilityByName("sniper_headshot"):GetSpecialValueFor("slow_duration") / 100		
	end
	
	-- if not unit:THTD_IsTower() then
	-- 	print("--------------")
	-- 	print(unit:GetUnitName())
	-- 	print(unit:GetOwner():GetUnitName())
	-- end

	if unitName == GameRules.game_info.luck_card then
		keys.damage = keys.damage * (1 + math.max(-90, GameRules.game_info.crit) / 100)
	end	
	
	local damage_table = {		
		ability = ability,	
		victim = target,
		attacker = unit,
		damage = keys.damage,
		damage_type = keys.damagetype_const,			
	}	
	keys.damage = ReturnAfterTaxDamage(damage_table, false)
	damage_table = {}
	if keys.damage <= 0 then return false end

	if target:HasModifier("modifier_bosses_kaguya") and keys.damage > health then	
		target:SetHealth(1)
		target:RemoveModifierByName("modifier_bosses_kaguya")
		tower.thtd_tower_damage = tower.thtd_tower_damage + health/100
		if unitName == "flandre" and keys.damage - health > 300 then				
			THTD_OverDamage(unit, unit:FindAbilityByName("thtd_flandre_02"), keys.damage - health, target:GetOrigin(), 400)
		end
		return false
	end

	tower.thtd_tower_damage = tower.thtd_tower_damage + math.min(keys.damage, health) / 100
	if unitName == "flandre" and keys.damage - health > 300 then				
		THTD_OverDamage(unit, unit:FindAbilityByName("thtd_flandre_02"), keys.damage - health, target:GetOrigin(), 400)
	end
	return true	
end

function CTHTDGameMode:OnModifyGoldFilter(keys)
	-- gold: 15
	-- player_id_const: 0
	-- reason_const: 13
	-- reliable: 0
	
	-- GameRules:SendCustomMessage("<font color='yellow'>"..tostring(keys.gold).."</font>", DOTA_TEAM_GOODGUYS, 0)
	-- 出售和接口改变金钱不会触发，当前地图只有杀怪奖励金钱

	if (keys.gold <= 0) then return true end
	
	if thtd_extra_gold[keys.player_id_const] == nil then
		thtd_extra_gold[keys.player_id_const] = 0
	end
	local current_gold = PlayerResource:GetGold(keys.player_id_const)
	if current_gold + keys.gold > 99999 then
		local add_gold = math.min(keys.gold, 99999-current_gold)
		thtd_extra_gold[keys.player_id_const] = thtd_extra_gold[keys.player_id_const] + (keys.gold - add_gold)
		keys.gold = add_gold		
	elseif thtd_extra_gold[keys.player_id_const] > 0 then
		local add_gold = math.min(thtd_extra_gold[keys.player_id_const], 99999-(keys.gold+current_gold))
		keys.gold = keys.gold + add_gold
		thtd_extra_gold[keys.player_id_const] = thtd_extra_gold[keys.player_id_const] - add_gold
	end

	THTD_RefreshExtraGold(keys.player_id_const)  
	return true
end

function CTHTDGameMode:OnDotaNonPlayerUsedAbility(keys)
	-- 字段
	-- abilityname
	-- caster_entindex
	
	local caster = EntIndexToHScript(keys.caster_entindex)
	-- print(caster:GetUnitName().."  "..keys.abilityname)

	if keys.abilityname == "lycan_howl" then	
		-- 防止技给buff生效延迟
		caster:SetContextThink(DoUniqueString("thtd_kagerou03_buff"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				
				local hero = caster:GetOwner()				
				for _,tower in pairs(hero.thtd_hero_tower_list) do
					if tower.thtd_kagerou_03_bonus ~= true and tower:HasModifier("modifier_lycan_howl") then						
						tower.thtd_kagerou_03_bonus = true
						local power_bonus = caster:FindAbilityByName(keys.abilityname):GetSpecialValueFor("armor")	
						local attack_bonus = caster:FindAbilityByName(keys.abilityname):GetSpecialValueFor("hp_regen")						
						tower:THTD_AddPower(power_bonus)
						tower:THTD_AddAttack(attack_bonus)
						tower:SetContextThink(DoUniqueString("thtd_kagerou03_buff_remove"), 
							function()
								if GameRules:IsGamePaused() then return 0.03 end
								if THTD_IsValid(tower) == false or tower:HasModifier("modifier_lycan_howl") == false or caster:THTD_IsHidden() then 
									if tower ~= nil and tower:IsNull() == false then 
										tower:THTD_AddPower(-power_bonus)
										tower:THTD_AddAttack(-attack_bonus)
										tower.thtd_kagerou_03_bonus = false
									end									
									return nil 
								end						
								return 0.3
							end,
						0)
					end
				end
				
				return nil 
			end,
		0.15)
		
		return
	end
end