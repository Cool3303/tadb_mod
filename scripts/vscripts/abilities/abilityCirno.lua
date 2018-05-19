function OnCirno01Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.__cirno_lock ~= true then 
		caster.__cirno_lock = true
		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)

		local count = 0
		for i=1,#targets do
			local unit = targets[i]
			if unit~=nil and unit:IsNull()==false and unit~=target and unit:IsAlive() then
				caster:PerformAttack(unit,true,false,true,false,false,false,true)
				count = count + 1
			end
			if count > 4 then
				break
			end
		end
		caster.__cirno_lock = false
	end
end

function OnCirno02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damagedGroup = {}

	Cirno02PassToNextUnit(keys,target,damagedGroup)
end

function Cirno02PassToNextUnit(keys,target,damagedGroup)
	if keys.ability == nil or keys.ability:IsNull() then
		damagedGroup = {}
		return
	end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),keys.radius)

	if targets[1]==nil or #damagedGroup >= keys.unit_max_count then
		damagedGroup = {}
		return
	end
	if #damagedGroup == 0 then
		table.insert(damagedGroup,target)
		local count = keys.ice_count
		caster:SetContextThink(DoUniqueString("thtd_cirno02_projectile"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				local info = 
				{
					Target = target,
					Source = caster,
					Ability = keys.ability,	
					EffectName = "particles/heroes/thtd_cirno/ability_cirno_02.vpcf",
			        iMoveSpeed = 1400,
					vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
					bDrawsOnMinimap = false,                          -- Optional
				    bDodgeable = true,                                -- Optional
				  	bIsAttack = false,                                -- Optional
				    bVisibleToEnemies = true,                         -- Optional
				    bReplaceExisting = false,                         -- Optional
				    flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
					bProvidesVision = true,                           -- Optional
					iVisionRadius = 400,                              -- Optional
					iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
				}
				local projectile = ProjectileManager:CreateTrackingProjectile(info)
				ParticleManager:DestroyLinearProjectileSystem(projectile,false)
				if count > 0 then
					count = count - 1
					return 0.05
				end
				return nil
			end, 
		0.05)
		caster:SetContextThink(DoUniqueString("thtd_cirno02_projectile"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				Cirno02PassToNextUnit(keys,target,damagedGroup)
				return nil
			end, 
		0.5)
	else
		for k,v in pairs(targets) do
			if v~=nil and v:IsNull()==false and IsUnitInGroup(v,damagedGroup) == false then
				table.insert(damagedGroup,v)
				local count = keys.ice_count
				caster:SetContextThink(DoUniqueString("thtd_cirno02_projectile"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						local info = 
						{
							Target = v,
							Source = target,
							Ability = keys.ability,	
							EffectName = "particles/heroes/thtd_cirno/ability_cirno_02.vpcf",
					        iMoveSpeed = 1400,
							vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
							bDrawsOnMinimap = false,                          -- Optional
						    bDodgeable = true,                                -- Optional
						  	bIsAttack = false,                                -- Optional
						    bVisibleToEnemies = true,                         -- Optional
						    bReplaceExisting = false,                         -- Optional
						    flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
							bProvidesVision = true,                           -- Optional
							iVisionRadius = 400,                              -- Optional
							iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
						}
						projectile = ProjectileManager:CreateTrackingProjectile(info)
						ParticleManager:DestroyLinearProjectileSystem(projectile,false)
						if count > 0 then
							count = count - 1
							return 0.05
						end
						return nil
					end, 
				0.05)
				caster:SetContextThink(DoUniqueString("thtd_cirno02_projectile"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						Cirno02PassToNextUnit(keys,v,damagedGroup)
						return nil
					end, 
				0.1)
			end
		end
	end
end

function OnCirno02SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local DamageTable = {
   			ability = keys.ability,
            victim = target, 
            attacker = caster, 
            damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 0.3, 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
   	if RandomInt(1,3) == 1 then
   		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_cirno_frozen_unit", nil)
   	end
   	if target.thtd_ability_cirno_02_damaged ~= true then
   		target.thtd_ability_cirno_02_damaged = true

   		target:SetContextThink(DoUniqueString("thtd_ability_cirno_02_damaged"), 
   			function()
   				if GameRules:IsGamePaused() then return 0.03 end
   				target.thtd_ability_cirno_02_damaged = false
   				return nil
   			end, 
   		3.0)
	   	local effectIndex = ParticleManager:CreateParticle("particles/heroes/cirno/ability_cirno_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)

		caster:EmitSound("Sound_THTD.thtd_cirno_02")
	end
end

function OnCirno03Attack(keys)
	if keys.ability:GetLevel() < 1 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = 1.5 * caster:THTD_GetPower()

	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),250)
	
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
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/cirno/ability_cirno_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end


function OnCirno04Attack(keys)
	if keys.ability:GetLevel() < 1 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()
	local damage = caster:THTD_GetPower() * 2

	if caster.thtd_cirno_04_attack_count == nil then
		caster.thtd_cirno_04_attack_count = 0
	end

	caster.thtd_cirno_04_attack_count = caster.thtd_cirno_04_attack_count + 1

	if caster.thtd_cirno_04_attack_count >= 5 then
		caster.thtd_cirno_04_attack_count = 0
		local count = 0 
		
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_cirno/ability_cirno_04_circle.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
		ParticleManager:DestroyParticleSystem(effectIndex,false)

		caster:SetContextThink(DoUniqueString("thtd_cirno_04_spell_start"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
				for k,v in pairs(targets) do
					local DamageTable = {
			   			ability = keys.ability,
			            victim = v, 
			            attacker = caster, 
			            damage = damage/5, 
			            damage_type = keys.ability:GetAbilityDamageType(), 
			            damage_flags = DOTA_DAMAGE_FLAG_NONE
				   	}
				   	UnitDamageTarget(DamageTable)
				end
				if count > 40 then
					return nil
				end
				caster:EmitSound("Sound_THTD.thtd_cirno_04")
				count = count + 1
				return 0.05
			end,
		0.05)
	end
end