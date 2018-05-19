
SUBQUEST_STATE_NONE = 0
SUBQUEST_STATE_FINISHED  = 1

if Subquest == nil then
	Subquest = {}
end

local public = Subquest
local meta = {__index=public}
local subquest_actions = {}
setmetatable(public, public)

function public:__call(...)
	local t = {}
	setmetatable(t, meta)
	t:constructor(...)
	return t
end

function public:constructor( hParent, hData )
	self.hData = hData
	self.nCurrentNumber = 0
	self.nState = SUBQUEST_STATE_NONE
	self.hParent = hParent
end

-- 
function public:GetQuest()
	return self.hParent
end

-- 
function public:GetPlayerID()
	return self:GetQuest():GetPlayerID()
end

-- 
function public:GetType()
	return self.hData["Type"]
end

-- 
function public:GetValue( key, def )
	return self.hData[key] or def
end

-- 
function public:GetNumber()
	return self.nCurrentNumber
end

-- 
function public:SetNumber( num )
	self.nCurrentNumber = num
end

-- 
function public:GetState()
	return self.nState
end

-- 
function public:SetState( state )
	self.nState = state
end

-- 
function public:IsState( state )
	return self.nState == state
end

-- 
function public:GetData()
	local data = {
		State = self.nState,
		Number = self.nCurrentNumber,
	}
	return data
end

-- 
function public:Update( event )
	for i,v in ipairs(subquest_actions) do
		v(self, event)
	end	
end

function public:AddAction( action )
	table.insert( subquest_actions, action )
end

return public