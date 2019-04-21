local thtd_daiyousei_damage_bonus =
{
	[3] = 0.3,
	[4] = 0.4,
	[5] = 0.6,
}

local thtd_momiji_damage_bonus =
{
    [3] = 0.3,
    [4] = 0.4,
    [5] = 0.6,
}

local thtd_sunny_damage_bonus =
{
    [3] = 0.1,
    [4] = 0.15,
    [5] = 0.25,
}

function UnitDamageTarget(damage_table)
    local DamageTable = PassTheUnitDamageSystem(damage_table)
    damage_table = {}
	return ApplyDamage(DamageTable)
end

function PassTheUnitDamageSystem(damage_table)
    local DamageTable = clone(damage_table)   
    if DamageTable.attacker:GetUnitName() == "junko" or DamageTable.attacker:HasModifier("modifier_junko_01") then
        DamageTable.damage_type = DAMAGE_TYPE_PURE         
        return DamageTable
    end

    if DamageTable.damage_type == DAMAGE_TYPE_MAGICAL then
        DamageTable.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR
    end

    if DamageTable.attacker:FindModifierByName("modifier_item_2009_physical_penetration") ~= nil then
        if DamageTable.victim:HasModifier("modifier_item_2009_physical_penetration_effect") == false then
            DamageTable.victim:AddNewModifier(DamageTable.attacker, nil, "modifier_item_2009_physical_penetration_effect", {})
        end
    end

    if DamageTable.attacker:FindModifierByName("modifier_item_2010_magical_penetration") ~= nil then
        if DamageTable.victim:HasModifier("modifier_item_2010_magical_penetration_effect") == false then
            DamageTable.victim:AddNewModifier(DamageTable.attacker, nil, "modifier_item_2010_magical_penetration_effect", {})
        end
    end

    if DamageTable.attacker:FindModifierByName("modifier_item_2020_damage") ~= nil then       
        DamageTable.damage = DamageTable.damage + DamageTable.attacker:THTD_GetPower() * DamageTable.attacker:THTD_GetStar()
    end

    if DamageTable.victim:HasModifier("modifier_miko_01_debuff") then
        local modifier = DamageTable.victim:FindModifierByName("modifier_miko_01_debuff")
        local miko = modifier:GetCaster()        
        DamageTable.damage = DamageTable.damage + miko:THTD_GetPower()        
    end

    if DamageTable.attacker:FindModifierByName("modifier_daiyousei_03") ~= nil then
        local modifier = DamageTable.attacker:FindModifierByName("modifier_daiyousei_03")
        local daiyousei = modifier:GetCaster()
        if daiyousei ~= nil then
            if DamageTable.attacker:GetUnitName() == "cirno" then
                DamageTable.damage = DamageTable.damage * ( 1 + (thtd_daiyousei_damage_bonus[daiyousei:THTD_GetStar()] or 0) * 1.5)
            else
                DamageTable.damage = DamageTable.damage * ( 1 + (thtd_daiyousei_damage_bonus[daiyousei:THTD_GetStar()] or 0) )
            end
        end
        DamageTable.damage_type = DAMAGE_TYPE_MAGICAL 
        DamageTable.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR
    elseif DamageTable.attacker:FindModifierByName("modifier_momiji_02") ~= nil then
        local modifier = DamageTable.attacker:FindModifierByName("modifier_momiji_02")
        local momiji = modifier:GetCaster()
        if momiji ~= nil then
            DamageTable.damage_type = DAMAGE_TYPE_PHYSICAL 
            if DamageTable.attacker:GetUnitName() == "aya" then
                if DamageTable.victim.thtd_is_outer ~= true then
                    DamageTable.damage = DamageTable.damage * ( 1 + (thtd_momiji_damage_bonus[momiji:THTD_GetStar()] or 0) * 1.5)
                else
                    DamageTable.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
                end
            else
                DamageTable.damage = DamageTable.damage * ( 1 + (thtd_momiji_damage_bonus[momiji:THTD_GetStar()] or 0) )
            end
        end
    elseif DamageTable.victim:HasModifier("modifier_sunny_02_debuff") then
        local modifier = DamageTable.victim:FindModifierByName("modifier_sunny_02_debuff")
        local sunny = modifier:GetCaster()
        if sunny ~= nil then
            DamageTable.damage = DamageTable.damage * ( 1 + (thtd_sunny_damage_bonus[sunny:THTD_GetStar()] or 0))
        end
        DamageTable.damage_type = DAMAGE_TYPE_PURE
    end
    return DamageTable
end

function ReturnAfterTaxDamageAfterAbility(damage_table)
    local DamageTable = PassTheUnitDamageSystem(damage_table)
    return ReturnAfterTaxDamage(DamageTable, true)
end

function ReturnAfterTaxDamage(DamageTable, Predict)
    -- 造成实际伤害后的税后伤害处理，在伤害过滤器调用，普通攻击也同样会计算
    if DamageTable.damage <= 0 then 
        DamageTable = {}
        return 0 
    end

    local unit = DamageTable.attacker
    local target = DamageTable.victim
    local unitName = unit:GetUnitName()

    if unitName == "yuyuko" and Predict ~= true then
        if unit.thtd_yuyuko_02_chance == nil then
            unit.thtd_yuyuko_02_chance = 5
        end
        if unit:FindAbilityByName("thtd_yuyuko_02")~=nil and RandomInt(1,100) <= unit.thtd_yuyuko_02_chance then            
            local max_damage = unit:THTD_GetPower() * unit:THTD_GetStar() * 125
            if GameRules.game_info.luck_card == "yuyuko" then
                max_damage = max_damage * (1 + math.max(-90, GameRules.game_info.crit) / 100)
            end	
            DamageTable.damage = math.min(target:GetHealth() + 100, max_damage)
            local return_damage = math.max(DamageTable.damage, 0)
            DamageTable = {}     
            return return_damage
        end
    end    

    -- 只在预估时使用，实际时在伤害过滤器中处理了
    if unitName == "junko" or unit:HasModifier("modifier_junko_01") then
        local return_damage = math.max(DamageTable.damage, 0)
        if unitName == "satori" then
            local max_damage = 3768000 * 0.5    
            if GameRules.game_info.luck_card == "satori" then
                max_damage = max_damage * (1 + math.max(-90, GameRules.game_info.crit) / 100)
            end	
            return_damage = math.min(return_damage, max_damage)
        end  
        DamageTable = {}     
        return return_damage
    end

    -- 物理伤害转化为0甲的伤害
    if DamageTable.damage_type == DAMAGE_TYPE_PHYSICAL then
        if not (target.thtd_is_outer == true and unit:GetUnitName() == "aya" and unit:HasModifier("modifier_momiji_02")) then 
            local armor = target:GetPhysicalArmorValue()
            if armor > 0 then 
                if Predict ~= true then   
                    DamageTable.damage = DamageTable.damage / (1 - (0.052 * armor /(0.9 + 0.048 * armor)))  -- 7.20版本护甲计算
                end
            else
                if Predict ~= true then   
                    DamageTable.damage = DamageTable.damage / (1 - (0.052 * armor /(0.9 - 0.048 * armor)))  -- 7.20版本负护甲计算
                end
            end
        end
    end

    if target:HasModifier("modifier_bosses_hina") and unit:THTD_IsTower() then            
        if DamageTable.damage > unit:THTD_GetPower()*unit:THTD_GetStar()*4 then
            DamageTable.damage = DamageTable.damage * 0.5
        end 
    end

    if target:HasModifier("modifier_bosses_kisume") then        
        DamageTable.damage = DamageTable.damage - 2000      
        if DamageTable.damage <= 0 then
            DamageTable = {}    
            return 0
        end
    end

    if unit.thtd_damage_outgoing ~= nil and unit.thtd_damage_outgoing ~= 0 then
        DamageTable.damage = DamageTable.damage * (1 + unit.thtd_damage_outgoing/100)
    end

    if target.thtd_damage_special_incoming ~= nil and target.thtd_damage_special_incoming ~= 0 then
        DamageTable.damage = DamageTable.damage * (1 + target.thtd_damage_special_incoming/100)
    end 

    if target.thtd_damage_incoming ~= nil and target.thtd_damage_incoming ~= 0 then
        DamageTable.damage = DamageTable.damage * (1 + target.thtd_damage_incoming/100)
    end    

    if target:GetHealthPercent() > 70 and unit:HasModifier("modifier_item_2025_damage") then
        DamageTable.damage = DamageTable.damage * 1.5
    end

    if target:GetHealthPercent() < 30 and unit:HasModifier("modifier_item_2026_damage") then
        DamageTable.damage = DamageTable.damage * 1.5
    end

    if unit.equip_bonus_table ~= nil then
        if target:HasModifier("modifier_bosses_mokou")==false and Predict ~= true then
            local chance = unit.equip_bonus_table["crit_chance"] + unit.thtd_crit_chance 
            if unit:HasModifier("modifier_ogre_magi_bloodlust") then
                local modifier = unit:FindModifierByName("modifier_ogre_magi_bloodlust")      
                local inaba = modifier:GetCaster()  
                chance = chance + inaba:FindAbilityByName("ogre_magi_bloodlust"):GetSpecialValueFor("bonus_movement_speed")                    
            end
            if RandomInt(1,100) <= chance then               
                DamageTable.damage = DamageTable.damage * (1.5 + unit.equip_bonus_table["crit_damage"]/100)                       
            end
        end
        DamageTable.damage = DamageTable.damage * (1 + unit.equip_bonus_table["damage_percentage"]/100)
    end  

    if unit:HasModifier("modifier_lily_outgoing_damage") then
        DamageTable.damage = DamageTable.damage * 1.25
    end

    if DamageTable.damage_type == DAMAGE_TYPE_PHYSICAL then
        local armor = target:GetPhysicalArmorValue()       

        if unit:HasModifier("modifier_kokoro_03_buff") then
            if unit:FindModifierByName("modifier_kokoro_03_buff"):GetCaster():HasModifier("modifier_kokoro_04_buff_3") then               
                DamageTable.damage = DamageTable.damage * 1.45
            else
                DamageTable.damage = DamageTable.damage * 1.3
            end
        end

        if unit:HasModifier("modifier_utsuho_rin_buff") then
            DamageTable.damage = DamageTable.damage * 1.2
        end       

        if unit.thtd_physical_damage_outgoing ~= nil and unit.thtd_physical_damage_outgoing ~= 0 then
			DamageTable.damage = DamageTable.damage * (1 + unit.thtd_physical_damage_outgoing/100)
		end

        if target.thtd_physical_damage_incoming ~= nil and target.thtd_physical_damage_incoming ~= 0 then
            DamageTable.damage = DamageTable.damage * (1 + target.thtd_physical_damage_incoming/100)
        end

        if unit.equip_bonus_table ~= nil then
            DamageTable.damage = DamageTable.damage * (1 + unit.equip_bonus_table["physical_damage_percentage"]/100)
        end
        
        if armor >= 0 then 
            if unit.equip_bonus_table ~= nil then
                armor = armor * (1 - unit.equip_bonus_table["physical_penetration_percentage"]/100)
            end
            if unit.thtd_physical_penetration ~= nil and armor > 0 then
                armor = math.max(0,armor + unit.thtd_physical_penetration)
            end
            local damage_decrease = (1 - (armor * 0.04) /(1 + armor * 0.04))
            DamageTable.damage = DamageTable.damage * math.max(damage_decrease, 0.33)
        else
            local damage_decrease = (2 - 0.96^(-armor))
            DamageTable.damage = DamageTable.damage * math.min(damage_decrease, 1.66)            
        end
    end

    if DamageTable.damage_type == DAMAGE_TYPE_MAGICAL then
        local magicArmor = target:GetMagicalArmorValue() * 100

        if unit:HasModifier("modifier_patchouli_03_buff") then
            DamageTable.damage = DamageTable.damage * 1.3
        end

        if unit:HasModifier("modifier_cirno_suwako_buff") then
            DamageTable.damage = DamageTable.damage * 1.2
        end      
        
        if unit.thtd_magical_damage_outgoing ~= nil and unit.thtd_magical_damage_outgoing ~= 0 then
            DamageTable.damage = DamageTable.damage * (1 + unit.thtd_magical_damage_outgoing/100)
        end

        if target.thtd_magical_damage_incoming ~= nil and target.thtd_magical_damage_incoming ~= 0 then
            DamageTable.damage = DamageTable.damage * (1 + target.thtd_magical_damage_incoming/100)
        end

        if unit.equip_bonus_table ~= nil then
            DamageTable.damage = DamageTable.damage * (1 + unit.equip_bonus_table["magical_damage_percentage"]/100)
        end

        if magicArmor >= 0 then
            if unit.equip_bonus_table ~= nil then
                magicArmor = magicArmor * (1 - unit.equip_bonus_table["magical_penetration_percentage"]/100)
            end

            if unit.thtd_magical_penetration ~= nil and magicArmor > 0 then
                magicArmor = math.max(0,magicArmor + unit.thtd_magical_penetration)
            end

            local damage_decrease = (1 - (magicArmor * 0.04) /(1 + magicArmor * 0.04))           
            DamageTable.damage = DamageTable.damage * math.max(damage_decrease, 0.33)           
        else
            local damage_decrease = (2 - 0.96^(-magicArmor))
            DamageTable.damage = DamageTable.damage * math.min(damage_decrease, 1.66)           
        end
    end    

    if DamageTable.damage_type == DAMAGE_TYPE_PURE then
        if target:HasModifier("modifier_hina_01_slow_debuff") and unit:THTD_IsTower() then 
            if DamageTable.damage > unit:THTD_GetPower() * unit:THTD_GetStar() * 4 then
                DamageTable.damage = DamageTable.damage + unit:THTD_GetPower() * unit:THTD_GetStar() * 4
            elseif RandomInt(1,100) <= 40 then 
                DamageTable.damage = DamageTable.damage * 1.4
            end
        end
    end        

    local return_damage = math.max(DamageTable.damage, 0)
    if unitName == "satori" then
        local max_damage = 3768000 * 0.5     
        if GameRules.game_info.luck_card == "satori" then
            max_damage = max_damage * (1 + math.max(-90, GameRules.game_info.crit) / 100)
        end	
        return_damage = math.min(return_damage, max_damage)
    end
    DamageTable = {}     
    return return_damage
end

function UnitStunTarget( caster,target,stuntime)
	target:AddNewModifier(caster, nil, "modifier_stunned", {duration=stuntime})
end


local thtd_physical_penetration_buff_table = 
{
    "modifier_mystia_01_buff",
    "modifier_kaguya_03_4_buff",
}

function RefreshPhysicalPenetration(keys)
    local target = keys.target

    target.thtd_physical_penetration = 0

    for k,v in pairs(thtd_physical_penetration_buff_table) do
        local modifier = target:FindModifierByName(v)
        if modifier~=nil then
            local ability = modifier:GetAbility()
            if ability~=nil then
                target.thtd_physical_penetration = target.thtd_physical_penetration + ability:GetSpecialValueFor("penetration")
            end
        end
    end
end


local thtd_magical_penetration_buff_table = 
{
    "modifier_koakuma_02_buff",
    "modifier_byakuren_04_magic_buff",
}

function RefreshMagicalPenetration(keys)
    local target = keys.target

    target.thtd_magical_penetration = 0

    for k,v in pairs(thtd_magical_penetration_buff_table) do
        local modifier = target:FindModifierByName(v)
        if modifier~=nil then
            local ability = modifier:GetAbility()
            if ability~=nil then
                target.thtd_magical_penetration = target.thtd_magical_penetration + ability:GetSpecialValueFor("penetration")
            end
        end
    end
end


local thtd_outgoing_damage_buff_table = 
{
    "modifier_kaguya_03_3_buff",
    "modifier_merlin_01_buff",
}

function RefreshDamageOutgoingPercentage(keys)
    local target = keys.target

    target.thtd_damage_outgoing = 0

    for k,v in pairs(thtd_outgoing_damage_buff_table) do
        local modifier = target:FindModifierByName(v)
        if modifier~=nil then
            local ability = modifier:GetAbility()
            if ability~=nil then
                target.thtd_damage_outgoing = target.thtd_damage_outgoing + ability:GetSpecialValueFor("outgoing_percent")
            end
        end
    end
    
    if target:HasModifier("modifier_item_2014_damage_aura_effect") then
        target.thtd_damage_outgoing = target.thtd_damage_outgoing + 10
    end
end
