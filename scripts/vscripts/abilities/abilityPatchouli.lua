local PATCHOULI_01_AGNI_SHINE = 0
local PATCHOULI_01_BURY_IN_LAKE = 1
local PATCHOULI_01_MERCURY_POISON = 2

function OnPatchouli01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_patchouli_02_type == nil then
		caster.thtd_patchouli_02_type = 2
	end
	if caster.thtd_patchouli_02_cast_type == nil then
		caster.thtd_patchouli_02_cast_type = 0
	end

	if caster.thtd_patchouli_02_type == PATCHOULI_01_AGNI_SHINE then
		Patchouli01AgniShine(keys)
		caster.thtd_patchouli_02_cast_type = PATCHOULI_01_AGNI_SHINE
	elseif caster.thtd_patchouli_02_type == PATCHOULI_01_BURY_IN_LAKE then
		Patchouli01BuryInLake(keys)
		caster.thtd_patchouli_02_cast_type = PATCHOULI_01_BURY_IN_LAKE
	elseif caster.thtd_patchouli_02_type == PATCHOULI_01_MERCURY_POISON then
		Patchouli01MercuryPoison(keys)
		caster.thtd_patchouli_02_cast_type = PATCHOULI_01_MERCURY_POISON
	end
end

function Patchouli01AgniShine(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,350)
	for k,v in pairs(targets) do
		local DamageTable = {
   			ability = keys.ability,
            victim = v, 
            attacker = caster, 
            damage = caster:THTD_GetPower() * 2^caster:THTD_GetStar(), 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end

	caster:EmitSound("Hero_Invoker.Cataclysm.Ignite")

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_patchouli/ability_patchouli_01_agni_shine.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)
	
end

function Patchouli01BuryInLake(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	
	local isFirst = false
	local time = 10.0	
	local hero = caster:GetOwner()

	caster:EmitSound("Sound_THTD.thtd_patchouli_01_02")
	
	caster:SetContextThink(DoUniqueString("thtd_patchouli01_buryinlake"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time < 0 then return nil end
			
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)

				if v:IsAlive() and v:GetHealthPercent() < 30 and isFirst == false and v.thtd_damage_lock ~= true then
					isFirst = true
			   		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_patchouli/ability_patchouli_01_bury_in_lake_bury.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
					ParticleManager:DestroyParticleSystem(effectIndex,false)
					EmitSoundOnLocationForAllies(v:GetOrigin(),"Hero_Kunkka.Tidebringer.Attack",caster)
					THTD_Ability_Kill(caster, v)
			   	end
			end
			time = time - 0.5
			return 0.5
		end, 
	0)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_patchouli/ability_patchouli_01_bury_in_lake.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystemTime(effectIndex,10.0)
end

function Patchouli01MercuryPoison(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	
	local time = 10.0

	EmitSoundOnLocationForAllies(targetPoint,"Sound_THTD.thtd_patchouli_01_03",caster)
	
	caster:SetContextThink(DoUniqueString("thtd_patchouli01_mercuryposion"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time < 0 then return nil end
			
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
			for k,v in pairs(targets) do
				if v:HasModifier("modifier_patchouli_01_mercury_poison_debuff") == false then					
					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_patchouli_01_mercury_poison_debuff", nil)
				end
			end
			time = time - 0.2
			return 0.2
		end, 
	0)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_patchouli/ability_patchouli_01_mercury_poison.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystemTime(effectIndex,10.0)
end

function OnPatchouli01MercuryPoisonThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local DamageTable = {
		ability = keys.ability,
        victim = target, 
        attacker = caster, 
        damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5, 
        damage_type = keys.ability:GetAbilityDamageType(), 
		damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end


function OnPatchouli02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:EmitSound("Hero_Invoker.Invoke")

	if caster.thtd_patchouli_02_type == nil then
		caster.thtd_patchouli_02_type = 0
	end
	
	if caster.thtd_patchouli_02_type == PATCHOULI_01_AGNI_SHINE then
		caster.thtd_patchouli_02_type = PATCHOULI_01_BURY_IN_LAKE
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_patchouli_bury_in_lake", duration=1, params={count=1}, color="#0ff"} )
	elseif caster.thtd_patchouli_02_type == PATCHOULI_01_BURY_IN_LAKE then
		caster.thtd_patchouli_02_type = PATCHOULI_01_MERCURY_POISON
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_patchouli_mercury_poison", duration=1, params={count=1}, color="#0ff"} )
	elseif caster.thtd_patchouli_02_type == PATCHOULI_01_MERCURY_POISON then
		caster.thtd_patchouli_02_type = PATCHOULI_01_AGNI_SHINE
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="change_to_patchouli_agni_shine", duration=1, params={count=1}, color="#0ff"} )
	end
end


function OnPatchouli04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = caster:GetOrigin()	

	local count = 4

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_patchouli_04/ability_patchouli_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, vecCaster + Vector(0,0,256))
	ParticleManager:SetParticleControl(effectIndex, 1, vecCaster + Vector(0,0,256))
	ParticleManager:SetParticleControl(effectIndex, 3, vecCaster + Vector(0,0,256))
	
	caster:SetContextThink(DoUniqueString("thtd_patchouli04_spell_start"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			count = count * 2
			local radius = math.min(128,count)
			ParticleManager:SetParticleControl(effectIndex, 14, Vector(radius,0,0))
			if count > 100 then 
				OnPatchouli04SpellThink(keys)
				ParticleManager:DestroyParticleSystemTimeFalse(effectIndex,3.0)
				return nil 
			end
			return 0.5
		end,
	0.5)
end

function OnPatchouli04SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster:THTD_GetStar() < 5 then return end

	local time = 2.0

	caster:SetContextThink(DoUniqueString("thtd_patchouli04_spell_start"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time < 0 then return nil end			
			local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 10, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
		   		UnitStunTarget(caster,v,0.5)
			end
			time = time - 0.5
			return 0.5
		end,
	0)
end