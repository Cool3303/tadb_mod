
-- [Subquests] 击杀目标
local kill = function ( szUnitName, iMaxCount )
	return {
		Type = "Kill",
		UnitName = szUnitName,
		MaxCount = iMaxCount,
	}
end

-- [Subquests] 查找目标
local findUnit = function ( szUnitName )
	return {
		Type = "FindUnit",
		UnitName = szUnitName,
	}
end

-- [Subquests] 获取物品
local findItem = function ( szItemName, iMaxCount )
	return {
		Type = "FindItem",
		ItemName = szItemName,
		MaxCount = iMaxCount,
	}
end

-- [Subquests] 自定义
local customTarget = function ( event, o )
	local t = { Type = event }
	if o then
		for k,v in pairs(o) do
			if k ~= "Type" and k ~= "Event" then
				t[k] = v
			end
		end
	end
	return t
end

-- [Subquests] 收集卡牌
local collectTower = function ( szItemName )
	return {
		Type = "CollectTower",
		ItemName = szItemName,
	}
end

-- [Rewards] 金币奖励
local gold = function ( amount )
	return {"gold", amount}
end

-- [Rewards] 物品奖励
local item = function ( itemname )
	return {"item", itemname}
end

-- [Rewards] 概率奖励
local chance = function ( c, o )
	return {c, o}
end

-- [Rewards] 阴阳玉奖励
local yinyangyu = function ( amount )
	return {"yinyangyu", amount}
end

QuestTable =
{
	-- ["xxxx"] =
	-- {
	-- 	Sorts = "Normal",  -- 正常任务
	-- 	Sorts = "Main",    -- 主线任务
	-- 	Sorts = "Daily",   -- 日常任务
	-- 	Sorts = "Week",    -- 周常任务
	-- 	Sorts = "Month",   -- 每月任务
	-- 	Sorts = "Event",   -- 活动任务

	-- 	-- 是否可以重复
	-- 	Repeat = false,

	-- 	-- 自动完成
	-- 	AutoComplete = false,

	-- 	-- 目标
	-- 	Subquests =
	-- 	{
	-- 		kill("xxx", 1),
	-- 		findUnit("xxx"),
	-- 		findItem("xxx", 1),
	-- 		customTarget("xxxx", {Name="abc"})
	-- 	},

	-- 	-- 接受任务奖励
	-- 	AcceptedRewards =
	-- 	{
	-- 		[1]=
	-- 		{
	-- 			gold(100),
	-- 		},
	-- 		[2]=
	-- 		{
	-- 			"Random",
	-- 			gold(100),
	-- 			item("item_0001"),
	-- 		},
	-- 		[3]=
	-- 		{
	-- 			"Chance", 2,
	-- 			chance(20, item("item_0005")),
	-- 			chance(50, item("item_0006")),
	-- 		}
	-- 	},

	-- 	-- 完成任务奖励
	-- 	CompletedRewards =
	-- 	{
	-- 		[1]=
	-- 		{
	-- 			gold(100)
	-- 		},
	-- 	},
	-- },

	-- 通关50波：送100阴阳玉 
	-- ["quest_wave_clear_001"] =
	-- {
	-- 	Sorts = "Normal",
	-- 	Repeat = false,
	-- 	AutoComplete = true,

	-- 	Subquests =
	-- 	{
	-- 		customTarget("wave_clear", {Wave=50})
	-- 	},

	-- 	CompletedRewards =
	-- 	{
	-- 		[1]=
	-- 		{
	-- 			yinyangyu(100)
	-- 		},
	-- 	},
	-- },

	-- 通关无尽10波（仅一次）
	["quest_endless_wave_clear_001"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=10})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 通关无尽20波（仅一次）
	["quest_endless_wave_clear_002"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=15})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(200)
			},
		},
	},

	-- 通关无尽30波（仅一次）
	["quest_endless_wave_clear_003"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=20})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(300)
			},
		},
	},

	-- 通关无尽40波（仅一次）
	["quest_endless_wave_clear_004"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=25})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(400)
			},
		},
	},

	-- 通关无尽50波（仅一次）
	["quest_endless_wave_clear_005"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=30})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(500)
			},
		},
	},

	-- 通关无尽60波（仅一次）
	["quest_endless_wave_clear_006"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=35})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(600)
			},
		},
	},

	-- 通关无尽70波（仅一次）
	["quest_endless_wave_clear_007"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=40})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(700)
			},
		},
	},

	-- 通关无尽80波（仅一次）
	["quest_endless_wave_clear_008"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=50})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(800)
			},
		},
	},

	-- 通关无尽90波（仅一次）
	["quest_endless_wave_clear_009"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("endless_wave_clear", {Wave=60})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(900)
			},
		},
	},

	-- 通关难度1
	["quest_finished_game_001"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("finished_game", {Difficulty=1})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 通关难度2
	["quest_finished_game_002"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("finished_game", {Difficulty=2})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(200)
			},
		},
	},

	-- 通关难度3
	["quest_finished_game_003"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("finished_game", {Difficulty=3})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(300)
			},
		},
	},

	-- 通关难度4
	["quest_finished_game_004"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			customTarget("finished_game", {Difficulty=4})
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(400)
			},
		},
	},

	-- 集齐八云紫，八云蓝，橙
	["quest_collect_tower_001"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0036"),
			collectTower("item_0037"),
			collectTower("item_0038"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐八意永琳，蓬莱山辉夜，藤原妹红
	["quest_collect_tower_002"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0039"),
			collectTower("item_0040"),
			collectTower("item_0041"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐射命丸文，姬海棠果，犬走椛
	["quest_collect_tower_003"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0042"),
			collectTower("item_0043"),
			collectTower("item_0044"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐八坂神奈子，洩矢诹访子，东风谷早苗
	["quest_collect_tower_004"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0046"),
			collectTower("item_0047"),
			collectTower("item_0048"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐秋静叶，秋穰子
	["quest_collect_tower_005"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0088"),
			collectTower("item_0003"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐蕾米莉亚·斯卡雷特，芙兰朵露·斯卡雷特
	["quest_collect_tower_006"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0030"),
			collectTower("item_0032"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐十六夜咲夜，红美铃
	["quest_collect_tower_007"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0022"),
			collectTower("item_0034"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐帕秋莉·诺雷姬，小恶魔
	["quest_collect_tower_008"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0021"),
			collectTower("item_0033"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐封兽鵺，村纱水蜜
	["quest_collect_tower_009"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0049"),
			collectTower("item_0050"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 集齐寅丸星，纳兹琳
	["quest_collect_tower_010"] =
	{
		Sorts = "Normal",
		Repeat = false,
		AutoComplete = true,

		Subquests =
		{
			collectTower("item_0002"),
			collectTower("item_0069"),
		},

		CompletedRewards =
		{
			[1]=
			{
				yinyangyu(100)
			},
		},
	},

	-- 无尽怪奖励 50+守无尽怪数量/100*(1 + (难度-1) *0.5)
	["quest_infinite_reward"] =
	{
		Sorts = "Normal",
		Repeat = true,
		AutoComplete = true,

		Subquests =
		{
		},

		CompletedRewards =
		{
		},
	},


}