function OnFlandre01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_flandre_illusion_table == nil then
		caster.thtd_flandre_illusion_table = {}
	end

	caster:EmitSound("Hero_PhantomLancer.Doppelganger.Appear")

	for i=1,3 do
		local illusion = CreateUnitByName(
				"flandre_illusion", 
				caster:GetOrigin() + Vector(math.cos(math.pi/2*(i+1)),math.sin(math.pi/2*(i+1)),0)*100, 
				false, 
				caster, 
				caster, 
				caster:GetTeam() 
			)
		illusion:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
		illusion:MoveToPosition(illusion:GetOrigin()+Vector(0,-100,0))
		illusion:SetForwardVector(caster:GetForwardVector())
		keys.ability:ApplyDataDrivenModifier(caster, illusion, "modifier_flandre_01_illusion", nil)

		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_flandre/ability_flandre_02_fire.vpcf", PATTACH_CUSTOMORIGIN, illusion) 
		ParticleManager:SetParticleControlEnt(effectIndex , 0, illusion, 5, "attach_attack1", Vector(0,0,0), true)

		caster.thtd_flandre_illusion_table[i] = illusion

		local count = 0
		illusion:SetContextThink(DoUniqueString("thtd_flandre_01_illusion"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if count > 20 then 
					illusion:AddNoDraw()
					illusion:ForceKill(true)
					return nil
				elseif caster:IsAttacking()==false then
					illusion:RemoveGesture(ACT_DOTA_ATTACK)
					illusion:MoveToPosition(illusion:GetOrigin()+Vector(0,-100,0))
				end
				count = count + 1
				return 0.5
			end, 
		0)
	end
end

function OnFlandre02AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_flandre_illusion_table == nil then
		caster.thtd_flandre_illusion_table = {}
	end

	for k,v in pairs(caster.thtd_flandre_illusion_table) do
		if v~=nil and v:IsNull()==false and v:IsAlive() then
			local forward = (target:GetOrigin() - v:GetOrigin()):Normalized()
			v:StartGesture(ACT_DOTA_ATTACK)
			v:MoveToTargetToAttack(target)
		end
	end
end

function Flandre01GetIllusionCount(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_flandre_illusion_table == nil then
		caster.thtd_flandre_illusion_table = {}
	end

	local illusion_Count = 1

	for k,v in pairs(caster.thtd_flandre_illusion_table) do
		if v~=nil and v:IsNull()==false and v:IsAlive() then
			illusion_Count = illusion_Count + 1
		end
	end
	return illusion_Count
end

function OnFlandre02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local vecTarget = target:GetOrigin()

	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * Flandre01GetIllusionCount(keys) /4

	if caster:FindAbilityByName("thtd_flandre_03"):GetLevel()>0 then
		damage = damage * (2 - target:GetHealth()/target:GetMaxHealth())
	end

	local oldHealth = target:GetHealth()

	local DamageTable = {
		ability = keys.ability,
        victim = target, 
        attacker = caster, 
        damage = damage, 
        damage_type = keys.ability:GetAbilityDamageType(), 
        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	local olddamage = ReturnAfterTaxDamage(DamageTable)
   	UnitDamageTarget(DamageTable)

   	OnFlandre02SpellStart(caster)
	OnFlandre02EndDamage(keys,target,vecTarget,olddamage - oldHealth)
end

function OnFlandre02Created(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_flandre/ability_flandre_02_fire.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_attack1", Vector(0,0,0), true)

	caster.thtd_flandre_02_effectIndex = effectIndex
end

function OnFlandre02Destroy(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	ParticleManager:DestroyParticleSystem(caster.thtd_flandre_02_effectIndex,false)
end

function OnFlandre02SpellStart( caster )
	local ability = caster:FindAbilityByName("thtd_flandre_02")
	local modifier = caster:FindModifierByName("modifier_flandre_02_buff")
	local outgoing = GetPhysicalDamageOutgoingPercentage(caster,ability)

	if caster.thtd_flandre_02_count == nil then
		caster.thtd_flandre_02_count = 1
	end

	local count = caster.thtd_flandre_02_count

	if ability:GetLevel()>0 and outgoing<50 then
		ModifyPhysicalDamageOutgoingPercentage(caster,count,ability)
		modifier:SetStackCount(outgoing+count)
		caster:SetContextThink(DoUniqueString("modifier_flandre_02_buff_count"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				ModifyPhysicalDamageOutgoingPercentage(caster,-count,ability)
				local outgoing_current = GetPhysicalDamageOutgoingPercentage(caster,ability)
				modifier:SetStackCount(outgoing_current-count)
				return nil
			end, 
		20.0)
	end
end

function OnFlandre04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_flandre_04_debuff", nil)
	target:StartGesture(ACT_DOTA_DIE)
end


function OnFlandre02EndDamage(keys,target,vecTarget,damage)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if target==nil or target:IsNull() or target:IsAlive() == false then
   		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_flandre/abiilty_flandre_02_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex , 0 , target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		if damage > 0 then
	   		local targets = THTD_FindUnitsInRadius(caster,vecTarget,400)
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = damage, 
		            damage_type = DAMAGE_TYPE_PURE, 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)

				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_flandre/abiilty_flandre_02_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex , 0 , v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end
		end
   	end
end

function OnFlandre04Destroy(keys)
	local target = keys.target
	if target==nil or target:IsNull() or target:IsAlive() == false then return end

	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecTarget = target:GetOrigin()
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * Flandre01GetIllusionCount(keys) * 4

	if caster:FindAbilityByName("thtd_flandre_03"):GetLevel()>0 then
		damage = damage * (2 - target:GetHealth()/target:GetMaxHealth())
	end
	
	caster:EmitSound("Hero_DoomBringer.LvlDeath")

	local DamageTable = {
		ability = keys.ability,
        victim = target, 
        attacker = caster, 
        damage = damage, 
        damage_type = keys.ability:GetAbilityDamageType(), 
        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
	local oldHealth = target:GetHealth()
   	UnitDamageTarget(DamageTable)
   	local olddamage = ReturnAfterTaxDamage(DamageTable)
	OnFlandre02EndDamage(keys,target,vecTarget,olddamage - oldHealth)
end