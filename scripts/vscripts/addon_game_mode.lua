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
 	GameRules:SetStrategyTime(1)
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
		ver = "190315",		
		game_code = "null",		
		max_food = THTD_MAX_FOOD,
		admin = http.config.admin		
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


local shopEntitiesOrigin = 
{
	[1] = Vector(-2454,2989,142),
	[2] = Vector(2227,2922,142),
	[3] = Vector(2259,-2806,142),
	[4] = Vector(-2454,-2867,142),
}

local shopEntitiesForward = 
{
	[1] = Vector(-math.cos(math.pi/4),-math.sin(math.pi/4),0),
	[2] = Vector(math.cos(math.pi/4),-math.sin(math.pi/4),0),
	[3] = Vector(math.cos(math.pi/4),math.sin(math.pi/4),0),
	[4] = Vector(-math.cos(math.pi/4),math.sin(math.pi/4),0),
}

local heroSpawnOrigin = 
{
	[1] = Vector(-3424,2816,140),
	[2] = Vector(3424,2816,140),
	[3] = Vector(3424,-2816,140),
	[4] = Vector(-3424,-2816,140),
}


function CTHTDGameMode:OnDotaItemPickedUp(keys)		
	local item = EntIndexToHScript(keys.ItemEntityIndex)
	if item == nil then return end
	if item.locked_by_player_id == nil or item.locked_by_player_id == keys.PlayerID or item.card_poor_player_id == keys.PlayerID then return end
	local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")	
	for _,hero in pairs(heroes) do	
		if hero.thtd_player_id == item.locked_by_player_id and hero:IsStunned() then return end
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
				http.api.getGameConfig(GameRules.game_info.admin)
				return nil
			end,
		1.0)

	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then	
		ListenToGameEvent('npc_spawned', Dynamic_Wrap( CTHTDGameMode, 'OnNpcSpawned' ), self )		
		ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(CTHTDGameMode, 'OnDotaItemPickedUp'), self)

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

		if difficulty == 7 or difficulty == 9 then	
			for i = 1, 5 do
				thtd_ability_table["lily"][i]["thtd_lily_01"] = 2
			end		
			for i = 1, 5 do
				thtd_ability_table["daiyousei"][i]["thtd_daiyousei_01"] = 2
			end		
			for i = 2, 5 do
				thtd_ability_minoriko_star_up_table[i] = math.floor(thtd_ability_minoriko_star_up_table[i]*0.7)
				thtd_ability_sizuha_star_up_table[i] = math.floor(thtd_ability_sizuha_star_up_table[i]*0.7)
			end
			for i = 1, 5 do
				thtd_nazrin_star_bouns_constant[i] = math.floor(thtd_nazrin_star_bouns_constant[i]*1.3)
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
		http.api.getRank()

		GameRules.players_team_rank_ok = false
		GameRules.players_team_rank = {}
		GameRules.players_team_rank_data = {}
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("getRankDelay"),
			function()
				http.api.getTeamRank()
				return nil
			end,
		1.0)

		GameRules.players_max_wave = {}
		local total = PlayerResource:GetPlayerCount()
		local count = 0
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("GetPlayersWaveData"),
			function()
				if PlayerResource:GetTeam(count) == DOTA_TEAM_GOODGUYS then
					http.api.getWaveData(count)					
				end
				count = count + 1
				if count >= total then 					
					return nil 
				else
					return 1.0
				end
			end,
		2.0)

	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then  			
		SpawnSystem:InitSpawn()
		for i=0, PlayerResource:GetPlayerCount()-1 do
			if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then 
				if GameRules.players_ban_status[i] == true then
					GameRules:SendCustomMessage("<font color='red'>由于 "..PlayerResource:GetPlayerName(i).." 为作弊玩家，已将其踢出游戏！</font>", DOTA_TEAM_GOODGUYS, 0)	  				
					local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
					for _,hero in pairs(heroes) do	
						if hero.thtd_player_id == i then 
							SpawnSystem:GameOver(hero)
							break
						end
					end					
				end
			end			
		end		
		-- PrintTable(GameRules.players_max_wave)
		GameRules:SendCustomMessage("<font color='yellow'>按主键盘数字键 6 至 0 发表情，按字母键 i 切换第一视角</font>", DOTA_TEAM_GOODGUYS, 0)	
	end
	  
end

function CTHTDGameMode:GameStateCustomGameSetup()	
	for i=0, PlayerResource:GetPlayerCount()-1 do
		local player = PlayerResource:GetPlayer(i)
		if player then
			CreateHeroForPlayer("npc_dota_hero_lina", player):RemoveSelf()			
		end
	end

	GameRules.players_ban_status = {
		[0] = false,
		[1] = false,
		[2] = false,
		[3] = false
	}
	GameRules.players_card_group = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}

	local total = PlayerResource:GetPlayerCount()
	local count = 0
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("WaitForUiLoaded"),
		function()
			if PlayerResource:GetTeam(count) == DOTA_TEAM_GOODGUYS then
				http.api.getBanPlayer(count)
				http.api.getCardGroup(count)
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
		
		local heroPlayerID = hero:GetPlayerOwnerID()
		hero.thtd_player_id = heroPlayerID	
			
		hero:SetAbsOrigin(heroSpawnOrigin[heroPlayerID+1])		
		hero.spawn_position = heroSpawnOrigin[heroPlayerID+1]		
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
		1.0)		

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
			shopEntitiesOrigin[hero:GetPlayerOwnerID()+1], 
			false, 
			hero, 
			hero, 
			hero:GetTeam() 
		)
		shop:SetControllableByPlayer(hero:GetPlayerOwnerID(), true) 
		shop:SetHasInventory(true)
		shop.hero = hero			
		shop:SetContextThink(DoUniqueString("shop_think"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				shop:MoveToPosition(shop:GetOrigin()+shopEntitiesForward[hero:GetPlayerOwnerID()+1])
				return nil				
			end,
		1.0)

		if GameRules:GetCustomGameDifficulty() == 10 then 
			hero:SetContextThink(DoUniqueString("SetSpawn") ,
				function()
					if GameRules:IsGamePaused() then return 0.1 end	
					if SpawnSystem.IsUnLimited then return nil end			
					PlayerResource:ModifyGold(heroPlayerID, math.min(SpawnSystem.CurWave * 20, 500) , true, DOTA_ModifyGold_Unspecified)	
					return 1
				end,
			10)
		end

		hero:SetContextThink(DoUniqueString("thtd_ai_think"), 
			function()
				if GameRules:IsGamePaused() then return 0.1 end
				if hero:IsStunned() then return nil end				
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
			if GameRules:GetCustomGameDifficulty() == 10 then 
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
	if tostring(PlayerResource:GetSteamID(keys.playerid)) ~= GameRules.game_info.admin then return end	

	local text = keys.text

	if string.sub(text,1,6) == "-color" then
		local colorValue = string.sub(text, 8, 11)	
		CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="item_locked_tip", duration=10, params={}, color=colorValue})
	end	

	if string.sub(text,1,4) == "-pos" then
		local player = PlayerResource:GetPlayer(keys.playerid)
		local hero = player:GetAssignedHero()
		local pos = hero:GetAbsOrigin()
		print("------- Current Position (x, y, z):")
		print(math.floor(pos.x + 0.5))
		print(math.floor(pos.y + 0.5))
		print(math.floor(pos.z + 0.5))
	end

	if string.sub(text,1,5) == "-wave" then
		local num = tonumber(string.sub(text, 7, 9))
		if num ~= nil and num > -49 then 
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="wave", param=num})					
		end			
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

	if string.sub(text,1,8) == "-levelup" then		
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerid),"thtd_command", {cmd="levelup", param={}})
	end	
end

function CTHTDGameMode:ExecuteOrder( keys )	
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
			local ability = EntIndexToHScript(keys.entindex_ability)
			local orderUnit = EntIndexToHScript(keys.units["0"])
			orderUnit:SetContextThink(DoUniqueString("eject_item"),
				function() 
					if GameRules:IsGamePaused() then return 0.03 end
					orderUnit:EjectItemFromStash(ability)					
					local box = ability:GetContainer()
					box:SetAbsOrigin(heroSpawnOrigin[keys.issuer_player_id_const+1])
					return nil
				end,
			0.2)
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
	if GameRules:GetCustomGameDifficulty() == 10 then return end
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
			local bonus = 1.0
			if GameRules:GetCustomGameDifficulty() == 7 or GameRules:GetCustomGameDifficulty() == 9 then bonus = 1.3 end
			hero:SetContextThink(DoUniqueString("thtd_pertick_gold_think"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					if SpawnSystem.IsUnLimited then return nil end
					PlayerResource:ModifyGold(hero:GetPlayerOwnerID(), math.floor(2.5 * SpawnSystem.CurWave * bonus) , true, DOTA_ModifyGold_Unspecified)					
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
	if keys.entindex_parent_const == nil then
		return true
	end
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
	end
	return true
end

function CTHTDGameMode:DamageFilter(keys)	
	-- damage: 24
	-- damagetype_const: 1
	-- entindex_attacker_const: 503
	-- entindex_inflictor_const: 500
	-- entindex_victim_const: 434
	if keys.damage <= 0 then
		return false
	end

	if keys.entindex_attacker_const == nil or keys.entindex_victim_const == nil then
		return true
	end

	local unit = EntIndexToHScript(keys.entindex_attacker_const)	
	local target = EntIndexToHScript(keys.entindex_victim_const)

	local unitName = unit:GetUnitName()
	local health = target:GetHealth()

	if target.thtd_damage_lock == true or keys.damage <= 0 then
		return false
	end

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

	if unitName == "junko" or unit:HasModifier("modifier_junko_01") then			
		if unitName == "satori" then
			keys.damage = math.min(keys.damage, 3768000*0.5)
		elseif unitName == "yuyuko" then
			if unit.thtd_yuyuko_02_chance == nil then
				unit.thtd_yuyuko_02_chance = 5
			end
			if unit:FindAbilityByName("thtd_yuyuko_02")~=nil and RandomInt(1,100) <= unit.thtd_yuyuko_02_chance then            
				keys.damage = math.min(health + 100, unit:THTD_GetPower() * unit:THTD_GetStar() * 100)
			end		
		end		
		if target:HasModifier("modifier_bosses_kaguya") and keys.damage > health then
			target:SetHealth(1)
			target:RemoveModifierByName("modifier_bosses_kaguya")
			tower.thtd_tower_damage = tower.thtd_tower_damage + health/100
			if unitName == "flandre" and keys.damage - health > 300 then  --按无尽减伤后的最小量100，100/（1-0.625）取整
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

	local damage_table = {			
		victim = target,
		attacker = unit,
		damage = keys.damage,
		damage_type = keys.damagetype_const,			
	}

	keys.damage = ReturnAfterTaxDamage(damage_table, false)
	damage_table = {}
	if keys.damage <= 0 then
		return false
	end

	if target:HasModifier("modifier_bosses_kaguya") and keys.damage > health then	
		target:SetHealth(1)
		target:RemoveModifierByName("modifier_bosses_kaguya")
		tower.thtd_tower_damage = tower.thtd_tower_damage + health/100
		if unitName == "flandre" and keys.damage - health > 300 then				
			THTD_OverDamage(unit, unit:FindAbilityByName("thtd_flandre_02"), keys.damage - health, target:GetOrigin(), 400)
		end
		return false
	end

	tower.thtd_tower_damage = tower.thtd_tower_damage + math.min(keys.damage,health) / 100
	if unitName == "flandre" and keys.damage - health > 300 then				
		THTD_OverDamage(unit, unit:FindAbilityByName("thtd_flandre_02"), keys.damage - health, target:GetOrigin(), 400)
	end
	return true	
end
