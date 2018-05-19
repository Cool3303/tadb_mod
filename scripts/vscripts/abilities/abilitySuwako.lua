function OnSuwako01SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage_table = {
		ability = keys.ability,
		victim = target,
		attacker = caster,
		damage = caster:THTD_GetPower(),
		damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = 0
	}
	UnitDamageTarget(damage_table)

	if target.thtd_is_suwako_knockback ~= true then
		target.thtd_is_suwako_knockback = true
		FindClearSpaceForUnit(target, target:GetOrigin() - target:GetForwardVector()*(150 * (1 + caster:THTD_GetFaith()/500)), false)
	end
end

function OnSuwako01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local info = 
	{
			Ability = keys.ability,
        	EffectName = "particles/heroes/thtd_suwako/ability_suwako_01_ring.vpcf",
        	vSpawnOrigin = caster:GetOrigin() + Vector(0,0,128),
        	fDistance = 600,
        	fStartRadius = 200,
        	fEndRadius = 200,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = caster:GetForwardVector() * 1500,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	ParticleManager:DestroyLinearProjectileSystem(projectile,false)
end


function OnSuwako02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_suwako_02_rect == nil then
		caster.thtd_suwako_02_rect = {}
	end

	caster.thtd_suwako_02_rect["point"]  = targetPoint
	if caster.thtd_suwako_02_rect["effectIndex"] == nil then
		caster.thtd_suwako_02_rect["effectIndex"] = ParticleManager:CreateParticle("particles/heroes/thtd_suwako/ability_suwako_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(caster.thtd_suwako_02_rect["effectIndex"], 0, targetPoint)
		ParticleManager:SetParticleControl(caster.thtd_suwako_02_rect["effectIndex"], 1, Vector(300,1,1))
	else
		ParticleManager:DestroyParticleSystem(caster.thtd_suwako_02_rect["effectIndex"],true)
		caster.thtd_suwako_02_rect["effectIndex"] = ParticleManager:CreateParticle("particles/heroes/thtd_suwako/ability_suwako_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(caster.thtd_suwako_02_rect["effectIndex"], 0, targetPoint)
		ParticleManager:SetParticleControl(caster.thtd_suwako_02_rect["effectIndex"], 1, Vector(300,1,1))
	end
end

function OnSuwako02Think(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.thtd_suwako_02_rect == nil then
		caster.thtd_suwako_02_rect = {}
	end
	if keys.ability:GetLevel() < 1 or caster:HasModifier("modifier_touhoutd_release_hidden") then 
		if caster.thtd_suwako_02_rect["effectIndex"]~=nil then
			ParticleManager:DestroyParticleSystem(caster.thtd_suwako_02_rect["effectIndex"],true)
		end
		return
	end

	if caster.thtd_suwako_02_rect["effectIndex"] ~= nil then
		local point = caster.thtd_suwako_02_rect["point"]
		local targets = THTD_FindUnitsInRadius(caster,point,300)

		for k,v in pairs(targets) do
			if v.thtd_suwako_02_count == nil then
				v.thtd_suwako_02_count = 0
			end
			if v.thtd_suwako_02_lock == nil then
				v.thtd_suwako_02_lock = false
			end
			v.thtd_suwako_02_count = v.thtd_suwako_02_count + 1
			if v.thtd_suwako_02_count > 20 and v.thtd_suwako_02_lock == false then
				keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_suwako_rooted",{Duration = 1.0})
				v.thtd_suwako_02_lock = true

				v:SetContextThink(DoUniqueString("thtd_suwako_02_leave_rect"), 
					function()
						if GetDistanceBetweenTwoVec2D(point,v:GetOrigin())>300 then
							v.thtd_suwako_02_count = 0
							v.thtd_suwako_02_lock = false
							return nil
						else
							local damage_table = {
								ability = keys.ability,
								victim = v,
								attacker = caster,
								damage = caster:THTD_GetStar() * caster:THTD_GetPower() / 4  * (1 + caster:THTD_GetFaith()/500),
								damage_type = keys.ability:GetAbilityDamageType(), 
								damage_flags = 0
							}
							UnitDamageTarget(damage_table)
						end
						return 0.1
					end, 
				0)
			end
		end
	end
end

function OnSuwako03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local inners = THTD_FindUnitsInner(caster)

	for k,v in pairs(inners) do
		if v:HasModifier("modifier_suwako_03_rooted") == false then
			local g = -10
			local vh = 120
			local t = math.abs(2*vh/g)
			local targetPoint = v:GetOrigin() + RandomVector(200)
			local rad = GetRadBetweenTwoVec2D(v:GetOrigin(),targetPoint)
			local dis = GetDistanceBetweenTwoVec2D(v:GetOrigin(),targetPoint)
			local speed = dis/t
			local curOrigin = v:GetOrigin()
			local originz = curOrigin.z
			
			keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_suwako_03_rooted",{})

			local effectIndex = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_torrent_base/kunkka_spell_torrent_splash_econ.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			v:SetContextThink(DoUniqueString("thtd_suwako_03_unit_up"), 
				function()
					if GameRules:IsGamePaused() then return end
					vh = vh + g
					curOrigin = Vector(curOrigin.x + math.cos(rad) * speed,curOrigin.y + math.sin(rad) * speed,curOrigin.z + vh)
					v:SetOrigin(curOrigin)

					if curOrigin.z >= originz then
						return 0.03
					else
						FindClearSpaceForUnit(v, v:GetOrigin(), false)
						local damage_table = {
							ability = keys.ability,
							victim = v,
							attacker = caster,
							damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 5,
							damage_type = keys.ability:GetAbilityDamageType(), 
							damage_flags = 0
						}
						UnitDamageTarget(damage_table)
						v:RemoveModifierByName("modifier_suwako_03_rooted")
						return nil
					end
				end,
			0)
		end
	end
end

function OnSuwakoKill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster:HasModifier("modifier_thtd_ss_kill") then
		local modifier = caster:FindModifierByName("modifier_thtd_ss_faith")
		if modifier==nil then
			caster:AddNewModifier(caster, nil, "modifier_thtd_ss_faith", {})
		elseif modifier:GetStackCount() < caster:THTD_GetStar() * 100 then
			modifier:SetStackCount(modifier:GetStackCount()+1)
		end
	end
end