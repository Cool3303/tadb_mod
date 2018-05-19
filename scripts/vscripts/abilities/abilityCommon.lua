function OnTouhouReleaseTowerSpellStart(keys)
	local caster = keys.caster
	local target = keys.target

	if target:THTD_IsTower() and target:GetOwner() == caster then
		for i=0,8 do
			local targetItem = target:GetItemInSlot(i)
			if targetItem~=nil and targetItem:IsNull()==false then
				target:DropItemAtPositionImmediate(targetItem, target:GetOrigin())
			end
		end

		target:AddNewModifier(caster, nil, "modifier_touhoutd_release_hidden", {})
		target:SetOrigin(Vector(0,0,0))
		target:AddNoDraw()
		target:THTD_DestroyLevelEffect()
		target:RemoveModifierByName("modifier_touhoutd_no_health_bar")
		target.thtd_tower_damage = 0

		local item = EntIndexToHScript(target.thtd_item)
		caster:AddItem(item)

		if target:THTD_GetStar() > 1 then
			item.thtd_item_owner = caster
		end

		for k,v in pairs(caster.thtd_hero_tower_list) do
			if v == target then
				table.remove(caster.thtd_hero_tower_list,k)
			end
		end

		-- 组合刷新
		local combo = target:THTD_GetCombo()
		local func = target["THTD_"..target:GetUnitName().."_thtd_combo"]
		if func then
			func(target,combo)
		end
	end
end

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

function PutTowerToPoint(keys)
	local caster = keys.caster
	local targetPoint = keys.target_points[1]
	local itemName = keys.ability:GetAbilityName()
	local tower = keys.ability.tower

	if caster:GetUnitName()~="npc_dota_hero_lina" and keys.ability.thtd_item_owner ~= nil and keys.ability.thtd_item_owner ~= caster then return end

	if caster.food >= caster.thtd_game_info["food_count_max"] then 
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="not_enough_food", duration=5, params={count=1}, color="#0ff"} )
		return 
	end

	if IsBonusTower(itemName) and GetBonusTowerCount(caster) >= THTD_MAX_BONUS_TOWER then
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="bonus_tower_limit", duration=5, params={count=1}, color="#0ff"} )
		return 
	end

	if tower == nil then
		local spawnTowerName = towerNameList[itemName]["kind"]
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
		tower:SetOrigin(targetPoint)
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
		0.1)
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
		EmitSoundOn(THTD_GetVoiceEvent(towerNameList[itemName]["kind"],"spawn"),tower)
	end

	tower.thtd_item = keys.ability:GetEntityIndex()
	caster:TakeItem(keys.ability)
	tower:SetMana(0)
	caster:EmitSound("Sound_THTD.thtd_set_tower")

	table.insert(caster.thtd_hero_tower_list,tower)
	caster.food = #caster.thtd_hero_tower_list
	caster:THTD_CreateFoodEffect()

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
		item = caster:GetItemInSlot(item_slot)
		if item ~= nil and item.thtd_exp_up_lock ~= true then
			local tower = item:THTD_GetTower()
			if tower ~= nil then
				if tower:THTD_GetStar() == star and tower:THTD_GetLevel() == THTD_MAX_LEVEL then
					table.insert(composeItem,item)
				end
			end
			if item:GetAbilityName() == THTD_STAR_ITEM[star] or item:GetAbilityName() == THTD_SEIGA_STAR_ITEM[star] then
				table.insert(composeItem,item)
			end
		end
	end

	for item_slot = 0,5 do
		item = hero:GetItemInSlot(item_slot)
		if item ~= nil and item.thtd_exp_up_lock ~= true then
			local tower = item:THTD_GetTower()
			if tower ~= nil then
				if tower:THTD_GetStar() == star and tower:THTD_GetLevel() == THTD_MAX_LEVEL then
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
			composeItem[i]:THTD_RemoveSelf()
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
	if item ~= nil and item.thtd_exp_up_lock ~= true then
		caster:EmitSound("Sound_THTD.thtd_exp_up")
		local tower = item:THTD_GetTower()
		local exp = 3000
		if tower ~= nil then
			exp = (1000 + tower:THTD_GetExp()/5)*1500*(item:THTD_GetCardQuality()+1)/1000
		end
		if item:THTD_GetCardName() == caster:GetUnitName() then
			caster:THTD_SetAbilityLevelUp()
		elseif item:THTD_GetCardName() == "BonusEgg" then
			exp = (1000 + 5400/5)*1500*(item:THTD_GetCardQuality()+1)/1000
		elseif item:THTD_GetCardName() == nil or string.find(item:THTD_GetCardName(),"item_20") ~= nil then
			return
		end
		caster:THTD_AddExp(exp)
		item:THTD_RemoveSelf()
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
end

function OnTouhoutdExUp(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:THTD_IsTower() and target:GetUnitName() == "rumia" and target:THTD_GetStar() == 5 and target:GetOwner() == caster and caster.thtd_ability_rumia_ex_lock ~= true then
		target:EmitSound("Hero_Wisp.Tether")
		caster.thtd_ability_rumia_ex_lock = true
		target:THTD_UpgradeEx()
		target:SetBaseAttackTime(0.4)
		target:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		target:SetModel("models/thd2/rumia_ex/rumia_ex.vmdl")
		target:SetOriginalModel("models/thd2/rumia_ex/rumia_ex.vmdl")
		target:SetModelScale(0.7)

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
		end
		return 
	end
	local itemName = keys.ability:GetAbilityName()

	local drawList = {}

	--caster:EmitSound("Sound_THTD.thtd_draw_normal_card")

	drawList[1] = {}
	drawList[2] = {}

	for k,v in pairs(towerPlayerList[caster:GetPlayerOwnerID()+1]) do
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
	local item = nil
	if chance <=20 then
		if #drawList[2] > 0 then
			item = CreateItem(drawList[2][RandomInt(1,#drawList[2])], nil, nil)
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 1000 , true, DOTA_ModifyGold_SellItem) 
		end
	elseif chance > 20 then
		if #drawList[1] > 0 then
			item = CreateItem(drawList[1][RandomInt(1,#drawList[1])], nil, nil)
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 250 , true, DOTA_ModifyGold_SellItem) 
		end
	end

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
			local player = caster:GetPlayerOwner()
			if player then
				EmitSoundOnClient(THTD_GetVoiceEvent(cardName,"spawn"),player)
			end
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
			end
		end
	end

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
		end
		return 
	end
	local itemName = keys.ability:GetAbilityName()

	--caster:EmitSound("Sound_THTD.thtd_draw_senior_card")

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
	local item = nil
	if chance <=5 then
		if #drawList[4] > 0 then
			item = CreateItem(drawList[4][RandomInt(1,#drawList[4])], nil, nil)
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 5000 , true, DOTA_ModifyGold_SellItem) 
		end
	elseif chance <= 25 then
		if #drawList[3] > 0 then
			item = CreateItem(drawList[3][RandomInt(1,#drawList[3])], nil, nil)
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 2500 , true, DOTA_ModifyGold_SellItem) 
		end
	elseif chance > 25 then
		if #drawList[2] > 0 then
			item = CreateItem(drawList[2][RandomInt(1,#drawList[2])], nil, nil)
		else
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 1000 , true, DOTA_ModifyGold_SellItem) 
		end
	end

	if item~=nil then
		caster:AddItem(item)
		item:THTD_RemoveItemInList(caster:GetPlayerOwnerID())

		local itemNameRelease = item:GetAbilityName()
		if itemNameRelease ~= "item_2001" then
			caster:SetContextThink(DoUniqueString("thtd_item_release"), 
				function()
					if item==nil or item:IsNull() then
						THTD_AddItemToListByName(caster:GetPlayerOwnerID(),itemNameRelease)
						return nil
					end
					return 0.1
				end,
			0.1)
		end

		local cardName = item:THTD_GetCardName()
		local index = item:GetEntityIndex()

		if caster~=nil and caster:IsNull()==false then
			caster.thtd_hero_star_list[tostring(index)] = 1
			caster.thtd_hero_level_list[tostring(index)] = 1
		end

		if item:THTD_IsCardHasVoice() == true then
			local player = caster:GetPlayerOwner()
			if player then
				EmitSoundOnClient(THTD_GetVoiceEvent(cardName,"spawn"),player)
			end
		end

		if item:THTD_IsCardHasPortrait() == true then
			local portraits= item:THTD_GetPortraitPath(cardName)
			if item:THTD_GetCardQuality() == 3 then
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

function DrawUltimaCard(keys)
	local caster = keys.caster
	if caster:GetNumItemsInInventory()>=9 or caster:GetUnitName()~="npc_dota_hero_lina" then 
		if keys.ability:IsItem()==false then
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		end
		local player = caster:GetPlayerOwner()
		if player then
			EmitSoundOnClient("Sound_THTD.thtd_star_up_fail",player)
		end
		return 
	end

	local drawList = {}

	drawList[4] = {}

	for k,v in pairs(towerNameList) do
		if v["quality"] == 4 and v["kind"] ~= "BonusEgg" and string.find(v["kind"], 'item_20') == nil then
			table.insert(drawList[4],k)
		end
	end

	local item = nil
	if #drawList[4] > 0 then
		item = CreateItem(drawList[4][RandomInt(1,#drawList[4])], nil, nil)
	end

	if item~=nil then
		caster:AddItem(item)
		item.thtd_exp_up_lock = true
		caster:SetContextThink(DoUniqueString("thtd_item_release"), 
			function()
				if item==nil or item:IsNull() then
					caster:SpendGold(5000,DOTA_ModifyGold_Unspecified)
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
			local player = caster:GetPlayerOwner()
			if player then
				EmitSoundOnClient(THTD_GetVoiceEvent(cardName,"spawn"),player)
			end
		end

		if item:THTD_IsCardHasPortrait() == true then
			local portraits= item:THTD_GetPortraitPath(cardName)
			local effectIndex = ParticleManager:CreateParticle(portraits, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(effectIndex, 0, Vector(-58,-80,0))
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(80,0,0))
			ParticleManager:DestroyParticleSystemTime(effectIndex,6.0)
			effectIndex = ParticleManager:CreateParticle("particles/portraits/portraits_ssr_get_screen_effect.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:DestroyParticleSystemTime(effectIndex,4.0)
			caster:EmitSound("Sound_THTD.thtd_draw_ssr")
		end
	end

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
		return
	end

	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1001", caster.hero, caster.hero)
	caster.hero:AddItem(item)
	if item~=nil and item:IsNull()==false then
		local index = item:GetEntityIndex()
		if caster.hero~=nil and caster.hero:IsNull()==false then
			caster.hero.thtd_hero_star_list[tostring(index)] = 1
			caster.hero.thtd_hero_level_list[tostring(index)] = 1
		end
	end
end

function BuySeniorCard(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1002", caster.hero, caster.hero)
	caster.hero:AddItem(item)
	if item~=nil and item:IsNull()==false then
		local index = item:GetEntityIndex()
		if caster.hero~=nil and caster.hero:IsNull()==false then
			caster.hero.thtd_hero_star_list[tostring(index)] = 1
			caster.hero.thtd_hero_level_list[tostring(index)] = 1
		end
	end
end

function BuyEggLevel1(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1003", caster.hero, caster.hero)
	caster.hero:AddItem(item)
	local index = item:GetEntityIndex()
	if caster.hero~=nil and caster.hero:IsNull()==false then
		caster.hero.thtd_hero_star_list[tostring(index)] = 1
		caster.hero.thtd_hero_level_list[tostring(index)] = 10
	end
end

function BuyEggLevel2(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1004", caster.hero, caster.hero)
	caster.hero:AddItem(item)
	local index = item:GetEntityIndex()
	if caster.hero~=nil and caster.hero:IsNull()==false then
		caster.hero.thtd_hero_star_list[tostring(index)] = 2
		caster.hero.thtd_hero_level_list[tostring(index)] = 10
	end
end

function BuyEggLevel3(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1005", caster.hero, caster.hero)
	caster.hero:AddItem(item)
	local index = item:GetEntityIndex()
	if caster.hero~=nil and caster.hero:IsNull()==false then
		caster.hero.thtd_hero_star_list[tostring(index)] = 3
		caster.hero.thtd_hero_level_list[tostring(index)] = 10
	end
end

function BuyEggLevel4(keys)
	local caster = keys.caster
	if caster.hero:GetNumItemsInInventory()>=9 then 
		PlayerResource:ModifyGold(caster.hero:GetPlayerOwnerID(), keys.ability:GetGoldCost(keys.ability:GetLevel()) , true, DOTA_ModifyGold_SellItem) 
		return
	end
	caster:EmitSound("Sound_THTD.thtd_buy")
	local item = CreateItem("item_1006", caster.hero, caster.hero)
	caster.hero:AddItem(item)
	local index = item:GetEntityIndex()
	if caster.hero~=nil and caster.hero:IsNull()==false then
		caster.hero.thtd_hero_star_list[tostring(index)] = 4
		caster.hero.thtd_hero_level_list[tostring(index)] = 10
	end
end

function ChooseIt(keys)
	local caster = keys.caster
	if caster:GetNumItemsInInventory()>=9 then
		return
	end
	if keys.ability:GetAbilityName() == "item_1007" then
		local item = CreateItem("item_0001", nil, nil)
		caster:AddItem(item)
	elseif keys.ability:GetAbilityName() == "item_1008" then
		local item = CreateItem("item_0002", nil, nil)
		caster:AddItem(item)
	elseif keys.ability:GetAbilityName() == "item_1009" then
		local item = CreateItem("item_0003", nil, nil)
		caster:AddItem(item)
	end

	if caster.choose_item_1~=nil and caster.choose_item_1:IsNull()==false then
		caster.choose_item_1:RemoveSelf()
	end
	if caster.choose_item_2~=nil and caster.choose_item_2:IsNull()==false then
		caster.choose_item_2:RemoveSelf()
	end
	if caster.choose_item_3~=nil and caster.choose_item_3:IsNull()==false then
		caster.choose_item_3:RemoveSelf()
	end
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
 	local towerName =  towerNameList[itemName]["kind"]
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
	else
		caster.thtd_close_ai = false
	end
end

function AddMagicArmor(keys)
	if keys.ability:GetLevel()<1 then return end
	local caster = keys.caster
	local unit = keys.target

	unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()+keys.magic_armor)
end

function RemoveMagicArmor(keys)
	if keys.ability:GetLevel()<1 then return end
	local caster = keys.caster
	local unit = keys.target

	unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue()-keys.magic_armor)
end