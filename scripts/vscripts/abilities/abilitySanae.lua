local thtd_sanae_star_bonus = 
{
	[1] = 25,
	[2] = 50,
	[3] = 100,
	[4] = 200,
	[5] = 500,
}

thtd_sanae_01 = class({})

function thtd_sanae_01:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local ExtraData = { 
			count=0
		}
		
	self:Sanae01PassToNextUnit(caster,caster:GetOrigin(),target,ExtraData)
end


function thtd_sanae_01:Sanae01PassToNextUnit(target,target_1,target_2,data)
	local caster = self:GetCaster()

	local info = 
	{
		Target = target_2,
		Source = target,
		Ability = self,	
		EffectName = "particles/heroes/sanae/ability_sanae_01.vpcf",
        iMoveSpeed = 1400,
		vSourceLoc= target_1,                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
	    bDodgeable = true,                                -- Optional
	  	bIsAttack = false,                                -- Optional
	    bVisibleToEnemies = true,                         -- Optional
	    bReplaceExisting = false,                         -- Optional
	    flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,
		iVisionRadius = 400,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = { 
			count=data.count + 1
		}
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

--------------------------------------------------------------------------------

function thtd_sanae_01:OnProjectileHit_ExtraData( hTarget, vLocation, data )
	local caster = self:GetCaster()
	local target = hTarget

	if target:THTD_IsTower() and target.thtd_sanae_01_bonus ~= true then
		local bonus = thtd_sanae_star_bonus[caster:THTD_GetStar()] / (data.count+1)
		target:THTD_AddPower(bonus)
		caster.thtd_last_cast_unit = target
		target.thtd_sanae_01_bonus = true

		local effectIndex = ParticleManager:CreateParticle("particles/heroes/sanae/ability_sanae_01_effect.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystemTime(effectIndex,5.0)

		caster:SetContextThink(DoUniqueString("thtd_koishi03_buff_remove"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				target:THTD_AddPower(-bonus)
				target.thtd_sanae_01_bonus = false
			end,
		5.0)
	end

	local targets = 
		FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetOrigin(), 
			nil, 
			400, 
			self:GetAbilityTargetTeam(), 
			self:GetAbilityTargetType(), 
			self:GetAbilityTargetFlags(), 
			FIND_ANY_ORDER, 
			false
		)

	for k,v in pairs(targets) do
		if v~=nil and v~=target and v:THTD_IsTower() and v.thtd_sanae_01_bonus ~= true and data.count < 4 then
			self:Sanae01PassToNextUnit(target,vLocation,v,data)
			break
		end
	end

	return true
end

function OnSanae02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_sanae/ability_sanae_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystemTime(effectIndex,5.0)

	effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_sanae/ability_sanae_02_p.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystemTime(effectIndex,5.0)

	local time = 5.0

	caster:SetContextThink(DoUniqueString("thtd_patchouli04_spell_start"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time <= 0 then 
				return nil 
			end
			time = time - 0.1
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
			for k,v in pairs(targets) do
				local modifier = v:FindModifierByName("modifier_sanae_debuff")
			   	if modifier == nil then
					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_sanae_debuff", {duration=0.2})
				else
					modifier:SetDuration(0.2,false)
			   	end
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.2, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
			end
			return 0.1
		end,
	0.1)
end

function OnSanae03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local time = 2.0

	local vec = targetPoint + RandomVector(300)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_sanae_03/ability_sanae_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, vec)
	ParticleManager:SetParticleControl(effectIndex, 1, vec)
	ParticleManager:SetParticleControl(effectIndex, 3, vec)
	ParticleManager:SetParticleControl(effectIndex, 4, vec)
	ParticleManager:SetParticleControl(effectIndex, 5, vec)
	ParticleManager:SetParticleControl(effectIndex, 6, vec)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	caster:SetContextThink(DoUniqueString("thtd_patchouli04_spell_start"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time <= 0 then 
				return nil 
			end
			time = time - 0.2
			local targets = THTD_FindUnitsInRadius(caster,vec,300)
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * (1 + caster:THTD_GetFaith()/250), 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
		   		UnitStunTarget(caster,v,0.5 * (1 + caster:THTD_GetFaith()/250))
			end
			vec = targetPoint + RandomVector(300)
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_sanae_03/ability_sanae_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, vec)
			ParticleManager:SetParticleControl(effectIndex, 1, vec)
			ParticleManager:SetParticleControl(effectIndex, 3, vec)
			ParticleManager:SetParticleControl(effectIndex, 4, vec)
			ParticleManager:SetParticleControl(effectIndex, 5, vec)
			ParticleManager:SetParticleControl(effectIndex, 6, vec)
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			return 0.2
		end,
	0.2)
end

function OnSanae04SpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability

	local targets = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1000)

	for k,v in pairs(targets) do
		ability:ApplyDataDrivenModifier(caster, v, "modifier_sanae_04_buff", nil)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/sanae/ability_sanea_04_effect_b.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(effectIndex,15.0)
end

function OnSanaeKill(keys)
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