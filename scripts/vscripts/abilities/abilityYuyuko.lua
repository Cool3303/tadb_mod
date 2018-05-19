function OnYuyuko01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	caster:EmitSound("Sound_THTD.thtd_yuyuka_01")

	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)

	for k,v in pairs(targets) do
		local info = 
		{
			Target = v,
			Source = caster,
			Ability = keys.ability,	
			EffectName = "particles/heroes/thtd_yuyuko/ability_yuyuko_01.vpcf",
		    iMoveSpeed = 750,
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
	end
end

function OnYuyuko01SpellHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local DamageTable = {
		ability = keys.ability,
        victim = target, 
        attacker = caster, 
        damage = caster:THTD_GetPower() * 0.6, 
        damage_type = keys.ability:GetAbilityDamageType(), 
        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
   	caster:EmitSound("Hero_Necrolyte.ProjectileImpact")
end


function OnYuyuko04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()
	local vecForward = caster:GetForwardVector() 
	local targetPoint = keys.target_points[1]
	caster.thtd_yuyuko_04_target_point = targetPoint

	caster:EmitSound("Voice_Thdots_Yuyuko.AbilityYuyuko04")

	local unit = CreateUnitByName(
		"npc_dota2x_unit_yuyuko_04"
		,caster:GetOrigin() - vecForward * 100
		,false
		,caster
		,caster
		,caster:GetTeam()
	)
	local ability_dummy_unit = unit:FindAbilityByName("ability_dummy_unit")
	ability_dummy_unit:SetLevel(1)
	
	unit:StartGesture(ACT_DOTA_IDLE)
	local forwardRad = GetRadBetweenTwoVec2D(caster:GetOrigin(),unit:GetOrigin())
	unit:SetForwardVector(Vector(math.cos(forwardRad+math.pi/2),math.sin(forwardRad+math.pi/2),0))

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_yuyuko/ability_yuyuko_04.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/yuyuko/ability_yuyuko_04_effect_d.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex2, 0, caster:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(effectIndex2,2.0)

	unit:SetContextThink(DoUniqueString("ability_yuyuko_04_unit_remove"), 
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			unit:RemoveSelf()
			return nil
		end, 
		5.0)
end

function OnYuyuko04SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
end

function OnYuyuko04SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = caster.thtd_yuyuko_04_target_point

	if GameRules:IsGamePaused() then return end

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.damage_radius)
 
	for _,v in pairs(targets) do  

		if v.thtd_ability_yuyuko_04_damaged ~= true then
			v.thtd_ability_yuyuko_04_damaged = true
			
			local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)

	   		v:SetContextThink(DoUniqueString("thtd_ability_cirno_02_damaged"), 
	   			function()
	   				if GameRules:IsGamePaused() then return 0.03 end
	   				v.thtd_ability_yuyuko_04_damaged = false
	   				return nil
	   			end, 
	   		1.0)
	   	end

		if v:IsAlive() and v:GetHealth() <= (v:GetMaxHealth()*0.3) and v.thtd_damage_lock ~= true then
			effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/yuyuko/ability_yuyuko_04_effect_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 5, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)

	   		local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/yuyuko/ability_yuyuko_04_effect_d.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex2, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystemTime(effectIndex2,2.0)

			v:SetHealth(1)
			local DamageTable = {
	   			ability = keys.ability,
	            victim = v, 
	            attacker = caster, 
	            damage = caster:THTD_GetPower() * caster:THTD_GetStar(), 
	            damage_type = keys.ability:GetAbilityDamageType(), 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
	   	end
	end
end
