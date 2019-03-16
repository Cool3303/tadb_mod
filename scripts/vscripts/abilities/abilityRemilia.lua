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

		OnRemilia02SpellStart(caster, 1)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_remilia/ability_remilia_03_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/abiilty_moluo_014.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, keys.target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	
end

function OnRemilia02SpellStart(caster, factor)
	local ability = caster:FindAbilityByName("thtd_remilia_02")
	local modifier = caster:FindModifierByName("modifier_reimilia_02_buff")
	
	if caster.thtd_remilia_02_count == nil then
		caster.thtd_remilia_02_count = 1
	end
	if caster.thtd_remilia_02_outgoing == nil then
		caster.thtd_remilia_02_outgoing = 0
	end

	local count = math.min(caster.thtd_remilia_02_count * factor, 50 - caster.thtd_remilia_02_outgoing)
	if ability:GetLevel() > 0 and count > 0 then		
		ModifyMagicalDamageOutgoingPercentage(caster,count)
		caster.thtd_remilia_02_outgoing = caster.thtd_remilia_02_outgoing + count
		modifier:SetStackCount(caster.thtd_remilia_02_outgoing)
		caster:SetContextThink(DoUniqueString("modifier_reimilia_02_buff_count"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end				
				ModifyMagicalDamageOutgoingPercentage(caster,-count)
				caster.thtd_remilia_02_outgoing = caster.thtd_remilia_02_outgoing - count
				modifier:SetStackCount(caster.thtd_remilia_02_outgoing)
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
	local hero = caster:GetOwner()

	if caster.thtd_remilia_03_chance == nil then
		caster.thtd_remilia_03_chance = 5
	end
	
	if caster.thtd_remilia_03_chanceBonus == nil then
		caster.thtd_remilia_03_chanceBonus = 0
	end
	
	local chance = RandomInt(0, math.max(0, 100 - caster.thtd_remilia_03_chanceBonus))
	caster.thtd_remilia_03_chanceBonus = caster.thtd_remilia_03_chanceBonus + caster.thtd_remilia_03_chance	

	if chance <= caster.thtd_remilia_03_chance and caster:FindAbilityByName("thtd_remilia_04"):GetLevel()>0 then	
		caster.thtd_remilia_03_chanceBonus = 0
		
		local dealdamage = caster:THTD_GetPower() * caster:THTD_GetStar() * 48			
		local damage_table = {
				ability = keys.ability,
				victim = target,
				attacker = caster,
				damage = dealdamage,
				damage_type = keys.ability:GetAbilityDamageType(), 
				amage_flags = keys.ability:GetAbilityTargetFlags()
		}
		local olddamage = ReturnAfterTaxDamageAfterAbility(damage_table)
		if olddamage > (target:GetHealth()*0.95) then
			if target:GetHealth() > target:GetMaxHealth()*0.05 then 
				caster.thtd_tower_damage = caster.thtd_tower_damage + (target:GetHealth() - target:GetMaxHealth()*0.05) / 100
				target:SetHealth(target:GetMaxHealth()*0.05)				
			end
		else
			UnitDamageTarget(damage_table)
		end		
		
		if not target:HasModifier("modifier_remilia_03_debuff") then
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_remilia_03_debuff",nil)			
		end
	else
		local dealdamage = caster:THTD_GetPower() * caster:THTD_GetStar() * 5
		local damage_table = {
				ability = keys.ability,
				victim = target,
				attacker = caster,
				damage = dealdamage,
				damage_type = keys.ability:GetAbilityDamageType(), 
		    	amage_flags = keys.ability:GetAbilityTargetFlags()
		}
		UnitDamageTarget(damage_table)
		OnRemilia02SpellStart(caster, 1)
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

	local dealdamage = caster:THTD_GetPower() * caster:THTD_GetStar() * 3

	local time = 3.0

	caster:EmitSound("Sound_THTD.thtd_remilia_04")
	
	caster:SetContextThink(DoUniqueString("ability_remilia_03_effect_destroy"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time <= 0 then return nil end

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

			OnRemilia02SpellStart(caster, 3)			

			time = time - 0.3
			return 0.3			
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
