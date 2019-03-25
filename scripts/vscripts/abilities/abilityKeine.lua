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

	if caster.thtd_keine_change == nil then
		caster.thtd_keine_change = THTD_KEINE_02_HUMEN
	end

	if caster.thtd_keine_change == THTD_KEINE_02_HUMEN then
		if target:THTD_IsTower() then

			caster.thtd_last_cast_unit = target

			if target.thtd_keine_01_open == nil then
				target.thtd_keine_01_open = false
			end

			if target.thtd_keine_01_open ~= true then
				target.thtd_keine_01_open = true
				
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_keine/ability_keine_01_buff.vpcf", PATTACH_CUSTOMORIGIN, target) 
				ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "follow_origin", Vector(0,0,0), true)

				local bonus = thtd_keine_01_attack_bonus[caster:THTD_GetStar()]
				target:THTD_AddAttack(bonus)
				local time = 10.0
				target:SetContextThink(DoUniqueString("thtd_keine_01_buff_remove"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						if time <= 0 or caster==nil or caster:IsNull() or caster:THTD_IsHidden() then 							
							target:THTD_AddAttack(-bonus)
							target.thtd_keine_01_open = false
							ParticleManager:DestroyParticleSystem(effectIndex,true)
							return nil 
						end
						time = time - 0.25
						return 0.25
					end,
				0)
			end
		end
	end
end

function OnKeine01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()

	if keys.ability:GetLevel() < 1 then return end
	if caster.thtd_keine_change == THTD_KEINE_02_SHIRASAWA then
		local chance = RandomInt(0,100)

		if chance <= 25 then
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_keine/ability_keine_01_stun.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
			ParticleManager:SetParticleControl(effectIndex, 1, Vector(300,300,300))
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 2
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
		   			v:SetContextThink(DoUniqueString("ability_item_keine_01_stun"), 
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
end

THTD_KEINE_02_HUMEN = 1
THTD_KEINE_02_SHIRASAWA = 2

function OnKeine02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_keine_change == nil then
		caster.thtd_keine_change = THTD_KEINE_02_HUMEN
	end

	if caster.thtd_keine_change == THTD_KEINE_02_HUMEN then
		caster.thtd_keine_change = THTD_KEINE_02_SHIRASAWA
		caster:SetModel("models/thd_hero/keine/keine2/keine2.vmdl")
		caster:SetOriginalModel("models/thd_hero/keine/keine2/keine2.vmdl")
		if caster.thtd_close_ai == true then
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_keine_shirasawa", duration=5, params={}, color="#0ff"} )
		end
	elseif caster.thtd_keine_change == THTD_KEINE_02_SHIRASAWA then
		caster.thtd_keine_change = THTD_KEINE_02_HUMEN
		caster:SetModel("models/thd_hero/keine/keine.vmdl")
		caster:SetOriginalModel("models/thd_hero/keine/keine.vmdl")
		if caster.thtd_close_ai == true then
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_keine_humen", duration=5, params={}, color="#0ff"} )
		end
	end
end

function OnKeine03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,1000)

	if caster.thtd_keine_change == nil then
		caster.thtd_keine_change = THTD_KEINE_02_HUMEN
	end

	if caster.thtd_keine_change == THTD_KEINE_02_HUMEN then
		for k,v in pairs(targets) do
			Keine03MarkUnit(v)
			local modifier = v:FindModifierByName("thtd_keine_03_debuff")
			if modifier==nil and v.thtd_keine_mark_count < 2 then
   				keys.ability:ApplyDataDrivenModifier(caster, v, "thtd_keine_03_debuff", {Duration=10.0})
   			end
		end
	elseif caster.thtd_keine_change == THTD_KEINE_02_SHIRASAWA then
		local inners = THTD_FindUnitsInner(caster)

		for k,v in pairs(inners) do
			if v:HasModifier("thtd_keine_03_debuff") then
				v.thtd_keine_mark_count = v.thtd_keine_mark_count + 1
				v:RemoveModifierByName("thtd_keine_03_debuff")
			end
		end
	end
end

function Keine03MarkUnit(unit)
	unit.thtd_keine_mark_count = 0
	unit.thtd_keine_03_origin = unit:GetOrigin()
	unit.thtd_keine_03_next_move_point = unit.next_move_point
	unit.thtd_keine_03_next_move_forward = unit.next_move_forward
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_keine/ability_keine_03.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleControl(effectIndex, 0, unit:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, unit:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 2, unit:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	unit.thtd_keine_03_mark_health = unit:GetHealth()
end

function OnKeine03AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_keine_03_chance == nil then
		caster.thtd_keine_03_chance = 20
	end

	if caster.thtd_keine_change == THTD_KEINE_02_HUMEN then
		local chance = RandomInt(0,100)
		
		if chance < caster.thtd_keine_03_chance then
			local targetPoint = target:GetOrigin()
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
			for k,v in pairs(targets) do
				Keine03MarkUnit(v)
				local modifier = v:FindModifierByName("thtd_keine_03_debuff")
				if modifier==nil and v.thtd_keine_mark_count < 2 then
	   				keys.ability:ApplyDataDrivenModifier(caster, v, "thtd_keine_03_debuff", {Duration=10.0})
	   			end
	   		end
		end
	else
		local targetPoint = target:GetOrigin()
		local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
				
		for k,v in pairs(targets) do
			if v:HasModifier("thtd_keine_03_debuff") then
				v.thtd_keine_mark_count = v.thtd_keine_mark_count + 1
				v:RemoveModifierByName("thtd_keine_03_debuff")
			end
		end
	end
end

function OnKeine03Destroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target~=nil and target:IsNull()==false and target:IsAlive() and target.thtd_keine_03_origin ~= nil then
		local distance = GetDistanceBetweenTwoVec2D(target:GetOrigin(), target.thtd_keine_03_origin)

		local effectIndex = ParticleManager:CreateParticle("particles/bosses/thtd_keine/ability_bosses_keine.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		FindClearSpaceForUnit(target,target.thtd_keine_03_origin,false)
		ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)

   		target.next_move_point = target.thtd_keine_03_next_move_point
		target.next_move_forward = target.thtd_keine_03_next_move_forward
		target.thtd_keine_03_origin = nil

		local currentHealth = target:GetHealth()
		local decrease_health = target.thtd_keine_03_mark_health - currentHealth

		target:SetHealth(target.thtd_keine_03_mark_health)

		if caster.thtd_keine_04_change == THTD_KEINE_04_SWORD then
 			OnKeine04Sword(keys,target)
		elseif caster.thtd_keine_04_change == THTD_KEINE_04_JADE then
			OnKeine04Jade(keys,target,distance)
		elseif caster.thtd_keine_04_change == THTD_KEINE_04_MIRROR then
			OnKeine04Mirror(keys,target,decrease_health,currentHealth)
		elseif caster.thtd_keine_04_change == THTD_KEINE_04_SHRINE then
			OnKeine04Shrine(keys,target)
		end
	end
end

function OnKeine04SwordHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 5

	local DamageTable = {
			ability = caster,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end

function OnKeine04Sword(keys,target)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local info = 
	{
		Target = target,
		Source = caster,
		Ability = keys.ability,	
		EffectName = "particles/heroes/thtd_keine/ability_keine_04_sword.vpcf",
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
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
	}
	local projectile = ProjectileManager:CreateTrackingProjectile(info)
	ParticleManager:DestroyLinearProjectileSystem(projectile,false)
end

function OnKeine04Jade(keys,target,distance)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * distance/100

	local DamageTable = {
			ability = caster,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end

function OnKeine04Mirror(keys,target,decrease_health,currentHealth)
	local caster = EntIndexToHScript(keys.caster_entindex)
	target:SetHealth(currentHealth+decrease_health/2)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_keine/ability_keine_04_mirror.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnKeine04Shrine(keys,target)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
end

THTD_KEINE_04_SWORD = 1
THTD_KEINE_04_JADE = 2
THTD_KEINE_04_MIRROR = 3
THTD_KEINE_04_SHRINE = 4

function OnKeine04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_keine_04_change == nil then
		caster.thtd_keine_04_change = THTD_KEINE_04_SWORD
	end

	if caster.thtd_keine_04_change == THTD_KEINE_04_SWORD then
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_keine_04_jade", duration=5, params={count=1}, color="#0ff"} )
		caster.thtd_keine_04_change = THTD_KEINE_04_JADE
	elseif caster.thtd_keine_04_change == THTD_KEINE_04_JADE then
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_keine_04_mirror", duration=5, params={count=1}, color="#0ff"} )
		caster.thtd_keine_04_change = THTD_KEINE_04_MIRROR
	elseif caster.thtd_keine_04_change == THTD_KEINE_04_MIRROR then
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_keine_04_shrine", duration=5, params={count=1}, color="#0ff"} )
		caster.thtd_keine_04_change = THTD_KEINE_04_SHRINE
	elseif caster.thtd_keine_04_change == THTD_KEINE_04_SHRINE then
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_keine_04_sword", duration=5, params={count=1}, color="#0ff"} )
		caster.thtd_keine_04_change = THTD_KEINE_04_SWORD
	end
end