TRUE = 1
FALSE = 0

THTD_Custom_Hit_Block = {}

function GetTempleOfGodBuffedTowerCount(targets)
    local count = 1
    for k,v in pairs(targets) do
        if v:GetUnitName() == "soga" or v:GetUnitName() == "miko" or v:GetUnitName() == "futo" or v:GetUnitName() == "yoshika" or v:GetUnitName() == "seiga" then
            if v:HasModifier("modifier_miko_02_buff") then
                count = count + 1
            end
        end
    end
    return count
end


function THTD_GetAllTempleOfGodTowerStarCount(caster)
    local star = 0
    for k,v in pairs(caster:GetOwner().thtd_hero_tower_list) do
        if v~=nil and v:IsNull()==false and v:IsAlive() and v:GetUnitName() == towerName then
            if v:HasModifier("modifier_miko_02_buff") then
                star = star + v:THTD_GetStar()
            end
        end
    end
    return star
end

function GetTempleOfGodTowerCount(hero)
    local count = 0
    for k,v in pairs(hero.thtd_hero_tower_list) do
        if v:GetUnitName() == "soga" or v:GetUnitName() == "miko" or v:GetUnitName() == "futo" or v:GetUnitName() == "yoshika" or v:GetUnitName() == "seiga" then
            count = count + 1
        end
    end
    return count
end

function IsTempleOfGodTower(unit)
    if unit:GetUnitName() == "soga" or unit:GetUnitName() == "futo" or unit:GetUnitName() == "yoshika" or unit:GetUnitName() == "seiga" then
        return true
    end
    return false
end

function GetStarLotusBuffedTowerCount(targets)
    local count = 1
    for k,v in pairs(targets) do
        if v:GetUnitName() == "nazrin" or v:GetUnitName() == "toramaru" or v:GetUnitName() == "minamitsu" or v:GetUnitName() == "nue" or v:GetUnitName() == "kogasa" then
            if v:HasModifier("modifier_byakuren_03_buff") then
                count = count + 1
            end
        end
    end
    return count
end

function GetStarLotusTowerCount(hero)
    local count = 0
    for k,v in pairs(hero.thtd_hero_tower_list) do
        if v:GetUnitName() == "byakuren" or v:GetUnitName() == "nazrin" or v:GetUnitName() == "toramaru" or v:GetUnitName() == "minamitsu" or v:GetUnitName() == "nue" or v:GetUnitName() == "kogasa" then
            count = count + 1
        end
    end
    return count
end

function IsStarLotusTower(unit)
    if unit:GetUnitName() == "nazrin" or unit:GetUnitName() == "toramaru" or unit:GetUnitName() == "minamitsu" or unit:GetUnitName() == "nue" or unit:GetUnitName() == "kogasa" then
        return true
    end
    return false
end

SteamID_white_list = 
{
    "76561198072887807",
    "76561198068129994"
}
function IsInSteamWhiteList()
    for i=0, PlayerResource:GetPlayerCount() do
        local player = PlayerResource:GetPlayer(i)
        if player then
            local steamid = tostring(PlayerResource:GetSteamID(i))
            for k,v in pairs(SteamID_white_list) do
                if v == steamid then
                    return true
                end
            end
        end
    end
    return false
end

function THTD_GetIntPart(x)
    if x<= 0 then
        return math.ceil(x)
    end
    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x)-1
    end

    return x
end

function THTD_GetAllTowerStarCount(caster)
    local star = 0
    for k,v in pairs(caster:GetOwner().thtd_hero_tower_list) do
        if v~=nil and v:IsNull()==false and v:IsAlive() and v:GetUnitName() == towerName then
            star = star + v:THTD_GetStar()
        end
    end
    return star
end

function THTD_GetFirstTowerByName(caster,towerName)
    for k,v in pairs(caster:GetOwner().thtd_hero_tower_list) do
        if v~=nil and v:IsNull()==false and v:IsAlive() and v:GetUnitName() == towerName then
            return v
        end
    end
    return nil
end

function THTD_FindFriendlyUnitsAll(caster)
    if caster:THTD_IsTower() then
        return caster:GetOwner().thtd_hero_tower_list
    end
    return {}
end

function THTD_FindFriendlyUnitsInRadius(caster,point,radius)
    if caster:THTD_IsTower() then
        local targets = {}
         for k,v in pairs(caster:GetOwner().thtd_hero_tower_list) do
            if v~=nil and v:IsNull()==false and v:IsAlive() then
                if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                    table.insert(targets,v)
                end
            end
        end
        return targets
    end
    return {}
end

function THTD_FindUnitsInRadius(caster,point,radius)
    if caster:THTD_IsTower() then
        local id = caster:GetOwner().thtd_player_id
        local targets = {}
        if id ~= nil then
            for k,v in pairs(THTD_EntitiesRectInner[id]) do
                if v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_is_outer ~= true then
                    if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                        if v.thtd_is_yukari_01_hidden ~= true then
                            table.insert(targets,v)
                        end
                    end
                else
                    table.remove(THTD_EntitiesRectInner[id],k)
                end
            end

            if not(point.x+radius < 4432 and point.x-radius > -4432 and point.y+radius < 3896 and point.y-radius > -3896) then
                for k,v in pairs(THTD_EntitiesRectOuter) do
                    if v~=nil and v:IsNull()==false and v:IsAlive() then
                        if GetDistanceBetweenTwoVec2D(v:GetOrigin(), point) < radius then
                            if v.thtd_is_yukari_01_hidden ~= true then
                                table.insert(targets,v)
                            end
                        end
                    else
                        table.remove(THTD_EntitiesRectOuter,k)
                    end
                end
            end
            return targets
        end
    end
    return {}
end

function THTD_FindUnitsAll(caster)
    if caster:THTD_IsTower() then
        local id = caster:GetOwner().thtd_player_id
        local targets = {}
        if id ~= nil then
            for k,v in pairs(THTD_EntitiesRectInner[id]) do
                if v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_is_outer ~= true then
                    if v.thtd_is_yukari_01_hidden ~= true then
                        table.insert(targets,v)
                    end
                else
                    table.remove(THTD_EntitiesRectInner[id],k)
                end
            end

            for k,v in pairs(THTD_EntitiesRectOuter) do
                if v~=nil and v:IsNull()==false and v:IsAlive() then
                    if v.thtd_is_yukari_01_hidden ~= true then
                        table.insert(targets,v)
                    end
                else
                    table.remove(THTD_EntitiesRectOuter,k)
                end
            end
            return targets
        end
    end
    return {}
end

function THTD_FindUnitsInner(caster)
    if caster:THTD_IsTower() then
        local id = caster:GetOwner().thtd_player_id
        local targets = {}
        if id ~= nil then
            for k,v in pairs(THTD_EntitiesRectInner[id]) do
                if v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_is_outer ~= true then
                    if v.thtd_is_yukari_01_hidden ~= true then
                        table.insert(targets,v)
                    end
                else
                    table.remove(THTD_EntitiesRectInner[id],k)
                end
            end
            return targets
        end
    end
    return {}
end

function THTD_FindUnitsOuter(caster)
    if caster:THTD_IsTower() then
        local id = caster:GetOwner().thtd_player_id
        local targets = {}
        if id ~= nil then
            for k,v in pairs(THTD_EntitiesRectOuter) do
                if v~=nil and v:IsNull()==false and v:IsAlive() then
                    if v.thtd_is_yukari_01_hidden ~= true then
                        table.insert(targets,v)
                    end
                else
                    table.remove(THTD_EntitiesRectOuter,k)
                end
            end
            return targets
        end
    end
    return {}
end

function IsUnitInGroup(unit,group)
    for k,v in pairs(group) do
        if v == unit then
            return true
        end
    end
    return false
end


function GetGameTimeText()
    local time = math.floor(GameRules:GetGameTime())

    local hour = math.floor(time/3600)
    local minute = math.floor((time%3600)/60)
    local second = math.floor(time%3600%60)

    return timeText(NumberText(hour),NumberText(minute),NumberText(second)),time
end

function ModifyDamageIncomingPercentage(unit,percentage,special)
    local special = special or nil
    local incomingPercentage = unit.thtd_damage_incoming
    if incomingPercentage == nil then
        unit.thtd_damage_incoming = 0
    end
    if special ~= nil then
        if unit.thtd_damage_incoming_table == nil then
            unit.thtd_damage_incoming_table = {}
        end
        if unit.thtd_damage_incoming_table[special] == nil then
            unit.thtd_damage_incoming_table[special] = 0
        end
        unit.thtd_damage_incoming_table[special] = unit.thtd_damage_incoming_table[special] + percentage
    end
    unit.thtd_damage_incoming = unit.thtd_damage_incoming + percentage
end

function RemoveDamageIncoming(unit,special)
    local special = special or nil

    if special ~= nil then
        local percentage = unit.thtd_damage_incoming_table[special]
        if percentage then
            unit.thtd_damage_incoming =  unit.thtd_damage_incoming - percentage
            unit.thtd_damage_incoming_table[special] = {}
        end
    else
        unit.thtd_damage_incoming = 0
    end
end

function ModifyMagicalDamageIncomingPercentage(unit,percentage,special)
    local special = special or nil
    local incomingPercentage = unit.thtd_magical_damage_incoming
    if incomingPercentage == nil then
        unit.thtd_magical_damage_incoming = 0
    end
    if special ~= nil then
        if unit.thtd_magical_damage_incoming_table == nil then
            unit.thtd_magical_damage_incoming_table = {}
        end
        if unit.thtd_magical_damage_incoming_table[special] == nil then
            unit.thtd_magical_damage_incoming_table[special] = 0
        end
        unit.thtd_magical_damage_incoming_table[special] = unit.thtd_magical_damage_incoming_table[special] + percentage
    end
    unit.thtd_magical_damage_incoming = unit.thtd_magical_damage_incoming + percentage
end

function RemoveMagicalDamageIncoming(unit,special)
    local special = special or nil

    if special ~= nil then
        local percentage = unit.thtd_magical_damage_incoming_table[special]
        if percentage then
            unit.thtd_magical_damage_incoming =  unit.thtd_magical_damage_incoming - percentage
            unit.thtd_magical_damage_incoming_table[special] = {}
        end
    else
        unit.thtd_magical_damage_incoming = 0
    end
end

function ModifyPhysicalDamageIncomingPercentage(unit,percentage,special)
    local special = special or nil
    local incomingPercentage = unit.thtd_physical_damage_incoming
    if incomingPercentage == nil then
        unit.thtd_physical_damage_incoming = 0
    end
    if special ~= nil then
        if unit.thtd_physical_damage_incoming_table == nil then
            unit.thtd_physical_damage_incoming_table = {}
        end
        if unit.thtd_physical_damage_incoming_table[special] == nil then
            unit.thtd_physical_damage_incoming_table[special] = 0
        end
        unit.thtd_physical_damage_incoming_table[special] = unit.thtd_physical_damage_incoming_table[special] + percentage
    end
    unit.thtd_physical_damage_incoming = unit.thtd_physical_damage_incoming + percentage
end

function RemovePhysicalDamageIncoming(unit,special)
    local special = special or nil

    if special ~= nil then
        local percentage = unit.thtd_physical_damage_incoming_table[special]
        if percentage then
            unit.thtd_physical_damage_incoming =  unit.thtd_physical_damage_incoming - percentage
            unit.thtd_physical_damage_incoming_table[special] = {}
        end
    else
        unit.thtd_physical_damage_incoming = 0
    end
end

function GetPhysicalDamageIncomingPercentage(unit,special)
    local special = special or nil

    if special~=nil then
        return unit.thtd_physical_damage_incoming_table[special] or 0
    end

    return unit.thtd_physical_damage_incoming or 0
end

function ModifyPhysicalDamageOutgoingPercentage(caster,percentage,ability)
    local ability = ability or nil
    local outgoingPercentage = caster.thtd_physical_damage_outgoing
    if outgoingPercentage == nil then
        caster.thtd_physical_damage_outgoing = 0
    end
    caster.thtd_physical_damage_outgoing = caster.thtd_physical_damage_outgoing + percentage
    if ability ~= nil then
        if ability.thtd_physical_damage_outgoing == nil then
            ability.thtd_physical_damage_outgoing = 0
        end
        ability.thtd_physical_damage_outgoing = ability.thtd_physical_damage_outgoing + percentage
    end
end

function GetPhysicalDamageOutgoingPercentage(caster,ability)
    local ability = ability or nil
    if ability == nil then
        return caster.thtd_physical_damage_outgoing or 0
    else
        return ability.thtd_physical_damage_outgoing or 0
    end
end


function ModifyMagicalDamageOutgoingPercentage(caster,percentage,ability)
    local ability = ability or nil
    local outgoingPercentage = caster.thtd_magical_damage_outgoing
    if outgoingPercentage == nil then
        caster.thtd_magical_damage_outgoing = 0
    end
    caster.thtd_magical_damage_outgoing = caster.thtd_magical_damage_outgoing + percentage
    if ability ~= nil then
        if ability.thtd_magical_damage_outgoing == nil then
            ability.thtd_magical_damage_outgoing = 0
        end
        ability.thtd_magical_damage_outgoing = ability.thtd_magical_damage_outgoing + percentage
    end
end

function GetMagicalDamageOutgoingPercentage(caster,ability)
    local ability = ability or nil
    if ability == nil then
        return caster.thtd_magical_damage_outgoing or 0
    else
        return ability.thtd_magical_damage_outgoing or 0
    end
end


function UnitStunTarget( caster,target,stuntime)
    target:AddNewModifier(caster, nil, "modifier_stunned", {duration=stuntime})
end

function UnitNoPathingfix( caster,target,duration)
    target:AddNewModifier(caster, nil, "modifier_spectre_spectral_dagger_path_phased", {duration=duration})
end

function GetDistanceBetweenTwoVec2D(a, b)
    local xx = (a.x-b.x)
    local yy = (a.y-b.y)
    return math.sqrt(xx*xx + yy*yy)
end

function GetDistance(ent1,ent2)
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

function GetRealRadBetweenTwoVec2D(a,b)
    local dx = math.sqrt(a.x * a.x + a.y * a.y)
    local dy = math.sqrt(b.x * b.x + b.y * b.y)

    local vecAB = a.x*b.x + a.y*b.y

    return math.acos(vecAB/dx*dy)
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

function IsRadBetweenTwoRad2D(a,rada,radb)
    local math2pi = math.pi * 2
    rada = rada + math2pi
    radb = radb + math2pi
    a = a + math2pi
    local maxrad = math.max(rada,radb)
    local minrad = math.min(rada,radb)
    if(a<maxrad and a>minrad)then
        return true
    end
    return false
end

function table.nums(table)
    if type(table) ~= "table" then return nil end
    local l = 0
    for k,v in pairs(table) do
        l = l+1
    end
    return l
end
function IsNumberInTable(Table,t)
    if Table == nil then return false end
    if type(Table) ~= "table" then return false end
    for i= 1,#Table do
        if t == Table[i] then
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

function  ApplyProjectile(keys,castvec,endvec,File)
    local caster = keys.caster
    local vecCaster = caster:GetOrigin() 
    local point = 1/#endvec*endvec
    local targetPoint = endvec
    local forwardVec = caster:GetForwardVector() 
    local knifeTable = {
    Ability = keys.ability,
    fDistance = keys.DamageRadius,
    fStartRadius = 0,
    fEndRadius = 200,
    Source = caster,
    bHasFrontalCone = false,
    bRepalceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    fExpireTime = GameRules:GetGameTime()+10,
    bDeleteOnHit = false,
    vVelocity = point*3000,
    bProvidesVision =true,
    iVisionRadius = 0,
    iVisionTeamNumber = caster: GetTeamNumber(),
    vSpawnOrigin = castvec,
    EffectName = File,
}

ProjectileManager:CreateLinearProjectile(knifeTable)
end
function table.deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
     end
     return _copy(object)
end
--删除table中的table
function TableRemoveTable( table_1 , table_2 )
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
function CDOTABaseAbility:IsUnitTarget( )
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
                    TableRemoveTable(caster.CatapultUnit,unit)
 
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

function PrintTable(t, indent, done)
    --print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
        table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
        -- Ignore FDesc
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                    print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                    print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                end
            end
        end
    end
end

function GetTableString( t, strTable )
    if type(t) ~= "table" then return end

    if strTable.bytes == nil then
        strTable.bytes = 0
    end

    for k,v in pairs(t) do
        local tp = type(v)

        if tp == "table" then
            GetTableString( v, strTable )

        elseif tp ~= "function" then
            if tp == "number" then
                v = math.floor(v)
            end

            local str = k..tostring(v)

            local bytes = {string.byte(str,1,-1)}
            for __,num in pairs(bytes) do
                strTable.bytes = strTable.bytes + num
            end
        end
    end
end

function PrintTestLog(string)
    print(string)
end


function UnitNoCollision( caster,target,duration)
    target:AddNewModifier(caster, nil, "modifier_phased", {duration=duration})
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

function ParticleManager:DestroyLinearProjectileSystem(effectIndex,time)
    if effectIndex==nil then return end
    Timer.Wait 'Effect_Destroy_Particle_Time' (time,
        function()
            if effectIndex==nil then return end
            ProjectileManager:DestroyLinearProjectile(effectIndex)
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

    -- for i=0,360 do
    --     vface = vface + i
    --     local rad = vface/180*math.pi
    --     if GridNav:CanFindPath(pos,pos + Vector(math.cos(rad),math.sin(rad),0)*50) then
    --         return GetRadBetweenTwoVec2D(pos,pos + Vector(math.cos(rad),math.sin(rad),0)*50)
    --     end
    -- end
    -- return 90
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

    -- if GridNav:IsBlocked(pos) or GridNav:IsTraversable(pos) == false then
    --     return false
    -- end

    -- for i=0,360 do
    --     local rad = i/180*math.pi
    --     if GridNav:CanFindPath(pos,pos + Vector(math.cos(rad),math.sin(rad),0)*1000) then
    --         return false
    --     end
    -- end
    -- return true
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
            local ent   = GameRules:GetGameModeEntity()

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
            
            local ent   = GameRules:GetGameModeEntity()
            
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
            PrintTestLog("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
    local unitKv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    for k,v in pairs(unitKv) do
        PrintTestLog("PRECACHE UNIT RESOURCE", k)
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
                PrintTestLog("PRECACHE PARTICLE RESOURCE", value)
            end
            if string.find(value, "vmdl") then
                PrecacheResource( "model",  value, context)
                PrintTestLog("PRECACHE MODEL RESOURCE", value)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile",  value, context)
                PrintTestLog("PRECACHE SOUND RESOURCE", value)
            end
        end
    end
end