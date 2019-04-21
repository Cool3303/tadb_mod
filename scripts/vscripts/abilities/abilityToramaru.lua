local thtd_toramaru_star_bouns_constant =
{
	[1] = 15,
	[2] = 55,
	[3] = 135,
	[4] = 270,
	[5] = 1065,
}

function OnToramaru01SpellStart(keys)
	if SpawnSystem.IsUnLimited then return end
	if GameRules:GetCustomGameDifficulty() == 8 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage = caster:THTD_GetPower() * caster:THTD_GetStar(),
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = 0
	}
	UnitDamageTarget(damage_table)

	local gold = thtd_toramaru_star_bouns_constant[caster:THTD_GetStar()]	
	THTD_ModifyGoldEx(caster:GetPlayerOwnerID(), gold , true, DOTA_ModifyGold_CreepKill)
	SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, target, gold, caster:GetPlayerOwner() )
	caster:EmitSound("Sound_THTD.thtd_nazrin_01")

	
	local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetAbsOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnToramaru02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if SpawnSystem.IsUnLimited then
		keys.ability:EndCooldown()
	end

	if caster:HasModifier("modifier_byakuren_03_buff") then
		THTD_ModifyGoldEx(caster:GetPlayerOwnerID(), 250 , true, DOTA_ModifyGold_CreepKill)
	end

	local target = keys.target

	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 10,
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = 0
	}
	if SpawnSystem.IsUnLimited then
		damage_table.damage = damage_table.damage * 4
	end
	UnitDamageTarget(damage_table)
	local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetAbsOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnToramaru03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if SpawnSystem.IsUnLimited then
		keys.ability:EndCooldown()
	end

	if caster:HasModifier("modifier_byakuren_03_buff") then
		THTD_ModifyGoldEx(caster:GetPlayerOwnerID(), 2500, true, DOTA_ModifyGold_CreepKill)
	end
	
	local inners = THTD_FindUnitsInner(caster)

	for k,v in pairs(inners) do
		local damage_table = {
			ability = keys.ability,
			victim = v,
			attacker = caster,
			damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 5,
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = 0
		}
		if SpawnSystem.IsUnLimited then
			damage_table.damage = damage_table.damage * 4
		end
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, v:GetAbsOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end

function OnSpellStartToramaru04(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 2
	if SpawnSystem.IsUnLimited then
		damage = damage + PlayerResource:GetGold(caster:GetPlayerOwnerID())*caster:THTD_GetStar()*0.02*4
	else
		damage = damage + PlayerResource:GetGold(caster:GetPlayerOwnerID())*caster:THTD_GetStar()*0.02
	end
	local targets = THTD_FindUnitsInRadius(caster,caster:GetAbsOrigin(),keys.ability:GetCastRange())
	for k,v in pairs(targets) do
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/sunny/ability_sunny_01_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, v, 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 9, v, 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystem(effectIndex,false)

		local DamageTable = {
			ability = keys.ability,
			victim = v, 
			attacker = caster, 
			damage = damage, 
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		UnitDamageTarget(DamageTable)
	end
end