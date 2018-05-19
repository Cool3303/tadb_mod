function GetNueExtraDamage(caster)
	local ability = caster:FindAbilityByName("thtd_nue_01")

	local basedamage = caster:THTD_GetPower()

	local extradamage = caster:GetModifierStackCount("modifier_nue_01_extradamage", caster) or 0

	return extradamage*basedamage + basedamage
end

function OnNue01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))

	keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_nue_01_extradamage", {} )
	caster:SetModifierStackCount("modifier_nue_01_extradamage", caster, caster:GetModifierStackCount("modifier_nue_01_extradamage", caster)+1)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_01_ball.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_ball", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_ball", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.Duration)
end

function OnNue01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local DamageTable = {
			victim = target, 
			attacker = caster, 
			ability = keys.ability,
			damage = GetNueExtraDamage(caster), 
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	if target:HasModifier("modifier_minamitsu_01_slow_buff") then
		DamageTable.damage = DamageTable.damage * 1.5
	end
	UnitDamageTarget(DamageTable)
	if caster:HasModifier("modifier_byakuren_03_buff") then
		if target:GetHealth() / target:GetMaxHealth() < 0.1 then
			target:SetHealth(1)
			local damage_kill = {
					victim = target, 
					attacker = caster, 
					ability = keys.ability,
					damage = caster:THTD_GetPower() * caster:THTD_GetStar(), 
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = keys.ability:GetAbilityTargetFlags()
			}
			UnitDamageTarget(damage_kill)
		end
	end
	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 3, target, 5, "attach_hitloc", Vector(0,0,0), true)
end

function OnNue02SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local damage_table = {
				ability = keys.ability,
			    victim = keys.target,
			    attacker = caster,
			    damage = caster:THTD_GetPower() * caster:THTD_GetStar() + GetNueExtraDamage(caster) * keys.damage_percent,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	if keys.target:HasModifier("modifier_minamitsu_01_slow_buff") then
		damage_table.damage = damage_table.damage * 1.5
	end
	UnitDamageTarget(damage_table)
	if caster:HasModifier("modifier_byakuren_03_buff") then
		if keys.target:GetHealth() / keys.target:GetMaxHealth() < 0.1 then
			keys.target:SetHealth(1)
			local damage_kill = {
					victim = keys.target, 
					attacker = caster, 
					ability = keys.ability,
					damage = caster:THTD_GetPower() * caster:THTD_GetStar(), 
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = keys.ability:GetAbilityTargetFlags()
			}
			UnitDamageTarget(damage_kill)
		end
	end
end

function OnNue03Kill(keys)
	local caster = keys.attacker
	local target = keys.unit
	local ability = nil
	local level = keys.ability:GetLevel()

	if level >= 1 then
		ability = caster:FindAbilityByName("thtd_nue_01")
		if ability~=nil then
			ability:EndCooldown()
		end
		ability = caster:FindAbilityByName("thtd_nue_02")
		if ability~=nil then
			ability:EndCooldown()
		end
	end
end