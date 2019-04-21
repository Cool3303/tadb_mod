function GetNueExtraDamage(caster)
	local ability = caster:FindAbilityByName("thtd_nue_01")
	local basedamage = caster:THTD_GetPower()
	local extradamage = caster:GetModifierStackCount("modifier_nue_01_extradamage", caster) or 0
	return (extradamage + 1) * basedamage
end

function OnNue01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel())
	keys.ability:StartCooldown(cooldown)	
	keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_nue_01_extradamage", {Duration = cooldown})
	caster.modifier_extradamage_count = math.min(caster:GetModifierStackCount("modifier_nue_01_extradamage", caster) + 1, 50)
	caster:SetModifierStackCount("modifier_nue_01_extradamage", caster, caster.modifier_extradamage_count)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_01_ball.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_ball", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_ball", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTime(effectIndex,keys.Duration)
end

function OnNue01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if target.thtd_damage_lock == true then return end
	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 3, target, 5, "attach_hitloc", Vector(0,0,0), true)

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
	if caster:HasModifier("modifier_byakuren_03_buff") and THTD_IsValid(target) and target.thtd_damage_lock ~= true then
		if target:GetHealthPercent() < 10 and target:HasModifier("modifier_nue_killed") == false then	
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_nue_killed", {Duration = 30.0})
			THTD_Ability_Kill(caster, target)
		end
	end	
end

function OnNue01Destroy(keys)	
	local caster = EntIndexToHScript(keys.caster_entindex)	
	caster.modifier_extradamage_count = caster.modifier_extradamage_count - 1
	if caster.modifier_extradamage_count > 0 then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_nue_01_extradamage", {Duration = 1.0})	
		caster:SetModifierStackCount("modifier_nue_01_extradamage", caster, caster.modifier_extradamage_count)		
	end
end

function OnNue02SpellHit(keys)	
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if target.thtd_damage_lock == true then return end
	local damage_table = {
				ability = keys.ability,
			    victim = target,
			    attacker = caster,
			    damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 2 + GetNueExtraDamage(caster) * keys.damage_crit, 
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	if target:HasModifier("modifier_minamitsu_01_slow_buff") then
		damage_table.damage = damage_table.damage * 1.5
	end
	UnitDamageTarget(damage_table)
	if caster:HasModifier("modifier_byakuren_03_buff") and THTD_IsValid(target) and target.thtd_damage_lock ~= true then
		if target:GetHealthPercent() < 10 and target:HasModifier("modifier_nue_killed") == false then	
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_nue_killed", {Duration = 30.0})
			THTD_Ability_Kill(caster, target)
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