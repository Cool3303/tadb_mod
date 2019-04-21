function OnJunko01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.ability_junko_01_target == target then return end
	if caster == target then return end

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_junko_01", nil)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_junko/ability_junko_01_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "follow_origin", Vector(0,0,0), true)

	local effectIndex_caster = ParticleManager:CreateParticle("particles/heroes/thtd_junko/ability_junko_01_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex_caster , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	caster.ability_junko_01_target = target

	caster:SetContextThink(DoUniqueString("modifier_junko_01"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster:THTD_IsHidden() then
				if target~=nil and target:IsNull()==false and target:HasModifier("modifier_junko_01") then
					target:RemoveModifierByName("modifier_junko_01")
				end
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				ParticleManager:DestroyParticleSystem(effectIndex_caster,true)
				caster.ability_junko_01_target = nil
				return nil
			end
			if caster.ability_junko_01_target ~= target then
				if target~=nil and target:IsNull()==false and target:HasModifier("modifier_junko_01") then
					target:RemoveModifierByName("modifier_junko_01")
				end
				ParticleManager:DestroyParticleSystem(effectIndex,true)				
				return nil
			end
			return 0.2
		end,
	0.2)	
end

function OnJunko02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)		
	local max_count = 25	

	caster:SetContextThink("modifier_junko_02_think", 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster==nil or caster:IsNull() or caster:IsAlive()==false then return nil end
			if caster:THTD_IsHidden() or max_count <= 0 then return nil end
			max_count = max_count - 1

			local forwardCos = caster:GetForwardVector().x
			local forwardSin = caster:GetForwardVector().y
			local angle = (39 - 6.5 * RandomInt(0,12)) / 180 * math.pi
			local forward = Vector(	math.cos(angle)*forwardCos - math.sin(angle)*forwardSin,
									forwardSin*math.cos(angle) + forwardCos*math.sin(angle),0)
			local info = 
			{
					Ability = keys.ability,
		        	EffectName = "particles/heroes/thtd_junko/ability_junko_02.vpcf",
		        	vSpawnOrigin = caster:GetOrigin() + forward * 500 - caster:GetForwardVector() * 500 + Vector(0,0,128),
		        	fDistance = 1200,
		        	fStartRadius = 150,
		        	fEndRadius = 150,
		        	Source = caster,
		        	bHasFrontalCone = false,
		        	bReplaceExisting = false,
		        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        	fExpireTime = GameRules:GetGameTime() + 10.0,
					bDeleteOnHit = true,
					vVelocity = caster:GetForwardVector() * 1800,
					bProvidesVision = true,
					iVisionRadius = 1000,
					iVisionTeamNumber = caster:GetTeamNumber()
			}
			local projectile = ProjectileManager:CreateLinearProjectile(info)
			ParticleManager:DestroyLinearProjectileSystem(projectile,false)
			return 0.2
		end,
	0.1)
end

function OnJunkoProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target	
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 2

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)

   	if target.thtd_junko_02_debuff_count == nil then
   		target.thtd_junko_02_debuff_count = 0
   	end
   	if target.thtd_junko_02_debuff_count < 5 then
   		target.thtd_junko_02_debuff_count = target.thtd_junko_02_debuff_count + 1   	
   	end
end

function OnJunko03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,500)
	for k,v in pairs(targets) do
		local damage = caster:THTD_GetPower()*caster:THTD_GetStar() * 4
		
		if v.thtd_junko_02_debuff_count ~= nil then
			damage = damage * (1 + v.thtd_junko_02_debuff_count * 0.2) 
			if v.thtd_junko_02_debuff_count >= 5 then UnitStunTarget(caster,v,2) end
			v.thtd_junko_02_debuff_count = 0
		end

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

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_junko/ability_junko_03.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)			
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnJunko04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,500)
	for k,v in pairs(targets) do
		local damage = caster:THTD_GetPower()*caster:THTD_GetStar()*20

		local DamageTable = {
			ability = keys.ability,
	        victim = v, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
		UnitDamageTarget(DamageTable)
		if not v:HasModifier("modifier_junko_04_debuff") then 
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_junko_04_debuff", {Duration = 1.5})		
		end	
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_junko/ability_junko_04.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint+Vector(0,0,64))		
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(1,0,0))			
	ParticleManager:SetParticleControl(effectIndex, 2, Vector(255,255,255))				
	ParticleManager:SetParticleControl(effectIndex, 3, targetPoint)	
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnJunko04BuffDestroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if THTD_IsValid(caster) and THTD_IsValid(target) then
		local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = caster:THTD_GetPower()*caster:THTD_GetStar()*20*2, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		UnitDamageTarget(DamageTable)
	end
end