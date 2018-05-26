-- Generated from template


if CTHTDGameMode == nil then
	CTHTDGameMode = class({})
end


require( "common")
require( "system/spawner")
require( "system/items")
require( "system/tower")
require( "system/damage")
require( "system/custom_event")
require( "system/combo")
require( "ai/common")
require( "trigger/PassCorner")
require( "utils/copy_config")
require( "system/quest/quest_system")

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
-- Create the game mode when we activate
function Activate()
	GameRules.THTDGameMode = CTHTDGameMode()
	GameRules.THTDGameMode:InitGameMode()
end

HERO_MAX_LEVEL = 10

HERO_EXP_TABLE={0}

-- Sum 5400
-- Experience allocation rules Guarantee 1X 30 points 2X 20 points, 3X 10 points, 4X 6 points, 5X 3 points
-- Eat a tower experience 300 points 200 points 100 points 60 points 30 points
-- Experience rate 1X 100% 2X 2/3 3X 1/3 4X 1/5 5X 1/10
-- Material Training (1000+Material Card Experience/5)*star

exp={200,300,400,500,600,700,800,900,1000}
xp=0

for i=2,HERO_MAX_LEVEL-1 do
	HERO_EXP_TABLE[i]=HERO_EXP_TABLE[i-1]+exp[i-1]
end

function CTHTDGameMode:InitGameMode()
	print( "Template addon is loaded." )

	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1734.0)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(HERO_EXP_TABLE)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(HERO_MAX_LEVEL)
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

  	ListenToGameEvent('player_connect_full', Dynamic_Wrap(CTHTDGameMode, 'AutoAssignPlayer'), self)

  	ListenToGameEvent('player_disconnect', Dynamic_Wrap(CTHTDGameMode, 'CleanupPlayer'), self)

  	ListenToGameEvent('player_chat', Dynamic_Wrap(CTHTDGameMode, 'OnPlayerSay'), self)

 	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(CTHTDGameMode, 'OnGameRulesStateChange'), self)

  	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(CTHTDGameMode, 'ItemAddedToInventory'), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(CTHTDGameMode, 'OnDamageFilter'), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(CTHTDGameMode, 'OnModifierFilter'), self)
	-- GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(CTHTDGameMode, 'OnModifyGoldFilter'), self)

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

	-- 将便利店技能所需金币保存到Nettable
	local abilities = {
		"ability_touhoutd_shop_buy_egg_level_1",
		"ability_touhoutd_shop_buy_egg_level_2",
		"ability_touhoutd_shop_buy_egg_level_3",
		"ability_touhoutd_shop_buy_normal_card",
		"ability_touhoutd_shop_buy_senior_card",
		"ability_touhoutd_shop_buy_egg_level_4",
	}
	local abilitiesGoldCost = {}
	local abilityKV = LoadKeyValues( "scripts/npc/npc_abilities_custom.txt" )
	for i,v in ipairs(abilities) do
		if abilityKV[v] then
			abilitiesGoldCost[v] = abilityKV[v]["AbilityGoldCost"]
		end
	end
	CustomNetTables:SetTableValue( "CustomGameInfo", "AbilitiesGoldCost", abilitiesGoldCost)

	CustomGameEventManager:RegisterListener("select_card",
		function(keys,data)
			local player = PlayerResource:GetPlayer(data.PlayerID)
			if player ==nil then return end
			local caster = player:GetAssignedHero()
			if caster == nil then return end
			local itemName = data.itemname
			if itemName ~= nil then
				if caster.thtd_last_select_item~=nil and caster.thtd_last_select_item:IsNull()==false then
					caster:RemoveItem(caster.thtd_last_select_item)
					local item = CreateItem(itemName, nil, nil)
					if item~=nil then
						caster:AddItem(item)
						item:THTD_RemoveItemInList(caster:GetPlayerOwnerID())

						-- 回收
						local itemNameRelease = item:GetAbilityName()
						caster:SetContextThink(DoUniqueString("thtd_item_release"),
							function()
								if item==nil or item:IsNull() then
									THTD_AddItemToListByName(caster:GetPlayerOwnerID(),itemNameRelease)
									return nil
								end
								return 0.1
							end,
						0.1)

						local cardName = item:THTD_GetCardName()
						local index = item:GetEntityIndex()

						if caster~=nil and caster:IsNull()==false then
							caster.thtd_hero_star_list[tostring(index)] = 1
							caster.thtd_hero_level_list[tostring(index)] = 1
						end

						if item:THTD_IsCardHasVoice() == true then
							EmitAnnouncerSoundForPlayer(THTD_GetVoiceEvent(cardName,"spawn"),caster:GetPlayerOwnerID())
						end

						if item:THTD_IsCardHasPortrait() == true then
							local portraits= item:THTD_GetPortraitPath(cardName)
							if item:THTD_GetCardQuality() == 1 then
								local effectIndex = ParticleManager:CreateParticleForPlayer(portraits, PATTACH_WORLDORIGIN, caster, caster:GetPlayerOwner())
								ParticleManager:SetParticleControl(effectIndex, 0, Vector(-58,-80,0))
								ParticleManager:SetParticleControl(effectIndex, 1, Vector(80,0,0))
								ParticleManager:DestroyParticleSystemTime(effectIndex,6.0)
								caster:EmitSound("Sound_THTD.thtd_draw_n")
							elseif item:THTD_GetCardQuality() == 2 then
								local effectIndex = ParticleManager:CreateParticleForPlayer(portraits, PATTACH_WORLDORIGIN, caster, caster:GetPlayerOwner())
								ParticleManager:SetParticleControl(effectIndex, 0, Vector(-58,-80,0))
								ParticleManager:SetParticleControl(effectIndex, 1, Vector(80,0,0))
								ParticleManager:DestroyParticleSystemTime(effectIndex,6.0)
								caster:EmitSound("Sound_THTD.thtd_draw_r")
							elseif item:THTD_GetCardQuality() == 3 then
								local effectIndex = ParticleManager:CreateParticleForPlayer(portraits, PATTACH_WORLDORIGIN, caster, caster:GetPlayerOwner())
								ParticleManager:SetParticleControl(effectIndex, 0, Vector(-58,-80,0))
								ParticleManager:SetParticleControl(effectIndex, 1, Vector(80,0,0))
								ParticleManager:DestroyParticleSystemTime(effectIndex,6.0)
								caster:EmitSound("Sound_THTD.thtd_draw_sr")
							elseif item:THTD_GetCardQuality() == 4 then
								local effectIndex = ParticleManager:CreateParticle(portraits, PATTACH_WORLDORIGIN, nil)
								ParticleManager:SetParticleControl(effectIndex, 0, Vector(-58,-80,0))
								ParticleManager:SetParticleControl(effectIndex, 1, Vector(80,0,0))
								ParticleManager:DestroyParticleSystemTime(effectIndex,6.0)
								effectIndex = ParticleManager:CreateParticle("particles/portraits/portraits_ssr_get_screen_effect.vpcf", PATTACH_WORLDORIGIN, nil)
								ParticleManager:DestroyParticleSystemTime(effectIndex,4.0)
								caster:EmitSound("Sound_THTD.thtd_draw_ssr")
							end
						end
					end
				end
			end
		end
	)
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

local shopFoodOrigin =
{
	[1] = Vector(-2016,2688,137),
	[2] = Vector(2016,2688,137),
	[3] = Vector(2016,-2688,142),
	[4] = Vector(-2016,-2688,142),
}

local shopSpawnOrigin =
{
	[1] = Vector(-3424,2816,140),
	[2] = Vector(3424,2816,140),
	[3] = Vector(3424,-2816,140),
	[4] = Vector(-3424,-2816,140),
}

local vote_disconnect_player =
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

local G_disconnect_player_count = 0
local G_disconnect_dead_player_count = 0

function CTHTDGameMode:OnGameRulesStateChange(keys)
  	local newState = GameRules:State_Get()

	if newState ==  DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:GameStateCustomGameSetup()
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
  		ListenToGameEvent('npc_spawned', Dynamic_Wrap( CTHTDGameMode, 'OnHeroSpawned' ), self )

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

		if AcceptExtraMode == true then
			difficulty = 3
		end
		GameRules:SetCustomGameDifficulty(difficulty+1)
		for i=0, PlayerResource:GetPlayerCount() do
			local player = PlayerResource:GetPlayer(i)
			if player then
				PlayerResource:ModifyGold(player:GetPlayerID(), difficulty*1000 , true, DOTA_ModifyGold_Unspecified)
			end
		end
		print("[Custom Game Difficulty]", GameRules:GetCustomGameDifficulty())

  	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
			self:GameSetHeroOriginPosition()
			if false and GameRules:IsCheatMode() and IsInToolsMode() == false then
				local base = Entities:FindByName(nil, "dota_goodguys_fort")
				base:ForceKill(false)
			end
  	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
  		self:THTD_InitCreepMsgEffect(PlayerResource:GetPlayerCount()*40)
  		SpawnSystem:InitSpawn()

		local is_wave_first_over_52 = false
		local last_wave = 1
		local player_count = PlayerResource:GetPlayerCount()

  		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("thtd_creep_count"),
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if SpawnSystem:GetWave() <= 51 then
					local entities = Entities:FindAllByClassname("npc_dota_creature")
					local count = 0
					for k,v in pairs(entities) do
						local findNum =  string.find(v:GetUnitName(), 'creature')
						if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() then
							count = count + 1
						end
					end
					local playerCount = PlayerResource:GetPlayerCount() - G_disconnect_dead_player_count
					if playerCount ~= player_count then
  						self:THTD_InitCreepMsgEffect(playerCount*40)
  						player_count = playerCount
					end
					if count > 40*playerCount then
						local base = Entities:FindByName(nil, "dota_goodguys_fort")
						base:ForceKill(false)
						return nil
					end
				elseif SpawnSystem:GetWave() == 52 and is_wave_first_over_52 ~= true then
					CTHTDGameMode:THTD_InitCreepMsgEffect(30)
					local entities = Entities:FindAllByClassname("npc_dota_creature")
					for k,v in pairs(entities) do
						local findNum =  string.find(v:GetUnitName(), 'creature')
						if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() then
							v:ForceKill(false)
						end
					end
					is_wave_first_over_52 = true
				end
				return 1.0
			end,
		1.0)
  	end
end

function CTHTDGameMode:THTD_InitCreepMsgEffect(count)
	for i=0, PlayerResource:GetPlayerCount() do
		local player = PlayerResource:GetPlayer(i)
		if player then
			local hero = player:GetAssignedHero()
			if hero then
				hero.thtd_game_info["creep_count_max"] = count
			end
		end
	end
end


function CTHTDGameMode:THTD_CreateCreepEffect(count,hero)
	hero.thtd_game_info["creep_count"] = count
end

function CTHTDGameMode:GameStateCustomGameSetup()
	for i=0, PlayerResource:GetPlayerCount() do
		local player = PlayerResource:GetPlayer(i)
		if player then
			CreateHeroForPlayer("npc_dota_hero_lina", player):RemoveSelf()
		end
	end
end

function CTHTDGameMode:GameSetHeroOriginPosition()
	for i=0, PlayerResource:GetPlayerCount() do
		local player = PlayerResource:GetPlayer(i)
		if player then
			player:SetContextThink(DoUniqueString("thtd_wait_GameSetHeroOriginPosition"),
				function()
					local hero = player:GetAssignedHero()
					if hero then
						local origin = shopSpawnOrigin[i+1]
						hero:SetOrigin(origin)
						PlayerResource:SetCameraTarget(i,hero)
						hero:SetContextThink(DoUniqueString("GameSetHeroOriginPosition"),
							function()
								PlayerResource:SetCameraTarget(i,nil)
							end,
						0.5)
						return nil
					else
						return 0.03
					end
				end,
			0.03)
		end
	end
end

function CTHTDGameMode:AutoAssignPlayer(keys)

end

function CTHTDGameMode:OnEntityKilled(keys)
	-- 储存被击杀的单位
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- 储存杀手单位
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )

	local playerid = killedUnit.thtd_player_index

	local findNum =  string.find(killedUnit:GetUnitName(), 'creature')

	if findNum ~= nil then
		local targets = {}

		if killerEntity:THTD_IsTower() then
			targets = THTD_FindFriendlyUnitsInRadius(killerEntity,killedUnit:GetOrigin(),1500)
		elseif killerEntity.thtd_spawn_unit_owner ~= nil then
			targets = THTD_FindFriendlyUnitsInRadius(killerEntity.thtd_spawn_unit_owner,killedUnit:GetOrigin(),1500)
		end

		local expUnits = {}

		for k,v in pairs(targets) do
			if v ~= nil and v:IsNull()==false and v:THTD_IsTower() and v:THTD_GetLevel() < THTD_MAX_LEVEL and v:GetOwner():GetPlayerID() == playerid then
				table.insert(expUnits,v)
			end
		end
		targets = {}

		local totalNum = #expUnits

		for k,v in pairs(expUnits) do
			v:THTD_AddExp(killedUnit:GetDeathXP()/totalNum)
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

function CTHTDGameMode:CleanupPlayer(keys)
end

function CTHTDGameMode:OnHeroSpawned(keys)
	local hero = EntIndexToHScript(keys.entindex)
	if hero:GetUnitName() == "npc_dota_hero_lina" and hero.isFirstSpawn ~= false then
		hero.isFirstSpawn = false
		hero.thtd_hero_tower_list = {}
		hero.thtd_hero_star_list = {}
		hero.thtd_hero_level_list = {}
		hero.thtd_hero_power_list = {}
		hero.thtd_hero_damage_list ={}
		hero.thtd_combo_voice_array = {}
		hero.food = 0
		hero.press_key = {}
		hero.thtd_emoji_effect = nil
		hero.thtd_has_skin = false

		hero.thtd_game_info = {}
		hero.thtd_game_info["creep_count_max"] = 0
		hero.thtd_game_info["creep_count"] = 0
		hero.thtd_game_info["food_count"] = 0
		if AcceptExtraMode == true then
			hero.thtd_game_info["food_count_max"] = 12
		else
			hero.thtd_game_info["food_count_max"] = 12
		end
		hero.thtd_game_info["creature_kill_count"] = 0

		CTHTDGameMode:THTD_CreateCreepEffect(0,hero)

		local sound_lock = false
		hero:SetContextThink(DoUniqueString("thtd_combo_voice_array"),
			function()
				if hero:IsStunned() then return nil end
				for k,v in pairs(hero.thtd_combo_voice_array) do
					if v~=nil and v["comboName"] == "lyrica_lunasa_merlin" then
						if v["unit"]~=nil and v["unit"]:IsNull()==false then
							EmitSoundOn(THTD_GetVoiceEvent(v["unit"]:GetUnitName(),"combo."..v["comboName"]),v["unit"])
							table.remove(hero.thtd_combo_voice_array,k)
						end
					elseif v~=nil and sound_lock == false then
						sound_lock = true
						if v["unit"]~=nil and v["unit"]:IsNull()==false then
							local tower = v["unit"]
							EmitSoundOn(THTD_GetVoiceEvent(tower:GetUnitName(),"combo."..v["comboName"]),tower)
						end
				  		hero:SetContextThink(DoUniqueString("thtd_creep_count"),
							function()
								if GameRules:IsGamePaused() then return 0.03 end
								sound_lock = false
								table.remove(hero.thtd_combo_voice_array,k)
								return nil
							end,
						v["duration"]+0.5)
					end
				end
				return 0.1
			end,
		0.1)

		local is_wave_first_over_52 = false
		local last_wave = 1
		local heroPlayerID = hero:GetPlayerOwnerID()
		local playerConnect = true

		hero.thtd_player_id = heroPlayerID

  		hero:SetContextThink(DoUniqueString("thtd_creep_count"),
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if SpawnSystem:GetWave() == 0 then return 0.03 end
				if last_wave ~= SpawnSystem:GetWave() then
					hero:RemoveAllTowerDamage()
					last_wave = SpawnSystem:GetWave()
					if last_wave <= 51 then
						QuestSystem:Update( heroPlayerID, {Type="wave_clear", Wave=last_wave} )
					else
						QuestSystem:Update( heroPlayerID, {Type="endless_wave_clear", Wave=last_wave-50} )
					end
				end
				if SpawnSystem:GetWave() <= 51 then
					local entities = Entities:FindAllByClassname("npc_dota_creature")
					local count = 0
					for k,v in pairs(entities) do
						local findNum =  string.find(v:GetUnitName(), 'creature')
						if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() then
							count = count + 1
						end
					end
					self:THTD_CreateCreepEffect(count,hero)

					if (hero:GetPlayerOwner()==nil or hero:GetPlayerOwner():IsNull()) and playerConnect == true then
						G_disconnect_player_count = G_disconnect_player_count + 1
						playerConnect = false
						CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="player_disconnect", duration=15, params={count=1}, color="#0ff"} )
						CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="{d:count}", duration=15, params={count=heroPlayerID+1}, color="#0ff"})
					elseif hero:GetPlayerOwner()~=nil and hero:GetPlayerOwner():IsNull() == false and playerConnect == false then
						G_disconnect_player_count = G_disconnect_player_count - 1
						playerConnect = true
					end

					if playerConnect == false then
						if vote_disconnect_player[heroPlayerID+1] > 0 and vote_disconnect_player[heroPlayerID+1] >= (PlayerResource:GetPlayerCount() - G_disconnect_player_count) then
							local entities = Entities:FindAllByClassname("npc_dota_creature")
							for k,v in pairs(entities) do
								if v:GetOwner() == hero then
									v:SetOrigin(Vector(0,0,0))
									v:AddNoDraw()
									v:AddNewModifier(hero, nil, "modifier_touhoutd_release_hidden", {})
								end
							end
							SpawnSystem:StopWave(heroPlayerID+1)
							hero:AddNewModifier(hero, nil, "modifier_touhoutd_release_hidden", {})
							hero:AddNoDraw()
							G_disconnect_dead_player_count = G_disconnect_dead_player_count + 1
							return nil
						end
					end

				elseif SpawnSystem:GetWave() == 52 and is_wave_first_over_52 ~= true then
					hero.thtd_game_info["creature_kill_count"] = 0
					is_wave_first_over_52 = true
					QuestSystem:Update( heroPlayerID, {Type="finished_game",Difficulty=GameRules:GetCustomGameDifficulty()} )

				elseif SpawnSystem:GetWave() >= 52 then
					local winner = GameRules:IsCheatMode() and DOTA_TEAM_BADGUYS or DOTA_TEAM_GOODGUYS
					if AcceptExtraMode == true then
						if SpawnSystem:GetWave() > 121 then
						 	ServerEvent( "set_can_select_free_mode", heroPlayerID, {} )
						 	GiveTouhouGamePoints(heroPlayerID, math.floor(50+hero.thtd_game_info["creature_kill_count"]*(1+(GameRules:GetCustomGameDifficulty()-1)*0.5)))
						 	GameRules:SetGameWinner(winner)
						 	return nil
						end
					else
						if SpawnSystem:GetWave() > (80+(GameRules:GetCustomGameDifficulty()-1)*10) then
						 	ServerEvent( "set_can_select_free_mode", heroPlayerID, {} )
						 	GiveTouhouGamePoints(heroPlayerID, math.floor(50+hero.thtd_game_info["creature_kill_count"]*(1+(GameRules:GetCustomGameDifficulty()-1)*0.5)))
						 	GameRules:SetGameWinner(winner)
						 	return nil
						end
					end

					if hero:IsStunned() == false then
						local entities = Entities:FindAllByClassname("npc_dota_creature")
						local count = 0
						for k,v in pairs(entities) do
							local findNum =  string.find(v:GetUnitName(), 'creature_unlimited')
							if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == heroPlayerID then
								count = count + 1
							end
							local findNum2 =  string.find(v:GetUnitName(), 'creature_alice')
							if findNum2 ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == heroPlayerID and v.thtd_is_outer then
								count = count + 1
							end
							local findNum3 =  string.find(v:GetUnitName(), 'creature_bosses')
							if findNum3 ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == heroPlayerID then
								count = count + 1
							end
						end
						if count > 30 then
							for k,v in pairs(entities) do
								local findNum = string.find(v:GetUnitName(), 'creature_unlimited')
								local findNum2 = string.find(v:GetUnitName(), 'creature_alice')
								local findNum3 =  string.find(v:GetUnitName(), 'creature_bosses')
								if (findNum ~= nil or findNum2 ~= nil or findNum3 ~= nil) and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == heroPlayerID then
									v:ForceKill(false)
								elseif v~=nil and v:IsNull()==false and v:IsAlive() and v:GetOwner() == hero then
									v:SetOrigin(Vector(0,0,0))
									v:AddNoDraw()
									v:AddNewModifier(hero, nil, "modifier_touhoutd_release_hidden", {})
								end
							end
							SpawnSystem:StopWave(heroPlayerID+1)
							UnitStunTarget( hero,hero,-1)
							hero:AddNoDraw()
							CTHTDGameMode:THTD_CreateCreepEffect(count,hero)
							GiveTouhouGamePoints(heroPlayerID, math.floor(50+hero.thtd_game_info["creature_kill_count"]/5*(1+(GameRules:GetCustomGameDifficulty()-1)*0.5)))

							local isEndGame = true
							local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
							for k,v in pairs(heroes) do
								if v~=nil and v:IsNull()==false and v:IsAlive() and v:IsStunned() == false then
									isEndGame = false
								end
							end

							if isEndGame == true then
								local base = Entities:FindByName(nil, "dota_goodguys_fort")
								base:ForceKill(false)
							end
							return nil
						else
							CTHTDGameMode:THTD_CreateCreepEffect(count,hero)
						end
					end
				end
				return 1.0
			end,
		1.0)

		hero:SetModelScale(1.4)
		UnitNoPathingfix( hero,hero,-1)

		hero:AddNewModifier(hero, nil, "modifier_phased", nil)
		hero:SetAbilityPoints(0)
		for i=1,10 do
			hero:HeroLevelUp(false)
		end
		hero:SetAbilityPoints(0)
		local ability=hero:GetAbilityByIndex(0)
		if ability ~= nil then
			ability:SetLevel(1)
		end
		ability=hero:GetAbilityByIndex(1)
		if ability ~= nil then
			ability:SetLevel(1)
		end
		ability=hero:GetAbilityByIndex(2)
		if ability ~= nil then
			ability:SetLevel(1)
		end
		ability=hero:GetAbilityByIndex(3)
		if ability ~= nil then
			ability:SetLevel(1)
		end
		ability=hero:GetAbilityByIndex(4)
		if ability ~= nil then
			ability:SetLevel(1)
		end
		ability=hero:GetAbilityByIndex(5)
		if ability ~= nil then
			ability:SetLevel(1)
		end
		ability=hero:GetAbilityByIndex(6)
		if ability ~= nil then
			ability:SetLevel(1)
		end

		local item = CreateItem("item_1007", hero, hero)
		hero:AddItem(item)
		hero.choose_item_1 = item
		item = CreateItem("item_1008", hero, hero)
		hero:AddItem(item)
		hero.choose_item_2 = item
		item = CreateItem("item_1009", hero, hero)
		hero:AddItem(item)
		hero.choose_item_3 = item

		if true or HasTouhouVIP(heroPlayerID) then
			item = CreateItem("item_1010", hero, hero)
			hero:AddItem(item)
		end

		local origin = shopFoodOrigin[hero:GetPlayerOwnerID()+1]
		self:THTD_InitFoodMsgEffect(hero)

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
				if hero:GetNumItemsInStash() > 0 then
					for i=9,15 do
						local targetItem = hero:GetItemInSlot(i)
						if targetItem ~= nil and targetItem:IsNull()==false then
							hero:EjectItemFromStash(targetItem)
							local box = targetItem:GetContainer()
							box:SetOrigin(shopSpawnOrigin[hero:GetPlayerOwnerID()+1])
						end
					end
				end
				return 1.0
			end,
		1.0)
	end
end

function CTHTDGameMode:VoteKickPlayer(num)
	vote_disconnect_player[num] = vote_disconnect_player[num] + 1
end

function CTHTDGameMode:DisVoteKickPlayer(num)
	vote_disconnect_player[num] = vote_disconnect_player[num] - 1
end

local player_vote =
{
	[1] =
	{
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false,
	},
	[2] =
	{
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false,
	},
	[3] =
	{
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false,
	},
	[4] =
	{
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false,
	},
}

function CTHTDGameMode:OnPlayerSay( keys )
	local text = keys.text

	local findNum =  string.find(text, '-kickafk')
	if findNum ~= nil then
		local num = tonumber(string.sub(text, 10, 10))
		if player_vote[keys.playerid+1][num] == false then
			CTHTDGameMode:VoteKickPlayer(num)
			CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="player_disconnect_vote", duration=5, params={count=1}, color="#0ff"})
			CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="{d:count}", duration=5, params={count=vote_disconnect_player[num]}, color="#0ff"})
			player_vote[keys.playerid+1][num] = true
		end
	end

	local findNum =  string.find(text, '-disvote')
	if findNum ~= nil then
		local num = tonumber(string.sub(text, 10, 10))
		if player_vote[keys.playerid+1][num] == true then
			CTHTDGameMode:DisVoteKickPlayer(num)
			CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="player_disconnect_disvote", duration=5, params={count=1}, color="#0ff"})
			CustomGameEventManager:Send_ServerToAllClients("show_message", {msg="{d:count}", duration=5, params={count=vote_disconnect_player[num]}, color="#0ff"})
			player_vote[keys.playerid+1][num] = false
		end
	end

	if GameRules:IsCheatMode() or IsInToolsMode() then
		if text == "-config" then
			_CopyConfig()
		elseif text == "-win" then
			GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
		elseif text == "-quest" then
			QuestSystem:Update( 0, {Type="wave_clear", Wave=50} )
		elseif text == "-server" then
			ServerEvent( "set_can_select_free_mode", keys.playerid, {} )
		elseif text == "-gold" then
			PlayerResource:SetGold(keys.playerid, 99999, true)
		elseif text == "-stop" then
			SpawnSystem:StopWave(keys.playerid+1)
		elseif text == "-resume" then
			SpawnSystem:ResumeWave(keys.playerid+1)
<<<<<<< HEAD
        elseif text == "-skip" then
            SpawnSystem:SkipBreakTime(keys.playerid+1)
=======
>>>>>>> utilyti
		end
	end
end

function CTHTDGameMode:OnTHTDExperienceFilter(keys)
	return true
end

function CTHTDGameMode:OnTHTDOrderFilter(keys)
  	if keys.units["0"] ~= nil then
    	local orderUnit = EntIndexToHScript(keys.units["0"])
    	if orderUnit ~= nil then
	      	if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
	    	elseif keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
	  		end
	  	end
  		return true
  	end
end

function CTHTDGameMode:ItemAddedToInventory( keys )
	local iInventoryParentIndex = keys.inventory_parent_entindex_const
	local hInventoryParent = EntIndexToHScript(keys.inventory_parent_entindex_const)

	local iItemParentIndex = keys.item_parent_entindex_const
	local hItemParent = EntIndexToHScript(keys.item_parent_entindex_const)

	local iItemIndex = keys.item_entindex_const
	local hItem = EntIndexToHScript(iItemIndex)
	local itemName = hItem:GetAbilityName()

	if itemName == "item_tpscroll" or itemName == "item_enchanted_mango" then
		return false
	end
	if itemName == "item_2024" then
		OnAddGoldPerTick(hInventoryParent,8,hItem)
	end
	return true
end


function OnAddGoldPerTick(caster,pertick,item)
	if SpawnSystem:GetWave() > 51 then return end
	if caster==nil or caster:IsNull() then return end
	if item.thtd_isUsed == true then return end
	local hero = nil
	if caster:THTD_IsTower() or caster:GetUnitName() == "minoriko_shop" then
		hero = caster:GetOwner()
	elseif caster:GetUnitName() == "npc_dota_hero_lina" then
		hero = caster
	end

	if hero~=nil then
		if hero.thtd_pertick_is_open == nil then
			hero.thtd_pertick_is_open = false
		end
		if hero.thtd_pertick_is_open == false then
			hero.thtd_pertick_is_open = true
			item.thtd_isUsed = true
			hero:SetContextThink(DoUniqueString("thtd_pertick_gold_think"),
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					if SpawnSystem:GetWave() > 51 then return nil end
					if hero.thtd_pertick_is_open == true then
						PlayerResource:ModifyGold(hero:GetPlayerOwnerID(), pertick , true, DOTA_ModifyGold_Unspecified)
					end
					return 1.0
				end,
			1.0)
		end
	end
end

function CTHTDGameMode:OnModifierFilter(keys)
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
-- gold: 15
-- player_id_const: 0
-- reason_const: 13
-- reliable: 0

local extra_gold =
{
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0,
}

function CTHTDGameMode:OnModifyGoldFilter(keys)
	local current_gold = PlayerResource:GetGold(keys.player_id_const)

	if current_gold+keys.gold > 99999 then
		extra_gold[keys.player_id_const] = extra_gold[keys.player_id_const] + keys.gold
		return false
	elseif extra_gold[keys.player_id_const] > 0 then
		local add_gold = math.min(extra_gold[keys.player_id_const],99999-(keys.gold+current_gold))
		keys.gold = keys.gold + add_gold
		extra_gold[keys.player_id_const] = extra_gold[keys.player_id_const] - add_gold
	end
	return true
end


function CTHTDGameMode:OnDamageFilter(keys)
	if keys.entindex_attacker_const == nil or keys.entindex_victim_const == nil then
		return true
	end

	-- keys.damage = 10000000
	-- if true then return true end

	local unit = EntIndexToHScript(keys.entindex_attacker_const)
	local target = EntIndexToHScript(keys.entindex_victim_const)

	if target:HasModifier("modifier_flandre_04_debuff") then
		return false
	end

	if target.thtd_damage_lock == true then
		return false
	end

	local damage_table = {
			ability = keys.ability,
			victim = target,
			attacker = unit,
			damage = keys.damage,
			damage_type = keys.damagetype_const
	}

	keys.damage = ReturnAfterTaxDamage(damage_table)
	damage_table = {}

	if target:HasModifier("modifier_bosses_kaguya") then
	    if keys.damage > target:GetHealth() then
	    	target:SetHealth(1)
	    	target:RemoveModifierByName("modifier_bosses_kaguya")
			return false
		end
	end

	if keys.damage > 0 then
		if unit:THTD_IsTower() then
			local damage = math.min(keys.damage,target:GetHealth())
			unit.thtd_tower_damage = unit.thtd_tower_damage + damage
		elseif unit.thtd_spawn_unit_owner ~= nil and unit.thtd_spawn_unit_owner:IsNull()==false and unit.thtd_spawn_unit_owner:IsAlive() then
			local tower = unit.thtd_spawn_unit_owner
			if tower:THTD_IsTower() then
				local damage = math.min(keys.damage,target:GetHealth())
				tower.thtd_tower_damage = tower.thtd_tower_damage + damage
			end
		end
	end
	return true
end

local thtd_bosses_list =
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

function CDOTA_BaseNPC:RemoveAllTowerDamage()
	if AcceptExtraMode == true then
		if SpawnSystem:GetWave() > 51 and (SpawnSystem:GetWave())%4 == 0 then
			self.thtd_minoriko_02_change = 0
			PlayerResource:ModifyGold(self:GetPlayerOwnerID(),3500,true,DOTA_ModifyGold_CreepKill)
			for k,v in pairs(self.thtd_hero_tower_list) do
				if v~=nil and v:IsNull()==false and v:IsAlive() then
					if v:THTD_IsTower() and v:THTD_GetLevel()<THTD_MAX_LEVEL then
						v:THTD_SetLevel(THTD_MAX_LEVEL)
					end
				end
			end
			CustomGameEventManager:Send_ServerToPlayer(self:GetPlayerOwner(),"show_message", {msg="extra_bonus_nazrin", duration=60, params={count=1}, color="#0ff"} )
			CustomGameEventManager:Send_ServerToPlayer(self:GetPlayerOwner(),"show_message", {msg="extra_bonus_minoriko_limit", duration=60, params={count=1}, color="#0ff"} )
			CustomGameEventManager:Send_ServerToPlayer(self:GetPlayerOwner(),"show_message", {msg="extra_bonus_lily", duration=60, params={count=1}, color="#0ff"} )

			local bossIndex = RandomInt(1,#thtd_bosses_list)
			self.thtd_next_bossName = thtd_bosses_list[bossIndex]
			CustomGameEventManager:Send_ServerToPlayer(self:GetPlayerOwner(),"show_message", {msg="extra_bosses_"..self.thtd_next_bossName, duration=60, params={count=1}, color="#0ff"} )
			thtd_next_bossName_list[self:GetPlayerOwnerID()+1] = self.thtd_next_bossName
		end
	end

	for k,v in pairs(self.thtd_hero_tower_list) do
		if v~=nil and v:IsNull()==false and v:IsAlive() then
			if SpawnSystem:GetWave() <= 51 then
				if v:GetUnitName() == "toramaru" then
					PlayerResource:ModifyGold(v:GetPlayerOwnerID(),v.thtd_tower_damage*0.01,true,DOTA_ModifyGold_CreepKill)
					SendOverheadEventMessage(v:GetPlayerOwner(),OVERHEAD_ALERT_GOLD,v,v.thtd_tower_damage*0.01,v:GetPlayerOwner() )
				elseif v:GetUnitName() == "shinki" and v.thtd_shinki_01_lock == false then
					OnShinkiGainCard(v)
				end
			end
			v.thtd_tower_damage = 0
		end
	end
end

function CDOTA_BaseNPC:THTD_CreateFoodEffect()
	self.thtd_game_info["food_count"] = self.food
end

function CDOTA_BaseNPC:RefreshItemListNetTable()
	local towerList = {}
	for k,v in pairs(self.thtd_hero_tower_list) do
		towerList[k] = v:GetEntityIndex()
		local item = v:THTD_GetItem()
		if item~=nil then
			self.thtd_hero_star_list[tostring(item)] = v:THTD_GetStar()
			self.thtd_hero_level_list[tostring(item)] = v:THTD_GetLevel()
			self.thtd_hero_power_list[tostring(v:GetEntityIndex())] = math.floor(v:THTD_GetPower())
			self.thtd_hero_damage_list[tostring(v:GetEntityIndex())] = v.thtd_tower_damage
		end
	end

	local steamid = PlayerResource:GetSteamID(self:GetPlayerOwnerID())
	local playerid = self:GetPlayerOwnerID()

	CustomNetTables:SetTableValue("TowerListInfo", "cardlist"..tostring(steamid), towerPlayerList[self:GetPlayerOwnerID()+1])
	CustomNetTables:SetTableValue("TowerListInfo", "starlist"..tostring(steamid), self.thtd_hero_star_list)
	CustomNetTables:SetTableValue("TowerListInfo", "levellist"..tostring(steamid), self.thtd_hero_level_list)
	CustomNetTables:SetTableValue("TowerListInfo", "powerlist"..tostring(steamid), self.thtd_hero_power_list)
	CustomNetTables:SetTableValue("TowerListInfo", "damagelist"..tostring(steamid), self.thtd_hero_damage_list)
	CustomNetTables:SetTableValue("TowerListInfo", "towerlist"..tostring(steamid), towerList)
	CustomNetTables:SetTableValue("CustomGameInfo", "game_info"..tostring(steamid), self.thtd_game_info)
end

function CTHTDGameMode:THTD_InitFoodMsgEffect(hero)
	hero:THTD_CreateFoodEffect()
	hero:SetContextThink(DoUniqueString("thtd_on_hero_food_changed"),
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if hero:IsStunned() then return nil end
			hero:RefreshItemListNetTable()
			local food = #hero.thtd_hero_tower_list
			if food ~= nil and hero.food ~= food then
				hero.food = food
				hero:THTD_CreateFoodEffect()
			end
			return 0.5
		end,
	0.5)
end

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
	local count = 0
	for k,v in pairs(shinki_01_draw_card_type[caster:THTD_GetStar()]) do
		if k == "Level1" then
			local drawList = {}

			drawList[1] = {}
			for k,v in pairs(towerNameList) do
				if v["quality"] == 1 and v["kind"] ~= "BonusEgg" then
					table.insert(drawList[1],k)
				end
			end

			for i=1,v do
				local item = CreateItem(drawList[1][RandomInt(1,#drawList[1])], nil, nil)
				if item ~= nil then
					local origin = shopSpawnOrigin[caster:GetPlayerOwnerID()+1] + Vector(count*100,0,0)
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
				if v["quality"] == 1 and v["kind"] ~= "BonusEgg" then
					table.insert(drawList[1],k)
				elseif v["quality"] == 2 and v["kind"] ~= "BonusEgg" then
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
					local origin = shopSpawnOrigin[caster:GetPlayerOwnerID()+1] + Vector(count*100,0,0)
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
				if v["quality"] == 2 and v["kind"] ~= "BonusEgg" then
					table.insert(drawList[2],k)
				elseif v["quality"] == 3 and v["kind"] ~= "BonusEgg" then
					table.insert(drawList[3],k)
				elseif v["quality"] == 4 and v["kind"] ~= "BonusEgg" then
					table.insert(drawList[4],k)
				end
			end


			for i=1,v do
				local chance = RandomInt(0,100)
				local item = nil
				if chance <=5 then
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
					local origin = shopSpawnOrigin[caster:GetPlayerOwnerID()+1] + Vector(count*100,0,0)
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
