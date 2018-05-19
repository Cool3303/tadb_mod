function OnKanako01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target:GetOrigin()
	local targetForward = keys.target:GetForwardVector()

	local knockBackGroup = {}

	local info = 
	{
			Ability = keys.ability,
        	EffectName = "particles/heroes/kanako/ability_kanako_01.vpcf",
        	vSpawnOrigin = targetPoint + Vector(0,0,128),
        	fDistance = 250,
        	fStartRadius = 400,
        	fEndRadius = 400,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = -targetForward * 200,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	ParticleManager:DestroyLinearProjectileSystem(projectile,false)
	
	local origin = targetPoint + targetForward * 150
	local time = 1.25
	local count = 0

	caster:SetContextThink(DoUniqueString("thtd_kanako_01_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local targets = THTD_FindUnitsInRadius(caster,origin,300)
			origin = origin - targetForward * 8

			for k,v in pairs(targets) do
				local forward = v:GetForwardVector()
				if v.thtd_is_kanako_knockback ~= true then
					v:SetOrigin(v:GetOrigin() - forward * 16)
					table.insert(knockBackGroup,v)
				end

				local damage = caster:THTD_GetPower()
				local DamageTable = {
						ability = keys.ability,
				        victim = v, 
				        attacker = caster, 
				        damage = damage/5, 
				        damage_type = keys.ability:GetAbilityDamageType(), 
				        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)

			   	local modifier = v:FindModifierByName("modifier_kanako_01_stun")
			   	if modifier == nil then
					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_kanako_01_stun", {duration=0.1})
				else
					modifier:SetDuration(0.1,false)
				end
			end

			count = count + 1
			if count == 5 then
				count = 0
			   	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_kanako/ability_kanako_01_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, origin+Vector(0,0,160) - targetForward * 150)
				ParticleManager:SetParticleControlForward(effectIndex, 0, targetForward)
				ParticleManager:SetParticleControl(effectIndex, 1, Vector(100,1,1))
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end

			if time > 0 then
				time = time - 0.04
			else
				for k,v in pairs(knockBackGroup) do
					if v~=nil and v:IsNull()==false and v:IsAlive() then
						v.thtd_is_kanako_knockback = true
						FindClearSpaceForUnit(v, v:GetOrigin(), false)
					end
				end
				knockBackGroup = {}
				return nil
			end
			return 0.04
		end,
	0.04)
end

local thtd_kanako_gojou_star_bonus = 
{
	[3] = 2,
	[4] = 4,
	[5] = 6,
}

function OnKanako02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_kanako_gojou_count == nil then
		caster.thtd_kanako_gojou_count = 0
	end

	if caster.thtd_kanako_gojou_count < thtd_kanako_gojou_star_bonus[caster:THTD_GetStar()] then

		local gojou = CreateUnitByName(
				"kanako_gojou", 
				targetPoint, 
				false, 
				caster:GetOwner(), 
				caster:GetOwner(), 
				caster:GetTeam() 
			)
		gojou.thtd_spawn_unit_owner = caster
		gojou:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
		FindClearSpaceForUnit(gojou, targetPoint, false)
		keys.ability:ApplyDataDrivenModifier(caster, gojou, "modifier_kanako_rooted", {})

		local ability = gojou:FindAbilityByName("thtd_kanako_03_unit")
		if ability then
			ability:SetLevel(1)
		end

		if caster.thtd_kanako_gojou_group == nil then
			caster.thtd_kanako_gojou_group = {}
		end

		table.insert(caster.thtd_kanako_gojou_group,gojou)
		caster.thtd_kanako_gojou_count = caster.thtd_kanako_gojou_count + 1
	end
end

function OnKanako03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:GetUnitName() == "kanako_gojou" then
		OnKanako03ReleaseUnit(caster,target)
	end
end

function OnKanako03ReleaseUnit(caster,target)
	if caster.thtd_kanako_gojou_group == nil then
		caster.thtd_kanako_gojou_group = {}
	end
	for k,v in pairs(caster.thtd_kanako_gojou_group) do
		if v==nil or v:IsNull() or v:IsAlive()==false or v == target then
			if v.thtd_kanako_03_gojou_effect~=nil then
				ParticleManager:DestroyParticleSystem(v.thtd_kanako_03_gojou_effect,true)
			end
			if v.thtd_kanako_03_last_link_unit ~= nil and v.thtd_kanako_03_last_link_unit:IsNull()==false and v.thtd_kanako_03_last_link_unit:IsAlive() then
				if v.thtd_kanako_03_last_link_unit.thtd_kanako_03_gojou_effect ~= nil then
					ParticleManager:DestroyParticleSystem(v.thtd_kanako_03_last_link_unit.thtd_kanako_03_gojou_effect,true)
					v.thtd_kanako_03_last_link_unit.thtd_kanako_03_gojou_effect = nil
				end
				v.thtd_kanako_03_last_link_unit.thtd_kanako_03_is_contact = false
			end
			table.remove(caster.thtd_kanako_gojou_group,k)
			caster.thtd_kanako_gojou_count = caster.thtd_kanako_gojou_count - 1
		end
	end

	target:AddNoDraw()
	target:ForceKill(true)
end

function OnKanako03UnitSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local hero = caster.thtd_spawn_unit_owner

	if target:GetUnitName() == "kanako_gojou" and caster~=target and target.thtd_kanako_03_is_contact ~= true then
		if caster.thtd_kanako_03_last_link_unit ~= nil and caster.thtd_kanako_03_last_link_unit:IsNull()==false and caster.thtd_kanako_03_last_link_unit:IsAlive() then
			caster.thtd_kanako_03_last_link_unit.thtd_kanako_03_is_contact = false
			ParticleManager:DestroyParticleSystem(caster.thtd_kanako_03_last_link_unit.thtd_kanako_03_gojou_effect,true)
			caster.thtd_kanako_03_last_link_unit.thtd_kanako_03_gojou_effect = nil
		end
		caster.thtd_kanako_03_last_link_unit = target
		target.thtd_kanako_03_last_link_unit = caster
		target.thtd_kanako_03_is_contact = true
		caster.thtd_kanako_03_is_contact = true
		if caster.thtd_kanako_03_gojou_effect == nil then
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_kanako/ability_kanako_03_line.vpcf", PATTACH_CUSTOMORIGIN, caster) 
			ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_hitloc", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(effectIndex , 1, target, 5, "attach_hitloc", Vector(0,0,0), true)
			caster.thtd_kanako_03_gojou_effect = effectIndex
		else
			ParticleManager:SetParticleControlEnt(caster.thtd_kanako_03_gojou_effect , 1, target, 5, "attach_hitloc", Vector(0,0,0), true)
		end
	end
end

local thtd_kanako_gojou_star_damage_bonus =
{
	[3] = 5,
	[4] = 5,
	[5] = 5
}

function OnKanako03Think(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.thtd_kanako_gojou_group == nil then
		caster.thtd_kanako_gojou_group = {}
	end
	if keys.ability:GetLevel() < 1 or caster:HasModifier("modifier_touhoutd_release_hidden") then 
		for k,v in pairs(caster.thtd_kanako_gojou_group) do
			OnKanako03ReleaseUnit(caster,v)
		end
	else
		for k,v in pairs(caster.thtd_kanako_gojou_group) do
			if v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_kanako_03_is_contact == true then
				if v.thtd_kanako_03_last_link_unit ~= nil and v.thtd_kanako_03_last_link_unit:IsNull()==false and v.thtd_kanako_03_last_link_unit:IsAlive() then
					local targets = 
						FindUnitsInLine(
							caster:GetTeamNumber(), 
							v:GetOrigin(), 
							v.thtd_kanako_03_last_link_unit:GetOrigin(), 
							nil, 
							80,	
							keys.ability:GetAbilityTargetTeam(), 
							keys.ability:GetAbilityTargetType(), 
							keys.ability:GetAbilityTargetFlags()
						)

					for index,unit in pairs(targets) do
					   	local modifier = unit:FindModifierByName("modifier_kanako_03_damaged")
					   	if modifier == nil then
							keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_kanako_03_damaged", {Duration=0.2})
							local damage = caster:THTD_GetPower() * caster:THTD_GetStar()  * thtd_kanako_gojou_star_damage_bonus[caster:THTD_GetStar()]
							local DamageTable = {
									ability = keys.ability,
							        victim = unit, 
							        attacker = caster, 
							        damage = damage * (1 + caster:THTD_GetFaith()/1000), 
							        damage_type = keys.ability:GetAbilityDamageType(), 
							        damage_flags = DOTA_DAMAGE_FLAG_NONE
						   	}
						   	UnitDamageTarget(DamageTable)
						else
							modifier:SetDuration(0.2,false)
						end
					end
				end
			end
		end
	end
end

function OnKanako04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local origin = caster:GetOrigin()

	local time = 15.0
	caster:SetContextThink(DoUniqueString("thtd_kanako_04_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local targets = THTD_FindUnitsInRadius(caster,origin,680)

			for k,v in pairs(targets) do
				local distance = GetDistanceBetweenTwoVec2D(v:GetOrigin(), origin)
				if distance > 600 and distance < 680 then
					local modifier = v:FindModifierByName("modifier_thdots_kanako_04_damaged_buff")
					if modifier == nil then
						keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thdots_kanako_04_damaged_buff", {Duration=0.2})
						local damage = caster:THTD_GetPower() * caster:THTD_GetStar()  * 5
						local DamageTable = {
								ability = keys.ability,
						        victim = v, 
						        attacker = caster, 
						        damage = damage * (1 + caster:THTD_GetFaith()/1000), 
						        damage_type = keys.ability:GetAbilityDamageType(), 
						        damage_flags = DOTA_DAMAGE_FLAG_NONE
					   	}
					   	UnitDamageTarget(DamageTable)
					else
						modifier:SetDuration(0.2,false)
					end
				end
				local damage = caster:THTD_GetPower() * caster:THTD_GetStar() / 4
				local DamageTable = {
						ability = keys.ability,
				        victim = v, 
				        attacker = caster, 
				        damage = damage * (1 + caster:THTD_GetFaith()/1000), 
				        damage_type = keys.ability:GetAbilityDamageType(), 
				        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
			end

			if caster:THTD_IsHidden() then
				caster:RemoveModifierByName("modifier_thdots_kanako_04_buff")
				return nil
			end

			if time > 0 then
				time = time - 0.1
			else
				return nil
			end
			return 0.1
		end,
	0.1)
end

function OnKanakoKill(keys)
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