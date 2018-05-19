local thtd_keine_01_attack_bonus = 
{
	[1] = 100,
	[2] = 200,
	[3] = 400,
	[4] = 800,
	[5] = 2000,
}

function OnKeine01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:THTD_IsTower() then
		if target.thtd_keine_01_open == nil then
			target.thtd_keine_01_open = false
		end

		if target.thtd_keine_01_open ~= true then
			target.thtd_keine_01_open = true

			local bonus = thtd_keine_01_attack_bonus[caster:THTD_GetStar()]
			target:THTD_AddAttack(bonus)

			target:SetContextThink(DoUniqueString("thtd_keine_01_buff_remove"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					target:THTD_AddAttack(-bonus)
					target.thtd_keine_01_open = false
				end,
			10.0)
		end
	end
end

function OnKeine01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()

	if keys.ability:GetLevel() < 1 then return end

	local chance = RandomInt(0,100)

	if chance >= 25 then
		local damage = caster:THTD_GetStar() * caster:THTD_GetPower()
		local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
		for k,v in pairs(targets) do
			local DamageTable = {
	   			ability = keys.ability,
	            victim = v, 
	            attacker = caster, 
	            damage = damage, 
	            damage_type = keys.ability:GetAbilityDamageType(), 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
		   	if v.thtd_is_lock_keine_01_stun ~= true then
				v.thtd_is_lock_keine_01_stun = true
				UnitStunTarget(caster,v,1.0)
	   			v:SetContextThink(DoUniqueString("ability_item_iku_01_stun"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						v.thtd_is_lock_keine_01_stun = false
						return nil
					end,
				1.5)
	   		end
		end
	end
end
