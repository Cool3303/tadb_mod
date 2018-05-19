
QUEST_STATE_NONE = 0
QUEST_STATE_ACCEPTED  = 1
QUEST_STATE_FINISHED  = 2
QUEST_STATE_COMPLETED = 3
QUEST_STATE_FAILED = 4

if Quest == nil then
	Quest = {}
end

local public = Quest
local tinsert = table.insert
local tremove = table.remove
local meta = {__index=public}
local onGiveRewardAction = {}
local Subquest = require('system.quest.subquest')

setmetatable(public, public)

function public:__call(...)
	local t = {}
	setmetatable(t, meta)
	t:constructor(...)
	return t
end

function public:constructor( iPlayerID, szQuestName, hInitData )
	local hQuestData = QuestTable[szQuestName]
	assert(hQuestData, "Invalid Quest Name")

	self.iPlayerID = iPlayerID
	self.szQuestName = szQuestName
	self.hSubquestList = {}
	self.hQuestData = hQuestData
	self.nState = hInitData.State or QUEST_STATE_ACCEPTED

	for k,v in pairs(hQuestData["Subquests"]) do
		self:AddSubquest( Subquest(self, v) )
	end
end

-- 
function public:GetPlayerID()
	return self.iPlayerID
end

-- 
function public:GetQuestName()
	return self.szQuestName
end

-- 
function public:GetSorts()
	return self.hQuestData["Sorts"]
end

-- 
function public:IsRepeat()
	return self.hQuestData["Repeat"] == true
end

-- 
function public:IsAutoComplete()
	return self.hQuestData["AutoComplete"] == true
end

-- 
function public:GetState()
	return self.nState
end

-- 
function public:SetState( num )
	self.nState = num
end

-- 
function public:IsState( num )
	return self.nState == num
end

-- 
function public:AddSubquest( hSubquest )
	tinsert(self.hSubquestList, hSubquest)
end

-- 
function public:GetSubquest( nIndex )
	return self.hSubquestList[nIndex]
end

-- 
function public:RemoveSubquest( target )
	if type(target) == "number" then
		self.hSubquestList[target] = nil
	else
		for i,v in ipairs(self.hSubquestList) do
			if v == target then
				tremove(self.hSubquestList, i)
				break
			end
		end
	end
end

function public:Complete()
	if self:IsState(QUEST_STATE_FINISHED) then
		self:SetState(QUEST_STATE_COMPLETED)
		self:GiveCompletedRewards()
		ServerEvent( "completed_quest", self.iPlayerID, {quest=self:GetQuestName()} )
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( self.iPlayerID ), 
			"quest_system_completed_msg",
			{quest = self:GetQuestName()})
	end
end

function public:GiveCompletedRewards()
	for k,Rewards in pairs(self.hQuestData["CompletedRewards"]) do
		local startIndex = 1
		if type(Rewards[1]) == "string" then
			startIndex = 2
		end
		for i=startIndex,#Rewards do
			for _,f in ipairs(onGiveRewardAction) do
				f(self, Rewards[i])
			end
		end
	end
end

-- 
function public:Update( hEvent )
	for i,v in ipairs(self.hSubquestList) do
		v:Update(hEvent)
	end

	-- 
	local isFinished = #self.hSubquestList > 0
	for i,v in ipairs(self.hSubquestList) do
		if not v:IsState(SUBQUEST_STATE_FINISHED) then
			isFinished = false
			break
		end
	end

	if isFinished then
		self:SetState(QUEST_STATE_FINISHED)
		if self:IsAutoComplete() then
			self:Complete()
		end
	end
end

-- 
function public:GetQuestData()
	local data = {}
	local subquests = {}

	for i,v in ipairs(self.hSubquestList) do
		subquests[i] = v:GetData()
	end

	data["State"] = self.nState
	data["Subquests"] = subquests
	return data
end

function public:OnGiveReward( action )
	tinsert( onGiveRewardAction, action )
end

return public