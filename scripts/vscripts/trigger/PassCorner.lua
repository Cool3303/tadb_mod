function OnPassTheCorner(data)
	local target = data.activator

	local findNum =  string.find(target:GetUnitName(), 'creature')
	if findNum == nil and target:GetUnitName() ~= "yukari_train" then return end
	if target == nil or target:IsNull() then return end
	if target.thtd_ability_reisen_01_fearing == true then return end

	local caller = data.caller
	local vecLocation = thisEntity:GetOrigin()
	local vecTarget = target:GetOrigin()

	if target:GetUnitName() == "yukari_train" then
		target.next_move_point = THTD_GetTrainNextPathForUnit(target,thisEntity:GetName())
		target:SetBaseMoveSpeed(2500)
		target:SetContextThink(DoUniqueString("AttackingBase"), 
			function ()
				target:SetBaseMoveSpeed(2000)
				return nil
			end, 
		0.5) 
	else
		-- if target.thtd_last_corner == nil then
		-- 	for k,v in pairs(THTD_EntitiesRect[target.thtd_next_corner]) do
		-- 		if string.find(tostring(k),"corner") == nil then
		-- 			if v==nil or v:IsNull() or v:IsAlive()==false then
		-- 				table.remove(THTD_EntitiesRect[target.thtd_next_corner],k)
		-- 			elseif v == target then
		-- 				table.remove(THTD_EntitiesRect[target.thtd_next_corner],k)
		-- 			end
		-- 		end
		-- 	end
		-- elseif target.thtd_next_corner ~= nil then
		-- 	for k,v in pairs(THTD_EntitiesRect[target.thtd_last_corner][target.thtd_next_corner]) do
		-- 		if v==nil or v:IsNull() or v:IsAlive()==false then
		-- 			table.remove(THTD_EntitiesRect[target.thtd_last_corner][target.thtd_next_corner],k)
		-- 		elseif v == target then
		-- 			table.remove(THTD_EntitiesRect[target.thtd_last_corner][target.thtd_next_corner],k)
		-- 		end
		-- 	end
		-- end
		-- target.thtd_last_corner = target.thtd_next_corner
		
		target.next_move_point = THTD_GetNextPathForUnit(target,thisEntity:GetName())
		
		-- if target.thtd_last_corner ~= nil and target.thtd_next_corner ~= nil then
		-- 	table.insert(THTD_EntitiesRect[target.thtd_last_corner][target.thtd_next_corner],target)
		-- end
	end
end

function THTD_GetTrainNextPathForUnit(target,corner)
	local vecTable = {}

	for i=1,4 do
		local forward = THTD_GetForward(i)

		if G_path_corner[corner][forward] ~= nil then
			if target.next_move_forward == nil or forward~=GetContraryForward(target.next_move_forward) then
				table.insert(vecTable,forward)
			end
		end
	end

	local nextForward = vecTable[RandomInt(1,#vecTable)]

	if target.FirstTrain == nil then
		target.next_corner_table[corner] = nextForward
	else
		nextForward = target.FirstTrain.next_corner_table[corner]
	end

	if nextForward ~= nil then
		local vecRun = G_path_corner[corner][nextForward]

		target.next_move_forward = nextForward
		
		if vecRun~=nil then
			return G_path_corner[vecRun].Vector * 1.5
		else
			return target.next_move_point
		end
	else
		target:AddNoDraw()
		target:ForceKill(true)
	end
end

function THTD_GetNextPathForUnit(target,corner)
	local vecTable = {}

	for i=1,4 do
		local forward = THTD_GetForward(i)

		if G_path_corner[corner][forward] ~= nil then
			if target.next_move_forward == nil or forward~=GetContraryForward(target.next_move_forward) then
				table.insert(vecTable,forward)
			end
		end
	end

	local nextForward = vecTable[RandomInt(1,#vecTable)]

	if nextForward ~= nil then
		local vecRun = G_path_corner[corner][nextForward]

		target.next_move_forward = nextForward
		
		if vecRun~=nil then
			--target.thtd_next_corner = vecRun
			return G_path_corner[vecRun].Vector * 1.5
		else
			--target.thtd_next_corner = nil
			return target.next_move_point
		end
	else
		target.next_move_forward = nil
	end
end

function GetContraryForward(forward)
	if forward == "up" then
		return "down"
	elseif forward == "down" then
		return "up"
	elseif forward == "left" then
		return "right"
	elseif forward == "right" then
		return "left"
	end
	return forward
end

function THTD_GetForward(num)
	if num == 1 then
		return "up"
	elseif num == 2 then
		return "down"
	elseif num == 3 then
		return "left"
	elseif num == 4 then
		return "right"
	end
	return "left"
end


G_path_corner = 
{
	["corner_0_M2768"] = {
		Vector = Vector(0,-2768,137),
		["up"] = nil,
		["down"] = "corner_0_M3808",
		["left"] = "corner_M2771_M2768",
		["right"] = "corner_2771_M2768",
	},
	["corner_2771_M2768"] = {
		Vector = Vector(2771,-2768,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = "corner_0_M2768",
		["right"] = "corner_4544_M2768",
	},
	["corner_M2771_2768"] = {
		Vector = Vector(-2771,2768,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = "corner_M4544_2768",
		["right"] = "corner_0_2768",
	},
	["corner_5584_M3808"] = {
		Vector = Vector(5584,-3808,137),
		["up"] = "corner_5584_0",
		["down"] = nil,
		["left"] = "corner_0_M3808",
		["right"] = nil,
	},
	["corner_M5584_M3808"] = {
		Vector = Vector(-5584,-3808,137),
		["up"] = "corner_M5584_0",
		["down"] = nil,
		["left"] = nil,
		["right"] = "corner_0_M3808",
	},
	["corner_0_3808"] = {
		Vector = Vector(0,3808,137),
		["up"] = nil,
		["down"] = "corner_0_2768",
		["left"] = "corner_M5584_3808",
		["right"] = "corner_5584_3808",
	},
	["corner_M2771_M2768"] = {
		Vector = Vector(-2771,-2768,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = "corner_M4544_M2768",
		["right"] = "corner_0_M2768",
	},
	["corner_2771_1056"] = {
		Vector = Vector(2771,1056,137),
		["up"] = "corner_2771_2768",
		["down"] = nil,
		["left"] = nil,
		["right"] = nil,
	},
	["corner_4544_M2768"] = {
		Vector = Vector(4544,-2768,137),
		["up"] = "corner_4544_0",
		["down"] = nil,
		["left"] = "corner_2771_M2768",
		["right"] = nil,
	},
	["corner_M4544_M2768"] = {
		Vector = Vector(-4544,-2768,137),
		["up"] = "corner_M4544_0",
		["down"] = nil,
		["left"] = nil,
		["right"] = "corner_M2771_M2768",
	},
	["corner_M4544_0"] = {
		Vector = Vector(-4544,0,137),
		["up"] = "corner_M4544_2768",
		["down"] = "corner_M4544_M2768",
		["left"] = "corner_M5584_0",
		["right"] = nil,
	},
	["corner_M5584_0"] = {
		Vector = Vector(-5584,0,137),
		["up"] = "corner_M5584_3808",
		["down"] = "corner_M5584_M3808",
		["left"] = nil,
		["right"] = "corner_M4544_0",
	},
	["corner_5584_0"] = {
		Vector = Vector(5584,0,137),
		["up"] = "corner_5584_3808",
		["down"] = "corner_5584_M3808",
		["left"] = "corner_4544_0",
		["right"] = nil,
	},
	["corner_4544_0"] = {
		Vector = Vector(4544,0,137),
		["up"] = "corner_4544_2768",
		["down"] = "corner_4544_M2768",
		["left"] = nil,
		["right"] = "corner_5584_0",
	},
	["corner_0_2768"] = {
		Vector = Vector(0,2768,137),
		["up"] = "corner_0_3808",
		["down"] = nil,
		["left"] = "corner_M2771_2768",
		["right"] = "corner_2771_2768",
	},
	["corner_0_M3808"] = {
		Vector = Vector(0,-3808,137),
		["up"] = "corner_0_M2768",
		["down"] = nil,
		["left"] = "corner_M5584_M3808",
		["right"] = "corner_5584_M3808",
	},
	["corner_4544_2768"] = {
		Vector = Vector(4544,2768,137),
		["up"] = nil,
		["down"] = "corner_4544_0",
		["left"] = "corner_2771_2768",
		["right"] = nil,
	},
	["corner_M5584_3808"] = {
		Vector = Vector(-5584,3808,137),
		["up"] = nil,
		["down"] = "corner_M5584_0",
		["left"] = nil,
		["right"] = "corner_0_3808",
	},
	["corner_5584_3808"] = {
		Vector = Vector(5584,3808,137),
		["up"] = nil,
		["down"] = "corner_5584_0",
		["left"] = "corner_0_3808",
		["right"] = nil,
	},
	["corner_2771_2768"] = {
		Vector = Vector(2771,2768,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = "corner_0_2768",
		["right"] = "corner_4544_2768",
	},
	["corner_M2771_M1056"] = {
		Vector = Vector(-2771,-1056,137),
		["up"] = nil,
		["down"] = "corner_M2771_M2768",
		["left"] = nil,
		["right"] = nil,
	},
	["corner_2771_M1056"] = {
		Vector = Vector(2771,-1056,137),
		["up"] = nil,
		["down"] = "corner_2771_M2768",
		["left"] = nil,
		["right"] = nil,
	},
	["corner_M2771_1056"] = {
		Vector = Vector(-2771,1056,137),
		["up"] = "corner_M2771_2768",
		["down"] = nil,
		["left"] = nil,
		["right"] = nil,
	},
	["corner_1408_M1056"] = {
		Vector = Vector(1408,-1056,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = nil,
		["right"] = "corner_2771_M1056",
	},
	["corner_M1408_M1056"] = {
		Vector = Vector(-1408,-1056,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = "corner_M2771_M1056",
		["right"] = nil,
	},
	["corner_M1408_1056"] = {
		Vector = Vector(-1408,1056,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = "corner_M2771_1056",
		["right"] = nil,
	},
	["corner_1408_1056"] = {
		Vector = Vector(1408,1056,137),
		["up"] = nil,
		["down"] = nil,
		["left"] = nil,
		["right"] = "corner_2771_1056",
	},
	["corner_M4544_2768"] = {
		Vector = Vector(-4544,2768,137),
		["up"] = nil,
		["down"] = "corner_M4544_0",
		["left"] = nil,
		["right"] = "corner_M2771_2768",
	},
}