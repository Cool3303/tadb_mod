function OnDaiyousei01SpellStart(keys)
	if SpawnSystem:GetWave() > 51 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	caster:EmitSound("Hero_Enchantress.EnchantCreep")

	if target:THTD_IsTower() and target~=caster and target:THTD_GetLevel()<THTD_MAX_LEVEL then
		target:THTD_LevelUp(caster:THTD_GetStar())
		target.thtd_exp = thtd_exp_table[target:THTD_GetLevel()-1]
	end
	local count = caster:THTD_GetStar()
	local targets = THTD_FindFriendlyUnitsInRadius(caster,target:GetOrigin(),1000)

	for k,v in pairs(targets) do
		if count > 0 and v:THTD_IsTower() and v~=caster and v:THTD_GetLevel()<THTD_MAX_LEVEL and v~=target then
			v:THTD_LevelUp(count)
			v.thtd_exp = thtd_exp_table[v:THTD_GetLevel()-1]
			count = count - 1
		end
	end
end

function OnDaiyousei02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	caster:EmitSound("Sound_THTD.thtd_daiyousei_02")

	local targets = 
		FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetOrigin(), 
			nil, 
			1000, 
			keys.ability:GetAbilityTargetTeam(), 
			keys.ability:GetAbilityTargetType(), 
			keys.ability:GetAbilityTargetFlags(), 
			FIND_ANY_ORDER, 
			false
		)

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_yatagarasu.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex , 0 , caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)	

	for k,v in pairs(targets) do
		if IsInDaiyousei02BlackList(v) == false then
			v:GiveMana(10)
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/daiyousei/ability_daiyousei_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex , 0 , v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	end
end

local daiyousei_02_black_list =
{
	"lily",
	"daiyousei",
	"youmu",
}

function IsInDaiyousei02BlackList(unit)
	for k,v in pairs(daiyousei_02_black_list) do
		if unit:GetUnitName() == v then
			return true
		end
	end
	return false
end

function OnDaiyousei03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.ability_daiyousei_03_target == target then return end
	if caster == target then return end

	caster:EmitSound("Hero_Wisp.Tether.Target")

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_daiyousei_03", {})
	local stack_count = target:GetModifierStackCount("modifier_daiyousei_03", nil) + 1 or 1
	target:SetModifierStackCount("modifier_daiyousei_03", nil, stack_count)
	
	local effectIndex = Daiyousei03CreateLine(caster,target)
	caster.ability_daiyousei_03_target = target

	local count = 0
	caster:SetContextThink(DoUniqueString("modifier_daiyousei_03"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster.ability_daiyousei_03_target ~= target then
				if target~=nil and target:IsNull()==false and target:HasModifier("modifier_daiyousei_03") then
					target:SetModifierStackCount("modifier_daiyousei_03", nil, target:GetModifierStackCount("modifier_daiyousei_03", nil) - 1)
					if (target:GetModifierStackCount("modifier_daiyousei_03", nil) or 0) <= 0 then
						target:RemoveModifierByName("modifier_daiyousei_03")
					end	
				end
				if count > 10 then
					caster:StopSound("Hero_Wisp.Tether.Target")
				else
					count = count + 1
				end
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				return nil
			end
			return 0.1
		end,
	0.1)

	caster:SetContextThink("modifier_daiyousei_03_remove", 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster:HasModifier("modifier_touhoutd_release_hidden") or keys.ability:GetLevel()<1 then
				caster.ability_daiyousei_03_target = nil
				return nil
			end
			return 0.1
		end,
	0.1)
end

function Daiyousei03CreateLine(caster,target)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/daiyousei/ability_daiyousei_03.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, target, 5, "attach_hitloc", Vector(0,0,0), true)
	return effectIndex
end

function OnDaiyousei04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_ability_daiyousei_04_lock == nil then caster.thtd_ability_daiyousei_04_lock = false end

	if target:GetUnitName() == "cirno" and target:THTD_GetStar() == 5 and caster.thtd_ability_daiyousei_04_lock == false then
		target:EmitSound("Hero_Wisp.Tether")
		caster.thtd_ability_daiyousei_04_lock = true
		
		target:THTD_UpgradeEx()

        local newAttackTime = target:GetBaseAttackTime() * 0.66
        if newAttackTime < 0.3 then newAttackTime = 0.3 end
		target:SetBaseAttackTime(newAttackTime)
        
		target:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

        target:SetModel("models/new_touhou_model/cirno/ex/ex_cirno.vmdl")
		target:SetOriginalModel("models/new_touhou_model/cirno/ex/ex_cirno.vmdl")
		target:SetModelScale(target:GetModelScale() * 1.2)
        
		local mana_regen_ability = target:FindAbilityByName("ability_common_mana_regen_buff")
		if mana_regen_ability ~= nil then
			if mana_regen_ability:GetLevel() < mana_regen_ability:GetMaxLevel() then
				mana_regen_ability:SetLevel(mana_regen_ability:GetMaxLevel())
			end
		end
    
        print("exup_count: "..target.exup_count
             .."\n\tpower:  "..target.thtd_power
             .."\n\tattack: "..target.thtd_attack
             .."\n\ttime:   "..target:GetBaseAttackTime())          
	end
end