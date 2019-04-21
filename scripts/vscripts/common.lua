THTD_Custom_Hit_Block = {}

function GetHeroFairyList(hero)
    local fairyList = {}
    local count = 0
    for k,v in pairs(hero.thtd_hero_tower_list) do        
        if v:GetUnitName() == "sunny" and v.thtd_combo_fairyList ~= nil then       
            table.insert(fairyList,v.thtd_combo_fairyList)
        end
    end
    return fairyList
end

function IsUnitInFairy(fairyArea,unit)    
    local pos1 = fairyArea.sunny:GetAbsOrigin()
    local pos2 = fairyArea.star:GetAbsOrigin()
    local pos3 = fairyArea.luna:GetAbsOrigin()

    local origin = unit:GetAbsOrigin()

    if IsInTriangle(pos1,pos2,pos3,origin) == true then
        return true
    else
        return false
    end
end
      
function GetTriangleArea(p0,p1,p2)
    local ab = Vector(p1.x - p0.x, p1.y - p0.y, 0)
    local bc = Vector(p2.x - p1.x, p2.y - p1.y, 0)
    return math.abs((ab.x * bc.y - ab.y * bc.x) / 2.0)
end
     
function IsInTriangle(a,b,c,d)
    local sabc = GetTriangleArea(a, b, c)
    local sadb = GetTriangleArea(a, d, b)
    local sbdc = GetTriangleArea(b, d, c)
    local sadc = GetTriangleArea(a, d, c)
          
    local sumSuqar = sadb + sbdc + sadc
          
    if (-5 < (sabc - sumSuqar) and (sabc - sumSuqar) < 5) then 
        return true 
    else
        return false
    end    
end

--判断三点是否一条线
function IsThreePointsOnOneLine(p1,p2,p3)
    local a = math.floor(GetDistanceBetweenTwoVec2D(p1, p2) + 0.5)
    local b = math.floor(GetDistanceBetweenTwoVec2D(p2, p3) + 0.5)
    local c = math.floor(GetDistanceBetweenTwoVec2D(p3, p1) + 0.5)
    local max = math.max(a, b, c)
    if a == max and a == (b + c) then return true end
    if b == max and b == (a + c) then return true end
    if c == max and c == (a + b) then return true end
    return false
end

--求三角形的重心和最大半径
function GetCircleCenterAndRadius(p1,p2,p3)   
    local center = Vector((p1.x + p2.x + p3.x)/3, (p1.y + p2.y + p3.y)/3, 0)  
    return center, math.max(math.floor(GetDistanceBetweenTwoVec2D(p1, center) + 0.5), math.floor(GetDistanceBetweenTwoVec2D(p2, center) + 0.5), math.floor(GetDistanceBetweenTwoVec2D(p3, center) + 0.5))
end

-- 两点连线上任意点的坐标
function GetTwoVectorSub(pos1, pos2, p1vsp2)
    --Px点到两端点的距离P1Px与PxP2比值为p1vsp2
    local x=(pos1.x + p1vsp2 * pos2.x)/(1+p1vsp2)
    local y=(pos1.y + p1vsp2 * pos2.y)/(1+p1vsp2)
    local z=(pos1.z + p1vsp2 * pos2.z)/(1+p1vsp2)
    return Vector(x, y, z)
end

--求三角形的外接圆圆心和半径，如果三点共线则返回nil
function GetOuterCircleCenterAndRadius(p1,p2,p3)     
    local a = math.floor(GetDistanceBetweenTwoVec2D(p1, p2) + 0.5)
    local b = math.floor(GetDistanceBetweenTwoVec2D(p2, p3) + 0.5)
    local c = math.floor(GetDistanceBetweenTwoVec2D(p3, p1) + 0.5)

    --如果在一条线上，则返回中点
    local max = math.max(a, b, c)
    if a == max and a == (b + c) then 
        local x = (p1.x + p2.x) / 2
        local y = (p1.y + p2.y) / 2
        local r = a / 2
        return Vector(math.floor(x + 0.5),math.floor(y + 0.5),0), r
    end
    if b == max and b == (a + c) then 
        local x = (p2.x + p3.x) / 2
        local y = (p2.y + p3.y) / 2
        local r = b / 2
        return Vector(math.floor(x + 0.5),math.floor(y + 0.5),0), r
    end
    if c == max and c == (a + b) then 
        local x = (p1.x + p3.x) / 2
        local y = (p1.y + p3.y) / 2
        local r = c / 2
        return Vector(math.floor(x + 0.5),math.floor(y + 0.5),0), r
    end

    --外接圆半径
    local p = (a + b +c)/2
    local s = math.sqrt(p*(p-a)*(p-b)*(p-c))
    local r = math.floor(a*b*c/(4*s) + 0.5)

    --外接圆圆心
    local x1  =  p1.x
	local x2  =  p2.x
	local x3  =  p3.x
	local y1  =  p1.y
	local y2  =  p2.y
	local y3  =  p3.y
    local t1 = x1*x1+y1*y1
	local t2 = x2*x2+y2*y2
	local t3 = x3*x3+y3*y3
	local temp = x1*y2+x2*y3+x3*y1-x1*y3-x2*y1-x3*y2
	local x = (t2*y3+t1*y2+t3*y1-t2*y1-t3*y2-t1*y3)/temp/2
    local y = (t3*x2+t2*x1+t1*x3-t1*x2-t2*x3-t3*x1)/temp/2
    
    return Vector(math.floor(x + 0.5),math.floor(y + 0.5),0), r
end

--求三角形的内接圆圆心和半径
function GetInnerCircleCenterAndRadius(p0,p1,p2)  
    local x1 = p0.x 
    local x2 = p1.x
    local x3 = p2.x
    local y1 = p0.y
    local y2 = p1.y
    local y3 = p2.y
 
    local x=((y2-y1)*(y3*y3-y1*y1+x3*x3-x1*x1)-(y3-y1)*(y2*y2-y1*y1+x2*x2-x1*x1))/(2*(x3-x1)*(y2-y1)-2*((x2-x1)*(y3-y1)))
    local y=((x2-x1)*(x3*x3-x1*x1+y3*y3-y1*y1)-(x3-x1)*(x2*x2-x1*x1+y2*y2-y1*y1))/(2*(y3-y1)*(x2-x1)-2*((y2-y1)*(x3-x1)))
 
    local radius = math.sqrt((p0.x - x)*(p0.x - x) + (p0.y - y)*(p0.y - y))
 
    return Vector(x,y,0),radius
end

-- 获取各刷怪路线的偏移位置，x, y 为偏移量，增长方向默认为左右集中，一致向下
function GetSpawnLineOffsetVector(lineid,vec,x,y) 
    -- lineid从左上顺时针
    if lineid == 2 or lineid == 3 then 
        return vec + Vector(-x,-y,0)
    else
        return vec + Vector(x,-y,0)    
    end
end

-- 判断单位是否有效，即非空、存活、激活
function THTD_IsValid(unit)
    if unit ~= nil and unit:IsNull() == false and unit:IsAlive() and unit:HasModifier("modifier_touhoutd_release_hidden") == false then
        return true
    else
        return false
    end
end

-- 获取单位所对位的玩家英雄
function THTD_GetHero(caster)
    local hero = nil
	if THTD_IsValid(caster) then 
		if caster:THTD_IsTower() then 
			hero = caster:GetOwner()
		elseif caster:GetUnitName() == "npc_dota_hero_lina" then 
			hero = caster
		else
			local player = caster:GetPlayerOwner()
			if player then 
				hero = player:GetAssignedHero()
			end
		end		
    end
    return hero    
end

-- 获取玩家英雄，使用实体变量方式，兼容玩家离线
function THTD_GetHeroFromPlayerId(playerid)
    local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
    if heroes == nil or #heroes == 0 then return nil end
    for _,hero in pairs(heroes) do
        if hero.thtd_player_id == playerid then return hero end
    end
    return nil      
end

-- 将玩家id转换为刷怪路线id
function THTD_GetSpawnIdFromPlayerId(playerid)
    local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
    if heroes == nil or #heroes == 0 then return nil end
    for _,hero in pairs(heroes) do
        if hero.thtd_player_id == playerid then return hero.thtd_spawn_id end
    end
    return nil      
end

-- PlayerResource:ModifyGold 强化版，超出金钱将保存
thtd_extra_gold = {[0] = 0,[1] = 0,[2] = 0,[3] = 0}
function THTD_ModifyGoldEx(playerid, gold, reliable, flag)
    if flag == nil then flag = DOTA_ModifyGold_Unspecified end
    if reliable ~= true then reliable = false end

    if thtd_extra_gold[playerid] == nil then
		thtd_extra_gold[playerid] = 0
    end
    
    local current_gold = PlayerResource:GetGold(playerid)
    local add_gold = gold
	if current_gold + gold > 99999 then
		add_gold = math.min(gold, 99999-current_gold)
		thtd_extra_gold[playerid] = thtd_extra_gold[playerid] + (gold - add_gold)		
	elseif thtd_extra_gold[playerid] > 0 then
		add_gold = math.min(thtd_extra_gold[playerid], 99999-(gold+current_gold))		
		thtd_extra_gold[playerid] = thtd_extra_gold[playerid] - add_gold
    end
    PlayerResource:ModifyGold(playerid, add_gold, reliable, flag)

	THTD_RefreshExtraGold(playerid)     
end

-- 刷新超出上限金钱显示
function THTD_RefreshExtraGold(playerid)
	local hero = THTD_GetHeroFromPlayerId(playerid)
    if thtd_extra_gold[playerid] > 1000 then	
        if not hero:HasModifier("modifier_touhoutd_extra_gold") then 
            local player = hero:GetPlayerOwner()
            if player then 
                CustomGameEventManager:Send_ServerToPlayer(player, "show_message", {msg="gold_over_tip", duration=10, params={}, color="#ff0"})
            end
        end
		hero:FindAbilityByName("ability_touhoutd_kill"):ApplyDataDrivenModifier(hero, hero, "modifier_touhoutd_extra_gold", nil)		
		hero:SetModifierStackCount("modifier_touhoutd_extra_gold", hero, math.floor(thtd_extra_gold[playerid] / 1000))
	elseif hero:HasModifier("modifier_touhoutd_extra_gold") then
		hero:FindModifierByName("modifier_touhoutd_extra_gold"):Destroy()
    end       
end


function THTD_IsTempleOfGodTower(unit)
    local unitName = unit:GetUnitName()
    if unitName == "miko" or unitName == "soga" or unitName == "futo" or unitName == "yoshika" or unitName == "seiga" then
        return true
    else
        return false
    end    
end

function THTD_IsTempleOfGodCanBuffedTower(unit)
    local unitName = unit:GetUnitName()
    if unitName == "soga" or unitName == "futo" or unitName == "yoshika" or unitName == "seiga" then
        return true
    else
        return false
    end    
end

function THTD_GetTempleOfGodBuffedTowerStarCount(caster)
    local hero = THTD_GetHero(caster)
    if hero == nil then return 0 end

    local star = 0
    for k,v in pairs(hero.thtd_hero_tower_list) do
        if THTD_IsValid(v) and THTD_IsTempleOfGodTower(v) then            
            if v:HasModifier("modifier_miko_02_buff") or v:GetUnitName() == "miko" then
                star = star + v:THTD_GetStar()
            end            
        end
    end
    return star
end


-- 不包括圣白莲
function THTD_IsStarLotusTower(unit)    
    local unitName = unit:GetUnitName()
    if unitName == "nazrin" or unitName == "toramaru" or unitName == "minamitsu" or unitName == "nue" or unitName == "kogasa" then
        return true
    else
        return false
    end    
end

function THTD_GetStarLotusBuffedTowerCount(caster)
    local hero = THTD_GetHero(caster)
    if hero == nil then return 0 end

    local count = 0
    for k,v in pairs(hero.thtd_hero_tower_list) do
        if THTD_IsValid(v) and THTD_IsStarLotusTower(v) then            
            if v:HasModifier("modifier_byakuren_03_buff") then
                count = count + 1
            end            
        end
    end
    return count
end

function THTD_GetStarLotusTowerCount(caster)
    local hero = THTD_GetHero(caster)
    if hero == nil then return 0 end

    local count = 0
    for k,v in pairs(hero.thtd_hero_tower_list) do
        local unitName = v:GetUnitName()
        if unitName == "byakuren" or unitName == "nazrin" or unitName == "toramaru" or unitName == "minamitsu" or unitName == "nue" or unitName == "kogasa" then
            count = count + 1
        end
    end
    return count
end


function THTD_GetFirstTowerByName(caster, towerName)
    local hero = THTD_GetHero(caster)
    if hero == nil then return nil end

    for k,v in pairs(hero.thtd_hero_tower_list) do
        if THTD_IsValid(v) and v:GetUnitName() == towerName then
            return v
        end
    end
    return nil
end

function THTD_FindFriendlyUnitsAll(caster)
    local hero = THTD_GetHero(caster)
    if hero == nil then return {} end

    return hero.thtd_hero_tower_list
end

function THTD_FindFriendlyUnitsInRadius(caster,point,radius)
    local hero = THTD_GetHero(caster)
    if hero == nil then return {} end
    
    local targets = {}
    for k,v in pairs(hero.thtd_hero_tower_list) do
        if THTD_IsValid(v) then
            if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                table.insert(targets,v)
            end
        end
    end
    return targets   
end

function THTD_FindUnitsInRadius(caster,point,radius)
    local hero = THTD_GetHero(caster)
    if hero == nil then return {} end

    
    local id = hero.thtd_player_id
    local targets = {}
    if id ~= nil then
        for k,v in pairs(THTD_EntitiesRectInner[id]) do
            if THTD_IsValid(v) and v.thtd_is_outer ~= true then
                if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                    if v.thtd_is_yukari_01_hidden ~= true then
                        table.insert(targets,v)
                    end
                end                
            end
        end

        if not(point.x+radius < 4432 and point.x-radius > -4432 and point.y+radius < 3896 and point.y-radius > -3896) then
            for k,v in pairs(THTD_EntitiesRectOuter) do
                if THTD_IsValid(v) then
                    if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                        if v.thtd_is_yukari_01_hidden ~= true then
                            table.insert(targets,v)
                        end
                    end                    
                end
            end
        end        
    end
    return targets
end

function THTD_FindUnitsAll(caster)
    local hero = THTD_GetHero(caster)
    if hero == nil then return {} end
    
    local id = hero.thtd_player_id
    local targets = {}
    if id ~= nil then
        for k,v in pairs(THTD_EntitiesRectInner[id]) do
            if THTD_IsValid(v) and v.thtd_is_outer ~= true then
                if v.thtd_is_yukari_01_hidden ~= true then
                    table.insert(targets,v)
                end                
            end
        end

        for k,v in pairs(THTD_EntitiesRectOuter) do
            if THTD_IsValid(v) then
                if v.thtd_is_yukari_01_hidden ~= true then
                    table.insert(targets,v)
                end                
            end
        end        
    end    
    return targets
end

function THTD_FindUnitsInner(caster)
    local hero = THTD_GetHero(caster)
    if hero == nil then return {} end
    
    local id = hero.thtd_player_id
    local targets = {}
    if id ~= nil then
        for k,v in pairs(THTD_EntitiesRectInner[id]) do
            if THTD_IsValid(v) and v.thtd_is_outer ~= true then
                if v.thtd_is_yukari_01_hidden ~= true then
                    table.insert(targets,v)
                end               
            end
        end        
    end
    return targets
end

function THTD_FindUnitsOuter(caster)
    local hero = THTD_GetHero(caster)
    if hero == nil then return {} end
    
    local id = hero.thtd_player_id
    local targets = {}
    if id ~= nil then
        for k,v in pairs(THTD_EntitiesRectOuter) do
            if THTD_IsValid(v) then
                if v.thtd_is_yukari_01_hidden ~= true then
                    table.insert(targets,v)
                end                
            end
        end        
    end
    return targets
end

function THTD_HasUnitsInRadius(caster,point,radius)
    local hero = THTD_GetHero(caster)
    if hero == nil then return false end
    
    local id = hero.thtd_player_id   
    if id ~= nil then
        for k,v in pairs(THTD_EntitiesRectInner[id]) do
            if THTD_IsValid(v) and v.thtd_is_outer ~= true then
                if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                    if v.thtd_is_yukari_01_hidden ~= true then
                        return true
                    end
                end                
            end
        end

        if not(point.x+radius < 4432 and point.x-radius > -4432 and point.y+radius < 3896 and point.y-radius > -3896) then
            for k,v in pairs(THTD_EntitiesRectOuter) do
                if THTD_IsValid(v) then
                    if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                        if v.thtd_is_yukari_01_hidden ~= true then
                            return true
                        end
                    end                    
                end
            end
        end           
    end
    
    return false
end

function THTD_IsUnitInGroup(unit,group)
    for k,v in pairs(group) do
        if v == unit then
            return true
        end
    end
    return false
end


-- 单位固有增减伤百分比更新
function ModifyDamageSpecialPercentage(unit, percentage)
    if unit.thtd_damage_special_incoming == nil then
        unit.thtd_damage_special_incoming = 0
    end    
    unit.thtd_damage_special_incoming = unit.thtd_damage_special_incoming + percentage
end

-- 单位全局增减伤百分比更新
function ModifyDamageIncomingPercentage(unit, percentage)
    if unit.thtd_damage_incoming == nil then
        unit.thtd_damage_incoming = 0
    end    
    unit.thtd_damage_incoming = unit.thtd_damage_incoming + percentage
end

-- 单位魔法伤害增减伤百分比更新
function ModifyMagicalDamageIncomingPercentage(unit, percentage)      
    if unit.thtd_magical_damage_incoming == nil then
        unit.thtd_magical_damage_incoming = 0
    end    
    unit.thtd_magical_damage_incoming = unit.thtd_magical_damage_incoming + percentage
end

-- 单位物理伤害增减伤百分比更新
function ModifyPhysicalDamageIncomingPercentage(unit, percentage)     
    if unit.thtd_physical_damage_incoming == nil then
        unit.thtd_physical_damage_incoming = 0
    end    
    unit.thtd_physical_damage_incoming = unit.thtd_physical_damage_incoming + percentage
end

-- 物理输出伤害增减伤百分比更新
function ModifyPhysicalDamageOutgoingPercentage(caster, percentage)       
    if caster.thtd_physical_damage_outgoing == nil then
        caster.thtd_physical_damage_outgoing = 0
    end
    caster.thtd_physical_damage_outgoing = caster.thtd_physical_damage_outgoing + percentage    
end

-- 魔法输出伤害增减伤百分比更新
function ModifyMagicalDamageOutgoingPercentage(caster, percentage)    
    if caster.thtd_magical_damage_outgoing == nil then
        caster.thtd_magical_damage_outgoing = 0
    end
    caster.thtd_magical_damage_outgoing = caster.thtd_magical_damage_outgoing + percentage    
end


function UnitStunTarget(caster,target,stuntime)
    target:AddNewModifier(caster, nil, "modifier_stunned", {duration=stuntime})
end

-- 设置无碰撞体积相位状态
function UnitNoCollision( caster,target,duration)
    target:AddNewModifier(caster, nil, "modifier_phased", {duration=duration})
end

function UnitNoPathingfix(caster,target,duration)
    target:AddNewModifier(caster, nil, "modifier_spectre_spectral_dagger_path_phased", {duration=duration})
end


function GetDistanceBetweenTwoVec2D(a, b)
    local xx = (a.x-b.x)
    local yy = (a.y-b.y)
    return math.sqrt(xx*xx + yy*yy)
end

function GetDistanceBetweenTwoEntity(ent1,ent2)
     local pos_1=ent1:GetOrigin()
     local pos_2=ent2:GetOrigin() 
     local x_=(pos_1[1]-pos_2[1])^2
     local y_=(pos_1[2]-pos_2[2])^2
     local dis=(x_+y_)^(0.5)
     return dis
end

function GetRadBetweenTwoVec2D(a,b)
    local y = b.y - a.y
    local x = b.x - a.x
    return math.atan2(y,x)
end

function GetRadBetweenTwoVecZ3D(a,b)
    local y = b.y - a.y
    local x = b.x - a.x
    local z = b.z - a.z
    local s = math.sqrt(x*x + y*y)
    return math.atan2(z,s)
end

--aVec:原点向量
--rectOrigin：单位原点向量
--rectWidth：矩形宽度
--rectLenth：矩形长度
--rectRad：矩形相对Y轴旋转角度
function IsRadInRect(aVec,rectOrigin,rectWidth,rectLenth,rectRad)
    local aRad = GetRadBetweenTwoVec2D(rectOrigin,aVec)
    local turnRad = aRad + (math.pi/2 - rectRad)
    local aRadius = GetDistanceBetweenTwoVec2D(rectOrigin,aVec)
    local turnX = aRadius*math.cos(turnRad)
    local turnY = aRadius*math.sin(turnRad)
    local maxX = rectWidth/2
    local minX = -rectWidth/2
    local maxY = rectLenth
    local minY = 0
    if(turnX<maxX and turnX>minX and turnY>minY and turnY<maxY)then
        return true
    else
        return false
    end
    return false
end


function IsValueInTable(Table,v)
    if Table == nil then return false end
    if type(Table) ~= "table" then return false end
    for i= 1,#Table do
        if v == Table[i] then
            return true
        end
    end
    return false
end

-- cx = 目标的x
-- cy = 目标的y
-- ux = math.cos(theta)   (rad是caster和target的夹角的弧度制表示)
-- uy = math.sin(theta)
-- r = 目标和原点之间的距离
-- theta = 夹角的弧度制
-- px = 原点的x
-- py = 原点的y
-- 返回 true or false(目标是否在扇形内，在的话=true，不在=false)
function IsPointInCircularSector(cx,cy,ux,uy,r,theta,px,py)
    local dx = px - cx
    local dy = py - cy

    local length = math.sqrt(dx * dx + dy * dy)

    if (length > r) then
        return false
    end

    local vec = Vector(dx,dy,0):Normalized()
    return math.acos(vec.x * ux + vec.y * uy) < theta
end 

--删除table中的table，第二个参数为子表
function TableRemoveSubTable(table_1 , table_2)
    for i,v in pairs(table_1) do
        if v == table_2 then
            table.remove(table_1,i)
            return
        end
    end
end

GameRules.AbilityBehavior = {             
    DOTA_ABILITY_BEHAVIOR_ATTACK,            
    DOTA_ABILITY_BEHAVIOR_AURA,     
    DOTA_ABILITY_BEHAVIOR_AUTOCAST,    
    DOTA_ABILITY_BEHAVIOR_CHANNELLED,   
    DOTA_ABILITY_BEHAVIOR_DIRECTIONAL,    
    DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET,    
    DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT, 
    DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK,   
    DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT,             
    DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING,    
    DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL,      
    DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE,   
    DOTA_ABILITY_BEHAVIOR_IGNORE_TURN ,        
    DOTA_ABILITY_BEHAVIOR_IMMEDIATE,         
    DOTA_ABILITY_BEHAVIOR_ITEM,              
    DOTA_ABILITY_BEHAVIOR_NOASSIST,            
    DOTA_ABILITY_BEHAVIOR_NONE,             
    DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN, 
    DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE,       
    DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES,      
    DOTA_ABILITY_BEHAVIOR_RUNE_TARGET,         
    DOTA_ABILITY_BEHAVIOR_UNRESTRICTED ,  
}

--判断单体技能
function CDOTABaseAbility:IsUnitTarget()
    local b = self:GetBehavior()

    if self:IsHidden() then b = b - 1 end
    for k,v in pairs(GameRules.AbilityBehavior) do
        repeat
            if v == 0 then break end
            b = b % v
        until true
    end

    if (b - DOTA_ABILITY_BEHAVIOR_AOE) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        b = b - DOTA_ABILITY_BEHAVIOR_AOE
    end

    if b == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        return true
    end
    return false
end

--判断点目标技能
function CDOTABaseAbility:IsPoint( )
    local b = self:GetBehavior()

     return bit.band(b,DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT
end

--判断无目标技能
function CDOTABaseAbility:IsNoTarget( )
    local b = self:GetBehavior()

    return bit.band(b,DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

--弹射函数 
--用于检测是否被此次弹射命中过
function CatapultFindImpact( unit,str )
    for i,v in pairs(unit.CatapultImpact) do
        if v == str then
            return true
        end
    end
    return false
end
 
--caster是施法者或者主要来源
--target是第一个目标
--ability是技能来源
--effectName是弹射的投射物
--move_speed是投射物的速率
--doge是表示能否被躲掉
--radius是每次弹射的范围
--count是弹射次数
--teams,types,flags获取单位的三剑客
--find_tpye是单位组按远近或者随机排列
--      FIND_CLOSEST
--      FIND_FARTHEST
--      FIND_UNITS_EVERYWHERE
function Catapult( caster,target,ability,effectName,move_speed,radius,count,teams,types,flags,find_tpye )
    print("Run Catapult")
 
    local old_target = caster
 
    --生成独立的字符串
    local str = DoUniqueString(ability:GetAbilityName())
    print("Catapult:"..str)
 
    --假设一个马甲
    local unit = {}
 
    --绑定信息
    --是否发射下一个投射物
    unit.CatapultNext = false
    unit.count_num = 0
    --本次弹射标识的字符串
    unit.CatapultThisProjectile = str
    unit.old_target = old_target
    --本次弹射的目标
    unit.CatapultThisTarget     = target
 
    --CatapultUnit用来存储unit
    if caster.CatapultUnit == nil then
        caster.CatapultUnit = {}
    end
 
    --把unit插入CatapultUnit
    table.insert(caster.CatapultUnit,unit)
 
    --用于决定是否发射投射物
    local fire = true
 
    --弹射最大次数
    local count_num = 0
     
    GameRules:GetGameModeEntity():SetContextThink(str,
        function( )
 
            --满足达到最大弹射次数删除计时器
            if count_num>=count then
                print("Catapult impact :"..count_num)
                print("Catapult:"..str.." is over")
                return nil
            end
 
 
            if unit.CatapultNext then
 
                --获取单位组
                local group = THTD_FindUnitsInRadius(caster,target:GetOrigin(),radius)
                 
                --用于计算循环次数
                local num = 0
                for i=1,#group do
                    if group[i].CatapultImpact == nil then
                        group[i].CatapultImpact = {}
                    end
 
                    --判断是否命中
                    local impact = CatapultFindImpact(group[i],str)
 
                    if  impact == false then
 
                        --替换old_target
                        old_target = target
 
                        --新target
                        target = group[i]
 
                        --可以发射新投射物
                        fire = true
                        unit.count_num = count_num
                        --等待下一个目标
                        unit.old_target = old_target
                        unit.CatapultNext =false
 
                        --锁定当前目标
                        unit.CatapultThisTarget = target
                        break
                    end
                    num = num + 1
                end
 
                --如果大于等于单位组的数量那么就删除计时器
                if num >= #group then
                    --从CatapultUnit中删除unit
                    TableRemoveSubTable(caster.CatapultUnit,unit)
 
                    print("Catapult impact :"..count_num)
                    print("Catapult:"..str.." is over")
                    return nil
                end
            end
 
            --发射投射物
            if fire then
                fire = false
                count_num = count_num + 1
                local info = 
                {
                    Target = target,
                    Source = old_target,
                    Ability = ability,  
                    EffectName = effectName,
                    bDodgeable = false,
                    iMoveSpeed = move_speed,
                    bProvidesVision = true,
                    iVisionRadius = 300,
                    iVisionTeamNumber = caster:GetTeamNumber(),
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
                }
                projectile = ProjectileManager:CreateTrackingProjectile(info)               
            end
 
            return 0.05
        end,0)
end
 
--此函数在KV里面用OnProjectileHitUnit调用
function CatapultImpact( keys )
    local caster = keys.caster
    local target = keys.target
 
    --防止意外
    if caster.CatapultUnit == nil then
        caster.CatapultUnit = {}
    end
    if target.CatapultImpact == nil then
        target.CatapultImpact = {}
    end
 
    --挨个检测是否是弹射的目标
    for i,v in pairs(caster.CatapultUnit) do
         
        if v.CatapultThisProjectile ~= nil and v.CatapultThisTarget ~= nil then
 
            if v.CatapultThisTarget == target then
 
                --标记target被CatapultThisProjectile命中
                table.insert(target.CatapultImpact,v.CatapultThisProjectile)
 
                --允许发射下一次投射物
                v.CatapultNext = true
                return
            end
 
        end
    end
end

function PrintTestLog(str)
    print(str)
end


function ParticleManager:DestroyParticleSystem(effectIndex,bool)
    if effectIndex==nil then return end
    if(bool)then
        ParticleManager:DestroyParticle(effectIndex,true)
        ParticleManager:ReleaseParticleIndex(effectIndex) 
    else
        Timer.Wait 'Effect_Destroy_Particle' (4,
            function()
                ParticleManager:DestroyParticle(effectIndex,true)
                ParticleManager:ReleaseParticleIndex(effectIndex) 
            end
        )
    end
end

function ParticleManager:DestroyParticleSystemTime(effectIndex,time)
    if effectIndex==nil then return end
    Timer.Wait 'Effect_Destroy_Particle_Time' (time,
        function()
            ParticleManager:DestroyParticle(effectIndex,true)
            ParticleManager:ReleaseParticleIndex(effectIndex) 
        end
    )
end

function ParticleManager:DestroyParticleSystemTimeFalse(effectIndex,time)
    if effectIndex==nil then return end
    Timer.Wait 'Effect_Destroy_Particle_Time' (time,
        function()
            ParticleManager:DestroyParticle(effectIndex,false)
            ParticleManager:DestroyParticleSystem(effectIndex,false)
        end
    )
end

function ParticleManager:DestroyLinearProjectileSystem(effectIndex,bool)
    if effectIndex==nil then return end
    if(bool)then
        ProjectileManager:DestroyLinearProjectile(effectIndex)
    else
        Timer.Wait 'Effect_Destroy_Particle' (8,
            function()
                if effectIndex==nil then return end
                ProjectileManager:DestroyLinearProjectile(effectIndex)
            end
        )
    end
end

function ParticleManager:DestroyLinearProjectileSystemTime(effectIndex,time)
    if effectIndex==nil then return end
    Timer.Wait 'Effect_Destroy_Particle_Time' (time,
        function()
            if effectIndex==nil then return end
            ProjectileManager:DestroyLinearProjectile(effectIndex)
        end
    )
end


function ShushanCreateProjectileMoveToTargetPoint(projectileTable,caster,speed,acceleration1,acceleration2,func)
    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlForward(effectIndex,3,projectileTable.vVelocity:Normalized())

    local acceleration = acceleration1
    local ability = projectileTable.Ability
    local targets = {}
    local targets_remove = {}
    local dis = 0
    local reflexCount = 0
    local pString = DoUniqueString("projectile_string")
    local high = projectileTable.vSpawnOriginNew.z - GetGroundHeight(projectileTable.vSpawnOriginNew, nil)
    local fixedTime = 10.0
    local count = 0

    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end

            local vec = projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50
            dis = dis + speed/50

            -- 是否反射
            if projectileTable.bReflexByBlock~=nil and projectileTable.bReflexByBlock==true then
                --if GridNav:CanFindPath(projectileTable.vSpawnOriginNew,projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50)==false or GetHitCustomBlock(projectileTable.vSpawnOriginNew,projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50)~=nil then
                if GetHitCustomBlock(projectileTable.vSpawnOriginNew,projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50)~=nil then    
                    local inRad = GetRadBetweenTwoVec2D(vec,projectileTable.vSpawnOriginNew)
                    local blockRad = GetBlockTurning(inRad,projectileTable.vSpawnOriginNew)
                    projectileTable.vVelocity = Vector(math.cos(inRad-blockRad+math.pi),math.sin(inRad-blockRad+math.pi),0)
                    vec = projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50 
                    ParticleManager:SetParticleControlForward(effectIndex,3,projectileTable.vVelocity:Normalized())
                    reflexCount = reflexCount + 1
                    for k,v in pairs(targets_remove) do
                        if v:GetContext(pString)~=0 then
                            v:SetContextNum(pString,0,0)
                            table.remove(targets_remove,k)
                        end
                    end
                end
            end

            -- 是否判断击中墙壁
            if projectileTable.bStopByBlock~=nil and projectileTable.bStopByBlock==true then
                if GridNav:CanFindPath(projectileTable.vSpawnOriginNew,projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50)==false then
                    if(projectileTable.bDeleteOnHit)then
                        if func then func(nil,vec) end
                        ParticleManager:DestroyParticleSystem(effectIndex,true)
                        return nil
                    else
                        if func then func(nil,vec) end
                    end
                end
            end
            
            targets = THTD_FindUnitsInRadius(caster,vec,projectileTable.fStartRadius)
            
            if(targets[1]~=nil)then
                if(projectileTable.bDeleteOnHit)then
                    if func then func(targets[1],vec,reflexCount) end
                    ParticleManager:DestroyParticleSystem(effectIndex,true)
                    return nil
                elseif(projectileTable.bDeleteOnHit==false)then
                    for k,v in pairs(targets) do
                        if v:GetContext(pString)~=1 then
                            v:SetContextNum(pString,1,0)
                            table.insert(targets_remove,v)
                            if func then func(v,vec,reflexCount) end
                        end
                    end
                end
            end

            if(speed <= 0 and acceleration2 ~= 0)then
                acceleration = acceleration2
                speed = 0
                acceleration2 = 0
            end

            fixedTime = fixedTime - 0.02
            if(dis<projectileTable.fDistance and fixedTime > 0)then
                    ParticleManager:SetParticleControl(effectIndex,3,Vector(vec.x,vec.y,GetGroundHeight(vec, nil)+high))
                    projectileTable.vSpawnOriginNew = vec
                    speed = speed + acceleration
                    return 0.02
            else
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function ShushanCreateProjectileMoveToPoint(projectileTable,caster,targetPoint,speed,iVelocity,acceleration,func)
    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil) 
    ParticleManager:SetParticleControlForward(effectIndex,3,(projectileTable.vVelocity*iVelocity/50 + speed/50 * (targetPoint - caster:GetOrigin()):Normalized()):Normalized())

    local ability = projectileTable.Ability
    local targets = {}
    local targets_remove = {}
    local totalDistance = 0

    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end

            -- 向心力单位向量
            local vecCentripetal = (projectileTable.vSpawnOriginNew - targetPoint):Normalized()

            -- 向心力
            local forceCentripetal = speed/50

            -- 初速度单位向量
            local vecInVelocity = projectileTable.vVelocity

            -- 初始力
            local forceIn = iVelocity/50

            -- 投射物矢量
            local vecProjectile = vecInVelocity * forceIn + forceCentripetal * vecCentripetal

            local vec = projectileTable.vSpawnOriginNew + vecProjectile

            -- 投射物单位向量
            local particleForward = vecProjectile:Normalized()

            -- 目标和投射物距离
            local dis = GetDistanceBetweenTwoVec2D(targetPoint,vec)

            ParticleManager:SetParticleControlForward(effectIndex,3,particleForward)

            totalDistance = totalDistance + math.sqrt(forceIn*forceIn + forceCentripetal*forceCentripetal)

            if(dis<projectileTable.fEndRadius)then
                if(projectileTable.bDeleteOnHit)then
                    if func then func(projectileTable.vSpawnOriginNew) end
                    ParticleManager:DestroyParticleSystem(effectIndex,true)
                    return nil
                end
            end

            if(totalDistance<projectileTable.fDistance and dis>=projectileTable.fEndRadius)then
                ParticleManager:SetParticleControl(effectIndex,3,vec)
                projectileTable.vSpawnOriginNew = vec
                speed = speed + acceleration
                return 0.02
            else
                if func then func(projectileTable.vSpawnOriginNew) end
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function ShushanCreateProjectileMoveToTarget(projectileTable,caster,target,speed,iVelocity,acceleration,func)
    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil) 
    ParticleManager:SetParticleControlForward(effectIndex,3,(projectileTable.vVelocity*iVelocity/50 + speed/50 * (target:GetOrigin() - caster:GetOrigin()):Normalized()):Normalized())

    local ability = projectileTable.Ability
    local targets = {}
    local targets_remove = {}
    local totalDistance = 0

    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            if target:IsNull() or target==nil then
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end

            -- 向心力单位向量
            local vecCentripetal = (projectileTable.vSpawnOriginNew - target:GetOrigin()):Normalized()

            -- 向心力
            local forceCentripetal = speed/50

            -- 初速度单位向量
            local vecInVelocity = projectileTable.vVelocity

            -- 初始力
            local forceIn = iVelocity/50

            -- 投射物矢量
            local vecProjectile = vecInVelocity * forceIn + forceCentripetal * vecCentripetal

            local vec = projectileTable.vSpawnOriginNew + vecProjectile

            -- 投射物单位向量
            local particleForward = vecProjectile:Normalized()

            -- 目标和投射物距离
            local dis = GetDistanceBetweenTwoVec2D(target:GetOrigin(),vec)

            ParticleManager:SetParticleControlForward(effectIndex,3,particleForward)

            totalDistance = totalDistance + math.sqrt(forceIn*forceIn + forceCentripetal*forceCentripetal)

            if dis < projectileTable.fStartRadius then
                targets = THTD_FindUnitsInRadius(caster,vec,projectileTable.fStartRadius)

                if(targets[1]~=nil)then
                    if(projectileTable.bDeleteOnHit)then
                        if func then func(targets[1],projectileTable.vSpawnOriginNew) end
                        ParticleManager:DestroyParticleSystem(effectIndex,true)
                        return nil
                    else
                        if #targets_remove==0 then
                            table.insert(targets_remove,targets[1])
                            if func then func(targets[1],projectileTable.vSpawnOriginNew) end
                        else
                            for k,v in pairs(targets) do
                                for k1,v1 in pairs(targets_remove) do
                                    if v~=v1 then
                                        table.insert(targets_remove,v)
                                        if func then func(v,projectileTable.vSpawnOriginNew) end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if(totalDistance<projectileTable.fDistance and dis>=projectileTable.fEndRadius)then
                ParticleManager:SetParticleControl(effectIndex,3,vec)
                projectileTable.vSpawnOriginNew = vec
                speed = speed + acceleration
                return 0.02
            else
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function ShushanCreateProjectileThrowToTargetPoint(projectileTable,caster,targetPoint,speed,upSpeed,func)
    local ability = projectileTable.Ability
    local targets = {}
    local targets_remove = {}
    local totalDistance = 0

    -- 过程时间
    local distance = GetDistanceBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
    local t = distance/speed

    -- 重力方向
    local vecGravity = Vector(0,0,-1)

    local PV = targetPoint.z - 128 - caster:GetOrigin().z

    -- 重力大小
    local gravity = 0.02 * ((2*upSpeed+PV/16)/t)

    -- 初速度单位向量
    local vecInVelocity = projectileTable.vVelocity

    -- 初始水平方向力
    local forceIn = 0.02 * speed

    -- 投射物矢量
    local vecProjectile = vecInVelocity * forceIn + gravity * vecGravity

    -- 投射物单位向量
    local particleForward = vecProjectile:Normalized()

    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil) 
    ParticleManager:SetParticleControlForward(effectIndex,3,caster:GetForwardVector())

    local count = 0

    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end

            distance = distance - forceIn
            if distance<0 then
                forceIn = 0
            end

            -- 投射物矢量
            vecProjectile = vecInVelocity * forceIn + upSpeed * vecGravity

            local vec = projectileTable.vSpawnOriginNew + vecProjectile

            totalDistance = totalDistance + math.sqrt(forceIn*forceIn + gravity*gravity)

            if(projectileTable.vSpawnOriginNew.z+128>targetPoint.z or t > t/2)then
                ParticleManager:SetParticleControl(effectIndex,3,vec)
                projectileTable.vSpawnOriginNew = vec
                upSpeed = upSpeed - gravity
                t = t - 0.02
                return 0.02
            else
                targets = THTD_FindUnitsInRadius(caster,vec,projectileTable.fStartRadius)
                if func then func(targets) end
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function GetBlockTurning(face,pos)
    local vface = face

    local hitblock = GetHitCustomBlock(pos,pos + Vector(math.cos(vface/180*math.pi),math.sin(vface/180*math.pi),0)*50)

    if hitblock~=nil then
        return 90
    end
    return 90
end

function GetBlockHeight(rad,pos)
    for i=0,200 do
        local gridPos = pos + Vector(math.cos(rad),math.sin(rad),0)*i
        local height = GetGroundHeight(gridPos,nil)
        if height > pos.z + 128 then
            return height
        end
    end
    return 0
end

function GetHitCustomBlock(vec,pos)
    for k,v in pairs(THTD_Custom_Hit_Block) do
        local circlePoint = v.circlePoint
        local dis1 = GetDistanceBetweenTwoVec2D(vec,circlePoint)
        local dis2 = GetDistanceBetweenTwoVec2D(pos,circlePoint)

        if dis1-50 < v.radius and dis2+50 >= v.radius then
            return v
        end
    end
    return nil
end

function IsAroundBlock(pos)
    for k,v in pairs(THTD_Custom_Hit_Block) do
        local circlePoint = v.circlePoint
        local dis = GetDistanceBetweenTwoVec2D(pos,circlePoint)

        if dis < v.radius then
            return true
        end
    end
    return false
end

function clone(object)  
    local lookup_table = {}  
    local function _copy(object)  
        if type(object) ~= "table" then  
            return object  
        elseif lookup_table[object] then  
            return lookup_table[object]  
        end  
        local newObject = {}  
        lookup_table[object] = newObject  
        for key, value in pairs(object) do  
            newObject[_copy(key)] = _copy(value)  
        end  
        return setmetatable(newObject, getmetatable(object))  
    end  
    return _copy(object)  
end  

--[[
    计时器函数Timer
    调用方法：
    Timer.Wait '5秒后打印一次' (5,
        function()
            print '我已经打印了一次文本'
        end
    )

    Timer.Loop '每隔1秒打印一次,一共打印5次' (1, 5,
        function(i)
            print('这是第' .. i .. '次打印')
            if i == 5 then
                print('我改变主意了,我还要打印10次,但是间隔降低为0.5秒')
                return 0.5, i + 10
            end
            if i == 10 then
                print('我好像打印的太多了,算了不打印了')
                return true
            end
        end
    )
]]

--全局计时器表
Timer = {}
local Timer = Timer
setmetatable(Timer, Timer)

function Timer.Wait(name)
    --[[if not dota_base_game_mode then
        print('WARNING: Timer created too soon!')
        return
    end]]--
    
    return function(t, func)
        local ent = GameRules:GetGameModeEntity()
        ent:SetThink(func, DoUniqueString(name), t)
    end
end

function Timer.Loop(name)
    --[[if not dota_base_game_mode then
        print('WARNING: Timer created too soon!')
        return
    end]]--
    
    return function(t, count, func)
        if not func then
            count, func = -1, count
        end
        
        local times = 0
        local function func2()
            times               = times + 1
            local t2, count2    = func(times)
            t, count = t2 or t, count2 or count
            
            if t == true or times == count then
                return nil
            end

            return t
        end
        
        local ent = GameRules:GetGameModeEntity()        
        ent:SetThink(func2, DoUniqueString(name), t)
    end
end

TIMERS_THINK = 0.01

if Timers == nil then
    print ( '[Timers] creating Timers' )
    Timers = {}
    Timers.__index = Timers
end

function Timers:new( o )
    o = o or {}
    setmetatable( o, Timers )
    return o
end

function Timers:start()
    Timers = self
    self.timers = {}
    
    local ent = Entities:CreateByClassname("info_target") -- Entities:FindByClassname(nil, 'CWorld')
    ent:SetThink("Think", self, "timers", TIMERS_THINK)
end

function Timers:Think()
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return
    end

    -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
    local now = GameRules:GetGameTime()

    -- Process timers
    for k,v in pairs(Timers.timers) do
    local bUseGameTime = true
    if v.useGameTime ~= nil and v.useGameTime == false then
        bUseGameTime = false
    end
    local bOldStyle = false
    if v.useOldStyle ~= nil and v.useOldStyle == true then
        bOldStyle = true
    end

    local now = GameRules:GetGameTime()
    if not bUseGameTime then
        now = Time()
    end

    if v.endTime == nil then
        v.endTime = now
    end
    -- Check if the timer has finished
    if now >= v.endTime then
        -- Remove from timers list
        Timers.timers[k] = nil
        
        -- Run the callback
        local status, nextCall = pcall(v.callback, GameRules:GetGameModeEntity(), v)

        -- Make sure it worked
        if status then
        -- Check if it needs to loop
        if nextCall then
            -- Change its end time

            if bOldStyle then
            v.endTime = v.endTime + nextCall - now
            else
            v.endTime = v.endTime + nextCall
            end

            Timers.timers[k] = v
        end

        -- Update timer data
        --self:UpdateTimerData()
        else
        -- Nope, handle the error
        Timers:HandleEventError('Timer', k, nextCall)
        end
    end
    end
    return TIMERS_THINK
end

function Timers:HandleEventError(name, event, err)
    print(err)

    -- Ensure we have data
    name = tostring(name or 'unknown')
    event = tostring(event or 'unknown')
    err = tostring(err or 'unknown')

    -- Tell everyone there was an error
    --Say(nil, name .. ' threw an error on event '..event, false)
    --Say(nil, err, false)

    -- Prevent loop arounds
    if not self.errorHandled then
    -- Store that we handled an error
    self.errorHandled = true
    end
end

function Timers:CreateTimer(name, args)
    if type(name) == "function" then
    args = {callback = name}
    name = DoUniqueString("timer")
    elseif type(name) == "table" then
    args = name
    name = DoUniqueString("timer")
    elseif type(name) == "number" then
    args = {endTime = name, callback = args}
    name = DoUniqueString("timer")
    end
    if not args.callback then
    print("Invalid timer created: "..name)
    return
    end


    local now = GameRules:GetGameTime()
    if args.useGameTime ~= nil and args.useGameTime == false then
    now = Time()
    end

    if args.endTime == nil then
    args.endTime = now
    elseif args.useOldStyle == nil or args.useOldStyle == false then
    args.endTime = now + args.endTime
    end

    Timers.timers[name] = args
end

function Timers:RemoveTimer(name)
    Timers.timers[name] = nil
end

function Timers:RemoveTimers(killAll)
    local timers = {}

    if not killAll then
    for k,v in pairs(Timers.timers) do
        if v.persist then
        timers[k] = v
        end
    end
    end

    Timers.timers = timers
end

Timers:start()


function PrecacheEveryThingFromKV( context )
    local kv_files = {
        "scripts/npc/npc_units_custom.txt",
        --[["scripts/npc/npc_abilities_custom.txt",
        "scripts/npc/npc_heroes_custom.txt",
        "scripts/npc/npc_abilities_override.txt",
        "npc_items_custom.txt"]]--
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            -- PrintTestLog("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
    local unitKv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    for k,v in pairs(unitKv) do      
        -- PrintTestLog("PRECACHE UNIT RESOURCE： "..k, k)
        PrecacheUnitByNameSync(k,context)       
    end
end

function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle",  value, context)
                -- PrintTestLog("PRECACHE PARTICLE RESOURCE", value)
            end
            if string.find(value, "vmdl") then
                PrecacheResource( "model",  value, context)
                -- PrintTestLog("PRECACHE MODEL RESOURCE", value)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile",  value, context)
                -- PrintTestLog("PRECACHE SOUND RESOURCE", value)
            end
        end
    end
end


-- 当物品被摧毁时执行，出现场景为升星、培养和出售，以及程序删除，将物品返回卡池，如果是卡牌则同时摧毁关联的塔
-- 参数：物品实体，玩家id，是否出售场景（不需要在本函数中进行删除物品）
function OnItemDestroyed(caster, item, isSold)
    --摧毁关联的塔
    local tower = item:THTD_GetTower()    
    if tower ~= nil then            
        tower:ForceKill(false)       
        item:THTD_ItemStarLevelRemove()
	end

    local itemName = item:GetAbilityName()
    --炸弹和福弹及赠送的不返回卡池
    if itemName ~= "item_2001" and item.card_poor_player_id ~= nil then
        THTD_AddItemToListByName(item.card_poor_player_id, itemName)
    end
    
    if isSold ~= true then 
        item:RemoveSelf()
    end
end

-- 同步卡池
function SetNetTableTowerPlayerList(playerId)
    local steamid = PlayerResource:GetSteamID(playerId)
    CustomNetTables:SetTableValue("TowerListInfo", "cardlist"..tostring(steamid), towerPlayerList[playerId+1])
end

-- 同步当前塔清单
function SetNetTableTowerList(caster)   
    local hero = THTD_GetHero(caster)
    if hero == nil then return end
   
    local towerList = {}    
    for k,v in pairs(hero.thtd_hero_tower_list) do
		towerList[k] = v:GetEntityIndex()	
	end
    local steamid = PlayerResource:GetSteamID(hero:GetPlayerOwnerID())
    CustomNetTables:SetTableValue("TowerListInfo", "towerlist"..tostring(steamid), towerList)
end

-- 本地图的技能秒杀，如果上限 maxDamage 大于0则按上限进行生命移除
function THTD_Kill(caster, target, maxDamage) 
    if THTD_IsValid(caster) and THTD_IsValid(target) then
        local tower = nil
        if caster:THTD_IsTower() then
            tower = caster
        elseif THTD_IsValid(caster.thtd_spawn_unit_owner) and caster.thtd_spawn_unit_owner:THTD_IsTower() then
            tower = caster.thtd_spawn_unit_owner
        end 
        
        if maxDamage == nil or maxDamage <= 0 or maxDamage >= target:GetHealth() then 
            local DamageTable = {
                ability = nil,
                victim = target, 
                attacker = caster, 
                damage = 10000, 
                damage_type = DAMAGE_TYPE_PURE, 
                damage_flags = DOTA_DAMAGE_FLAG_NONE
            }			
            
            if tower ~= nil then
                if tower.thtd_tower_damage == nil then 
                    tower.thtd_tower_damage = 0 
                end
                tower.thtd_tower_damage = tower.thtd_tower_damage + target:GetHealth() / 100
            end

            target:SetHealth(1)						
            UnitDamageTarget(DamageTable)      
        else
            target:SetHealth(math.max(1, target:GetHealth() - maxDamage))
            if tower ~= nil then
                if tower.thtd_tower_damage == nil then 
                    tower.thtd_tower_damage = 0 
                end
                tower.thtd_tower_damage = tower.thtd_tower_damage + maxDamage / 100
            end
        end
    end
end

-- 本地图的各卡技能秒杀，统一上限
function THTD_Ability_Kill(caster, target) 
    if SpawnSystem.CurWave > 120 then	
        local max_damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 125
        if GameRules.game_info.luck_card == caster:GetUnitName() then
            max_damage = max_damage * (1 + math.max(-90, GameRules.game_info.crit) / 100)
        end							
        THTD_Kill(caster, target, max_damage)
    else					
        THTD_Kill(caster, target, nil)
    end
end

-- 造成溢出伤害
function THTD_OverDamage(caster, ability, damage, point, range)
    if not THTD_IsValid(caster) then return end
    if damage == nil or damage <= 0 then return end

    local targetRange = range or 400
    local damageType = DAMAGE_TYPE_PURE
    if ability ~= nil then
        damageType = ability:GetAbilityDamageType()
    end

    caster:SetContextThink(DoUniqueString("thtd_over_damage"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            local targets = THTD_FindUnitsInRadius(caster,point,range)
            for k,v in pairs(targets) do
                local DamageTable = {
                    ability = ability,
                    victim = v, 
                    attacker = caster, 
                    damage = damage, 
                    damage_type = damageType,  
                    damage_flags = DOTA_DAMAGE_FLAG_NONE
                }
                UnitDamageTarget(DamageTable)
        
                local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_flandre/abiilty_flandre_02_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
                ParticleManager:SetParticleControl(effectIndex , 0 , v:GetOrigin())
                ParticleManager:DestroyParticleSystem(effectIndex,false)
            end            
            return nil
        end, 
    0.1)
end

-- 判断当前时间是否超过了指定时间，格式必须为 2019-04-19 10:00:00
function IsEndByDateTime(endDateTime)
    local date = GetSystemDate() --04/12/19  月 日 年
    local time = GetSystemTime() --00:10:43  时 分 秒
    local currentDateTime = "20"..string.sub(date,7,8).."-"..string.sub(date,1,2).."-"..string.sub(date,4,5).." "..time  
    if currentDateTime > endDateTime then     
        return true       
    else
        return false
    end     
end

-- http 发送函数

server_key = GetDedicatedServerKeyV2("mydota")   -- 不能泄露到客户端，可临时发布放在CustomNetTables在js中使用 $.Msg 显示

http = {}

http.config = table.loadkv("scripts/npc/config.txt")

function http.request(method, url, params, func)
    local req = CreateHTTPRequestScriptVM(method, url)  -- 需要放在Load阶段后，即DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP及以后阶段
    if params then 
        for k,v in pairs(params) do
            req:SetHTTPRequestGetOrPostParameter(tostring(k), tostring(v))
        end
    end
    req:SetHTTPRequestGetOrPostParameter("serverkey", server_key)
    req:SetHTTPRequestAbsoluteTimeoutMS(60 * 1000)
    req:Send(func)

    -- req:Send(function(result)
    --     if result.StatusCode == 200 then 
    --         local body = result.Body
    --     else
            
    --     end
    -- end)
end

function http.get(url, params, func)
    http.request("GET", url, params, func)
end

function http.post(url, params, func)
    http.request("POST", url, params, func)
end


http.api = {}
function http.api.GetWaveLocation(wave)		
    if wave == 0 or wave > 1000 then
        return "114.118000,22.101000"
    else
        return "114.118000,22.100"..tostring(1000 - wave)
    end
end

-- 获取游戏配置
-- 如果没有保存服务器返回 {"count":"0","info":"OK","infocode":"10000","status":1,"datas":[]}	
function http.api.getGameConfig(steamid_config, retryCount) 
    print("---- get data gameconfig start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    http.get(
        http.config.urlDataSearch,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableGameConfig,
            ['keywords'] = steamid_config,
            ['city'] = "全国",				
            ["page"] = "1"						
        },
        function(ret)       
            print("---- get data gameconfig end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then              
                -- print("------body text : ", ret.Body)
                local data = json.decode(ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.datas and data.datas[1] then                                         
                    CustomGameEventManager:Send_ServerToAllClients("thtd_game_code", {game_code = data.datas[1].game_code, game_msg = data.datas[1].game_msg, rank_limit = data.datas[1].rank_limit, text = ""})
                    GameRules.game_info.game_code = data.datas[1].game_code
                    GameRules.game_info.game_msg = data.datas[1].game_msg
                    GameRules.game_info.new_card_limit = data.datas[1].new_card_limit
                    GameRules.game_info.rank_limit = data.datas[1].rank_limit
                    GameRules.game_info.luck_card = data.datas[1].luck_card
                    GameRules.game_info.crit = data.datas[1].crit            
                    CustomNetTables:SetTableValue("CustomGameInfo", "game_info", GameRules.game_info)
                else
                    CustomGameEventManager:Send_ServerToAllClients("thtd_game_code", {game_code = "null", text = "服务器游戏配置数据不正确！"})
                end               					
            else
                if retryCount == nil or retryCount <= 1 then
                    CustomGameEventManager:Send_ServerToAllClients("thtd_game_code", {game_code = "null", text = "无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})
                else                   
                    http.api.getGameConfig(steamid_config, retryCount-1)
                end 
            end
        end
    )
end

-- 获取黑名单信息
-- 如果没有保存服务器返回 {"count":"0","info":"OK","infocode":"10000","status":1,"datas":[]}	
function http.api.getBlackOrWhitePlayer(playerid, retryCount) 
    if not PlayerResource:IsValidPlayerID(playerid) then return end

    print("---- get data banplayer start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    http.get(
        http.config.urlDataSearch,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableBanlist,
            ['keywords'] = steamid,
            ['city'] = "全国",				
            ["page"] = "1"						
        },
        function(ret)       
            print("---- get data banplayer end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then              
                -- print("------body text : ", ret.Body)
                local data = json.decode(ret.Body)                
                if data and data.datas and #data.datas > 0 then
                    GameRules.players_status[playerid].end_time = data.datas[1]["end_time"] 
                    GameRules.players_status[playerid].reason = data.datas[1]["_address"]                     
                    if IsEndByDateTime(GameRules.players_status[playerid]["end_time"]) then                      
                        GameRules.players_status[playerid].ban = 0
                        GameRules.players_status[playerid].vip = 0
                    elseif data.datas[1]["type"] == "ban" then 
                        GameRules.players_status[playerid].ban = 1
                        GameRules.players_status[playerid].vip = 0
                    elseif data.datas[1]["type"] == "vip" then 
                        GameRules.players_status[playerid].ban = 0
                        GameRules.players_status[playerid].vip = 1
                    end
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayersBlackAndWhiteList", GameRules.players_status)                   
                end
            else
                if retryCount == nil or retryCount <= 1 then
                    print("---- get data banplayer error: StatusCode ", ret.StatusCode)
                else                   
                    http.api.getBlackOrWhitePlayer(playerid, retryCount-1)
                end 
            end
        end
    )
end

-- 获取用户卡组数据
function http.api.getCardGroup(playerid, retryCount) 
    if not PlayerResource:IsValidPlayerID(playerid) then return end

    print("---- get data cardgroup start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    http.get(
        http.config.urlDataSearch,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableGroup,
            ['keywords'] = steamid,
            ['city'] = "全国",				
            ["page"] = "1"						
        },
        function(ret)       
            print("---- get data cardgroup end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then  
                local data = json.decode(ret.Body)
                -- print("------body text : ", ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.datas and #data.datas > 0 then
                    local maxPoint = 0
                    local maxIndex = 0
                    local ids = ""                    
                    for i = 1, #data.datas do
                        if maxIndex == 0 or (data.datas[i].point ~= nil and data.datas[i].point ~= "" and maxPoint < data.datas[i].point) then
                            maxPoint = data.datas[i].point
                            maxIndex = i
                        else
                            if ids == "" then 
                                ids = tostring(data.datas[i]._id)
                            else
                                ids = ids..","..tostring(data.datas[i]._id)
                            end
                        end                        
                    end
                    if ids ~= "" then
                        http.api.delete(http.config.tableGroup, ids)
                    end                   

                    local sourceData = data.datas[maxIndex]                    
                    local groupData = {}
                    groupData["_name"] = sourceData["_name"]
                    groupData["_id"] = sourceData["_id"]
                    groupData["point"] = sourceData["point"]  
                    groupData["group_max"] = sourceData["group_max"]
                    for k,v in pairs(sourceData) do 
                        if string.find(tostring(k), "cardgroup") ~= nil then
                            groupData[k] = http.api.decodeCardGroup(v)
                        end
                    end
                    if groupData["point"] == "" or tonumber(groupData["point"]) == nil then
                        groupData["point"] = 0           -- ""与空字符"\0"不相等
                    end
                    if groupData["group_max"] == "" or tonumber(groupData["group_max"]) == nil then                       
                        groupData["group_max"] = 3
                    end                    
                    
                    groupData["error"] = ""
                    GameRules.players_card_group[playerid] = groupData                   
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayerCardGroup"..steamid, groupData)                
                else
                    -- 新用户
                    local groupData = {}
                    groupData["_name"] = steamid
                    groupData["_id"] = "-1" --以此判定是否为新玩家
                    groupData["point"] = 0
                    groupData["group_max"] = 3
                    groupData["error"] = ""
                    GameRules.players_card_group[playerid] = groupData
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayerCardGroup"..steamid, groupData)        
                end               					
            else
                if retryCount == nil or retryCount <= 1 then
                    local groupData = {["_name"] = steamid, ["point"] = 0, ["group_max"] = 3, ["error"] = "无法连接服务器获取卡组，请断开重连以重新获取，StatusCode: "..tostring(ret.StatusCode)}
                    GameRules.players_card_group[playerid] = groupData
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayerCardGroup"..steamid, groupData)
                else                   
                    http.api.getCardGroup(playerid, retryCount-1) 
                end                 
            end
        end
    )
end

-- 保存老用户卡组数据
function http.api.saveCardGroup(playerid, groupkey, groupdata)  
    print("---- save data cardgroup start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100)) 
    local savedata = {}
    savedata["_id"] = GameRules.players_card_group[playerid]["_id"]
    savedata[groupkey] = http.api.encodeCardGroup(groupdata)    
    http.post(
        http.config.urlDataUpdate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableGroup,
            ['data'] = json.encode(savedata)
        },
        function(ret)       
            print("---- save data cardgroup end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then  
                local data = json.decode(ret.Body)
                -- print("------body text : ", ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.info == "OK" then
                    -- 成功返回 {"info":"OK","infocode":"10000","status":1} 
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_cardgroup", {code = 1, msg = ""})             
                else                                
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_cardgroup", {code = 0, msg = "返回信息："..ret.Body})
                end               					
            else              
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_cardgroup", {code = 0, msg = "无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})
            end
        end
    )
end

-- 保存老用户解锁的卡组位及扣除积分
function http.api.unlockCardGroup(playerid, retryCount)
    print("---- save data cardgroup unlock start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100)) 
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    local index = GameRules.players_card_group[playerid]["group_max"] + 1
    local point =  index * 500
    if GameRules.players_card_group[playerid]["point"] < point then return end
    local savedata = {}
    savedata["_id"] = GameRules.players_card_group[playerid]["_id"]
    savedata["point"] = GameRules.players_card_group[playerid]["point"] - point
    savedata["group_max"] = index

    http.post(
        http.config.urlDataUpdate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableGroup,
            ['data'] = json.encode(savedata)
        },
        function(ret)       
            print("---- save data cardgroup unlock end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then  
                local data = json.decode(ret.Body)
                -- print("------body text : ", ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.info == "OK" then
                    -- 成功返回 {"info":"OK","infocode":"10000","status":1}
                    GameRules.players_card_group[playerid]["point"] = savedata["point"]
                    GameRules.players_card_group[playerid]["group_max"] = savedata["group_max"]
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayerCardGroup"..steamid, GameRules.players_card_group[playerid])       
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_update_gamepoint", {point = savedata["point"]})
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_unlock_cardgroup", {code = 1, msg = ""})             
                else                                
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_unlock_cardgroup", {code = 0, msg = "返回信息："..ret.Body})
                end               					
            else      
                if retryCount == nil or retryCount <= 1 then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_unlock_cardgroup", {code = 0, msg = "无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})
                else                   
                    http.api.unlockCardGroup(playerid, retryCount-1)
                end 
            end
        end
    )
end

-- 保存新用户卡组数据
function http.api.saveFirstCardGroup(playerid, groupkey, groupdata)  
    print("---- save data cardgroup start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100)) 
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    local savedata = {}
    savedata["_name"] = steamid
    savedata["_location"] =  http.config.Location
    savedata["point"] = 0
    savedata[groupkey] = http.api.encodeCardGroup(groupdata)    
    http.post(
        http.config.urlDataCreate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableGroup,
            ['loctype'] = "1",
            ['data'] = json.encode(savedata)
        },
        function(ret)       
            print("---- save data cardgroup end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then  
                local data = json.decode(ret.Body)
                -- print("------body text : ", ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.info == "OK" then
                    -- 成功返回 { "info":"OK", "status":1, "_id":"283"}
                    GameRules.players_card_group[playerid][groupkey] = groupdata
                    GameRules.players_card_group[playerid]["_id"] = data["_id"]
		            CustomNetTables:SetTableValue("CustomGameInfo", "PlayerCardGroup"..steamid, GameRules.players_card_group[playerid])
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_cardgroup", {code = 1, msg = ""})             
                else                                
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_cardgroup", {code = 0, msg = "返回信息："..ret.Body})
                end               					
            else              
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_cardgroup", {code = 0, msg = "无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})
            end
        end
    )
end

-- 卡组数据明细解码，hex编码的卡组名称#卡牌及数量#卡牌及数量#...，卡牌及数量为卡牌物品后4位加数量，如00011表示item_0001，数量1个。
-- 输入 string： e68891e79a84e58da1e7bb84#20084#00023#00801#00922#000410#00571#20044#20194#20204
-- 返回 data : {"name":"我的卡组","item_2008":4,"item_0002":3,"item_0080":1,"item_0092":2,...}
function http.api.decodeCardGroup(cardString) 
    local retData = {}
	local a = string.split(cardString, "#")
	if a == nil or #a < 2 then return retData end
    retData["name"] = string.fromhex(a[1])
    for i=2, #a do	
        retData["item_"..string.sub(a[i],1,4)] = tonumber(string.sub(a[i],5,6))
    end
	return retData
end

-- 卡组数据明细编码，hex编码的卡组名称#卡牌及数量#卡牌及数量#...，卡牌及数量为卡牌物品后4位加数量，如00011表示item_0001，数量1个。
-- 输入data = {"name":"我的卡组","item_2008":4,"item_0002":3,"item_0080":1,"item_0092":2,...}
-- 返回string: e68891e79a84e58da1e7bb84#20084#00023#00801#00922#000410#00571#20044#20194#20204#00583#20174#00362#20074#00522#20154#20241#20014#20064#00885#20231#00077#20164#00068#00973#00341#00962#20021#00162#00412
function http.api.encodeCardGroup(cardGroup) 
    local retString = ""
    if cardGroup["name"] ~= nil then retString = string.tohex(cardGroup["name"]) end
	for k,v in pairs(cardGroup) do 
        if k ~= "name" then
            retString = retString.."#"..string.sub(k,6,9)..tostring(v)        
        end
    end
    return retString 
end

-- 保存老用户游戏积分
function http.api.saveGamePoint(playerid, point, retryCount)
    print("---- save data game point start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100)) 
    local savedata = {}
    savedata["_id"] = GameRules.players_card_group[playerid]["_id"]
    savedata["point"] = GameRules.players_card_group[playerid]["point"] + point

    http.post(
        http.config.urlDataUpdate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableGroup,
            ['data'] = json.encode(savedata)
        },
        function(ret)       
            print("---- save data game point end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then  
                local data = json.decode(ret.Body)
                -- print("------body text : ", ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.info == "OK" then
                    -- 成功返回 {"info":"OK","infocode":"10000","status":1}
                    GameRules.players_card_group[playerid]["point"] = savedata["point"]
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_update_gamepoint", {point = savedata["point"]})
                    if point > 0 then 
                        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_gamepoint", {code = 1, point = point, msg = ""})             
                    end
                else       
                    if point > 0 then                          
                        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_gamepoint", {code = 0, point = point, msg = "返回信息："..ret.Body})
                    end
                end               					
            else      
                if retryCount == nil or retryCount <= 1 then
                    if point > 0 then 
                        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_gamepoint", {code = 0, point = point, msg = "无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})
                    end
                else                   
                    http.api.saveGamePoint(playerid, point, retryCount-1)
                end 
            end
        end
    )
end

-- 保存新用户游戏积分
function http.api.saveFirstGamePoint(playerid, point, retryCount)  
    print("---- save data game point start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100)) 
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    local savedata = {}
    savedata["_name"] = steamid
    savedata["_location"] =  http.config.Location
    savedata["point"] = point   
    http.post(
        http.config.urlDataCreate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = http.config.tableGroup,
            ['loctype'] = "1",
            ['data'] = json.encode(savedata)
        },
        function(ret)       
            print("---- save data game point end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then  
                local data = json.decode(ret.Body)
                -- print("------body text : ", ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.info == "OK" then
                    -- 成功返回 { "info":"OK", "status":1, "_id":"283"}                   
                    GameRules.players_card_group[playerid]["_id"] = data["_id"]
                    GameRules.players_card_group[playerid]["point"] = savedata["point"]
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayerCardGroup"..steamid, GameRules.players_card_group[playerid])
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_update_gamepoint", {point = savedata["point"]})
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_gamepoint", {code = 1, point = point, msg = ""})             
                else                                
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_gamepoint", {code = 0, point = point, msg = "返回信息："..ret.Body})
                end               					
            else 
                if retryCount == nil or retryCount <= 1 then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_save_gamepoint", {code = 0, point = point, msg = "无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})
                else                   
                    http.api.saveFirstGamePoint(playerid, point, retryCount-1)  
                end 
            end
        end
    )
end

-- 奖励游戏积分
function http.api.giveGamePoint(hero)  
    local difficulty = GameRules:GetCustomGameDifficulty()
    local heroes = Entities:FindAllByClassname("npc_dota_hero_lina")
    if difficulty < 6 then
        local names = ""
        for _,hero in pairs(heroes) do	
            if hero.thtd_gameover ~= true then 
                if names == "" then 
                    names = PlayerResource:GetPlayerName(hero.thtd_player_id)
                else
                    names = names.."，"..PlayerResource:GetPlayerName(hero.thtd_player_id)
                end
                if GameRules.players_card_group[hero.thtd_player_id]["_id"] ~= nil then
                    if GameRules.players_card_group[hero.thtd_player_id]["_id"] == "-1" then
                        http.api.saveFirstGamePoint(hero.thtd_player_id, 5*difficulty, 5)
                    else 
                        http.api.saveGamePoint(hero.thtd_player_id, 5*difficulty, 5)
                    end
                end                
            end
        end       
        GameRules:SendCustomMessage("<font color='yellow'>通关奖励游戏积分："..tostring(5*difficulty).." ，通关玩家："..names.."</font>", DOTA_TEAM_GOODGUYS, 0)	  				
        return
    end
   
    if hero.thtd_game_info["max_wave"] < 70 then return end
    if GameRules:GetCustomGameDifficulty() == 7 and hero.thtd_game_info["max_wave"] < 98 then return end
    if GameRules:GetCustomGameDifficulty() == 8 and hero.thtd_game_info["max_wave"] < 128 then return end
    local point = 25 + math.max(math.min(math.floor(1.05^(hero.thtd_game_info["max_wave"] - 70)), 1000), hero.thtd_game_info["max_wave"] - 70)
    GameRules:SendCustomMessage("<font color='yellow'>"..PlayerResource:GetPlayerName(hero:GetPlayerID()).."本次已成功通过的有效波数："..tostring(hero.thtd_game_info["max_wave"]).."，该波伤害总量："..tostring(hero.thtd_game_info["max_wave_damage"]).." 万，奖励游戏积分："..tostring(point).."。</font>", DOTA_TEAM_GOODGUYS, 0)
    if GameRules.players_card_group[hero.thtd_player_id]["_id"] ~= nil then
        if GameRules.players_card_group[hero.thtd_player_id]["_id"] == "-1" then
            http.api.saveFirstGamePoint(hero.thtd_player_id, point, 5)
        else 
            http.api.saveGamePoint(hero.thtd_player_id, point, 5)
        end
    end       
end


-- 获取排行榜数据，公共方法
function http.api.getRankCommon(table, page, limit, func)         
    http.get(
        http.config.urlDataAround,    
        {
            ['key'] = http.config.key,
            ['tableid'] = table,
            ['center'] = http.config.Location,
            ['radius'] = "1000",
            ['sortrule'] = "_distance:1",		
            ["page"] = page,
			["limit"] = limit						
        },
        func
    )
end

-- 获取单人排行榜数据
function http.api.getRank(retryCount)     
    print("---- get data rank start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    http.api.getRankCommon(http.config.tableToplist, 1, 100, function(ret)       
        print("---- get data rank end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
        if ret.StatusCode == 200 then  
            local data = json.decode(ret.Body)
            -- print("------body text : ", ret.Body)
            -- print("------body table :")
            -- PrintTable(data)
            if data and data.info == "OK" then    
                GameRules.players_rank_ok = true       
                if data.datas and #data.datas > 0 then 
                    local ranks = {}
                    for i = 1, #data.datas do
                        ranks[i] = {
                            ['id'] = data.datas[i]._id,
                            ['steamid'] = data.datas[i]._name,
                            ['account'] = data.datas[i]._address,
                            ['username'] = string.fromhex(data.datas[i].username),
                            ['wave'] = data.datas[i].wave,
                            ['damage'] = data.datas[i].damage,
                            ['updatetime'] = data.datas[i]._updatetime,
                            ['version'] = data.datas[i].version                                                 
                        }
                        for k,v in pairs(data.datas[i]) do
                            if string.sub(k,1,4) == "card" then
                                data.datas[i][k] = json.decode(string.fromhex(v))
                            end
                        end
                    end                    
                    GameRules.players_rank = ranks     
                    GameRules.players_rank_data = data.datas     
                    ranks = {}                
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayersRank", GameRules.players_rank)
                end
            else
                if not GameRules.is_team_mode then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 505, msg = "获取排行榜数据失败，本次游戏将无法上传排行榜，返回信息："..ret.Body})                
                end
            end               					
        else
            if retryCount == nil or retryCount <= 1 then
                if not GameRules.is_team_mode then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 201, msg = "获取排行榜数据失败，本次游戏将无法上传排行榜，无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})            
                end
            else                   
                http.api.getRank(retryCount-1) 
            end            
        end
    end)  
end

-- 获取组队排行榜数据
function http.api.getTeamRank(retryCount)     
    print("---- get data team rank start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    http.api.getRankCommon(http.config.tableTeamToplist, 1, 100, function(ret)       
        print("---- get data team rank end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
        if ret.StatusCode == 200 then  
            local data = json.decode(ret.Body)
            -- print("------body text : ", ret.Body)
            -- print("------body table :")
            -- PrintTable(data)
            if data and data.info == "OK" then    
                GameRules.players_team_rank_ok = true
                if data.datas and #data.datas > 0 then 
                    local ranks = {}
                    for i = 1, #data.datas do
                        ranks[i] = {
                            ['id'] = data.datas[i]._id,
                            ['steamid'] = data.datas[i]._name,
                            ['account'] = data.datas[i]._address,
                            ['username'] = string.fromhex(data.datas[i].username),
                            ['wave'] = data.datas[i].wave,
                            ['damage'] = data.datas[i].damage,
                            ['updatetime'] = data.datas[i]._updatetime,
                            ['version'] = data.datas[i].version                                                           
                        }
                        for k,v in pairs(data.datas[i]) do
                            if string.sub(k,1,4) == "card" then
                                data.datas[i][k] = json.decode(string.fromhex(v))
                            end
                        end
                    end
                    GameRules.players_team_rank = ranks     
                    GameRules.players_team_rank_data = data.datas     
                    ranks = {}                
                    CustomNetTables:SetTableValue("CustomGameInfo", "PlayersTeamRank", GameRules.players_team_rank)
                end
            else
                if GameRules.is_team_mode then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 505, msg = "获取组队排行榜数据失败，本次游戏将无法上传排行榜，返回信息："..ret.Body})                
                end
            end               					
        else
            if retryCount == nil or retryCount <= 1 then
                if GameRules.is_team_mode then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 201, msg = "获取组队排行榜数据失败，本次游戏将无法上传排行榜，无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})            
                end
            else                   
                http.api.getTeamRank(retryCount-1)  
            end              
        end
    end)  
end


-- 重置排行榜数据，公共方法
function http.api.resetRankCommon(table, index, isInTeam, func)   
    local savedata = {}
    if isInTeam then 
        savedata["_id"] = GameRules.players_team_rank[index].id
    else
        savedata["_id"] = GameRules.players_rank[index].id
    end
	savedata["_location"] = http.api.GetWaveLocation(70)
	savedata["wave"] = 70    
    http.post(
        http.config.urlDataUpdate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = table,
            ['data'] = json.encode(savedata)			
        },
        func
    )
end

-- 重置单人排行榜
function http.api.resetRank(index, playerid, retryCount)     
    print("---- save data reset rank start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    http.api.resetRankCommon(http.config.tableToplist, index, false, function(ret)
        print("---- save data reset rank end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
        if ret.StatusCode == 200 then  
            local data = json.decode(ret.Body)
            -- print("------body text : ", ret.Body)
            -- print("------body table :")
            -- PrintTable(data)
            if data and data.info == "OK" then
                -- 成功返回 {"info":"OK","infocode":"10000","status":1}            
                GameRules.players_rank[index]['wave'] = 70      
                GameRules.players_rank_data[index]['wave'] = 70
                if playerid then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_reset_rank", {index = index, msg = ""}) end
            else
                if playerid then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_reset_rank", {index = index, msg = "重置失败，返回信息："..ret.Body}) end
            end                         					
        else
            if retryCount == nil or retryCount <= 1 then
                if playerid then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_reset_rank", {index = index, msg = "重置失败，无法连接服务器，StatusCode: "..tostring(ret.StatusCode)}) end 
            else                   
                http.api.resetRank(index, playerid, retryCount-1)   
            end                    
        end
    end)  
end

-- 重置组队排行榜
function http.api.resetTeamRank(index, playerid, retryCount)      
    print("---- save data reset team rank start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    http.api.resetRankCommon(http.config.tableTeamToplist, index, true, function(ret)
        print("---- save data reset team rank end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
        if ret.StatusCode == 200 then  
            local data = json.decode(ret.Body)
            -- print("------body text : ", ret.Body)
            -- print("------body table :")
            -- PrintTable(data)
            if data and data.info == "OK" then
                -- 成功返回 {"info":"OK","infocode":"10000","status":1}            
                GameRules.players_team_rank[index]['wave'] = 70        
                GameRules.players_team_rank_data[index]['wave'] = 70               
                if playerid then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_reset_team_rank", {index = index, msg = ""}) end      
            else                                
                if playerid then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_reset_team_rank", {index = index, msg = "重置失败，返回信息："..ret.Body}) end
            end                         					
        else                   
            if retryCount == nil or retryCount <= 1 then
                if playerid then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_reset_team_rank", {index = index, msg = "重置失败，无法连接服务器，StatusCode: "..tostring(ret.StatusCode)}) end   
            else                   
                http.api.resetTeamRank(index, playerid, retryCount-1) 
            end  
        end
    end)  
end


-- 获取玩家最佳记录，如果为组队取组队记录，如果为单人则取单人记录
-- 如果没有保存服务器返回 {"count":"0","info":"OK","infocode":"10000","status":1,"datas":[]}	
function http.api.getWaveData(playerid, retryCount) 
    if not PlayerResource:IsValidPlayerID(playerid) then return end
    
    local tableName = http.config.tableToplist
    if GameRules.is_team_mode then tableName = http.config.tableTeamToplist end
    print("---- get data wave record start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    http.get(
        http.config.urlDataSearch,    
        {
            ['key'] = http.config.key,
            ['tableid'] = tableName,
            ['keywords'] = steamid,
            ['city'] = "全国",				
            ["page"] = "1"						
        },
        function(ret)       
            print("---- get data wave record end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then              
                -- print("------body text : ", ret.Body)
                local data = json.decode(ret.Body)                
                if data and data.datas and #data.datas > 0 then
                    local maxWave = 0
                    local maxWaveId = ""
                    local ids = ""                    
                    for i = 1, #data.datas do
                        if maxWaveId == "" or (data.datas[i].wave ~= nil and data.datas[i].wave ~= "" and maxWave < data.datas[i].wave) then
                            maxWave = data.datas[i].wave
                            maxWaveId = data.datas[i]._id
                        else
                            if ids == "" then 
                                ids = tostring(data.datas[i]._id)
                            else
                                ids = ids..","..tostring(data.datas[i]._id)
                            end
                        end                        
                    end
                    if maxWave == "" then maxWave = 0 end    
                    GameRules.players_max_wave[playerid] = {
                        id = maxWaveId, 
                        wave = maxWave
                    }
                    if ids ~= "" then
                        http.api.delete(tableName, ids)                        
                    end                    
                else
                    GameRules.players_max_wave[playerid] = {
                        id = "-1",  --新玩家
                        wave = 0
                    }           
                end 
                print("---- history wave : ")
                PrintTable(GameRules.players_max_wave[playerid])
            else
                if retryCount == nil or retryCount <= 1 then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 201, msg = "获取个人最佳历史数据失败，本次游戏将无法上传排行榜，无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})    
                else                   
                    http.api.getWaveData(playerid, retryCount-1) 
                end                          
            end
        end
    )
end

-- 删除数据
function http.api.delete(tablename, ids)
    print("---- delete data wave record start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    http.post(
        http.config.urlDataDelete,    
        {
            ['key'] = http.config.key,
            ['tableid'] = tablename,
            ['ids'] = ids
        },
        function(ret)       
            print("---- delete data wave record end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then  
                local data = json.decode(ret.Body)
                -- print("------body text : ", ret.Body)
                -- print("------body table :")
                -- PrintTable(data)
                if data and data.info == "OK" then
                    -- 成功返回 {"info":"OK","infocode":"10000","status":1}            
                    print("---------- delete OK : ", ids)         
                else     
                    print("---------- delete ERROR : ", ret.Body)   
                end                         					
            else
                print("---------- delete ERROR : StatusCode "..tostring(ret.StatusCode)) 
            end
        end
    )
end

-- 保存玩家最佳记录，首次保存，如果为组队取组队记录，如果为单人则取单人记录	
function http.api.saveFirstWaveData(playerid, wavedata, retryCount) 
    if not PlayerResource:IsValidPlayerID(playerid) then return end
    
    local tableName = http.config.tableToplist
    if GameRules.is_team_mode then tableName = http.config.tableTeamToplist end
    print("---- save data first wave record start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    local savedata = {}
    savedata["_name"] = steamid
    savedata["_address"] = wavedata["account"]
    savedata["_location"] = http.api.GetWaveLocation(wavedata["wave"])
    savedata["wave"] = wavedata["wave"]
    savedata["damage"] = wavedata["damage"]
    savedata["version"] = GameRules.game_info.ver
    savedata["username"] = string.tohex(wavedata["username"])
    for k,v in pairs(wavedata) do
        if string.sub(k,1,4) == "card" then
            savedata[k] = string.tohex(json.encode(v))
        end
    end
    http.post(
        http.config.urlDataCreate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = tableName,
            ['loctype'] = "1",
            ['data'] = json.encode(savedata)				
        },
        function(ret)       
            print("---- save data first wave record end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            if ret.StatusCode == 200 then              
                -- print("------body text : ", ret.Body)
                local data = json.decode(ret.Body)                
                if data and data.info == "OK" then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_upload_rank", {code = 1, msg = "恭喜！你的最高波数上传排行榜成功!"})	
                    if SpawnSystem:GetCount() == 0 then http.api.clearSameRank() end
                else
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 505, msg = "上传排行榜失败，返回信息："..ret.Body})  
                end 
            else
                if retryCount == nil or retryCount <= 1 then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 201, msg = "上传排行榜失败，无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})      
                else                   
                    http.api.saveFirstWaveData(playerid, wavedata, retryCount-1) 
                end                           
            end
        end
    )
end

-- 保存玩家最佳记录，如果为组队取组队记录，如果为单人则取单人记录	
function http.api.saveWaveData(playerid, wavedata, retryCount) 
    if not PlayerResource:IsValidPlayerID(playerid) then return end

    local ver = GameRules.game_info.ver
    for i=1,6 do
        if towerNameList[wavedata["card"..tostring(i)]["itemname"]]["cardname"] == GameRules.game_info.luck_card then 
           ver = ver.."EX"
           break  
        end
	end
    
    local tableName = http.config.tableToplist
    if GameRules.is_team_mode then tableName = http.config.tableTeamToplist end
    print("---- save data wave record start time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    local savedata = {}
    savedata["_id"] = wavedata["id"]
    savedata["_location"] = http.api.GetWaveLocation(wavedata["wave"])
    savedata["wave"] = wavedata["wave"]
    savedata["damage"] = wavedata["damage"]
    savedata["version"] = ver
    savedata["username"] = string.tohex(wavedata["username"])
    for k,v in pairs(wavedata) do
        if string.sub(k,1,4) == "card" then            
            savedata[k] = string.tohex(json.encode(v))
        end
    end
    http.post(
        http.config.urlDataUpdate,    
        {
            ['key'] = http.config.key,
            ['tableid'] = tableName,           
            ['data'] = json.encode(savedata)				
        },
        function(ret)       
            print("---- save data wave record end time : ", tostring(math.floor(GameRules:GetGameTime()*100 + 0.5)/100))
            local teamText = ""
            if GameRules.is_team_mode then teamText = "组队" end
            if ret.StatusCode == 200 then              
                -- print("------body text : ", ret.Body)
                local data = json.decode(ret.Body)                
                if data and data.info == "OK" then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_upload_rank", {code = 1, msg = "恭喜！你打破了历史记录，达到了新的最高波数，上传"..teamText.."排行榜成功!"})	
                    if SpawnSystem:GetCount() == 0 then http.api.clearSameRank() end
                else
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 505, msg = "上传"..teamText.."排行榜失败，返回信息："..ret.Body})  
                end 
            else
                if retryCount == nil or retryCount <= 1 then
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "thtd_http_error", {code = 201, msg = "上传"..teamText.."排行榜失败，无法连接服务器，StatusCode: "..tostring(ret.StatusCode)})     
                else                   
                    http.api.saveWaveData(playerid, wavedata, retryCount-1) 
                end                          
            end
        end
    )
end

-- 清除相同的排行榜
function http.api.clearSameRank()
    if GameRules.game_info.is_clear_rank == true then return end
    GameRules.game_info.is_clear_rank = true 
    local toplist
	if GameRules.is_team_mode then
		toplist = GameRules.players_team_rank_data	
	else
		toplist = GameRules.players_rank_data
    end
    if #toplist == 0 then return end

    local toDelList = {}   
    for i=1,#toplist-1 do		
        local wavedata = toplist[i]
        if table.hasvalue(toDelList, i) == false then 
            for j=i+1,#toplist do
                local topdata = toplist[j]  
                local isSameRank = false                

                if wavedata["card1"] ~= "" and wavedata["card1"] ~= nil and topdata["card1"] ~= "" and topdata["card1"] ~= nil and wavedata["card1"]["itemname"] == topdata["card1"]["itemname"] then
                    if wavedata["card1"]["damage"] / (10000 * wavedata["damage"]) >= 0.6 and topdata["card1"]["damage"] / (10000 * topdata["damage"]) >= 0.6 then
                        isSameRank = true
                    end						
                end

                if isSameRank == false then                    
					local topDamage1 = 0
					local topDamage2 = 0
					local topNum = 0
					for x=1,12 do
						if wavedata["card"..tostring(x)] ~= "" and wavedata["card"..tostring(x)] ~= nil then
							topDamage1 = topDamage1 + wavedata["card"..tostring(x)]["damage"]
						end
						if topdata["card"..tostring(x)] ~= "" and topdata["card"..tostring(x)] ~= nil then
							topDamage2 = topDamage2 + topdata["card"..tostring(x)]["damage"]
						end						
						if topDamage1 / (10000 * wavedata["damage"]) >= 0.8 and topDamage2 / (10000 * topdata["damage"]) >= 0.8 then
							topNum = x
							break
						end					
					end
					if topNum > 0 then
						local sameCount = 0
                        local usedIndex = ""
						for x=1,topNum do
							for y=1,topNum do
								if string.find(usedIndex,tostring(y)) == nil and wavedata["card"..tostring(x)] ~= "" and topdata["card"..tostring(y)] ~= "" and topdata["card"..tostring(y)] ~= nil and wavedata["card"..tostring(x)]["itemname"] == topdata["card"..tostring(y)]["itemname"] then
									sameCount = sameCount + 1
									usedIndex = usedIndex..tostring(y)..","
									break
								end					
							end
						end	
						if sameCount == topNum then isSameRank = true end
					end
                end 

                if isSameRank == true then
                    table.insert(toDelList, j)				
                end 
            end	
        end
	end

	for k,v in pairs(toDelList) do
		if GameRules.is_team_mode then
			http.api.resetTeamRank(v)
		else
			http.api.resetRank(v)
		end
	end
	print("---------- the same rank : ", json.encode(toDelList))   
end