THTD_MAX_BONUS_TOWER = 3

local thtd_skin_list = 
{
	["suwako"] = 
	{
		[1] = "models/thd_hero/suwako/cloth01/suwako_cloth01.vmdl",
	},
	["mokou"] = 
	{
		[1] = "models/thd_hero/mokou/cloth01/mokou_cloth01.vmdl",
	},
	["meirin"] = 
	{
		[1] = "models/thd_hero/meirin/cloth01/meirin_cloth01.vmdl",
	},
	["minoriko"] = 
	{
		[1] = "models/thd_hero/minoriko/cloth01/minoriko_cloth01.vmdl",
	},
	["sanae"] = 
	{
		[1] = "models/thd_hero/sanae/cloth01/sanae_jk.vmdl",
	},
	["mystia"] = 
	{
		[1] = "models/thd_hero/mystia/cloth01/mystia_cloth01.vmdl",
	},
	["reimu"] = 
	{
		[1] = "models/thd_hero/reimu/cloth01/reimu_cloth01.vmdl",
	},
}

function OnTouhouReleaseTowerSpellStart(keys)
	local caster = keys.caster
	local target = keys.target

	if caster:GetNumItemsInInventory()>=9 then 
		CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		EmitSoundOnClient("Sound_THTD.thtd_star_up_fail", caster:GetPlayerOwner())
		return 
	end

	if target:THTD_IsTower() and target:GetOwner() == caster then	
		local item = target.thtd_item
		if item == nil then return end
		
		if item.locked_by_player_id == nil then 
			target:THTD_DropItemAll()
		end
		target:AddNewModifier(caster, nil, "modifier_touhoutd_release_hidden", {})
		target:SetAbsOrigin(Vector(0,0,0))
		target:AddNoDraw()
		target:THTD_DestroyLevelEffect()
		target:RemoveModifierByName("modifier_touhoutd_no_health_bar")
		target.thtd_tower_damage = 0	
		
		item:THTD_ItemStarLevelUpdate()
		caster:AddItem(item)

		for k,v in pairs(caster.thtd_hero_tower_list) do
			if v == target then
				table.remove(caster.thtd_hero_tower_list,k)
				break
			end
		end

		for k,v in pairs(caster.thtd_hero_tower_list) do
			if v==nil or v:IsNull() or v:IsAlive()==false or v:THTD_IsHidden() then
				table.remove(caster.thtd_hero_tower_list,k)				
			end
		end

		caster.thtd_game_info["food_count"] = #caster.thtd_hero_tower_list
		SetNetTableTowerList(caster)

		for k,v in pairs(caster.thtd_hero_tower_list) do
			if v ~= target then
				local modifiers = v:FindAllModifiers()
				for _, modifier in pairs(modifiers) do
					if modifier:GetCaster() == target and THTD_IsRemainBuff(modifier:GetName()) == false then modifier:Destroy() end
				end
			end			
		end		

		local entities = Entities:FindAllByClassname("npc_dota_creature")						
		for k,v in pairs(entities) do
			if v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_spawn_unit_owner~=nil and v.thtd_spawn_unit_owner==target then 
				v:AddNoDraw()
				v:ForceKill(false)
			end
		end

		caster:THTD_HeroComboRefresh()

		if SpawnSystem.CurWave > 120 and SpawnSystem.CurTime <= 3 and caster.is_change_card ~= true then
			caster.is_change_card = true 
			GameRules:SendCustomMessage("<font color='red'>最后3秒内回收卡阵容变更的这一波不计入有效波数。</font>", DOTA_TEAM_GOODGUYS, 0)
			caster:SetContextThink(DoUniqueString("change_card"),
				function()
					if GameRules:IsGamePaused() then return 0.1 end
					caster.is_change_card = false
					return nil
				end,
			5)
		end	

		if GameRules:GetGameTime() - caster.thtd_ai_time > 1.2 then 
			print("----- AI system closed, now open again.")
			caster:SetContextThink(DoUniqueString("thtd_ai_think"), 
				function()					
					caster.thtd_ai_time = GameRules:GetGameTime()
					if GameRules:IsGamePaused() then return 0.1 end
					if caster.is_game_over or caster:IsStunned() then return nil end				
					for k,v in pairs(caster.thtd_hero_tower_list) do
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
		end

	end
end

function PutTowerToPoint(keys)
	local caster = keys.caster
	if caster:GetUnitName()~="npc_dota_hero_lina" then return end
	local targetPoint = keys.target_points[1]
	local itemName = keys.ability:GetAbilityName()
	local tower = keys.ability.tower

	if caster.thtd_game_info["food_count"] ~= #caster.thtd_hero_tower_list then
		caster.thtd_game_info["food_count"] = #caster.thtd_hero_tower_list
		SetNetTableTowerList(caster)
	end
	if caster.thtd_game_info["food_count"] >= THTD_MAX_FOOD then 
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="not_enough_food", duration=5, params={count=1}, color="#0ff"} )
		return 
	end

	if SpawnSystem.IsUnLimited == false and IsBonusTower(itemName) and GetBonusTowerCount(caster) >= THTD_MAX_BONUS_TOWER then
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="bonus_tower_limit", duration=5, params={count=1}, color="#0ff"} )
		return 
	end

	if GameRules:GetCustomGameDifficulty() == 10 and SpawnSystem.IsUnLimited == false and IsBonusTower(itemName) and towerNameList[itemName]["cardname"] ~= "shinki" then 
		GameRules:SendCustomMessage("<font color='yellow'>娱乐模式下，神绮之外的收益卡收益无效。</font>", DOTA_TEAM_GOODGUYS, 0)		
	end

	if itemName == "item_0050" and GameRules:GetCustomGameDifficulty() > 5 then 
		GameRules:SendCustomMessage("<font color='red'>封兽鵺只能在难度6以下使用。</font>", DOTA_TEAM_GOODGUYS, 0)
		return 
	end

	if itemName == "item_0069" and SpawnSystem.CurWave > 120 then 
		GameRules:SendCustomMessage("<font color='red'>寅丸星只能在无尽70波以前使用。</font>", DOTA_TEAM_GOODGUYS, 0)
		return 
	end

	if tower == nil then
		local spawnTowerName = towerNameList[itemName]["cardname"]
		tower = CreateUnitByName(
			spawnTowerName, 
			targetPoint, 
			false, 
			caster, 
			caster, 
			caster:GetTeam() 
		)

		if caster.thtd_has_skin == true and thtd_skin_list[spawnTowerName] ~= nil then
			local skin_index = RandomInt(1, #thtd_skin_list[spawnTowerName])
			local model_name = thtd_skin_list[spawnTowerName][skin_index]

			tower:SetModel(model_name)
			tower:SetOriginalModel(model_name)
		end

		tower:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
		tower:SetOwner(caster)
		tower:SetHullRadius(50)
		FindClearSpaceForUnit(tower, targetPoint, false)

		tower:SetForwardVector(Vector(0,-1,tower:GetForwardVector().z))
		keys.ability.tower = tower		
	else
		if tower:GetOwner() ~= caster then
			tower:SetOwner(caster)
			tower:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
		end
		tower:SetAbsOrigin(targetPoint)
		tower:SetContextThink(DoUniqueString("FindClearSpaceForUnit"), 
			function()
				if GetDistanceBetweenTwoVec2D(tower:GetOrigin(),targetPoint) < 100 then
					tower:RemoveModifierByName("modifier_touhoutd_release_hidden")
					tower:RemoveNoDraw()
					FindClearSpaceForUnit(tower, targetPoint, false)
					tower:THTD_DestroyLevelEffect()
					tower:THTD_CreateLevelEffect()					
					return nil
				end
				return 0.1
			end,
		0)
		tower:SetForwardVector(Vector(0,-1,tower:GetForwardVector().z))
	end

	if tower:GetUnitName() == "shinki" then
		tower.thtd_shinki_01_lock = true
		local time = 30
		tower:SetContextThink(DoUniqueString("thtd_shinki_lock"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if time > 0 and tower:THTD_IsHidden() == false then
					time = time - 1
					return 1.0
				end
				tower.thtd_shinki_01_lock = false
				return nil
			end,
		1.0)
	end

	tower:SetHealth(1)

	if keys.ability:THTD_IsCardHasVoice() == true then
		EmitSoundOn(THTD_GetVoiceEvent(towerNameList[itemName]["cardname"],"spawn"),tower)
	end

	tower.thtd_item = keys.ability
	caster:TakeItem(keys.ability)
	tower:SetMana(0)
	caster:EmitSound("Sound_THTD.thtd_set_tower")

	table.insert(caster.thtd_hero_tower_list,tower)
	caster.thtd_game_info["food_count"] = #caster.thtd_hero_tower_list	
	SetNetTableTowerList(caster)	

	tower:AddNewModifier(caster, nil, "modifier_touhoutd_building", {})
	tower:SetContextThink(DoUniqueString("thtd_modifier_touhoutd_building"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if tower:GetHealth() >= tower:GetMaxHealth() then 
				local noHealthBar = tower:FindAbilityByName("ability_common_attack_buff")
				if noHealthBar ~= nil then
					noHealthBar:ApplyDataDrivenModifier(tower, tower, "modifier_touhoutd_no_health_bar", nil)
				end
				tower:RemoveModifierByName("modifier_touhoutd_building")				
				caster:THTD_HeroComboRefresh()				
				return nil 
			end
			tower:SetHealth(tower:GetHealth()+4)
			return 0.04
		end, 
	0)

	if tower.isFirstSpawn ~= true then 
		tower.isFirstSpawn = true
		tower:THTD_InitExp()
		tower:AddNewModifier(caster, nil, "modifier_touhoutd_root", {})
	else
		tower:THTD_DestroyLevelEffect()
		tower:THTD_CreateLevelEffect()
	end	

	local modifiers = tower:FindAllModifiers()
	for _, modifier in pairs(modifiers) do
		if THTD_IsRemainBuff(modifier:GetName()) == false and modifier:GetCaster() ~= tower and THTD_IsValid(modifier:GetCaster()) == false then 			
			modifier:Destroy() 
		end
	end	
end


THTD_STAR_ITEM = 
{
	[1] = "item_1003",
	[2] = "item_1004",
	[3] = "item_1005",
	[4] = "item_1006",
}

THTD_SEIGA_STAR_ITEM = 
{
	[1] = "item_1011",
	[2] = "item_1012",
	[3] = "item_1013",
	[4] = "item_1014",
}

function StarUp(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local hero = player:GetAssignedHero()
	local star = caster:THTD_GetStar()

	if caster:THTD_GetLevel() < THTD_MAX_LEVEL or star >= 5 then 
		if player then
			EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
		end
		return 
	end

	composeItem = {}
	
	for item_slot = 0,5 do
		local item = caster:GetItemInSlot(item_slot)		
		if item ~= nil and item.locked_by_player_id == nil then
			local tower = item:THTD_GetTower()
			if tower ~= nil and tower:THTD_GetStar() == star and tower:THTD_GetLevel() == THTD_MAX_LEVEL then	
				if GameRules:GetCustomGameDifficulty() == 10 and tower:GetUnitName() == "minoriko" then 
					GameRules:SendCustomMessage("<font color='yellow'>娱乐模式下秋穣子不能当作素材。</font>", DOTA_TEAM_GOODGUYS, 0)				
				else
					table.insert(composeItem,item)
				end							
			end
			if item:GetAbilityName() == THTD_STAR_ITEM[star] or item:GetAbilityName() == THTD_SEIGA_STAR_ITEM[star] then
				table.insert(composeItem,item)
			end
		end
	end

	for item_slot = 0,5 do
		local item = hero:GetItemInSlot(item_slot)				
		if item ~= nil and item.locked_by_player_id == nil then
			local tower = item:THTD_GetTower()
			if tower ~= nil and tower:THTD_GetStar() == star and tower:THTD_GetLevel() == THTD_MAX_LEVEL then					
				if GameRules:GetCustomGameDifficulty() == 10 and tower:GetUnitName() == "minoriko" then 
					GameRules:SendCustomMessage("<font color='yellow'>娱乐模式下秋穣子不能当作素材。</font>", DOTA_TEAM_GOODGUYS, 0)				
				else
					table.insert(composeItem,item)
				end			
			end
			if item:GetAbilityName() == THTD_STAR_ITEM[star] or item:GetAbilityName() == THTD_SEIGA_STAR_ITEM[star] then
				table.insert(composeItem,item)
			end
		end
	end

	if (#composeItem >= star) then
		for i=1,star do			
			OnItemDestroyed(caster, composeItem[i], false)
		end
		caster:THTD_UpgradeStar()		
	else
		if player then
			EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
		end
	end
	composeItem = {}
end

function ExpUp(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local hero = player:GetAssignedHero()

	item = caster:GetItemInSlot(0)	

	if item ~= nil then		
		if item:THTD_GetCardName() == nil or string.find(item:THTD_GetCardName(),"item_20") ~= nil then
			if player then
				EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
			end
			return
		end
			
		if item.locked_by_player_id ~= nil then		
			if player then
				CustomGameEventManager:Send_ServerToPlayer(player , "show_message", {msg="item_is_locked", duration=5, params={}, color="#fff"} )
				EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
			end
			return		
		end	
		
		caster:EmitSound("Sound_THTD.thtd_exp_up")		
		local tower = item:THTD_GetTower()
		local exp = 3000
		if tower ~= nil then
			if tower:GetUnitName() == "minoriko" and GameRules:GetCustomGameDifficulty() == 10 then 
				GameRules:SendCustomMessage("<font color='yellow'>娱乐模式下秋穣子不能当作素材。</font>", DOTA_TEAM_GOODGUYS, 0)	
				if player then
					EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
				end
				return	
			end
			exp = (1000 + tower:THTD_GetExp()/5)*1500*(item:THTD_GetCardQuality()+1)/1000
		end
		if item:THTD_GetCardName() == caster:GetUnitName() then
			caster:THTD_SetAbilityLevelUp()
		elseif item:THTD_GetCardName() == "BonusEgg" then
			exp = (1000 + 5400/5)*1500*(item:THTD_GetCardQuality()+1)/1000		
		end
		caster:THTD_AddExp(exp)		
		OnItemDestroyed(caster, item, false)
	else
		if player then
			EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
		end
	end
end

function BlinkToPoint(keys)
	local caster = keys.caster
	local targetPoint = keys.target_points[1]

	FindClearSpaceForUnit(caster, targetPoint, false)
	caster:EmitSound("Sound_THTD.ability_touhoutd_blink.End")
end

function OnKillUnitSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target.thtd_damage_lock == true then
		keys.ability:EndCooldown()
		return
	end
	
	target:SetHealth(1)
	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = 10000, 
	        damage_type = DAMAGE_TYPE_PURE, 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	ApplyDamage(DamageTable)

	caster:EmitSound("Sound_THTD.ability_touhoutd_kill")

	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+Vector(0,0,128))
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function CloseStar(keys)
	local caster = keys.caster

	if caster.thtd_close_star ~= true then
		caster.thtd_close_star = true
	else
		caster.thtd_close_star = false
	end

	for index,tower in pairs(caster.thtd_hero_tower_list) do
		if tower ~= nil and tower:IsNull() == false then
			if caster.thtd_close_star == true and tower.thtd_is_effect_open == true and caster.focusTarget ~= tower then
				tower:THTD_DestroyLevelEffect()
			elseif caster.thtd_close_star == false and tower.thtd_is_effect_open == false then
				tower:THTD_CreateLevelEffect()
			end			
		end
	end	
end

function OnTouhoutdExUp(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:THTD_IsTower() and target:GetUnitName() == "rumia" and target:THTD_GetStar() == 5 and target:GetOwner() == caster and caster.thtd_ability_rumia_ex_lock ~= true then		
		target:EmitSound("Hero_Wisp.Tether")
		caster.thtd_ability_rumia_ex_lock = true
		target:THTD_UpgradeEx()	
		target:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		target:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
		target:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")
		target:SetModelScale(0.7)
		local modifier = target:AddNewModifier(target, nil, "modifier_attack_time", {})
		modifier:SetStackCount(4)

		local attack_power_ability=target:FindAbilityByName("ability_common_power_buff")

		if attack_power_ability ~= nil then
			if attack_power_ability:GetLevel() < attack_power_ability:GetMaxLevel() then
				attack_power_ability:SetLevel(5)
			end
		end
	end
end

function DrawNormalCard(keys)
	local caster = keys.caster
	if caster:GetNumItemsInInventory()>=9 or caster:GetUnitName()~="npc_dota_hero_lina" then 
		if keys.ability:IsItem()==false then
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		end
		local player = caster:GetPlayerOwner()
		if player then
			EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
			if caster:GetNumItemsInInventory()>=9 then 
				CustomGameEventManager:Send_ServerToPlayer(player, "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
			end
		end
		return 
	end
	
	local drawList = {}	
	drawList[1] = {}
	drawList[2] = {}
	
	for k,v in pairs(towerPlayerList[caster.thtd_player_id+1]) do
		if v["quality"] == 1 and v["itemName"] ~= "BonusEgg" then
			for i=1,v["count"] do
				table.insert(drawList[1],v["itemName"])
			end
		elseif v["quality"] == 2 and v["itemName"] ~= "BonusEgg" then
			for i=1,v["count"] do
				table.insert(drawList[2],v["itemName"])
			end
		end
	end

	local chance = RandomInt(0,100)
	local itemName = nil
	if chance <=20 then
		if #drawList[2] > 0 then
			itemName = drawList[2][RandomInt(1,#drawList[2])]
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 1000 , true, DOTA_ModifyGold_SellItem) 
		end
	elseif chance > 20 then
		if #drawList[1] > 0 then
			itemName = drawList[1][RandomInt(1,#drawList[1])]
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 250 , true, DOTA_ModifyGold_SellItem) 
		end
	end
	caster:THTD_AddCardPoolItem(itemName)	

	if keys.ability:IsItem() then
		local charge = keys.ability:GetCurrentCharges()
		if charge > 1 then
			keys.ability:SetCurrentCharges(charge-1)
		else
			caster:RemoveItem(keys.ability)
		end
	end

	drawList = {}
end

function DrawSeniorCard(keys)
	local caster = keys.caster
	if caster:GetNumItemsInInventory()>=9 or caster:GetUnitName()~="npc_dota_hero_lina" then 
		if keys.ability:IsItem()==false then
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		end
		local player = caster:GetPlayerOwner()
		if player then
			EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
			if caster:GetNumItemsInInventory()>=9 then 
				CustomGameEventManager:Send_ServerToPlayer(player, "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
			end
		end
		return 
	end
	
	local drawList = {}
	drawList[2] = {}
	drawList[3] = {}
	drawList[4] = {}

	for k,v in pairs(towerPlayerList[caster:GetPlayerOwnerID()+1]) do
		if v["quality"] == 2 and v["itemName"] ~= "BonusEgg" then
			for i=1,v["count"] do
				table.insert(drawList[2],v["itemName"])
			end
		elseif v["quality"] == 3 and v["itemName"] ~= "BonusEgg" then
			for i=1,v["count"] do
				table.insert(drawList[3],v["itemName"])
			end
		elseif v["quality"] == 4 and v["itemName"] ~= "BonusEgg" then
			for i=1,v["count"] do
				table.insert(drawList[4],v["itemName"])
			end
		end
	end

	local chance = RandomInt(0,100)
	if caster.thtd_chance_count["SSR"] == nil then 
		caster.thtd_chance_count["SSR"] = 0
	end
	if caster.thtd_chance_count["SSR"] >= 20 then 
		chance = 0
	end
	if chance > 5 then
		caster.thtd_chance_count["SSR"] = caster.thtd_chance_count["SSR"] + 1
	end
	local itemName = nil
	if chance <=5 then
		caster.thtd_chance_count["SSR"] = 0
		if #drawList[4] > 0 then
			itemName = drawList[4][RandomInt(1,#drawList[4])]
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 5000 , true, DOTA_ModifyGold_SellItem) 
		end
	elseif chance <= 25 then
		if #drawList[3] > 0 then
			itemName = drawList[3][RandomInt(1,#drawList[3])]
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 2500 , true, DOTA_ModifyGold_SellItem) 
		end
	elseif chance > 25 then
		if #drawList[2] > 0 then
			itemName = drawList[2][RandomInt(1,#drawList[2])]
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 1000 , true, DOTA_ModifyGold_SellItem) 
		end
	end
	caster:THTD_AddCardPoolItem(itemName)		

	if keys.ability:IsItem() then
		local charge = keys.ability:GetCurrentCharges()
		if charge > 1 then
			keys.ability:SetCurrentCharges(charge-1)
		else
			caster:RemoveItem(keys.ability)
		end
	end

	drawList = {}
end

function BuyNormalCard(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		CustomGameEventManager:Send_ServerToPlayer(caster.hero:GetPlayerOwner(), "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return
	end

	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1001", caster.hero, caster.hero)
	item.owner_player_id = caster.hero.thtd_player_id
	caster.hero:AddItem(item)	
end

function BuySeniorCard(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		CustomGameEventManager:Send_ServerToPlayer(caster.hero:GetPlayerOwner(), "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1002", caster.hero, caster.hero)
	item.owner_player_id = caster.hero.thtd_player_id
	caster.hero:AddItem(item)	
end

function BuyEggLevel1(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		CustomGameEventManager:Send_ServerToPlayer(caster.hero:GetPlayerOwner(), "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1003", caster.hero, caster.hero)
	item.owner_player_id = caster.hero.thtd_player_id
	caster.hero:AddItem(item)	
end

function BuyEggLevel2(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		CustomGameEventManager:Send_ServerToPlayer(caster.hero:GetPlayerOwner(), "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1004", caster.hero, caster.hero)
	item.owner_player_id = caster.hero.thtd_player_id
	caster.hero:AddItem(item)	
end

function BuyEggLevel3(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		CustomGameEventManager:Send_ServerToPlayer(caster.hero:GetPlayerOwner(), "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1005", caster.hero, caster.hero)
	item.owner_player_id = caster.hero.thtd_player_id
	caster.hero:AddItem(item)	
end

function BuyEggLevel4(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		CustomGameEventManager:Send_ServerToPlayer(caster.hero:GetPlayerOwner(), "show_message", {msg="not_enough_item_slot", duration=10, params={}, color="#ff0"})
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1006", caster.hero, caster.hero)
	item.owner_player_id = caster.hero.thtd_player_id
	caster.hero:AddItem(item)	
end

function GetBonusTowerCount(hero)
	local count = 0
	for k,v in pairs(hero.thtd_hero_tower_list) do
		if v:GetUnitName() == "minoriko" or v:GetUnitName() == "nazrin" or v:GetUnitName() == "lily" or v:GetUnitName() == "daiyousei" or v:GetUnitName() == "sizuha" or v:GetUnitName() == "toramaru" or v:GetUnitName() == "shinki" or v:GetUnitName() == "seiga" then
			count = count + 1
		end
	end
	return count
end

 function IsBonusTower(itemName)
 	local towerName =  towerNameList[itemName]["cardname"]
	if towerName == "minoriko" or towerName == "nazrin" or towerName == "lily" or towerName == "daiyousei" or towerName == "sizuha" or towerName == "toramaru" or towerName == "shinki" or towerName == "seiga" then
		return true
	end
	return false
 end

 function AddManaRegenPercentage(keys)
	local caster = keys.caster

	if keys.ability.thtd_mana_regen_percentage == nil then
		keys.ability.thtd_mana_regen_percentage = 0
	end

	if caster.thtd_mana_regen_percentage == nil then
		caster.thtd_mana_regen_percentage = 0
	end

	caster.thtd_mana_regen_percentage =  caster.thtd_mana_regen_percentage - keys.ability.thtd_mana_regen_percentage

	caster.thtd_mana_regen_percentage =  caster.thtd_mana_regen_percentage + keys.mana_regen
	
	keys.ability.thtd_mana_regen_percentage = keys.mana_regen
 end

function OnCloseAI(keys)
	local caster = keys.caster

	if caster.thtd_close_ai ~= true then
		caster.thtd_close_ai = true		
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_close_ai", duration=5, params={}, color="#0ff"} )		
	else
		caster.thtd_close_ai = false		
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_open_ai", duration=5, params={}, color="#0ff"} )
		-- 神子和幽幽子，是否开启大招
		local unitName = caster:GetUnitName()
		if unitName=="miko" then 
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner() , "ai_skill_enable", {entity=caster:GetEntityIndex(), name=unitName, skill=4})
			-- thtd_miko_04_cast
		elseif unitName=="yuyuko" then		
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner() , "ai_skill_enable", {entity=caster:GetEntityIndex(), name=unitName, skill=3})
			-- thtd_yuyuko_03_cast		
		elseif unitName=="keine" then		
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner() , "ai_skill_enable", {entity=caster:GetEntityIndex(), name=unitName, skill=2})
			-- thtd_keine_02_cast		
		elseif unitName=="patchouli" then		
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner() , "ai_skill_enable", {entity=caster:GetEntityIndex(), name=unitName, skill=2})
			-- thtd_patchouli_02_cast		
		elseif unitName=="medicine" then		
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner() , "ai_skill_enable", {entity=caster:GetEntityIndex(), name=unitName, skill=2})
			-- thtd_medicine_02_cast	
		elseif unitName=="sunny" then		
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner() , "ai_skill_enable", {entity=caster:GetEntityIndex(), name=unitName, skill=2})
			-- thtd_sunny_02_cast	
		elseif unitName=="alice" then		
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner() , "ai_skill_enable", {entity=caster:GetEntityIndex(), name=unitName, skill=1})
			-- thtd_alice_01_cast
		end
		
	end
end

function AddMagicArmor(keys)
	if keys.ability:GetLevel()<1 then return end
	local caster = keys.caster
	local unit = keys.target
	unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+keys.magic_armor)

	if caster:GetUnitName() == "patchouli" then
		if unit.thtd_poison_buff == nil then 
			unit.thtd_poison_buff = 0
		end
		unit.thtd_poison_buff = unit.thtd_poison_buff + 1
	end	
end

function RemoveMagicArmor(keys)
	if keys.ability:GetLevel()<1 then return end
	local caster = keys.caster
	local unit = keys.target
	unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()-keys.magic_armor)
	if caster:GetUnitName() == "patchouli" then
		if unit.thtd_poison_buff == nil then 
			unit.thtd_poison_buff = 0
		end		
		unit.thtd_poison_buff = math.max(0, unit.thtd_poison_buff - 1)
	end	
end