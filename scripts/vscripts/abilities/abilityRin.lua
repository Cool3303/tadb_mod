function OnRin01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target:GetOrigin()

	caster:EmitSound("Sound_THTD.thtd_rin_01")

	local info = 
	{
			Ability = keys.ability,
        	EffectName = "particles/heroes/rin/ability_rin_01.vpcf",
        	vSpawnOrigin = targetPoint,
        	fDistance = 1000,
        	fStartRadius = 400,
        	fEndRadius = 400,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = -keys.target:GetForwardVector() * 1500,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	Rin01Wheel(keys)
end

function Rin01Wheel(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local origin = keys.target:GetOrigin()
	local forward = -keys.target:GetForwardVector()

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/rin/ability_rin_01_projectile.vpcf", PATTACH_CUSTOMORIGIN, caster)

	ParticleManager:SetParticleControl(effectIndex, 0, origin)
	ParticleManager:SetParticleControlForward(effectIndex, 0 , forward)

	local count = 0
	caster:SetContextThink(DoUniqueString("ability_rin_01_wheel_move"), 
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			if count < 23 then
				origin = origin + forward * 45
				ParticleManager:SetParticleControl(effectIndex, 0, origin)
				count = count + 1
			else
				ParticleManager:DestroyParticleSystem(effectIndex,false)
				return nil
			end
			return 0.03
		end, 
		0.03)
end

function OnRin01ProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage = caster:THTD_GetPower()

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)

	 if target~=nil and target:IsNull()== false and target:IsAlive() and target:HasModifier("modifier_rin_01_debuff")==false then
   		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_rin_01_debuff", nil)
   	end
end

local thtd_rin_star_bouns =
{
	[3] = 0.04,
	[4] = 0.06,
	[5] = 0.15,
}

function OnRin01Death(keys)
	if keys.caster_entindex==nil then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.unit

	if caster:FindAbilityByName("thtd_rin_02"):GetLevel() < 1 then return end

	target:EmitSoundParams("Hero_Nevermore.Shadowraze",1,0.05,2) 

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/abiilty_moluo_014.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local damage = target:GetMaxHealth() * thtd_rin_star_bouns[caster:THTD_GetStar()]
	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)
	
	for k,v in pairs(targets) do
		local DamageTable = {
   			ability = keys.ability,
            victim = v, 
            attacker = caster, 
            damage = damage, 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	local olddamage = ReturnAfterTaxDamage(DamageTable)
		if olddamage > (caster:THTD_GetStar()*caster:THTD_GetPower()*5) then
			DamageTable.damage = caster:THTD_GetStar()*caster:THTD_GetPower()*15
		end
		UnitDamageTarget(DamageTable)
	end
end