function CDOTABaseAbility:THTD_GetTower()
	return self.tower or nil
end


function CDOTABaseAbility:THTD_RemoveSelf()
	local tower = self:THTD_GetTower()
	local index = self:GetEntityIndex()

	if tower ~= nil then
		local hero = tower:GetOwner()
		if hero~=nil and hero:IsNull()==false then
			hero.thtd_hero_star_list[tostring(index)] = 1
			hero.thtd_hero_level_list[tostring(index)] = 1
		end
		tower:ForceKill(false)
	end

	self:RemoveSelf()
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
				return
			end
		end
	end
end

function CDOTABaseAbility:THTD_AddItemToList(PlayerID)
	local list_num = PlayerID+1
	local itemName = self:GetAbilityName()

	if itemName~=nil then
		for k,v in pairs(towerPlayerList[list_num]) do
			if v["itemName"] == itemName then
				v["count"] = v["count"] + 1
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
	end
end

function THTD_AddItemToListByName(PlayerID,itemNameRelease)
	local list_num = PlayerID+1
	local itemName = itemNameRelease

	if itemName~=nil then
		for k,v in pairs(towerPlayerList[list_num]) do
			if v["itemName"] == itemName then
				v["count"] = v["count"] + 1
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
	end
end

function CDOTABaseAbility:THTD_GetCardName()
	if towerNameList[self:GetAbilityName()] ~= nil then
		return towerNameList[self:GetAbilityName()]["kind"]
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