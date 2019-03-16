function OnMokou01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_mokou_01_crit_chance == nil then
		caster.thtd_mokou_01_crit_chance = 10
	end

	if caster.thtd_mokou_01_crit_damage == nil then
		caster.thtd_mokou_01_crit_damage = 2.0
	end

	if caster.thtd_mokou_01_crit_chance < (caster:THTD_GetStar() * 10 + 20) then
		caster.thtd_mokou_01_crit_chance = caster.thtd_mokou_01_crit_chance + 5
	end

	local modifier = caster:FindModifierByName("passive_mokou_01_crit")

	if modifier ~= nil then
		modifier:SetStackCount(caster.thtd_mokou_01_crit_chance)
		modifier:SetDuration(10.0,false)
	else
		local modifier = keys.ability:ApplyDataDrivenModifier(caster, caster, "passive_mokou_01_crit", {Duration = 10.0})
		modifier:SetStackCount(caster.thtd_mokou_01_crit_chance)
	end

	local crit = Mokou02GetChance(caster)

	if crit > 1 then
		local damage = keys.attack_damage * crit

		if caster.thtd_mokou_01_crit_damage * 2 < (2^(caster:THTD_GetStar())) then
			caster.thtd_mokou_01_crit_damage = caster.thtd_mokou_01_crit_damage * 2
		end
		local radius = 150
		if caster.thtd_mokou_03_open == true then
			radius = 300
		end

	   	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),radius)
	   	
		for k,v in pairs(targets) do
			local DamageTable_aoe = {
	   			ability = keys.ability,
	            victim = v, 
	            attacker = caster, 
	            damage = damage, 
	            damage_type = keys.ability:GetAbilityDamageType(), 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable_aoe)
		   	if crit > 1 then
				SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL, v, damage, caster:GetPlayerOwner() )
			end
		end
		if caster.thtd_mokou_03_open == true then
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/mouko/ability_mokou_01_boom.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 3, target:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			caster:EmitSound("Hero_OgreMagi.Fireblast.Target")
		else
			local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/mouko/ability_mokou_02_boom.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin()+Vector(0,0,64))
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(1,1,1))
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			caster:EmitSound("Hero_OgreMagi.Fireblast.Target")
		end
	else
		caster.thtd_mokou_01_crit_damage = 2.0
	end
end

function OnMokou01Remove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	caster.thtd_mokou_01_crit_chance = 10
	caster.thtd_mokou_01_crit_damage = 2.0
end

function Mokou02GetChance(caster)
	if caster.thtd_mokou_01_crit_damage == nil then
 		caster.thtd_mokou_01_crit_damage = 2.0
 	end

 	local extra_chance = 0
 	if caster.thtd_keine_01_open == true then
 		extra_chance = 15
 	end
 	
 	if RandomInt(0,100) < caster.thtd_mokou_01_crit_chance + extra_chance then
 		return caster.thtd_mokou_01_crit_damage
 	end
 	return 1.0
end

local thtd_mokou_03_star_bonus = 
{
	[4] = 500,
	[5] = 2000,
}

function OnMokou03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.thtd_mokou_03_open == nil then
		caster.thtd_mokou_03_open = true
	end
	caster.thtd_mokou_03_open = true

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/mouko/ability_mokou_04_wing.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,10.0)

	local bonus = thtd_mokou_03_star_bonus[caster:THTD_GetStar()]
	caster:THTD_AddAttack(bonus)

	caster:SetContextThink(DoUniqueString("thtd_koishi03_buff_remove"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			caster:THTD_AddAttack(-bonus)
			caster.thtd_mokou_03_open = false
		end,
	10.0)
end