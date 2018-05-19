function OnTenshi01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if keys.ability:GetLevel() < 1 then return end

	local crit = Tenshi02GetChance(caster)

	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * crit * 1.5

	if crit > 1 then
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL, target, damage, caster:GetPlayerOwner() )
	end

	caster:EmitSound("Sound_THTD.thtd_tenshi_01")

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)

   	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)

	damage = caster:THTD_GetPower() * caster:THTD_GetStar() * crit * 0.8

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
	
	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnTenshi02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local crit = Tenshi02GetChance(caster)
	local damage = caster:GetAttackDamage() * crit

	if keys.ability:GetLevel() < 1 then return end

   	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),150)
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

	local effectIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnTenshi03AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	
	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_tenshi_03_attack_count == nil then
		caster.thtd_tenshi_03_attack_count = 0
	end

	if caster.thtd_tenshi_03_attack_count_bonus == nil then
		caster.thtd_tenshi_03_attack_count_bonus = 0
	end

	caster.thtd_tenshi_03_attack_count = caster.thtd_tenshi_03_attack_count + 1 + caster.thtd_tenshi_03_attack_count_bonus

	if caster.thtd_tenshi_03_attack_count < keys.max_count then return end

	caster.thtd_tenshi_03_attack_count = 0

	caster:EmitSound("Hero_Magnataur.ShockWave.Particle")

	local info = 
	{
			Ability = keys.ability,
        	EffectName = "particles/heroes/tenshi/ability_tenshi_03.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin(),
        	fDistance = 1500,
        	fStartRadius = 380,
        	fEndRadius = 380,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = caster:GetForwardVector() * 1800,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	ParticleManager:DestroyLinearProjectileSystem(projectile,false)
end

function OnTenshiProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local crit = Tenshi02GetChance(caster)
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * crit * 2.5

	if crit > 1 then
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL, target, damage, caster:GetPlayerOwner() )
	end

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)

end

function Tenshi02GetChance(caster)
	if RandomInt(0, 100) < 40 then
		return 4.0
	end
	return 1.0
end