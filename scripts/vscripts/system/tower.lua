THTD_MAX_LEVEL = 10
THTD_MAX_STAR = 5

thtd_exp_table={200,500,900,1400,2000,2700,3500,4400,5400}
thtd_exp_star_table={1,2/3,1/3,1/5,1/15}

-- 总和5400
-- 经验分配规则 保底 1X每只30点 2X每只20点，3X每只10点，4X每只6点，5X每只3点
-- 单吃一个兵经验 300点 200点 100点 60点 30点
-- 经验获取率1X 100% 2X 2/3 3X 1/3 4X 1/5 5X 1/10 
-- 素材培养 （1000+素材卡牌经验/5）* 星级


towerNameList = {
	["item_1003"]={["kind"]="BonusEgg",["quality"]=1}, -- 一星福蛋
	["item_1004"]={["kind"]="BonusEgg",["quality"]=2}, -- 二星福蛋
	["item_1005"]={["kind"]="BonusEgg",["quality"]=3}, -- 三星福蛋
	["item_1006"]={["kind"]="BonusEgg",["quality"]=4}, -- 四星福蛋
	["item_1011"]={["kind"]="BonusEgg",["quality"]=1}, -- 一星僵尸
	["item_1012"]={["kind"]="BonusEgg",["quality"]=2}, -- 二星僵尸
	["item_1013"]={["kind"]="BonusEgg",["quality"]=3}, -- 三星僵尸
	["item_1014"]={["kind"]="BonusEgg",["quality"]=4}, -- 四星僵尸
	["item_0001"]={["kind"]="lily",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=false}, -- 莉莉白
	["item_0002"]={["kind"]="nazrin",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 娜兹玲
	["item_0003"]={["kind"]="minoriko",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 秋穣子
	["item_0004"]={["kind"]="mugiyousei",["quality"]=1,["hasPortrait"]=false,["hasVoice"]=false}, -- 墓地妖精
	["item_0005"]={["kind"]="shanghainingyou",["quality"]=1,["hasPortrait"]=false,["hasVoice"]=false}, -- 上海人形
	["item_0006"]={["kind"]="hourainingyou",["quality"]=1,["hasPortrait"]=false,["hasVoice"]=false}, -- 蓬莱人形
	["item_0007"]={["kind"]="hanadayousei",["quality"]=1,["hasPortrait"]=false,["hasVoice"]=false}, -- 花田妖精
	["item_0008"]={["kind"]="maidyousei",["quality"]=1,["hasPortrait"]=false,["hasVoice"]=false}, -- 女仆妖精
	["item_0009"]={["kind"]="cirno",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=false}, -- 琪露诺
	["item_0010"]={["kind"]="kogasa",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 多多良小伞
	["item_0011"]={["kind"]="letty",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 蕾蒂
	["item_0012"]={["kind"]="lyrica",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 莉莉卡
	["item_0013"]={["kind"]="lunasa",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 露娜萨
	["item_0014"]={["kind"]="merlin",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 梅露兰
	["item_0015"]={["kind"]="rumia",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 露米娅
	["item_0016"]={["kind"]="satori",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 古明地觉
	["item_0017"]={["kind"]="iku",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=false}, -- 永江依玖
	["item_0018"]={["kind"]="mystia",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 米斯蒂娅
	["item_0019"]={["kind"]="marisa",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 魔理沙
	["item_0020"]={["kind"]="tenshi",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 比那名居天子
	["item_0021"]={["kind"]="patchouli",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 帕秋莉
	["item_0022"]={["kind"]="sakuya",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 十六夜咲夜
	["item_0023"]={["kind"]="reisen",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 铃仙
	["item_0024"]={["kind"]="yuyuko",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 西行寺幽幽子
	["item_0025"]={["kind"]="youmu",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 魂魄妖梦
	["item_0026"]={["kind"]="rin",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 火焰猫燐
	["item_0027"]={["kind"]="utsuho",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 灵乌路空
	["item_0028"]={["kind"]="reimu",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=true}, -- 博丽灵梦
	["item_0029"]={["kind"]="daiyousei",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=true}, -- 大妖精
	["item_0030"]={["kind"]="remilia",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=false}, -- 蕾米莉亚
	["item_0031"]={["kind"]="koishi",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=true}, -- 古明地恋
	["item_0032"]={["kind"]="flandre",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=false}, -- 芙兰朵露·斯卡雷特
	["item_0033"]={["kind"]="koakuma",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 小恶魔
	["item_0034"]={["kind"]="meirin",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=false}, -- 红美铃
	["item_0035"]={["kind"]="yuuka",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=true}, -- 风见幽香
	["item_0036"]={["kind"]="yukari",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=false}, -- 八云紫
	["item_0037"]={["kind"]="ran",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 八云蓝
	["item_0038"]={["kind"]="chen",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=false}, -- 橙
	["item_0039"]={["kind"]="eirin",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=true}, -- 八意永琳
	["item_0040"]={["kind"]="mokou",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 藤原妹红
	["item_0041"]={["kind"]="kaguya",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 蓬莱山辉夜
	["item_0042"]={["kind"]="aya",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 射命丸文
	["item_0043"]={["kind"]="hatate",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 姬海棠羽立
	["item_0044"]={["kind"]="momiji",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 犬走椛
	["item_0046"]={["kind"]="sanae",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 东风谷早苗
	["item_0047"]={["kind"]="kanako",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=true}, -- 八坂神奈子
	["item_0048"]={["kind"]="suwako",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 泄矢诹访子
	["item_0049"]={["kind"]="minamitsu",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 村纱水蜜
	["item_0050"]={["kind"]="nue",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 封兽鵺
	["item_0051"]={["kind"]="byakuren",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=false}, -- 圣白莲
	["item_0052"]={["kind"]="miko",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=true}, -- 丰聪耳神子
	--["item_0053"]={["kind"]="kokoro",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 秦心
	--["item_0056"]={["kind"]="star",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 斯塔·萨菲雅
	--["item_0057"]={["kind"]="sunny",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 桑妮·米尔克
	--["item_0058"]={["kind"]="luna",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 露娜·切露德
	["item_0061"]={["kind"]="keine",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 上白泽慧音
	--["item_0065"]={["kind"]="sumireko",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 宇佐见堇子
	["item_0069"]={["kind"]="toramaru",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=false}, -- 寅丸星
	--["item_0070"]={["kind"]="mamizou",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=false}, -- 二岩猯藏
	--["item_0079"]={["kind"]="mima",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 魅魔
	["item_0080"]={["kind"]="shinki",["quality"]=4,["hasPortrait"]=true,["hasVoice"]=false}, -- 神绮
	--["item_0083"]={["kind"]="elly",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 艾丽
	["item_0088"]={["kind"]="sizuha",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 秋静叶
	--["item_0092"]={["kind"]="medicine",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=true}, -- 梅蒂欣·梅兰可莉
	["item_0094"]={["kind"]="soga",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=true}, -- 苏我屠自古
	["item_0095"]={["kind"]="futo",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 物部布都
	["item_0096"]={["kind"]="seiga",["quality"]=3,["hasPortrait"]=true,["hasVoice"]=false}, -- 霍青娥
	["item_0097"]={["kind"]="yoshika",["quality"]=2,["hasPortrait"]=true,["hasVoice"]=false}, -- 宫古芳香

	["item_2001"]={["kind"]="item_2001",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2002"]={["kind"]="item_2002",["quality"]=4,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2003"]={["kind"]="item_2003",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2004"]={["kind"]="item_2004",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2005"]={["kind"]="item_2005",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2006"]={["kind"]="item_2006",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2007"]={["kind"]="item_2007",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2008"]={["kind"]="item_2008",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2009"]={["kind"]="item_2009",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2010"]={["kind"]="item_2010",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2011"]={["kind"]="item_2011",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2012"]={["kind"]="item_2012",["quality"]=4,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2013"]={["kind"]="item_2013",["quality"]=4,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2014"]={["kind"]="item_2014",["quality"]=4,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2015"]={["kind"]="item_2015",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2016"]={["kind"]="item_2016",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2017"]={["kind"]="item_2017",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2018"]={["kind"]="item_2018",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2019"]={["kind"]="item_2019",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2020"]={["kind"]="item_2020",["quality"]=4,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2021"]={["kind"]="item_2021",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2022"]={["kind"]="item_2022",["quality"]=2,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2023"]={["kind"]="item_2023",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2024"]={["kind"]="item_2024",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2025"]={["kind"]="item_2025",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
	["item_2026"]={["kind"]="item_2026",["quality"]=3,["hasPortrait"]=false,["hasVoice"]=false},
}

towerPlayerList = {
	[1] = {
	},
	[2] = {
	},
	[3] = {
	},
	[4] = {	
	},
}

-- 这个表是每颗星增加多少属性
-- 前一位数据代表基础属性，后一位数据代表成长属性

thtd_power_table = 
{
	["lily"] = {
		[1] = {50,10},
		[2] = {150,10},
		[3] = {400,10},
		[4] = {1100,10},
		[5] = {4000,10},
	},
	["nazrin"] = {
		[1] = {20,2},
		[2] = {80,4},
		[3] = {200,8},
		[4] = {450,10},
		[5] = {2000,15},
	},
	["mugiyousei"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["shanghainingyou"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["hourainingyou"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["hanadayousei"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["maidyousei"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["cirno"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["kogasa"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["letty"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["lyrica"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["lunasa"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["merlin"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["rumia"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["satori"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["iku"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["mystia"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["marisa"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["tenshi"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["patchouli"] = {
		[1] = {30,3.0},
		[2] = {100,5.0},
		[3] = {250,6.5},
		[4] = {600,8.0},
		[5] = {2500,15},
	},
	["reisen"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["yuyuko"] = {
		[1] = {40,5.0},
		[2] = {100,6.5},
		[3] = {260,8.0},
		[4] = {560,10.0},
		[5] = {2500,15.0},
	},
	["youmu"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["rin"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["utsuho"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["reimu"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["daiyousei"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["cirno_ex"] = 
	{
		[1] = {30,3.0},
		[2] = {110,5.0},
		[3] = {300,7.5},
		[4] = {600,10.0},
		[5] = {2400,30.0},
	},
	["remilia"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["flandre"] = {
		[1] = {28,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["sakuya"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["koishi"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["koakuma"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["meirin"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["yuuka"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["yukari"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["ran"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["chen"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["eirin"] = {
		[1] = {35,4.0},
		[2] = {130,6},
		[3] = {300,8},
		[4] = {600,10},
		[5] = {2600,20.0},
	},
	["mokou"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["kaguya"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["aya"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["hatate"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["momiji"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["sanae"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["kanako"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["suwako"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["minamitsu"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["nue"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["rumia_ex"] = 
	{
		[1] = {30,3.0},
		[2] = {110,5.0},
		[3] = {300,7.5},
		[4] = {600,10.0},
		[5] = {2400,30.0},
	},
	["toramaru"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["shinki"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["byakuren"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["soga"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["miko"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["futo"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["yoshika"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["seiga"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["keine"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
}

-- 这个表是每颗星增加多少攻击
-- 前一位数据代表基础攻击，后一位数据代表成长攻击

thtd_attack_table = 
{
	["lily"] = {
		[1] = {0,0},
		[2] = {0,0},
		[3] = {0,0},
		[4] = {0,0},
		[5] = {0,0},
	},
	["nazrin"] = {
		[1] = {10,1},
		[2] = {40,2},
		[3] = {100,4},
		[4] = {200,5},
		[5] = {500,6},
	},
	["mugiyousei"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["shanghainingyou"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["hourainingyou"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["hanadayousei"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["maidyousei"] = {
		[1] = {10,2},
		[2] = {55,3},
		[3] = {145,4},
		[4] = {350,6.5},
		[5] = {1400,26},
	},
	["cirno"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["kogasa"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["letty"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["lyrica"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["lunasa"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["merlin"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["rumia"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["satori"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["iku"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["mystia"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["marisa"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["marisa"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["tenshi"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["patchouli"] = {
		[1] = {10,1.0},
		[2] = {50,1.0},
		[3] = {100,1.0},
		[4] = {150,1.0},
		[5] = {500,1.0},
	},
	["reisen"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["yuyuko"] = {
		[1] = {1,1.0},
		[2] = {1,1.0},
		[3] = {1,1.0},
		[4] = {1,1.0},
		[5] = {1,1.0},
	},
	["youmu"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["rin"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["utsuho"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["reimu"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["daiyousei"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["cirno_ex"] = 
	{
		[1] = {30,3.0},
		[2] = {110,5.0},
		[3] = {300,7.5},
		[4] = {600,10.0},
		[5] = {2400,30.0},
	},
	["remilia"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["flandre"] = {
		[1] = {28,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["sakuya"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["koishi"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["koakuma"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["meirin"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["yuuka"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["yukari"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["ran"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["chen"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["eirin"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["mokou"] = {
		[1] = {30,2.5},
		[2] = {105,4.0},
		[3] = {230,5},
		[4] = {450,7.0},
		[5] = {2300,12},
	},
	["kaguya"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["aya"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["hatate"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["momiji"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["sanae"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["kanako"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["suwako"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["minamitsu"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["nue"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["rumia_ex"] = 
	{
		[1] = {30,3.0},
		[2] = {110,5.0},
		[3] = {300,7.5},
		[4] = {600,10.0},
		[5] = {2400,30.0},
	},
	["toramaru"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["shinki"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["byakuren"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["soga"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["miko"] = {
		[1] = {25,3.0},
		[2] = {85,4.5},
		[3] = {220,5},
		[4] = {450,7.5},
		[5] = {2200,15.0},
	},
	["futo"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["yoshika"] = {
		[1] = {15,2},
		[2] = {60,3.5},
		[3] = {160,5},
		[4] = {375,6.5},
		[5] = {1800,10},
	},
	["seiga"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
	["keine"] = {
		[1] = {20,2.5},
		[2] = {75,4.0},
		[3] = {190,5},
		[4] = {400,7.0},
		[5] = {2000,12},
	},
}

-- 这个表是用于解封技能
thtd_ability_table = 
{
	["lily"] = {
		[1] = {["thtd_lily_01"] = 1,["thtd_lily_02"] = 0,["ogre_magi_multicast"] = 0},
		[2] = {["thtd_lily_01"] = 1,["thtd_lily_02"] = 0,["ogre_magi_multicast"] = 0},
		[3] = {["thtd_lily_01"] = 1,["thtd_lily_02"] = 0,["ogre_magi_multicast"] = 1},
		[4] = {["thtd_lily_01"] = 1,["thtd_lily_02"] = 1,["ogre_magi_multicast"] = 2},
		[5] = {["thtd_lily_01"] = 1,["thtd_lily_02"] = 1,["ogre_magi_multicast"] = 3},
	},
	["nazrin"] = {
		[1] = {["thtd_nazrin_01"] = 1,["thtd_nazrin_02"] = 0},
		[2] = {["thtd_nazrin_01"] = 1,["thtd_nazrin_02"] = 0},
		[3] = {["thtd_nazrin_01"] = 1,["thtd_nazrin_02"] = 1},
		[4] = {["thtd_nazrin_01"] = 1,["thtd_nazrin_02"] = 1},
		[5] = {["thtd_nazrin_01"] = 1,["thtd_nazrin_02"] = 1},
	},
	["minoriko"] = {
		[1] = {["thtd_minoriko_01"] = 1,["thtd_minoriko_02"] = 0},
		[2] = {["thtd_minoriko_01"] = 1,["thtd_minoriko_02"] = 1},
		[3] = {["thtd_minoriko_01"] = 1,["thtd_minoriko_02"] = 1},
		[4] = {["thtd_minoriko_01"] = 1,["thtd_minoriko_02"] = 1},
		[5] = {["thtd_minoriko_01"] = 1,["thtd_minoriko_02"] = 1},
	},
	["mugiyousei"] = {
		[1] = {["thtd_mugiyousei_01"] = 1},
		[2] = {["thtd_mugiyousei_01"] = 1},
		[3] = {["thtd_mugiyousei_01"] = 1},
		[4] = {["thtd_mugiyousei_01"] = 1},
		[5] = {["thtd_mugiyousei_01"] = 1},
	},
	["shanghainingyou"] = {
		[1] = {["thtd_shanghainingyou_01"] = 1},
		[2] = {["thtd_shanghainingyou_01"] = 1},
		[3] = {["thtd_shanghainingyou_01"] = 1},
		[4] = {["thtd_shanghainingyou_01"] = 1},
		[5] = {["thtd_shanghainingyou_01"] = 1},
	},
	["hourainingyou"] = {
		[1] = {["thtd_hourainingyou_01"] = 1},
		[2] = {["thtd_hourainingyou_01"] = 1},
		[3] = {["thtd_hourainingyou_01"] = 1},
		[4] = {["thtd_hourainingyou_01"] = 1},
		[5] = {["thtd_hourainingyou_01"] = 1},
	},
	["hanadayousei"] = {
		[1] = {["thtd_hanadayousei_01"] = 1},
		[2] = {["thtd_hanadayousei_01"] = 1},
		[3] = {["thtd_hanadayousei_01"] = 1},
		[4] = {["thtd_hanadayousei_01"] = 1},
		[5] = {["thtd_hanadayousei_01"] = 1},
	},
	["maidyousei"] = {
		[1] = {["luna_moon_glaive"] = 1},
		[2] = {["luna_moon_glaive"] = 1},
		[3] = {["luna_moon_glaive"] = 1},
		[4] = {["luna_moon_glaive"] = 1},
		[5] = {["luna_moon_glaive"] = 1},
	},
	["cirno"] = {
		[1] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 0,["thtd_cirno_03"] = 0,["thtd_cirno_04"] = 0},
		[2] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 0,["thtd_cirno_03"] = 0,["thtd_cirno_04"] = 0},
		[3] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 0,["thtd_cirno_03"] = 0,["thtd_cirno_04"] = 0},
		[4] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 1,["thtd_cirno_03"] = 0,["thtd_cirno_04"] = 0},
		[5] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 1,["thtd_cirno_03"] = 0,["thtd_cirno_04"] = 0},
	},
	["cirno_ex"] = 
	{
		[1] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 0,["thtd_cirno_03"] = 0,["thtd_cirno_04"] = 0},
		[2] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 0,["thtd_cirno_03"] = 0,["thtd_cirno_04"] = 0},
		[3] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 0,["thtd_cirno_03"] = 1,["thtd_cirno_04"] = 0},
		[4] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 1,["thtd_cirno_03"] = 1,["thtd_cirno_04"] = 0},
		[5] = {["thtd_cirno_01"] = 1,["thtd_cirno_02"] = 1,["thtd_cirno_03"] = 1,["thtd_cirno_04"] = 1},
	},
	["letty"] = {
		[1] = {["thtd_letty_01"] = 1,["thtd_letty_02"] = 0},
		[2] = {["thtd_letty_01"] = 1,["thtd_letty_02"] = 0},
		[3] = {["thtd_letty_01"] = 1,["thtd_letty_02"] = 1},
		[4] = {["thtd_letty_01"] = 1,["thtd_letty_02"] = 2},
		[5] = {["thtd_letty_01"] = 1,["thtd_letty_02"] = 3},
	},
	["kogasa"] = {
		[1] = {["thtd_kogasa_01"] = 1,["thtd_kogasa_02"] = 0},
		[2] = {["thtd_kogasa_01"] = 1,["thtd_kogasa_02"] = 0},
		[3] = {["thtd_kogasa_01"] = 1,["thtd_kogasa_02"] = 1},
		[4] = {["thtd_kogasa_01"] = 1,["thtd_kogasa_02"] = 2},
		[5] = {["thtd_kogasa_01"] = 1,["thtd_kogasa_02"] = 3},
	},
	["lyrica"] = {
		[1] = {["thtd_lyrica_01"] = 1,["thtd_lyrica_02"] = 0},
		[2] = {["thtd_lyrica_01"] = 1,["thtd_lyrica_02"] = 0},
		[3] = {["thtd_lyrica_01"] = 1,["thtd_lyrica_02"] = 1},
		[4] = {["thtd_lyrica_01"] = 1,["thtd_lyrica_02"] = 1},
		[5] = {["thtd_lyrica_01"] = 1,["thtd_lyrica_02"] = 1},
	},
	["lunasa"] = {
		[1] = {["thtd_lunasa_01"] = 1,["thtd_lunasa_02"] = 0},
		[2] = {["thtd_lunasa_01"] = 1,["thtd_lunasa_02"] = 0},
		[3] = {["thtd_lunasa_01"] = 1,["thtd_lunasa_02"] = 1},
		[4] = {["thtd_lunasa_01"] = 1,["thtd_lunasa_02"] = 1},
		[5] = {["thtd_lunasa_01"] = 1,["thtd_lunasa_02"] = 1},
	},
	["merlin"] = {
		[1] = {["thtd_merlin_01"] = 1,["thtd_merlin_02"] = 0},
		[2] = {["thtd_merlin_01"] = 2,["thtd_merlin_02"] = 0},
		[3] = {["thtd_merlin_01"] = 3,["thtd_merlin_02"] = 1},
		[4] = {["thtd_merlin_01"] = 4,["thtd_merlin_02"] = 1},
		[5] = {["thtd_merlin_01"] = 5,["thtd_merlin_02"] = 1},
	},
	["rumia"] = {
		[1] = {["thtd_rumia_01"] = 1,["thtd_rumia_02"] = 0,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
		[2] = {["thtd_rumia_01"] = 2,["thtd_rumia_02"] = 0,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
		[3] = {["thtd_rumia_01"] = 3,["thtd_rumia_02"] = 1,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
		[4] = {["thtd_rumia_01"] = 4,["thtd_rumia_02"] = 1,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
		[5] = {["thtd_rumia_01"] = 5,["thtd_rumia_02"] = 1,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
	},
	["satori"] = {
		[1] = {["thtd_satori_01"] = 1,["thtd_satori_02"] = 0},
		[2] = {["thtd_satori_01"] = 2,["thtd_satori_02"] = 0},
		[3] = {["thtd_satori_01"] = 3,["thtd_satori_02"] = 0},
		[4] = {["thtd_satori_01"] = 4,["thtd_satori_02"] = 1},
		[5] = {["thtd_satori_01"] = 5,["thtd_satori_02"] = 1},
	},
	["iku"] = {
		[1] = {["thtd_iku_01"] = 1,["thtd_iku_02"] = 0},
		[2] = {["thtd_iku_01"] = 2,["thtd_iku_02"] = 0},
		[3] = {["thtd_iku_01"] = 3,["thtd_iku_02"] = 0},
		[4] = {["thtd_iku_01"] = 4,["thtd_iku_02"] = 1},
		[5] = {["thtd_iku_01"] = 5,["thtd_iku_02"] = 1},
	},
	["mystia"] = {
		[1] = {["thtd_mystia_01"] = 1,["thtd_mystia_02"] = 0},
		[2] = {["thtd_mystia_01"] = 2,["thtd_mystia_02"] = 0},
		[3] = {["thtd_mystia_01"] = 3,["thtd_mystia_02"] = 1},
		[4] = {["thtd_mystia_01"] = 4,["thtd_mystia_02"] = 2},
		[5] = {["thtd_mystia_01"] = 5,["thtd_mystia_02"] = 3},
	},
	["marisa"] = {
		[1] = {["thtd_marisa_01"] = 1,["thtd_marisa_02"] = 1,["thtd_marisa_03"] = 0},
		[2] = {["thtd_marisa_01"] = 1,["thtd_marisa_02"] = 1,["thtd_marisa_03"] = 0},
		[3] = {["thtd_marisa_01"] = 1,["thtd_marisa_02"] = 1,["thtd_marisa_03"] = 0},
		[4] = {["thtd_marisa_01"] = 1,["thtd_marisa_02"] = 1,["thtd_marisa_03"] = 1},
		[5] = {["thtd_marisa_01"] = 1,["thtd_marisa_02"] = 1,["thtd_marisa_03"] = 1},
	},
	["tenshi"] = {
		[1] = {["thtd_tenshi_01"] = 1,["thtd_tenshi_02"] = 1,["thtd_tenshi_03"] = 0},
		[2] = {["thtd_tenshi_01"] = 1,["thtd_tenshi_02"] = 1,["thtd_tenshi_03"] = 0},
		[3] = {["thtd_tenshi_01"] = 1,["thtd_tenshi_02"] = 1,["thtd_tenshi_03"] = 0},
		[4] = {["thtd_tenshi_01"] = 1,["thtd_tenshi_02"] = 1,["thtd_tenshi_03"] = 1},
		[5] = {["thtd_tenshi_01"] = 1,["thtd_tenshi_02"] = 1,["thtd_tenshi_03"] = 1},
	},
	["patchouli"] = {
		[1] = {["thtd_patchouli_01"] = 1,["thtd_patchouli_02"] = 1,["thtd_patchouli_03"] = 0},
		[2] = {["thtd_patchouli_01"] = 2,["thtd_patchouli_02"] = 1,["thtd_patchouli_03"] = 0},
		[3] = {["thtd_patchouli_01"] = 3,["thtd_patchouli_02"] = 1,["thtd_patchouli_03"] = 1},
		[4] = {["thtd_patchouli_01"] = 4,["thtd_patchouli_02"] = 1,["thtd_patchouli_03"] = 1},
		[5] = {["thtd_patchouli_01"] = 5,["thtd_patchouli_02"] = 1,["thtd_patchouli_03"] = 1},
	},
	["reisen"] = {
		[1] = {["thtd_reisen_01"] = 1,["thtd_reisen_02"] = 1,["thtd_reisen_03"] = 0},
		[2] = {["thtd_reisen_01"] = 2,["thtd_reisen_02"] = 1,["thtd_reisen_03"] = 0},
		[3] = {["thtd_reisen_01"] = 3,["thtd_reisen_02"] = 1,["thtd_reisen_03"] = 0},
		[4] = {["thtd_reisen_01"] = 4,["thtd_reisen_02"] = 1,["thtd_reisen_03"] = 1},
		[5] = {["thtd_reisen_01"] = 5,["thtd_reisen_02"] = 1,["thtd_reisen_03"] = 1},
	},
	["yuyuko"] = {
		[1] = {["thtd_yuyuko_01"] = 1,["thtd_yuyuko_02"] = 1,["thtd_yuyuko_03"] = 0},
		[2] = {["thtd_yuyuko_01"] = 2,["thtd_yuyuko_02"] = 1,["thtd_yuyuko_03"] = 0},
		[3] = {["thtd_yuyuko_01"] = 3,["thtd_yuyuko_02"] = 1,["thtd_yuyuko_03"] = 0},
		[4] = {["thtd_yuyuko_01"] = 4,["thtd_yuyuko_02"] = 1,["thtd_yuyuko_03"] = 1},
		[5] = {["thtd_yuyuko_01"] = 5,["thtd_yuyuko_02"] = 1,["thtd_yuyuko_03"] = 1},
	},
	["youmu"] = {
		[1] = {["thtd_youmu_01"] = 1,["thtd_youmu_02"] = 1,["thtd_youmu_03"] = 0},
		[2] = {["thtd_youmu_01"] = 1,["thtd_youmu_02"] = 1,["thtd_youmu_03"] = 0},
		[3] = {["thtd_youmu_01"] = 1,["thtd_youmu_02"] = 1,["thtd_youmu_03"] = 0},
		[4] = {["thtd_youmu_01"] = 1,["thtd_youmu_02"] = 1,["thtd_youmu_03"] = 1},
		[5] = {["thtd_youmu_01"] = 1,["thtd_youmu_02"] = 1,["thtd_youmu_03"] = 1},
	},
	["rin"] = {
		[1] = {["thtd_rin_01"] = 1,["thtd_rin_02"] = 0,},
		[2] = {["thtd_rin_01"] = 1,["thtd_rin_02"] = 0,},
		[3] = {["thtd_rin_01"] = 1,["thtd_rin_02"] = 1,},
		[4] = {["thtd_rin_01"] = 1,["thtd_rin_02"] = 1,},
		[5] = {["thtd_rin_01"] = 1,["thtd_rin_02"] = 1,},
	},
	["utsuho"] = {
		[1] = {["thtd_utsuho_01"] = 1,["thtd_utsuho_02"] = 1,["thtd_utsuho_03"] = 0,},
		[2] = {["thtd_utsuho_01"] = 1,["thtd_utsuho_02"] = 1,["thtd_utsuho_03"] = 0,},
		[3] = {["thtd_utsuho_01"] = 1,["thtd_utsuho_02"] = 1,["thtd_utsuho_03"] = 0,},
		[4] = {["thtd_utsuho_01"] = 1,["thtd_utsuho_02"] = 1,["thtd_utsuho_03"] = 1,},
		[5] = {["thtd_utsuho_01"] = 1,["thtd_utsuho_02"] = 1,["thtd_utsuho_03"] = 1,},
	},
	["reimu"] = {
		[1] = {["thtd_reimu_01"] = 1,["thtd_reimu_02"] = 1,["thtd_reimu_03"] = 0,["thtd_reimu_04"] = 0},
		[2] = {["thtd_reimu_01"] = 1,["thtd_reimu_02"] = 1,["thtd_reimu_03"] = 0,["thtd_reimu_04"] = 0},
		[3] = {["thtd_reimu_01"] = 1,["thtd_reimu_02"] = 1,["thtd_reimu_03"] = 1,["thtd_reimu_04"] = 0},
		[4] = {["thtd_reimu_01"] = 1,["thtd_reimu_02"] = 1,["thtd_reimu_03"] = 1,["thtd_reimu_04"] = 0},
		[5] = {["thtd_reimu_01"] = 1,["thtd_reimu_02"] = 1,["thtd_reimu_03"] = 1,["thtd_reimu_04"] = 1},
	},
	["daiyousei"] = {
		[1] = {["thtd_daiyousei_01"] = 1,["thtd_daiyousei_02"] = 1,["thtd_daiyousei_03"] = 0,["thtd_daiyousei_04"] = 0},
		[2] = {["thtd_daiyousei_01"] = 1,["thtd_daiyousei_02"] = 1,["thtd_daiyousei_03"] = 0,["thtd_daiyousei_04"] = 0},
		[3] = {["thtd_daiyousei_01"] = 1,["thtd_daiyousei_02"] = 1,["thtd_daiyousei_03"] = 1,["thtd_daiyousei_04"] = 0},
		[4] = {["thtd_daiyousei_01"] = 1,["thtd_daiyousei_02"] = 1,["thtd_daiyousei_03"] = 2,["thtd_daiyousei_04"] = 0},
		[5] = {["thtd_daiyousei_01"] = 1,["thtd_daiyousei_02"] = 1,["thtd_daiyousei_03"] = 3,["thtd_daiyousei_04"] = 1},
	},
	["remilia"] = 
	{
		[1] = {["thtd_remilia_01"] = 1,["thtd_remilia_02"] = 1,["thtd_remilia_03"] = 0,["thtd_remilia_04"] = 0},
		[2] = {["thtd_remilia_01"] = 1,["thtd_remilia_02"] = 1,["thtd_remilia_03"] = 0,["thtd_remilia_04"] = 0},
		[3] = {["thtd_remilia_01"] = 1,["thtd_remilia_02"] = 1,["thtd_remilia_03"] = 1,["thtd_remilia_04"] = 0},
		[4] = {["thtd_remilia_01"] = 1,["thtd_remilia_02"] = 1,["thtd_remilia_03"] = 1,["thtd_remilia_04"] = 0},
		[5] = {["thtd_remilia_01"] = 1,["thtd_remilia_02"] = 1,["thtd_remilia_03"] = 1,["thtd_remilia_04"] = 1},
	},
	["flandre"] = 
	{
		[1] = {["thtd_flandre_01"] = 1,["thtd_flandre_02"] = 1,["thtd_flandre_03"] = 0,["thtd_flandre_04"] = 0},
		[2] = {["thtd_flandre_01"] = 1,["thtd_flandre_02"] = 1,["thtd_flandre_03"] = 0,["thtd_flandre_04"] = 0},
		[3] = {["thtd_flandre_01"] = 1,["thtd_flandre_02"] = 1,["thtd_flandre_03"] = 1,["thtd_flandre_04"] = 0},
		[4] = {["thtd_flandre_01"] = 1,["thtd_flandre_02"] = 1,["thtd_flandre_03"] = 1,["thtd_flandre_04"] = 0},
		[5] = {["thtd_flandre_01"] = 1,["thtd_flandre_02"] = 1,["thtd_flandre_03"] = 1,["thtd_flandre_04"] = 1},
	},
	["sakuya"] = 
	{
		[1] = {["thtd_sakuya_01"] = 1,["thtd_sakuya_02"] = 0,["thtd_sakuya_03"] = 0},
		[2] = {["thtd_sakuya_01"] = 1,["thtd_sakuya_02"] = 0,["thtd_sakuya_03"] = 0},
		[3] = {["thtd_sakuya_01"] = 1,["thtd_sakuya_02"] = 1,["thtd_sakuya_03"] = 0},
		[4] = {["thtd_sakuya_01"] = 1,["thtd_sakuya_02"] = 1,["thtd_sakuya_03"] = 1},
		[5] = {["thtd_sakuya_01"] = 1,["thtd_sakuya_02"] = 1,["thtd_sakuya_03"] = 1},
	},
	["koishi"] = 
	{
		[1] = {["thtd_koishi_01"] = 1,["thtd_koishi_02"] = 1,["thtd_koishi_03"] = 0,["thtd_koishi_04"] = 0},
		[2] = {["thtd_koishi_01"] = 1,["thtd_koishi_02"] = 1,["thtd_koishi_03"] = 0,["thtd_koishi_04"] = 0},
		[3] = {["thtd_koishi_01"] = 1,["thtd_koishi_02"] = 1,["thtd_koishi_03"] = 1,["thtd_koishi_04"] = 0},
		[4] = {["thtd_koishi_01"] = 1,["thtd_koishi_02"] = 1,["thtd_koishi_03"] = 1,["thtd_koishi_04"] = 0},
		[5] = {["thtd_koishi_01"] = 1,["thtd_koishi_02"] = 1,["thtd_koishi_03"] = 1,["thtd_koishi_04"] = 1},
	},
	["koakuma"] = 
	{
		[1] = {["thtd_koakuma_01"] = 1,["thtd_koakuma_02"] = 0},
		[2] = {["thtd_koakuma_01"] = 1,["thtd_koakuma_02"] = 0},
		[3] = {["thtd_koakuma_01"] = 1,["thtd_koakuma_02"] = 1},
		[4] = {["thtd_koakuma_01"] = 1,["thtd_koakuma_02"] = 2},
		[5] = {["thtd_koakuma_01"] = 1,["thtd_koakuma_02"] = 3},
	},
	["meirin"] = 
	{
		[1] = {["thtd_meirin_01"] = 1,["thtd_meirin_02"] = 1},
		[2] = {["thtd_meirin_01"] = 1,["thtd_meirin_02"] = 1},
		[3] = {["thtd_meirin_01"] = 1,["thtd_meirin_02"] = 3},
		[4] = {["thtd_meirin_01"] = 1,["thtd_meirin_02"] = 3},
		[5] = {["thtd_meirin_01"] = 1,["thtd_meirin_02"] = 5},
	},
	["yuuka"] = 
	{
		[1] = {["thtd_yuuka_01"] = 1,["thtd_yuuka_02"] = 1,["thtd_yuuka_03"] = 0,["thtd_yuuka_04"] = 0},
		[2] = {["thtd_yuuka_01"] = 1,["thtd_yuuka_02"] = 1,["thtd_yuuka_03"] = 0,["thtd_yuuka_04"] = 0},
		[3] = {["thtd_yuuka_01"] = 1,["thtd_yuuka_02"] = 1,["thtd_yuuka_03"] = 1,["thtd_yuuka_04"] = 0},
		[4] = {["thtd_yuuka_01"] = 1,["thtd_yuuka_02"] = 1,["thtd_yuuka_03"] = 1,["thtd_yuuka_04"] = 0},
		[5] = {["thtd_yuuka_01"] = 1,["thtd_yuuka_02"] = 1,["thtd_yuuka_03"] = 1,["thtd_yuuka_04"] = 1},
	},
	["yukari"] = 
	{
		[1] = {["thtd_yukari_01"] = 1,["thtd_yukari_02"] = 1,["thtd_yukari_03"] = 0,["thtd_yukari_04"] = 0},
		[2] = {["thtd_yukari_01"] = 1,["thtd_yukari_02"] = 1,["thtd_yukari_03"] = 0,["thtd_yukari_04"] = 0},
		[3] = {["thtd_yukari_01"] = 1,["thtd_yukari_02"] = 1,["thtd_yukari_03"] = 1,["thtd_yukari_04"] = 0},
		[4] = {["thtd_yukari_01"] = 1,["thtd_yukari_02"] = 1,["thtd_yukari_03"] = 1,["thtd_yukari_04"] = 0},
		[5] = {["thtd_yukari_01"] = 1,["thtd_yukari_02"] = 1,["thtd_yukari_03"] = 1,["thtd_yukari_04"] = 1},
	},
	["ran"] = 
	{
		[1] = {["thtd_ran_01"] = 1,["thtd_ran_02"] = 1,["thtd_ran_03"] = 0},
		[2] = {["thtd_ran_01"] = 1,["thtd_ran_02"] = 2,["thtd_ran_03"] = 0},
		[3] = {["thtd_ran_01"] = 1,["thtd_ran_02"] = 3,["thtd_ran_03"] = 0},
		[4] = {["thtd_ran_01"] = 1,["thtd_ran_02"] = 4,["thtd_ran_03"] = 1},
		[5] = {["thtd_ran_01"] = 1,["thtd_ran_02"] = 5,["thtd_ran_03"] = 1},
	},
	["chen"] = 
	{
		[1] = {["thtd_chen_01"] = 1},
		[2] = {["thtd_chen_01"] = 2},
		[3] = {["thtd_chen_01"] = 3},
		[4] = {["thtd_chen_01"] = 4},
		[5] = {["thtd_chen_01"] = 5},
	},
	["eirin"] = 
	{
		[1] = {["thtd_eirin_01"] = 1,["thtd_eirin_02"] = 1,["thtd_eirin_03"] = 0,["thtd_eirin_04"] = 0},
		[2] = {["thtd_eirin_01"] = 1,["thtd_eirin_02"] = 1,["thtd_eirin_03"] = 0,["thtd_eirin_04"] = 0},
		[3] = {["thtd_eirin_01"] = 1,["thtd_eirin_02"] = 1,["thtd_eirin_03"] = 1,["thtd_eirin_04"] = 0},
		[4] = {["thtd_eirin_01"] = 1,["thtd_eirin_02"] = 1,["thtd_eirin_03"] = 1,["thtd_eirin_04"] = 0},
		[5] = {["thtd_eirin_01"] = 1,["thtd_eirin_02"] = 1,["thtd_eirin_03"] = 1,["thtd_eirin_04"] = 1},
	},
	["mokou"] = 
	{
		[1] = {["thtd_mokou_01"] = 1,["thtd_mokou_02"] = 1,["thtd_mokou_03"] = 0},
		[2] = {["thtd_mokou_01"] = 1,["thtd_mokou_02"] = 1,["thtd_mokou_03"] = 0},
		[3] = {["thtd_mokou_01"] = 1,["thtd_mokou_02"] = 1,["thtd_mokou_03"] = 0},
		[4] = {["thtd_mokou_01"] = 1,["thtd_mokou_02"] = 1,["thtd_mokou_03"] = 1},
		[5] = {["thtd_mokou_01"] = 1,["thtd_mokou_02"] = 1,["thtd_mokou_03"] = 1},
	},
	["kaguya"] = 
	{
		[1] = {["thtd_kaguya_01"] = 1,["thtd_kaguya_02"] = 1,["thtd_kaguya_03"] = 0},
		[2] = {["thtd_kaguya_01"] = 1,["thtd_kaguya_02"] = 2,["thtd_kaguya_03"] = 0},
		[3] = {["thtd_kaguya_01"] = 1,["thtd_kaguya_02"] = 3,["thtd_kaguya_03"] = 0},
		[4] = {["thtd_kaguya_01"] = 1,["thtd_kaguya_02"] = 4,["thtd_kaguya_03"] = 1},
		[5] = {["thtd_kaguya_01"] = 1,["thtd_kaguya_02"] = 5,["thtd_kaguya_03"] = 2},
	},

	["aya"] = 
	{
		[1] = {["thtd_aya_01"] = 1,["thtd_aya_02"] = 0,["thtd_aya_03"] = 0},
		[2] = {["thtd_aya_01"] = 1,["thtd_aya_02"] = 0,["thtd_aya_03"] = 0},
		[3] = {["thtd_aya_01"] = 1,["thtd_aya_02"] = 0,["thtd_aya_03"] = 0},
		[4] = {["thtd_aya_01"] = 1,["thtd_aya_02"] = 1,["thtd_aya_03"] = 1},
		[5] = {["thtd_aya_01"] = 1,["thtd_aya_02"] = 1,["thtd_aya_03"] = 1},
	},

	["hatate"] = 
	{
		[1] = {["thtd_hatate_01"] = 1,["thtd_hatate_02"] = 0},
		[2] = {["thtd_hatate_01"] = 1,["thtd_hatate_02"] = 0},
		[3] = {["thtd_hatate_01"] = 1,["thtd_hatate_02"] = 0},
		[4] = {["thtd_hatate_01"] = 1,["thtd_hatate_02"] = 1},
		[5] = {["thtd_hatate_01"] = 1,["thtd_hatate_02"] = 1},
	},

	["momiji"] = 
	{
		[1] = {["thtd_momiji_01"] = 1,["thtd_momiji_02"] = 0},
		[2] = {["thtd_momiji_01"] = 1,["thtd_momiji_02"] = 0},
		[3] = {["thtd_momiji_01"] = 1,["thtd_momiji_02"] = 1},
		[4] = {["thtd_momiji_01"] = 1,["thtd_momiji_02"] = 1},
		[5] = {["thtd_momiji_01"] = 1,["thtd_momiji_02"] = 1},
	},

	["sanae"] = 
	{
		[1] = {["thtd_sanae_01"] = 1,["thtd_sanae_02"] = 1,["thtd_sanae_03"] = 0,["thtd_sanae_04"] = 0},
		[2] = {["thtd_sanae_01"] = 1,["thtd_sanae_02"] = 1,["thtd_sanae_03"] = 0,["thtd_sanae_04"] = 0},
		[3] = {["thtd_sanae_01"] = 1,["thtd_sanae_02"] = 1,["thtd_sanae_03"] = 0,["thtd_sanae_04"] = 0},
		[4] = {["thtd_sanae_01"] = 1,["thtd_sanae_02"] = 1,["thtd_sanae_03"] = 1,["thtd_sanae_04"] = 0},
		[5] = {["thtd_sanae_01"] = 1,["thtd_sanae_02"] = 1,["thtd_sanae_03"] = 1,["thtd_sanae_04"] = 0},
	},

	["kanako"] = 
	{
		[1] = {["thtd_kanako_01"] = 1,["thtd_kanako_02"] = 0,["thtd_kanako_03"] = 0,["thtd_kanako_04"] = 0},
		[2] = {["thtd_kanako_01"] = 1,["thtd_kanako_02"] = 0,["thtd_kanako_03"] = 0,["thtd_kanako_04"] = 0},
		[3] = {["thtd_kanako_01"] = 1,["thtd_kanako_02"] = 1,["thtd_kanako_03"] = 1,["thtd_kanako_04"] = 0},
		[4] = {["thtd_kanako_01"] = 1,["thtd_kanako_02"] = 1,["thtd_kanako_03"] = 1,["thtd_kanako_04"] = 0},
		[5] = {["thtd_kanako_01"] = 1,["thtd_kanako_02"] = 1,["thtd_kanako_03"] = 1,["thtd_kanako_04"] = 1},
	},

	["suwako"] = 
	{
		[1] = {["thtd_suwako_01"] = 1,["thtd_suwako_02"] = 0,["thtd_suwako_03"] = 0},
		[2] = {["thtd_suwako_01"] = 1,["thtd_suwako_02"] = 0,["thtd_suwako_03"] = 0},
		[3] = {["thtd_suwako_01"] = 1,["thtd_suwako_02"] = 1,["thtd_suwako_03"] = 0},
		[4] = {["thtd_suwako_01"] = 1,["thtd_suwako_02"] = 1,["thtd_suwako_03"] = 1},
		[5] = {["thtd_suwako_01"] = 1,["thtd_suwako_02"] = 1,["thtd_suwako_03"] = 1},
	},

	["minamitsu"] = 
	{
		[1] = {["thtd_minamitsu_01"] = 1,["thtd_minamitsu_02"] = 1,["thtd_minamitsu_03"] = 0,["thtd_minamitsu_04"] = 0},
		[2] = {["thtd_minamitsu_01"] = 2,["thtd_minamitsu_02"] = 1,["thtd_minamitsu_03"] = 0,["thtd_minamitsu_04"] = 0},
		[3] = {["thtd_minamitsu_01"] = 3,["thtd_minamitsu_02"] = 1,["thtd_minamitsu_03"] = 0,["thtd_minamitsu_04"] = 0},
		[4] = {["thtd_minamitsu_01"] = 4,["thtd_minamitsu_02"] = 1,["thtd_minamitsu_03"] = 1,["thtd_minamitsu_04"] = 0},
		[5] = {["thtd_minamitsu_01"] = 5,["thtd_minamitsu_02"] = 1,["thtd_minamitsu_03"] = 1,["thtd_minamitsu_04"] = 1},
	},

	["nue"] = 
	{
		[1] = {["thtd_nue_01"] = 1,["thtd_nue_02"] = 0,["thtd_nue_03"] = 0},
		[2] = {["thtd_nue_01"] = 1,["thtd_nue_02"] = 0,["thtd_nue_03"] = 0},
		[3] = {["thtd_nue_01"] = 1,["thtd_nue_02"] = 1,["thtd_nue_03"] = 0},
		[4] = {["thtd_nue_01"] = 1,["thtd_nue_02"] = 1,["thtd_nue_03"] = 1},
		[5] = {["thtd_nue_01"] = 1,["thtd_nue_02"] = 1,["thtd_nue_03"] = 1},
	},

	["rumia_ex"] = 
	{
		[1] = {["thtd_rumia_01"] = 1,["thtd_rumia_02"] = 0,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
		[2] = {["thtd_rumia_01"] = 2,["thtd_rumia_02"] = 0,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
		[3] = {["thtd_rumia_01"] = 3,["thtd_rumia_02"] = 1,["thtd_rumia_03"] = 0,["thtd_rumia_04"] = 0},
		[4] = {["thtd_rumia_01"] = 4,["thtd_rumia_02"] = 1,["thtd_rumia_03"] = 1,["thtd_rumia_04"] = 0},
		[5] = {["thtd_rumia_01"] = 5,["thtd_rumia_02"] = 1,["thtd_rumia_03"] = 1,["thtd_rumia_04"] = 1},
	},

	["sizuha"] = {
		[1] = {["thtd_sizuha_01"] = 1,["thtd_sizuha_02"] = 0},
		[2] = {["thtd_sizuha_01"] = 1,["thtd_sizuha_02"] = 1},
		[3] = {["thtd_sizuha_01"] = 1,["thtd_sizuha_02"] = 1},
		[4] = {["thtd_sizuha_01"] = 1,["thtd_sizuha_02"] = 1},
		[5] = {["thtd_sizuha_01"] = 1,["thtd_sizuha_02"] = 1},
	},

	["toramaru"] = {
		[1] = {["thtd_toramaru_01"] = 1,["thtd_toramaru_02"] = 0,["thtd_toramaru_03"] = 0,["thtd_toramaru_04"] = 0},
		[2] = {["thtd_toramaru_01"] = 1,["thtd_toramaru_02"] = 1,["thtd_toramaru_03"] = 0,["thtd_toramaru_04"] = 0},
		[3] = {["thtd_toramaru_01"] = 1,["thtd_toramaru_02"] = 1,["thtd_toramaru_03"] = 1,["thtd_toramaru_04"] = 0},
		[4] = {["thtd_toramaru_01"] = 1,["thtd_toramaru_02"] = 1,["thtd_toramaru_03"] = 1,["thtd_toramaru_04"] = 0},
		[5] = {["thtd_toramaru_01"] = 1,["thtd_toramaru_02"] = 1,["thtd_toramaru_03"] = 1,["thtd_toramaru_04"] = 1},
	},

	["shinki"] = {
		[1] = {["thtd_shinki_01"] = 1,["thtd_shinki_02"] = 1,["thtd_shinki_03"] = 0,["thtd_shinki_04"] = 0},
		[2] = {["thtd_shinki_01"] = 1,["thtd_shinki_02"] = 1,["thtd_shinki_03"] = 0,["thtd_shinki_04"] = 0},
		[3] = {["thtd_shinki_01"] = 1,["thtd_shinki_02"] = 1,["thtd_shinki_03"] = 0,["thtd_shinki_04"] = 0},
		[4] = {["thtd_shinki_01"] = 1,["thtd_shinki_02"] = 1,["thtd_shinki_03"] = 1,["thtd_shinki_04"] = 0},
		[5] = {["thtd_shinki_01"] = 1,["thtd_shinki_02"] = 1,["thtd_shinki_03"] = 1,["thtd_shinki_04"] = 1},
	},

	["byakuren"] = {
		[1] = {["thtd_byakuren_01"] = 1,["thtd_byakuren_02"] = 1,["thtd_byakuren_03"] = 0,["thtd_byakuren_04"] = 0},
		[2] = {["thtd_byakuren_01"] = 1,["thtd_byakuren_02"] = 1,["thtd_byakuren_03"] = 0,["thtd_byakuren_04"] = 0},
		[3] = {["thtd_byakuren_01"] = 1,["thtd_byakuren_02"] = 1,["thtd_byakuren_03"] = 1,["thtd_byakuren_04"] = 0},
		[4] = {["thtd_byakuren_01"] = 1,["thtd_byakuren_02"] = 1,["thtd_byakuren_03"] = 1,["thtd_byakuren_04"] = 0},
		[5] = {["thtd_byakuren_01"] = 1,["thtd_byakuren_02"] = 1,["thtd_byakuren_03"] = 1,["thtd_byakuren_04"] = 1},
	},

	["soga"] = {
		[1] = {["thtd_soga_01"] = 1,["thtd_soga_02"] = 0,["thtd_soga_03"] = 0},
		[2] = {["thtd_soga_01"] = 1,["thtd_soga_02"] = 0,["thtd_soga_03"] = 0},
		[3] = {["thtd_soga_01"] = 1,["thtd_soga_02"] = 1,["thtd_soga_03"] = 0},
		[4] = {["thtd_soga_01"] = 1,["thtd_soga_02"] = 1,["thtd_soga_03"] = 1},
		[5] = {["thtd_soga_01"] = 1,["thtd_soga_02"] = 1,["thtd_soga_03"] = 1},
	},

	["miko"] = {
		[1] = {["thtd_miko_01"] = 1,["thtd_miko_02"] = 1,["thtd_miko_03"] = 0,["thtd_miko_04"] = 0},
		[2] = {["thtd_miko_01"] = 1,["thtd_miko_02"] = 1,["thtd_miko_03"] = 0,["thtd_miko_04"] = 0},
		[3] = {["thtd_miko_01"] = 1,["thtd_miko_02"] = 1,["thtd_miko_03"] = 1,["thtd_miko_04"] = 0},
		[4] = {["thtd_miko_01"] = 1,["thtd_miko_02"] = 1,["thtd_miko_03"] = 1,["thtd_miko_04"] = 0},
		[5] = {["thtd_miko_01"] = 1,["thtd_miko_02"] = 1,["thtd_miko_03"] = 1,["thtd_miko_04"] = 1},
	},

	["futo"] = {
		[1] = {["thtd_futo_01"] = 1,["thtd_futo_02"] = 0,["thtd_futo_03"] = 0},
		[2] = {["thtd_futo_01"] = 1,["thtd_futo_02"] = 0,["thtd_futo_03"] = 0},
		[3] = {["thtd_futo_01"] = 1,["thtd_futo_02"] = 1,["thtd_futo_03"] = 0},
		[4] = {["thtd_futo_01"] = 1,["thtd_futo_02"] = 1,["thtd_futo_03"] = 1},
		[5] = {["thtd_futo_01"] = 1,["thtd_futo_02"] = 1,["thtd_futo_03"] = 1},
	},

	["yoshika"] = {
		[1] = {["thtd_yoshika_01"] = 1,["thtd_yoshika_02"] = 0},
		[2] = {["thtd_yoshika_01"] = 2,["thtd_yoshika_02"] = 0},
		[3] = {["thtd_yoshika_01"] = 3,["thtd_yoshika_02"] = 1},
		[4] = {["thtd_yoshika_01"] = 4,["thtd_yoshika_02"] = 1},
		[5] = {["thtd_yoshika_01"] = 5,["thtd_yoshika_02"] = 1},
	},

	["seiga"] = {
		[1] = {["thtd_seiga_01"] = 1,["thtd_seiga_02"] = 1,["thtd_seiga_03"] = 0},
		[2] = {["thtd_seiga_01"] = 1,["thtd_seiga_02"] = 2,["thtd_seiga_03"] = 0},
		[3] = {["thtd_seiga_01"] = 1,["thtd_seiga_02"] = 3,["thtd_seiga_03"] = 0},
		[4] = {["thtd_seiga_01"] = 1,["thtd_seiga_02"] = 4,["thtd_seiga_03"] = 1},
		[5] = {["thtd_seiga_01"] = 1,["thtd_seiga_02"] = 5,["thtd_seiga_03"] = 1},
	},

	["keine"] = {
		[1] = {["thtd_keine_01"] = 1,["thtd_keine_02"] = 0,["thtd_keine_03"] = 0},
		[2] = {["thtd_keine_01"] = 1,["thtd_keine_02"] = 0,["thtd_keine_03"] = 0},
		[3] = {["thtd_keine_01"] = 1,["thtd_keine_02"] = 1,["thtd_keine_03"] = 0},
		[4] = {["thtd_keine_01"] = 1,["thtd_keine_02"] = 1,["thtd_keine_03"] = 1},
		[5] = {["thtd_keine_01"] = 1,["thtd_keine_02"] = 1,["thtd_keine_03"] = 1},
	},
}		

thtd_combo_table = 
{
	["ld_cirno"] = {"cirno","letty"},
	["lyrica_lunasa_merlin"] = {"lyrica","lunasa","merlin"},
	["tenshi_iku"] = {"tenshi","iku"},
	["yuyuko_youmu"] = {"youmu","yuyuko"},
	["youmu_reisen"] = {"youmu","reisen"},
	["utsuho_rin"] = {"utsuho","rin"},
	["reimu_marisa"] = {"reimu","marisa"},
	["koishi_satori"] = {"koishi","satori"},
	["remilia_sakuya"] = {"remilia","sakuya"},
	["remilia_flandre"] = {"remilia","flandre"},
	["meirin_sakuya"] = {"meirin","sakuya"},
	["reimu_yukari"] = {"reimu","yukari"},
	["koakuma_patchouli"] = {"koakuma","patchouli"},
	["chen_yukari_ran"] = {"chen","yukari","ran"},
	["eirin_kaguya"] = {"eirin","kaguya"},
	["rumia_reimu"] = {"rumia","reimu"},
	["suwako_kanako_sanae"] = {"suwako","kanako","sanae"},
	["nue_minamitsu"] = {"minamitsu","nue"},
	["futo_soga"] = {"futo","soga"},
	["yoshika_seiga"] = {"yoshika","seiga"},
}

thtd_ability_minoriko_star_up_table = 
{
	[2] = 40,
	[3] = 160,
	[4] = 500,
	[5] = 2200,
}

thtd_ability_sizuha_star_up_table = 
{

	[2] = 216,
	[3] = 432,
	[4] = 720,
	[5] = 1008,
}

function CDOTA_BaseNPC:THTD_InitExp()

	if self:GetUnitName() == "minoriko" or self:GetUnitName() == "sizuha" then

		self.thtd_level = 10
		self.thtd_star = 1
		self.thtd_power = 1
		self.thtd_tower_damage = 0
		self.thtd_is_ex = false
		self.thtd_close_ai = false
		self.thtd_istower = true
		self.thtd_isChanged = false
		self.thtd_exp = thtd_exp_table[THTD_MAX_LEVEL - 1]
		self.thtd_mana_regen = self:GetManaRegen()
		self.thtd_mana_regen_percentage = 0
		self.thtd_crit_chance = 0

		self:THTD_OpenAbility()
		self:THTD_CreateLevelEffect()
		self:SetHasInventory(true)

		self.equip_bonus_table = 
		{
			["attack_percentage"] = 0,
			["mana_regen_percentage"] = 0,
			["crit_chance"] = 0,
			["crit_damage"] = 0,
			["physical_penetration_percentage"] = 0,
			["magical_penetration_percentage"] = 0,
			["power_percentage"] = 0,
			["magical_damage_percentage"] = 0,
			["physical_damage_percentage"] = 0,
			["damage_percentage"] = 0,
			["cooldown"] = 0,
			["attack_speed"] = 0,
			["power"] = 0,
		}

		local time_count = 0

		self:SetContextThink(DoUniqueString("thtd_minoriko_star_up_listen"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if self:HasModifier("modifier_touhoutd_release_hidden") then return 1.0 end
				if SpawnSystem:GetWave() > 51 then return nil end
				if self.thtd_star < THTD_MAX_STAR then
					time_count = time_count + 1 * ( (self:FindAbilityByName("ability_common_star_up_speed"):GetLevel() - 1) * 0.1 + 1 )
					if self.thtd_isChanged == true then
						time_count = 0
						self.thtd_isChanged = false
					end
					
					local aki_star_up = false
					
					if self:GetUnitName() == "minoriko" then
						SendOverheadEventMessage(self:GetPlayerOwner(), OVERHEAD_ALERT_OUTGOING_DAMAGE, self, thtd_ability_minoriko_star_up_table[self.thtd_star+1] - time_count, self:GetPlayerOwner() )
						if time_count >= thtd_ability_minoriko_star_up_table[self.thtd_star+1] then
							self.thtd_star = self.thtd_star + 1
							self:THTD_OpenAbility()
							self:THTD_DestroyLevelEffect()
							self:THTD_CreateLevelEffect()
							time_count = 0
							aki_star_up = true
						end
					else
						SendOverheadEventMessage(self:GetPlayerOwner(), OVERHEAD_ALERT_OUTGOING_DAMAGE, self, thtd_ability_sizuha_star_up_table[self.thtd_star+1] - time_count, self:GetPlayerOwner() )
						if time_count >= thtd_ability_sizuha_star_up_table[self.thtd_star+1] then
							self.thtd_star = self.thtd_star + 1
							self:THTD_OpenAbility()
							self:THTD_DestroyLevelEffect()
							self:THTD_CreateLevelEffect()
							time_count = 0
							aki_star_up = true
						end
					end
					
					if aki_star_up then
						if self.thtd_star >= 3 then
							CustomGameEventManager:Send_ServerToPlayer( self:GetPlayerOwner() , "show_message", {msg=self:GetUnitName().." reached "..self.thtd_star.." Stars!", duration=5, params={count=1}, color="#f00"} )
						end

						self:EmitSound("Sound_THTD.thtd_star_up")
						local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_02.vpcf", PATTACH_CUSTOMORIGIN, self)
						ParticleManager:SetParticleControl(effectIndex, 0, self:GetOrigin())
						ParticleManager:SetParticleControl(effectIndex, 1, self:GetOrigin())
						ParticleManager:DestroyParticleSystem(effectIndex,false)
					end
					
					if self:HasModifier("modifier_touhoutd_release_hidden") then
						time_count = 0
					end
				end
				return 1.0
			end, 
		1.0)

		self:SetContextThink(DoUniqueString("thtd_close_star_listen"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if self:HasModifier("modifier_touhoutd_release_hidden") then return 1.0 end
				
				if self:GetOwner().thtd_close_star == true and self.thtd_is_effect_open == true and self:GetOwner().focusTarget ~= self then
					self:THTD_DestroyLevelEffect()
				elseif self:GetOwner().thtd_close_star == false and self.thtd_is_effect_open == false then
					self:THTD_CreateLevelEffect()
				end
				local item = EntIndexToHScript(self.thtd_item)
				if item == nil or item:IsNull() then
					local hero = self:GetOwner()
					if hero~=nil and hero:IsNull()==false then
						hero.thtd_hero_star_list[tostring(self.thtd_item)] = 1
						hero.thtd_hero_level_list[tostring(self.thtd_item)] = 1
					end

					self:ForceKill(true)
				end
				return 0.1
			end, 
		0.1)

		return
	end


	self.thtd_exp = 0
	self.thtd_level = 1
	self.thtd_star = 1
	self.thtd_tower_damage = 0
	self.thtd_is_ex = false
	self.exup_count = 0
    self.thtd_close_ai = false
	self.thtd_mana_regen = self:GetManaRegen()
	self.thtd_mana_regen_percentage = 0
	self.thtd_crit_chance = 0

	self.thtd_power = thtd_power_table[self:GetUnitName()][self.thtd_star][1]
	self.thtd_istower = true
	self:THTD_CreateLevelEffect()
	self:SetHasInventory(true)
	self:THTD_OpenAbility()
	self:THTD_AI_Init()


	self.equip_bonus_table = 
	{
		["attack_percentage"] = 0,
		["mana_regen_percentage"] = 0,
		["crit_chance"] = 0,
		["crit_damage"] = 0,
		["physical_penetration_percentage"] = 0,
		["magical_penetration_percentage"] = 0,
		["power_percentage"] = 0,
		["magical_damage_percentage"] = 0,
		["physical_damage_percentage"] = 0,
		["damage_percentage"] = 0,
		["cooldown"] = 0,
		["attack_speed"] = 0,
		["power"] = 0,
	}


	self.thtd_attack = thtd_attack_table[self:GetUnitName()][self.thtd_star][1]
	self:SetContextThink(DoUniqueString("thtd_common_listener"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if self:HasModifier("modifier_touhoutd_release_hidden") then return 1.0 end

			-- 攻击刷新
			local attack = math.floor(self:THTD_GetAttack()*0.7)
			if attack ~= self:GetModifierStackCount("common_thdots_base_attack_buff", self) then
				self:SetModifierStackCount("common_thdots_base_attack_buff", self, attack)
			end

			-- 属性刷新
			if self:THTD_GetPower() ~= self:GetModifierStackCount("common_thdots_base_power_buff", self) then
				self:SetModifierStackCount("common_thdots_base_power_buff", self, self:THTD_GetPower())
			end

			-- 装备刷新
			self:THTD_EquipRefresh()

			-- 组合刷新
			local combo = self:THTD_GetCombo()
			local func = self["THTD_"..self:GetUnitName().."_thtd_combo"]
			if func then
				local changeCombo = func(self,combo)
				if changeCombo~=nil and #changeCombo > 0 then
					for k,v in pairs(changeCombo) do
						local hero = self:GetOwner()
						if hero~=nil and hero:IsNull()==false then
							hero:SetContextThink(DoUniqueString("thtd_combo_voice_array_insert"), 
								function()
									if GameRules:IsGamePaused() then return 0.03 end
									v["unit"] = self
									table.insert(hero.thtd_combo_voice_array,v)
									return nil
								end,
							v["delay"])
						end
					end
					changeCombo = {}
				end
			end

			return 1.0
		end, 
	1.0)

	self:SetContextThink(DoUniqueString("thtd_exp_level_up_listen"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if self:HasModifier("modifier_touhoutd_release_hidden") then return 1.0 end

			if self:THTD_GetLevel() < THTD_MAX_LEVEL then
				if self.thtd_exp >= thtd_exp_table[self.thtd_level] then
					if self.thtd_exp >= thtd_exp_table[THTD_MAX_LEVEL-1] then
						self:THTD_SetLevel(THTD_MAX_LEVEL)
						self.thtd_exp = thtd_exp_table[THTD_MAX_LEVEL-1] + 1
						return 0.1
					end
					for i=self.thtd_level,(THTD_MAX_LEVEL-1) do
						if self.thtd_exp < thtd_exp_table[i] then
							self:THTD_SetLevel(i)
							return 0.1
						end
					end
				end
			end
			return 0.1
		end, 
	0.1)

	self:SetContextThink(DoUniqueString("thtd_close_star_listen"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if self:HasModifier("modifier_touhoutd_release_hidden") then return 1.0 end

			if self:GetOwner().thtd_close_star == true and self.thtd_is_effect_open == true and self:GetOwner().focusTarget ~= self then
				self:THTD_DestroyLevelEffect()
			elseif self:GetOwner().thtd_close_star == false and self.thtd_is_effect_open == false then
				self:THTD_CreateLevelEffect()
			end
			local item = EntIndexToHScript(self.thtd_item)
			if item == nil or item:IsNull() then
				local hero = self:GetOwner()
				if hero~=nil and hero:IsNull()==false then
					hero.thtd_hero_star_list[tostring(self.thtd_item)] = 1
					hero.thtd_hero_level_list[tostring(self.thtd_item)] = 1
				end

				self:ForceKill(true)
			end
			return 0.1
		end, 
	0.1)
end


function CDOTA_BaseNPC:THTD_AddCritChance(chance)
	self.thtd_crit_chance = self.thtd_crit_chance + chance
end

local thtd_attack_speed_black_list = 
{
	"nazrin",
	"iku"
}

function CDOTA_BaseNPC:IsInAttackSpeedBlackList()
	for k,v in pairs(thtd_attack_speed_black_list) do
		if self:GetUnitName() == v then
			return true
		end
	end
	return false
end

function CDOTA_BaseNPC:THTD_RefreshAttackSpeed()
	if self == nil or self:IsNull() == false and self:IsAlive() then
		if self:IsInAttackSpeedBlackList() then
			return
		end
		local modifier = self:FindModifierByName("modifier_attack_speed")
		if modifier ~= nil then
			modifier:SetStackCount(self.equip_bonus_table["attack_speed"])
		else
			modifier = self:AddNewModifier(self, nil, "modifier_attack_speed", {})
			modifier:SetStackCount(self.equip_bonus_table["attack_speed"])
		end
	end
end

local thtd_cooldown_black_list = 
{
	"daiyousei",
	"toramaru",
}

function CDOTA_BaseNPC:IsInCooldownBlackList()
	for k,v in pairs(thtd_cooldown_black_list) do
		if self:GetUnitName() == v then
			return true
		end
	end
	return false
end

function CDOTA_BaseNPC:THTD_RefreshCooldown()
	if self == nil or self:IsNull() == false and self:IsAlive() then
		if self:IsInCooldownBlackList() then
			return
		end

		local modifier = self:FindModifierByName("modifier_cooldown_reduce")
		if modifier ~= nil then
			modifier:SetStackCount(self.equip_bonus_table["cooldown"])
		else
			modifier = self:AddNewModifier(self, nil, "modifier_cooldown_reduce", {})
			modifier:SetStackCount(self.equip_bonus_table["cooldown"])
		end
	end
end

local thtd_mana_regen_black_list = 
{
	"lily",
}

function CDOTA_BaseNPC:IsInManaRegenBlackList()
	for k,v in pairs(thtd_mana_regen_black_list) do
		if self:GetUnitName() == v then
			return true
		end
	end
	return false
end

function CDOTA_BaseNPC:THTD_RefreshManaRegen()
	if self:IsInManaRegenBlackList() then
		return
	end
	local totalPercentage = self.equip_bonus_table["mana_regen_percentage"] + self.thtd_mana_regen_percentage

 	if math.abs(self:GetManaRegen() - self.thtd_mana_regen * (1 + totalPercentage/100) ) > 0.1 then
		self:SetBaseManaRegen( self.thtd_mana_regen * (1 + totalPercentage/100) )
	end
end

function CDOTA_BaseNPC:THTD_GetExp()
	return self.thtd_exp
end

function CDOTA_BaseNPC:THTD_SetExp(exp)
	self.thtd_exp = exp
end

function CDOTA_BaseNPC:THTD_AddExp(exp)
	self.thtd_exp = self.thtd_exp + exp * thtd_exp_star_table[self.thtd_star]
end

function CDOTA_BaseNPC:THTD_SetLevel(level)
	if level > 10 then level = 10 end
	local upLevel = level - self.thtd_level
	self.thtd_level = level
	if self.thtd_level > 10 then self.thtd_level = 10 end

	local unitName = self:GetUnitName()
	if self:THTD_IsTowerEx() == true then
		unitName = unitName.."_ex"
	end

	self:THTD_AddPower(thtd_power_table[unitName][self.thtd_star][2]*(upLevel))
	local modifier = self:FindModifierByName("modifier_shinki_02_power_up_bonus_buff")
	if modifier ~= nil and upLevel > 0 then
		local caster = modifier:GetCaster()
		self:THTD_AddPower(caster:THTD_GetStar()*2*(upLevel))
	end
	if thtd_attack_table[unitName]~=nil then
		self:THTD_AddAttack(thtd_attack_table[unitName][self.thtd_star][2]*(upLevel))
	end
	local effectIndex = ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf", PATTACH_CUSTOMORIGIN, self)
	ParticleManager:SetParticleControl(effectIndex, 0, self:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	self:EmitSound("Sound_THTD.thtd_level_up")

	self:THTD_DestroyLevelEffect()
	self:THTD_CreateLevelEffect()
end

function CDOTA_BaseNPC:THTD_LevelUp(level)
	self.thtd_level = self.thtd_level + level
	if self.thtd_level > 10 then self.thtd_level = 10 end

	local unitName = self:GetUnitName()
	if self:THTD_IsTowerEx() == true then
		unitName = unitName.."_ex"
	end

	self:THTD_AddPower(thtd_power_table[unitName][self.thtd_star][2]*level)
	local modifier = self:FindModifierByName("modifier_shinki_02_power_up_bonus_buff")
	if modifier ~= nil then
		local caster = modifier:GetCaster()
		self:THTD_AddPower(caster:THTD_GetStar()*2*level)
	end
	if thtd_attack_table[unitName]~=nil then
		self:THTD_AddAttack(thtd_attack_table[unitName][self.thtd_star][2]*level)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf", PATTACH_CUSTOMORIGIN, self)
	ParticleManager:SetParticleControl(effectIndex, 0, self:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	self:THTD_DestroyLevelEffect()
	self:THTD_CreateLevelEffect()
end

function CDOTA_BaseNPC:THTD_GetLevel()
	return self.thtd_level
end

function CDOTA_BaseNPC:THTD_GetStar()
	return self.thtd_star
end

function CDOTA_BaseNPC:THTD_SetStar(star)
	local lastPower = nil
	local lastAttack = nil

	local unitName = self:GetUnitName()
	if self:THTD_IsTowerEx() == true then
        unitName = unitName.."_ex"
	end

	if thtd_power_table[unitName][self.thtd_star]~=nil then
		lastPower = thtd_power_table[unitName][self.thtd_star][1] + thtd_power_table[unitName][self.thtd_star][2] * (self:THTD_GetLevel()-1)
	end
	if thtd_attack_table[unitName]~=nil then
		lastAttack = thtd_attack_table[unitName][self.thtd_star][1] + thtd_attack_table[unitName][self.thtd_star][2] * (self:THTD_GetLevel()-1)
	end

	self.thtd_star = star
	self.thtd_level = 1
	self.thtd_exp = 0

	if lastPower~=nil then
		self.thtd_power = self.thtd_power + thtd_power_table[unitName][self.thtd_star][1] - lastPower
	else
		self.thtd_power = self.thtd_power + thtd_power_table[unitName][self.thtd_star][1]
	end

	if lastAttack~=nil then
		self.thtd_attack = self.thtd_attack + thtd_attack_table[unitName][self.thtd_star][1] - lastAttack
	end

	self:THTD_DestroyLevelEffect()
	self:THTD_CreateLevelEffect()
	self:SetMana(0)
	self:THTD_OpenAbility()
	self:EmitSound("Sound_THTD.thtd_star_up")

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_02.vpcf", PATTACH_CUSTOMORIGIN, self)
	ParticleManager:SetParticleControl(effectIndex, 0, self:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, self:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function CDOTA_BaseNPC:THTD_UpgradeStar()
    self:THTD_SetStar(self:THTD_GetStar()+1)
end

	
function CDOTA_BaseNPC:THTD_GetPower()
	local ability=self:FindAbilityByName("ability_common_power_buff")
	local level = 1

	if ability ~= nil then
		level = ability:GetLevel()
	end
	return (self.thtd_power + self.equip_bonus_table["power"]) * (1 + ((level - 1) *0.15)) * (1 + self.equip_bonus_table["power_percentage"]/100)
end

function CDOTA_BaseNPC:THTD_SetPower(power)
	self.thtd_power = power
end

function CDOTA_BaseNPC:THTD_AddPower(power)
	self.thtd_power = self.thtd_power + power
end

function CDOTA_BaseNPC:THTD_SetAttack(attack)
	self.thtd_attack = attack
end

function CDOTA_BaseNPC:THTD_AddAttack(attack)
	self.thtd_attack = self.thtd_attack + attack
end

function CDOTA_BaseNPC:THTD_GetAttack()
	local ability=self:FindAbilityByName("ability_common_power_buff")
	local level = 1

	if ability ~= nil then
		level = ability:GetLevel()
	end
	return self.thtd_attack * (1 + ((level - 1) *0.2)) * (1 + self.equip_bonus_table["attack_percentage"]/100)
end


function CDOTA_BaseNPC:THTD_CreateLevelEffect()
	if self.thtd_is_effect_open == true then return end
	self.thtd_level_effect = ParticleManager:CreateParticle("particles/thtd/msg/thtd_msg_level.vpcf", PATTACH_CUSTOMORIGIN, self)
	if self.thtd_level < 10 then
		ParticleManager:SetParticleControl(self.thtd_level_effect, 0, self:GetOrigin())
		ParticleManager:SetParticleControl(self.thtd_level_effect, 2, Vector(0,1,0))
		ParticleManager:SetParticleControl(self.thtd_level_effect, 3, Vector(0,self.thtd_level,0))
	else
		ParticleManager:SetParticleControl(self.thtd_level_effect, 0, self:GetOrigin())
		ParticleManager:SetParticleControl(self.thtd_level_effect, 2, Vector(0,2,0))
		ParticleManager:SetParticleControl(self.thtd_level_effect, 3, Vector(0,10,0))
	end

	self.thtd_star_effect = ParticleManager:CreateParticle("particles/thtd/msg/thtd_msg_star.vpcf", PATTACH_CUSTOMORIGIN, self)

	ParticleManager:SetParticleControl(self.thtd_star_effect, 0, self:GetOrigin())
	ParticleManager:SetParticleControl(self.thtd_star_effect, 2, Vector(0,self.thtd_star,0))
	ParticleManager:SetParticleControl(self.thtd_star_effect, 3, Vector(0,0,0))
	self.thtd_is_effect_open = true
end

function CDOTA_BaseNPC:THTD_DestroyLevelEffect()
	ParticleManager:DestroyParticleSystem(self.thtd_level_effect,true)
	ParticleManager:DestroyParticleSystem(self.thtd_star_effect,true)
	self.thtd_is_effect_open = false
end

local thtd_bonus_ability_table = 
{
	"ability_common_attack_speed_buff",
	"ability_common_power_buff",
	"ability_common_mana_regen_buff",
	"ability_common_decrease_armor_buff",
	"ability_common_decrease_magic_armor_buff",
	"ability_common_star_up_speed",
}

function CDOTA_BaseNPC:THTD_SetAbilityLevelUp()
	for k,v in pairs(thtd_bonus_ability_table) do
		local ability=self:FindAbilityByName(v)

		if ability ~= nil then
			if ability:GetLevel() < ability:GetMaxLevel() then
				ability:SetLevel(ability:GetLevel()+1)
			end
		end
	end
end

function CDOTA_BaseNPC:THTD_OpenAbility()
	local unitName = self:GetUnitName()
	if self:THTD_IsTowerEx() == true then
		unitName = unitName.."_ex"
	end
	for k,v in pairs(thtd_ability_table[unitName]) do
		for abilityName,level in pairs(v) do
			local ability=self:FindAbilityByName(abilityName)
			if self:THTD_GetStar() == k then
				if ability ~= nil and ability:GetLevel()~=level then
					if level < 1 then
						ability:SetActivated(false)
					else
						ability:SetActivated(true)
					end
					ability:SetLevel(level)
				end
			end
		end
	end
end

function CDOTA_BaseNPC:THTD_IsTower()
	return self.thtd_istower or false
end

function CDOTA_BaseNPC:THTD_GetItem()
	return self.thtd_item
end


function CDOTA_BaseNPC:THTD_GetCombo()
	local comboTable = {}
	for index,value in pairs(thtd_combo_table) do
		local count = 0
		local isInCombo = false

		for k,v in pairs(value) do
			if THTD_IsTowerTypeInList(self:GetOwner(),v) == true then
				count = count + 1
			end
			if self:GetUnitName() == v then
				isInCombo = true
			end
		end
		if count == #value and isInCombo == true then
			comboTable[index] = value
		end
	end

	if comboTable ~= nil then
		return comboTable
	end
	return nil
end

function CDOTA_BaseNPC:THTD_UpgradeEx()
	local unitName = self:GetUnitName()
	local star = self:THTD_GetStar()
	local level = self:THTD_GetLevel()
--[[
	for k,v in pairs(thtd_ability_table[unitName]) do
		for abilityName,level in pairs(v) do
			if self:THTD_GetStar() == k then
				self:RemoveAbility(abilityName)
			end
		end
	end
]]--
	unitName = self:GetUnitName().."_ex"

	local index = 0
	for k,v in pairs(thtd_ability_table[unitName]) do
		index = index + 1
		for abilityName,level in pairs(v) do
			if self:THTD_GetStar() == k then
				local ability=self:GetAbilityByIndex(index)
				ability:SetLevel(level)
			end
		end
	end

	self:THTD_SetStar(1)
	self:THTD_SetLevel(1)
	self.thtd_is_ex = true
	self:THTD_SetStar(star)
	self:THTD_SetLevel(level)

    if self.exup_count > 0 then
        self.thtd_power = self.thtd_power + self.thtd_power * 0.3
        self.thtd_attack = self.thtd_attack + self.thtd_attack * 0.3
    end
    self.exup_count = self.exup_count + 1
end

function CDOTA_BaseNPC:THTD_IsTowerEx()
	return self.thtd_is_ex or false
end

function CDOTA_BaseNPC:THTD_GetFaith(caster)
	if self:HasModifier("modifier_thtd_ss_kill") and self:HasModifier("modifier_sanae_04_buff") then
		local modifier = self:FindModifierByName("modifier_thtd_ss_faith")
		if modifier ~= nil then
    		return modifier:GetStackCount()
    	end
    end
    return 0
end

local thtd_Unique_Slow_Buff = 
{
	"modifier_cirno_01_slow_buff",
	"modifier_kogasa_debuff",
	"modifier_merlin_01_debuff",
	"modifier_satori_01_debuff",
	"modifier_thdots_ran02_debuff",
	"modifier_sanae_debuff",
	"modifier_minamitsu_01_slow_buff",
	"modifier_kogasa_upgrade_debuff",
	"modifier_yoshika_01_slow",
}


function THTD_IsUniqueSlowBuff(modifierName)
	for index,name in pairs(thtd_Unique_Slow_Buff) do
		if name == modifierName then
			return true
		end
	end
	return false
end

function CDOTA_BaseNPC:THTD_HasUniqueSlowBuff()
	local modifiers = self:FindAllModifiers()
	local count = 0

	for k,v in pairs(modifiers) do
		for index,name in pairs(thtd_Unique_Slow_Buff) do
			if v:GetName() == name then
				count = count + 1
			end
		end
	end
	if count > 1 then
		return true
	end
	
	return false
end

function THTD_IsTowerTypeInList(hero,towername)
	for k,v in pairs(hero.thtd_hero_tower_list) do
		if v~=nil and v:IsNull() ==false then
			if v:GetUnitName() == towername then
				return true
			end
		end
	end
	return false
end

function CDOTA_BaseNPC:THTD_GetItemName()
	for k,v in pairs(towerNameList) do
		if v["kind"] == self:GetUnitName() then
			return k
		end
	end
	return nil
end

function CDOTA_BaseNPC:THTD_AddUnitItemToList(PlayerID)
	local list_num = PlayerID+1
	local itemName = self:THTD_GetItemName()

	if itemName~=nil then
		for k,v in pairs(towerPlayerList[list_num]) do
			if v["itemName"] == itemName then
				v["count"] = v["count"] + 1
				PrintTable(towerPlayerList[PlayerID+1])
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
	PrintTable(towerPlayerList[PlayerID+1])
end

function CDOTA_BaseNPC:THTD_IsHidden()
	if self:HasModifier("modifier_touhoutd_release_hidden") then
		return true
	end
	return false
end

local thtd_equip_table = 
{
	["item_2005"] = 
	{
		["single"] = 
		{
			["attack_percentage"] = 10,
		},
		["suit"] = 
		{
			[2] = {
				["attack_percentage"] = 30,
			},
			[4] = {
				["modifier"] = "modifier_item_2005_attack_aura",
			},
		},
	},
	["item_2006"] = 
	{
		["single"] = 
		{
			["mana_regen_percentage"] = 4,
		},
		["suit"] = 
		{
			[2] = {
				["mana_regen_percentage"] = 10,
			},
			[4] = {
				["modifier"] = "modifier_item_2006_mana_regen_aura",
			},
		},
	},
	["item_2007"] = 
	{
		["single"] = 
		{
			["mana_regen_percentage"] = 4,
		},
		["suit"] = 
		{
			[2] = {
				["mana_regen_percentage"] = 10,
			},
			[4] = {
				["modifier"] = "modifier_item_2008_slow_aura",
			},
		},
	},
	["item_2008"] = 
	{
		["single"] = 
		{
			["crit_chance"] = 5,
		},
		["suit"] = 
		{
			[2] = {
				["crit_chance"] = 10,
			},
			[4] = {
				["crit_damage"] = 100,
			},
		},
	},
	["item_2009"] = 
	{
		["single"] = 
		{
			["physical_penetration_percentage"] = 5,
		},
		["suit"] = 
		{
			[2] = {
				["physical_penetration_percentage"] = 10,
			},
			[4] = {
				["modifier"] = "modifier_item_2009_physical_penetration",
			},
		},
	},
	["item_2010"] = 
	{
		["single"] = 
		{
			["magical_penetration_percentage"] = 5,
		},
		["suit"] = 
		{
			[2] = {
				["magical_penetration_percentage"] = 10,
			},
			[4] = {
				["modifier"] = "modifier_item_2010_magical_penetration",
			},
		},
	},
	["item_2011"] = 
	{
		["single"] = 
		{
			["attack_percentage"] = 10,
			["power_percentage"] = 2,
		},
		["suit"] = 
		{
			[2] = {
				["attack_percentage"] = 15,
				["power_percentage"] = 6,
			},
			[4] = {
				["modifier"] = "modifier_item_2011_attack_stun",
			},
		},
	},
	["item_2012"] = 
	{
		["single"] = 
		{
			["magical_damage_percentage"] = 4,
		},
		["suit"] = 
		{
			[2] = {
				["magical_damage_percentage"] = 20,
			},
			[4] = {
				["modifier"] = "modifier_item_2012_magical_damage_aura",
			},
		},
	},
	["item_2013"] = 
	{
		["single"] = 
		{
			["physical_damage_percentage"] = 4,
		},
		["suit"] = 
		{
			[2] = {
				["physical_damage_percentage"] = 20,
			},
			[4] = {
				["modifier"] = "modifier_item_2013_physical_damage_aura",
			},
		},
	},
	["item_2014"] = 
	{
		["single"] = 
		{
			["damage_percentage"] = 3,
		},
		["suit"] = 
		{
			[2] = {
				["damage_percentage"] = 15,
			},
			[4] = {
				["modifier"] = "modifier_item_2014_damage_aura",
			},
		},
	},
	["item_2015"] = 
	{
		["single"] = 
		{
			["crit_chance"] = 5,
		},
		["suit"] = 
		{
			[2] = {
				["crit_chance"] = 10,
			},
			[4] = {
				["crit_chance"] = 25,
			},
		},
	},
	["item_2016"] = 
	{
		["single"] = 
		{
			["magical_damage_percentage"] = 2,
			["mana_regen_percentage"] = 2,
		},
		["suit"] = 
		{
			[2] = {
				["magical_damage_percentage"] = 10,
				["mana_regen_percentage"] = 5,
			},
			[4] = {
				["cooldown"] = 25,
			},
		},
	},
	["item_2017"] = 
	{
		["single"] = 
		{
			["attack_speed"] = 4,
		},
		["suit"] = 
		{
			[2] = {
				["attack_speed"] = 20,
			},
			[4] = {
				["attack_speed"] = 25,
			},
		},
	},
	["item_2018"] = 
	{
		["single"] = 
		{
			["attack_percentage"] = 5,
			["power_percentage"] = 2,
		},
		["suit"] = 
		{
			[2] = {
				["attack_percentage"] = 15,
				["power_percentage"] = 6,
			},
			[4] = {
				["modifier"] = "modifier_item_2018_bonus_attack_range",
			},
		},
	},
	["item_2019"] = 
	{
		["single"] = 
		{
			["power_percentage"] = 4,
		},
		["suit"] = 
		{
			[2] = {
				["power_percentage"] = 12,
			},
			[4] = {
				["power"] = 200,
			},
		},
	},
	["item_2020"] = 
	{
		["single"] = 
		{
			["power_percentage"] = 4,
		},
		["suit"] = 
		{
			[2] = {
				["power_percentage"] = 12,
			},
			[4] = {
				["modifier"] = "modifier_item_2020_damage",
			},
		},
	},
	["item_2025"] = 
	{
		["single"] = 
		{
			["power_percentage"] = 2,
			["magical_damage_percentage"] = 2,
		},
		["suit"] = 
		{
			[2] = {
				["power_percentage"] = 6,
				["magical_damage_percentage"] = 10,
			},
			[4] = {
				["modifier"] = "modifier_item_2025_damage",
			},
		},
	},
	["item_2026"] = 
	{
		["single"] = 
		{
			["power_percentage"] = 2,
			["physical_damage_percentage"] = 2,
		},
		["suit"] = 
		{
			[2] = {
				["power_percentage"] = 6,
				["physical_damage_percentage"] = 10,
			},
			[4] = {
				["modifier"] = "modifier_item_2026_damage",
			},
		},
	},
}

function CDOTA_BaseNPC:THTD_GetSelfItemCount(itemName)
	local count = 0
 	for i=0,5 do
		local targetItem = self:GetItemInSlot(i)
		if targetItem~=nil and targetItem:IsNull()==false then
			if targetItem:GetAbilityName() == itemName then
				count = count + 1
			end
		end
	end
	return count
end

function CDOTA_BaseNPC:THTD_EquipRefresh()
	local equip_bonus_table = 
	{
		["attack_percentage"] = 0,
		["mana_regen_percentage"] = 0,
		["crit_chance"] = 0,
		["crit_damage"] = 0,
		["physical_penetration_percentage"] = 0,
		["magical_penetration_percentage"] = 0,
		["power_percentage"] = 0,
		["magical_damage_percentage"] = 0,
		["physical_damage_percentage"] = 0,
		["damage_percentage"] = 0,
		["cooldown"] = 0,
		["attack_speed"] = 0,
		["power"] = 0,
	}

	local suitUnique = {}

 	for i=0,5 do
		local targetItem = self:GetItemInSlot(i)

		if targetItem~=nil and targetItem:IsNull()==false then
			for itemName,value in pairs(thtd_equip_table) do
				if targetItem:GetAbilityName() == itemName then
					if value["single"] ~= nil then
						for bonusName,bonus in pairs(value["single"]) do
							equip_bonus_table[bonusName] = equip_bonus_table[bonusName] + bonus
						end
					end


					if value["suit"] ~= nil and suitUnique[itemName] ~= true then
						suitUnique[itemName] = true

						if self:THTD_GetSelfItemCount(itemName) >= 2 then
							for bonusName,bonus in pairs(value["suit"][2]) do
								if bonusName ~= "modifier" then
									equip_bonus_table[bonusName] = equip_bonus_table[bonusName] + bonus
								else
									if self:HasModifier(bonus) == false then
										local modifier = self:AddNewModifier(self, nil, bonus, {})
										self:SetContextThink(DoUniqueString("thtd_remove_modifier"), 
											function()
												if GameRules:IsGamePaused() then return 0.03 end
												if self:THTD_GetSelfItemCount(itemName) < 2 then
													modifier:Destroy()
													return nil
												end
												return 1.0
											end,
										1.0)
									end
								end
							end
						end

						if self:THTD_GetSelfItemCount(itemName) >= 4 then
							for bonusName,bonus in pairs(value["suit"][4]) do
								if bonusName ~= "modifier" then
									equip_bonus_table[bonusName] = equip_bonus_table[bonusName] + bonus
								else
									if self:HasModifier(bonus) == false then
										self:AddNewModifier(self, nil, bonus, {})
										local modifier = self:AddNewModifier(self, nil, bonus, {})
										self:SetContextThink(DoUniqueString("thtd_remove_modifier"), 
											function()
												if GameRules:IsGamePaused() then return 0.03 end
												if self:THTD_GetSelfItemCount(itemName) < 4 then
													modifier:Destroy()
													return nil
												end
												return 1.0
											end,
										1.0)
									end
								end
							end
						end
					end


				end
			end
		end
	end

	for k,v in pairs(equip_bonus_table) do
		self.equip_bonus_table[k] = v
	end
	
	--PrintTable(self.equip_bonus_table)

	equip_bonus_table = {}
	suitUnique = {}
	
	self:THTD_RefreshManaRegen()
	self:THTD_RefreshCooldown()
	self:THTD_RefreshAttackSpeed()
end