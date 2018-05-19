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

function UnitDamageTarget(damage_table)
    local DamageTable = clone(damage_table)
    damage_table = {}
    
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
        DamageTable.damage = DamageTable.damage + DamageTable.attacker:THTD_GetPower()
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
    end

	return ApplyDamage(DamageTable)
end

function ReturnAfterTaxDamage(DamageTable)
    local unit = DamageTable.attacker
    local target = DamageTable.victim

     if target:HasModifier("modifier_bosses_hina") then
        if unit:THTD_IsTower() then
            if DamageTable.damage > unit:THTD_GetPower()*unit:THTD_GetStar()*4 then
                DamageTable.damage = DamageTable.damage * 0.5
            end
        end
    end

    if unit.thtd_damage_outgoing ~= nil and unit.thtd_damage_outgoing ~= 0 then
        DamageTable.damage = DamageTable.damage * (1 + unit.thtd_damage_outgoing/100)
    end

    if target.thtd_damage_incoming ~= nil and target.thtd_damage_incoming ~= 0 then
        DamageTable.damage = DamageTable.damage * (1 + target.thtd_damage_incoming/100)
    end

    if target:HasModifier("modifier_bosses_kisume") then
        DamageTable.damage = DamageTable.damage - 2000
    end

    if (target:GetHealth()/target:GetMaxHealth())>0.7 and unit:HasModifier("modifier_item_2025_damage") then
        DamageTable.damage = DamageTable.damage * 1.5
    end

    if (target:GetHealth()/target:GetMaxHealth())<0.3 and unit:HasModifier("modifier_item_2026_damage") then
        DamageTable.damage = DamageTable.damage * 1.5
    end

    if unit.equip_bonus_table ~= nil and target:HasModifier("modifier_bosses_mokou")==false then
        if RandomInt(0,100) < unit.equip_bonus_table["crit_chance"] + unit.thtd_crit_chance then
            DamageTable.damage = DamageTable.damage * (1.5 + unit.equip_bonus_table["crit_damage"]/100)
            -- SendOverheadEventMessage(unit:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL, target, DamageTable.damage, unit:GetPlayerOwner() )
        end
        DamageTable.damage = DamageTable.damage * (1 + unit.equip_bonus_table["damage_percentage"]/100)
    end

    if unit:GetUnitName() == "yuyuko" then
        if unit.thtd_yuyuko_02_chance == nil then
            unit.thtd_yuyuko_02_chance = 5
        end

        if unit:FindAbilityByName("thtd_yuyuko_02")~=nil and RandomInt(0,100) <= unit.thtd_yuyuko_02_chance then
            DamageTable.damage_type = DAMAGE_TYPE_PURE
            local max_damage = unit:THTD_GetStar() * unit:THTD_GetPower() * 100
            DamageTable.damage = math.min(target:GetHealth() + 5,max_damage)
        end
    end

    if unit:HasModifier("modifier_lily_outgoing_damage") then
        DamageTable.damage = DamageTable.damage * 1.25
    end

    if DamageTable.damage_type == DAMAGE_TYPE_PHYSICAL then
        local armor = target:GetPhysicalArmorValue()

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
            DamageTable.damage = DamageTable.damage / ((1 - (armor * 0.05) /(1 + armor * 0.05)))
            if unit.equip_bonus_table ~= nil then
                armor = armor * (1 - unit.equip_bonus_table["physical_penetration_percentage"]/100)
            end
            if unit.thtd_physical_penetration ~= nil and armor > 0 then
                armor = math.max(0,armor + unit.thtd_physical_penetration)
            end
            local damage_decrease = (1 - (armor * 0.04) /(1 + armor * 0.04))
            if damage_decrease <= 0.33 then
                damage_decrease = 0.33
                DamageTable.damage = DamageTable.damage * damage_decrease
            else
                DamageTable.damage = DamageTable.damage * damage_decrease
            end
        else
            local damage_decrease = (2 - 0.96^(-armor))
            if damage_decrease >= 1.66 then
                DamageTable.damage = DamageTable.damage / damage_decrease
                damage_decrease = 1.66
                DamageTable.damage = DamageTable.damage * damage_decrease
            end
        end
    end

    if DamageTable.damage_type == DAMAGE_TYPE_MAGICAL then
        local magicArmor = target:GetMagicalArmorValue() * 100
        
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
            if damage_decrease <= 0.33 then
                damage_decrease = 0.33
                DamageTable.damage = DamageTable.damage * damage_decrease
            else
                DamageTable.damage = DamageTable.damage * damage_decrease
            end
        else
            local damage_decrease = (2 - 0.96^(-magicArmor))
            if damage_decrease >= 1.66 then
                damage_decrease = 1.66
                DamageTable.damage = DamageTable.damage * damage_decrease
            else
                DamageTable.damage = DamageTable.damage * damage_decrease
            end
        end
    end

    local return_damage = DamageTable.damage

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