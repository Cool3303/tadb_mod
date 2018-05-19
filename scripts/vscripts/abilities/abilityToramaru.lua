local thtd_toramaru_star_bouns_constant =
{
	[1] = 12,
	[2] = 44,
	[3] = 108,
	[4] = 216,
	[5] = 852,
}


function OnToramaru01SpellStart(keys)
	if SpawnSystem:GetWave() > 51 then return end

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
	PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold , true, DOTA_ModifyGold_CreepKill)
	SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, target, gold, caster:GetPlayerOwner() )
	caster:EmitSound("Sound_THTD.thtd_nazrin_01")

	
	local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetAbsOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnToramaru02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if SpawnSystem:GetWave() > 51 then
		keys.ability:EndCooldown()
	end

	if caster:HasModifier("modifier_byakuren_03_buff") then
		PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 250 , true, DOTA_ModifyGold_CreepKill)
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
	if SpawnSystem:GetWave() > 51 then
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
	if SpawnSystem:GetWave() > 51 then
		keys.ability:EndCooldown()
	end

	if caster:HasModifier("modifier_byakuren_03_buff") then
		PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 2500, true, DOTA_ModifyGold_CreepKill)
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
		if SpawnSystem:GetWave() > 51 then
			damage_table.damage = damage_table.damage * 4
		end
		UnitDamageTarget(damage_table)
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, v:GetAbsOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end