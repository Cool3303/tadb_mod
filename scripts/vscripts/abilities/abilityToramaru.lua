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

function OnToramaru02SpellStartDown(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if SpawnSystem:GetWave() > 51 then
		return
	end
	
	if caster:GetModifierStackCount("thtd_toramaru_02", caster) == nil then
		caster:SetModifierStackCount("modifier_toramaru_02_money_stack", caster, 0)
	end

	local interest = caster:GetModifierStackCount("modifier_toramaru_02_money_stack", caster) * 5000 * 0.02 * caster:THTD_GetStar () or 0
	keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_toramaru_02_money_stack", {} )
	caster:SetModifierStackCount("modifier_toramaru_02_money_stack", caster, caster:GetModifierStackCount("modifier_toramaru_02_money_stack", caster)+1)
	CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="toramaru_interest" .. interest , duration=5, params={count=1}, color="#0ff"} )

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetAbsOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end


function OnToramaru03SpellStart(keys)
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

function OnToramaru04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if SpawnSystem:GetWave() > 51 then
		keys.ability:EndCooldown()
		if caster:GetModifierStackCount("thtd_toramaru_02", caster) >= 0 then
			PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 5000, true, DOTA_ModifyGold_CreepKill)
			caster:SetModifierStackCount("modifier_toramaru_02_money_stack", caster, caster:GetModifierStackCount("modifier_toramaru_02_money_stack", caster)-1)
		end
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

