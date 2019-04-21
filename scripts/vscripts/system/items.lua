
item_star_level = {}

function CDOTABaseAbility:THTD_ItemStarLevelUpdate()
	local tower = self:THTD_GetTower()
	if tower == nil then 
		self:THTD_ItemStarLevelRemove()
		return 
	end
	item_star_level[tostring(self:GetEntityIndex())] = {
		item_name = self:GetAbilityName(),
		star = tower:THTD_GetStar(),
		level = tower:THTD_GetLevel()
	}
	CustomNetTables:SetTableValue("CustomGameInfo", "ItemStarLevel", item_star_level)
end

function CDOTABaseAbility:THTD_ItemStarLevelRemove()
	local new = {}
	for k,v in pairs(item_star_level) do		
		if k ~= tostring(self:GetEntityIndex()) then new[k] = v end		
	end
	item_star_level = new
	new = {}
	CustomNetTables:SetTableValue("CustomGameInfo", "ItemStarLevel", item_star_level)
end

function CDOTABaseAbility:THTD_GetTower()
	return self.tower or nil
end

function CDOTABaseAbility:THTD_RemoveItemInList(PlayerID)
	local list_num = PlayerID+1
	local itemName = self:GetAbilityName()

	if itemName~=nil then
		for k,v in pairs(towerPlayerList[list_num]) do
			if v["itemName"] == itemName then
				v["count"] = v["count"] - 1
				if v["count"] <= 0 then
					table.remove(towerPlayerList[list_num],k)				
				end
				SetNetTableTowerPlayerList(PlayerID)
				return
			end
		end
	end
end

function THTD_AddItemToListByName(PlayerID,itemNameRelease)
	local list_num = PlayerID+1
	local itemName = itemNameRelease

	if itemName~=nil then
		for k,v in pairs(towerPlayerList[list_num]) do
			if v["itemName"] == itemName then
				v["count"] = v["count"] + 1
				SetNetTableTowerPlayerList(PlayerID)
				return
			end
		end
		local itemTable = 
		{
			["itemName"] = itemName,
			["quality"]= towerNameList[itemName]["quality"],
			["count"]= 1,
		}
		table.insert(towerPlayerList[PlayerID+1],itemTable)
		SetNetTableTowerPlayerList(PlayerID)
	end
end

function CDOTABaseAbility:THTD_GetCardName()
	if towerNameList[self:GetAbilityName()] ~= nil then
		return towerNameList[self:GetAbilityName()]["cardname"]
	else
		return nil
	end
end

function CDOTABaseAbility:THTD_GetCardQuality()
	if towerNameList[self:GetAbilityName()] ~= nil then
		return towerNameList[self:GetAbilityName()]["quality"]
	else
		return nil
	end
end

function CDOTABaseAbility:THTD_IsCardHasPortrait()
	if towerNameList[self:GetAbilityName()] ~= nil then
		return towerNameList[self:GetAbilityName()]["hasPortrait"]
	else
		return nil
	end
end

function CDOTABaseAbility:THTD_GetPortraitPath(unitName)
	return "particles/portraits/"..unitName.."/thtd_"..unitName.."_portraits.vpcf"
end

function CDOTABaseAbility:THTD_IsCardHasVoice()
	if towerNameList[self:GetAbilityName()] ~= nil then
		return towerNameList[self:GetAbilityName()]["hasVoice"]
	else
		return nil
	end
end

function THTD_GetVoiceEvent(cardName,key)
	return "Voice_THTD."..cardName.."."..key
end

function THTD_GetItemCountByName(playerid,itemName)
	for k,v in pairs(towerPlayerList[playerid+1]) do
		if v["itemName"] == itemName then
			return v["count"]
		end
	end
	return 0
end

function ItemSetScale(item, scale)
	if item == nil then return end
	local box = item:GetContainer()
	if box == nil then return end
	box:SetModelScale(scale)
end

local thtd_item_scale = 
{
	["kokoro"] = 0.55,
	["yoshika"] = 0.55,	
	["aya"] = 0.55,	
	["cirno"] = 0.55,	
	["marisa"] = 0.55,	
	["reimu"] = 0.55,	
	["remilia"] = 0.65,
	["flandre"] = 0.65,	
	["yukari"] = 0.45,	
	["satori"] = 0.55,	
	["patchouli"] = 0.55,	
	["sakuya"] = 0.55,	
	["youmu"] = 0.55,	
	["tenshi"] = 0.55,	
	["yuuka"] = 0.55,	
	["wriggle"] = 1.3,	
	
}

function THTD_ItemSetScale(item)
	if item == nil then return end
	local cardName = item:THTD_GetCardName()	
	if cardName ~= nil then
		if thtd_item_scale[cardName] == nil then
			-- ItemSetScale(item, 1.0)
		else		
			ItemSetScale(item, thtd_item_scale[cardName])
		end
	end	
end

function THTD_HasItemScale(item)
	if item == nil then return false end
	local cardName = item:THTD_GetCardName()	
	if cardName ~= nil and thtd_item_scale[cardName] ~= nil then
		return true
	end
	return false
end
