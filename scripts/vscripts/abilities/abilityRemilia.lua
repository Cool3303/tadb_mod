function OnRemilia01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	OnRemilia01AbsorbSoul(keys)
end

function OnRemilia01AbsorbSoul(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = keys.ability

	local targets = THTD_FindUnitsInRadius(caster,keys.target:GetOrigin(),800)

	for k,target in pairs(targets) do
		local damage_table={
			ability = ability,
			victim=target, 
			attacker=caster, 
			damage=caster:THTD_GetPower() * caster:THTD_GetStar(),
			damage_type=ability:GetAbilityDamageType(),
			damage_flags=ability:GetAbilityTargetFlags()
		}
		UnitDamageTarget(damage_table)
		
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo01_explosion_vip.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 2, target, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlForward(effectIndex, 2, caster:GetForwardVector())
		ParticleManager:SetParticleControlEnt(effectIndex , 5, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 7, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 10, caster, 5, "follow_origin", Vector(0,0,0), true)

		OnRemilia02SpellStart(caster)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_remilia/ability_remilia_03_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/abiilty_moluo_014.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, keys.target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	
end

function OnRemilia02SpellStart( caster )
	local ability = caster:FindAbilityByName("thtd_remilia_02")
	local modifier = caster:FindModifierByName("modifier_reimilia_02_buff")
	local outgoing = GetMagicalDamageOutgoingPercentage(caster,ability)

	if caster.thtd_remilia_02_count == nil then
		caster.thtd_remilia_02_count = 1
	end

	local count = caster.thtd_remilia_02_count

	if ability:GetLevel()>0 and outgoing<50 then
		ModifyMagicalDamageOutgoingPercentage(caster,count,ability)
		modifier:SetStackCount(outgoing+count)
		caster:SetContextThink(DoUniqueString("modifier_reimilia_02_buff_count"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				ModifyMagicalDamageOutgoingPercentage(caster,-count,ability)
				local outgoing_current = GetMagicalDamageOutgoingPercentage(caster,ability)
				modifier:SetStackCount(outgoing_current-count)
				return nil
			end, 
		20.0)
	end
end

function OnRemilia03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = keys.target_points[1]

	local forward = (keys.target_points[1] - caster:GetOrigin()):Normalized()

	local info = 
	{
			Ability = keys.ability,
        	EffectName = "particles/heroes/remilia/ability_remilia_01.vpcf",
        	vSpawnOrigin = caster:GetOrigin()+Vector(0,0,30),
        	fDistance = 2500,
        	fStartRadius = 300,
        	fEndRadius = 300,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = forward * 4000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	ParticleManager:DestroyLinearProjectileSystem(projectile,false)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/remilia/ability_remilia_03_spark.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin() + Vector(forward.x * 92,forward.y * 92,150))
	ParticleManager:SetParticleControl(effectIndex, 8, Vector(forward.x,forward.y,0))
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_remilia/ability_remilia_03_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnRemilia03SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local chance = RandomInt(0,100)

	if caster.thtd_remilia_03_chance == nil then
		caster.thtd_remilia_03_chance = 5
	end

	if chance <= caster.thtd_remilia_03_chance and caster:FindAbilityByName("thtd_remilia_04"):GetLevel()>0 then
		local dealdamage = caster:THTD_GetPower() * caster:THTD_GetStar() * 48.0
		local damage_table = {
				ability = keys.ability,
				victim = target,
				attacker = caster,
				damage = dealdamage,
				damage_type = keys.ability:GetAbilityDamageType(), 
		    	amage_flags = keys.ability:GetAbilityTargetFlags()
		}
   		local olddamage = ReturnAfterTaxDamage(damage_table)
		if olddamage > (target:GetHealth()*0.95) then
			target:SetHealth(target:GetMaxHealth()*0.05)
		else
			UnitDamageTarget(damage_table)
		end
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_remilia_03_debuff",nil)
	else
		local dealdamage = caster:THTD_GetPower() * caster:THTD_GetStar() * 2.5
		local damage_table = {
				ability = keys.ability,
				victim = target,
				attacker = caster,
				damage = dealdamage,
				damage_type = keys.ability:GetAbilityDamageType(), 
		    	amage_flags = keys.ability:GetAbilityTargetFlags()
		}
		UnitDamageTarget(damage_table)
		OnRemilia02SpellStart(caster)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/remilia/ability_remilia_01_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 3, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

end

function OnRemilia03Destroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.unit

	local dealdamage = caster:THTD_GetPower() * caster:THTD_GetStar() / 4

	local count = 0

	caster:EmitSound("Sound_THTD.thtd_remilia_04")
	
	caster:SetContextThink(DoUniqueString("ability_remilia_03_effect_destroy"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),500)

			for k,target in pairs(targets) do
				local damage_table={
					ability = ability,
					victim=target, 
					attacker=caster, 
					damage=dealdamage,
					damage_type=keys.ability:GetAbilityDamageType(),
					damage_flags=keys.ability:GetAbilityTargetFlags()
				}
				UnitDamageTarget(damage_table)
			end

			OnRemilia02SpellStart(caster)
			if count > 30 then
				return nil
			else
				count = count + 1
				return 0.1
			end
		end, 
	0)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/remilia/ability_remilia_04_laser.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin()+Vector(0,0,700))
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin()+Vector(800,0,800))
	ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin()+Vector(0,0,0))
	ParticleManager:SetParticleControl(effectIndex, 3, target:GetOrigin()+Vector(-800,0,800))
	ParticleManager:SetParticleControl(effectIndex, 4, target:GetOrigin()+Vector(0,0,1600))
	ParticleManager:SetParticleControl(effectIndex, 6, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local effectIndexSmoke = ParticleManager:CreateParticle("particles/heroes/remilia/ability_remilia_04_laser_rocket.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(effectIndexSmoke, 0, target:GetOrigin()+Vector(0,0,700))
	ParticleManager:SetParticleControl(effectIndexSmoke, 1, Vector(1,0,0))
	ParticleManager:SetParticleControl(effectIndexSmoke, 2, Vector(-1,0,0))
	ParticleManager:SetParticleControl(effectIndexSmoke, 3, Vector(0,0,0.5))
	ParticleManager:SetParticleControl(effectIndexSmoke, 4, Vector(0,0,-1))
	ParticleManager:DestroyParticleSystem(effectIndexSmoke,false)
end