

if QuestSystem == nil then
	QuestSystem = {
		hPlayerQuestList = {},
	}
	require('system.quest.quest_table')
end

local Quest = require('system.quest.quest')

local public = QuestSystem
local tinsert = table.insert
local jsonEncode = json.encode
local nullData = {}

function public:GetQuestList( iPlayerID )
	local list = self.hPlayerQuestList[tostring(PlayerResource:GetSteamID( iPlayerID ))]
	if list == nil then
		list = {}
		self.hPlayerQuestList[tostring(PlayerResource:GetSteamID( iPlayerID ))] = list
	end
	return list
end

function public:GetQuest( iPlayerID, szQuestName )
	local list = self:GetQuestList( iPlayerID )
	for i,v in ipairs(list) do
		if v:GetQuestName() == szQuestName then
			return v
		end
	end
end

function public:AcceptQuest( iPlayerID, szQuestName, hInitData )
	local list = self:GetQuestList( iPlayerID )
	local quest = Quest(iPlayerID, szQuestName, hInitData or nullData)
	tinsert(list, quest)
end

function public:Update( iPlayerID, hEvent )
	hEvent.iPlayerID = iPlayerID
	local list = self:GetQuestList( iPlayerID )
	for i,v in ipairs(list) do
		if v:IsState( QUEST_STATE_ACCEPTED ) then
			v:Update( hEvent )
		end
	end

	self:SendQuests( iPlayerID )
end

local sendQuestTime = {}
function public:SendQuests( iPlayerID )
	local time = sendQuestTime[iPlayerID] or 0
	if time >= GameRules:GetGameTime() then
		return
	end
	sendQuestTime[iPlayerID] = GameRules:GetGameTime() + 0.2

	GameRules:GetGameModeEntity():SetContextThink( DoUniqueString( "SendQuests" ), function ()
		local list = self:GetQuestList( iPlayerID )
		local player = PlayerResource:GetPlayer( iPlayerID )
		local updateQuests = {}

		for i,v in ipairs(list) do
			if v:IsState( QUEST_STATE_ACCEPTED ) then
				updateQuests[v:GetQuestName()] = v:GetQuestData()
			end
		end

		CustomGameEventManager:Send_ServerToPlayer( player, "quest_system_update", {t=jsonEncode(updateQuests)} )
		return nil
	end, 0.2 )
end

CustomGameEventManager:RegisterListener( "quest_system_request_update", function ( e, data )
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player then
		public:SendQuests( data.PlayerID )
	end
end)

require('system.quest.action')
return public