function OnMiko01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local forward = caster:GetForwardVector()

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/miko/ability_miko_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+Vector(0,0,64))
	ParticleManager:SetParticleControlForward(effectIndex , 0, caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_miko_01_pose", {Duration = 0.2})

	for i=1,3 do
		local rollRad = (i-2)*math.pi/4
		local currentPoint = Vector(math.cos(rollRad)*forward.x - math.sin(rollRad)*forward.y,
								 forward.y*math.cos(rollRad) + forward.x*math.sin(rollRad),
								 0) * 800 + caster:GetOrigin()
		local targets = 
			FindUnitsInLine(
				caster:GetTeamNumber(), 
				caster:GetOrigin(), 
				currentPoint, 
				nil, 
				200,
				keys.ability:GetAbilityTargetTeam(), 
				keys.ability:GetAbilityTargetType(), 
				keys.ability:GetAbilityTargetFlags()
			)
		for k,v in pairs(targets) do
			local DamageTable = {
	   			ability = keys.ability,
	            victim = v, 
	            attacker = caster, 
	            damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 4, 
	            damage_type = keys.ability:GetAbilityDamageType(), 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
		   	keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_miko_01_debuff", {Duration = 5.0})
		end
	end
	
end

function OnMiko02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:THTD_IsTower() and IsTempleOfGodTower(target) then
		if caster.thtd_miko_02_religious_count == nil then
			caster.thtd_miko_02_religious_count = 0
		end

		if caster.thtd_miko_02_religious_count >= 6000 then
			caster:RemoveModifierByName("modifier_miko_02_buff")
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_miko_02_buff", {})
			caster.thtd_miko_02_religious_count = 0
		end
	end
end

function OnMiko02SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1500)

	for k,v in pairs(targets) do
		if IsTempleOfGodTower(v) then
			if caster.thtd_miko_02_religious_count == nil then
				caster.thtd_miko_02_religious_count = 0
			end
			if caster.thtd_miko_02_religious_count < 6000 then
				caster.thtd_miko_02_religious_count = caster.thtd_miko_02_religious_count + 1
				SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, caster.thtd_miko_02_religious_count, caster:GetPlayerOwner() )
			else
				keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_miko_02_buff", {})
			end
		end
	end
end

function OnMiko03SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = caster:THTD_GetStar() * caster:THTD_GetPower(), 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
 end

function OnMiko03SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)

	if keys.ability:GetLevel() < 1 then return end

   	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1200)

   	if #targets > 0 then
		local index = RandomInt(1,#targets)

		if targets[index]~=nil and targets[index]:IsNull()==false and targets[index]:IsAlive() then
			local info = 
			{
				Target = targets[index],
				Source = caster,
				Ability = keys.ability,	
				EffectName = "particles/heroes/thtd_miko/ability_miko_03.vpcf",
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

			local friends = THTD_FindFriendlyUnitsAll(caster)
			for k,believer in pairs(friends) do
				if believer:HasModifier("modifier_miko_02_buff") then
   					local targets_extra = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1200)
   					if #targets_extra > 0 then
						local index_extra = RandomInt(1,#targets_extra)
						if targets_extra[index_extra]~=nil and targets_extra[index_extra]:IsNull()==false and targets_extra[index_extra]:IsAlive() then
							local info_extra = 
							{
								Target = targets_extra[index_extra],
								Source = caster,
								Ability = keys.ability,	
								EffectName = "particles/heroes/thtd_miko/ability_miko_03.vpcf",
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
							local projectile_extra = ProjectileManager:CreateTrackingProjectile(info_extra)
							ParticleManager:DestroyLinearProjectileSystem(projectile_extra,false)
						end
					end
				end
			end
		end
	end
end


function OnMiko04SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local inners = THTD_FindUnitsInner(caster)
	local friends = THTD_FindFriendlyUnitsAll(caster)

	for index,believer in pairs(friends) do
		if believer:HasModifier("modifier_miko_02_buff") then
			if believer:HasModifier("modifier_miko_04_pose") == false then
				keys.ability:ApplyDataDrivenModifier(believer, believer, "modifier_miko_04_pose", {Duration=8.0})
			end
			for k,v in pairs(inners) do
				if RandomInt(0,10) == 1 then
			   		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_miko/ability_thtd_miko_04_starfall.vpcf",PATTACH_CUSTOMORIGIN,caster)
					ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
					ParticleManager:SetParticleControl(effectIndex, 2, RandomVector(255))
					ParticleManager:SetParticleControl(effectIndex, 4, Vector(255,255,255))
					ParticleManager:DestroyParticleSystem(effectIndex,false)

					caster:SetContextThink(DoUniqueString("thtd_miko_04_star_fall"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							local deal_damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 2.5
							local damage_table = {
									ability = keys.ability,
								    victim = v,
								    attacker = caster,
								    damage = deal_damage,
								    damage_type = keys.ability:GetAbilityDamageType(), 
						    	    damage_flags = 0
							}
							UnitDamageTarget(damage_table)
							return nil
						end, 
					0.5)
				end
			end
		end
	end
end