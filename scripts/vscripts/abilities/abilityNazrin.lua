local thtd_nazrin_star_bouns =
{
	[1] = 0.02,
	[2] = 0.02,
	[3] = 0.02,
	[4] = 0.02,
	[5] = 0.02,
}

local thtd_nazrin_star_bouns_constant =
{
	[1] = 2.4,
	[2] = 8.8,
	[3] = 21.6,
	[4] = 43.2,
	[5] = 170.4,
}


function OnNazrin01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if SpawnSystem:GetWave() > 51 then 
		if caster:HasModifier("modifier_byakuren_03_buff") then
			local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)

			for k,v in pairs(targets) do
				local DamageTable = {
					ability = keys.ability,
			        victim = v, 
			        attacker = caster, 
			        damage = PlayerResource:GetGold(caster:GetPlayerOwnerID())*caster:THTD_GetStar()*0.08, 
			        damage_type = DAMAGE_TYPE_PHYSICAL, 
			        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
		   		UnitDamageTarget(DamageTable)
			end
		end
		return 
	end

	local seed = RandomInt(1,100)
	if seed >= 50 then
		local gold = math.floor(caster:THTD_GetPower() * thtd_nazrin_star_bouns[caster:THTD_GetStar()]) + thtd_nazrin_star_bouns_constant[caster:THTD_GetStar()]

		PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold , true, DOTA_ModifyGold_CreepKill)
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, target, gold, caster:GetPlayerOwner() )
		caster:EmitSound("Sound_THTD.thtd_nazrin_01")
	end
end