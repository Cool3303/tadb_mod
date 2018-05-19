
if not IsInToolsMode() then return end

function _CopyConfig()
	local basePath = "../../../content/dota_addons/touhoutd/panorama/scripts/custom_game/copy_from_lua_config.js"
	local script_text = [[
GameUI.GetTowerNameList = function () {
	return TowerNameList;
}
GameUI.GetQuestTable = function () {
	return QuestTable;
}
]]
	script_text = script_text .. "\n\n"

	-- 物品表
	local str = json.encode(towerNameList)
	script_text = script_text .. "\n\nvar TowerNameList = \n" .. str .. "\n\n"

	-- 任务表
	local str = json.encode(QuestTable)
	script_text = script_text .. "\n\nvar QuestTable = \n" .. str .. "\n\n"

	out = io.open(basePath,"w")
	if out then
		out:write(script_text)
		out:close()
	end
end