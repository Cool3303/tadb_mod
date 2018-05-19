-- 每0.5秒触发一次，持续4秒
-- 伤害20 50 100 200 400

local thtd_lunasa01_star_bonus = 
{
	[1] = 20,
	[2] = 50,
	[3] = 100,
	[4] = 200,
	[5] = 400,
}

local thtd_lunasa02_star_bonus = 
{
	[3] = 100,
	[4] = 200,
	[5] = 400,
}

function OnLunasa01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_lunasa_duration == nil then
		caster.thtd_lunasa_duration = 4.0
	end

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)

	caster:EmitSound("Sound_THTD.thtd_lunasa_01")

	for k,v in pairs(targets) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_lunasa_01_debuff", {Duration = caster.thtd_lunasa_duration})
		local count = 0
	   	v:SetContextThink(DoUniqueString("thtd_lunasa01_debuff"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if count > 8 then return nil end
				count = count + 1
				
				local damage = thtd_lunasa01_star_bonus[caster:THTD_GetStar()]
				local DamageTable = {
						ability = keys.ability,
				        victim = v, 
				        attacker = caster, 
				        damage = damage, 
				        damage_type = keys.ability:GetAbilityDamageType(), 
				        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
				return 0.5
			end, 
		0)

		if v.thtd_prismriver_01_comboName == nil then
			v.thtd_prismriver_01_comboName = ""
			v.thtd_prismriver_01_comboCount = 0
		end

		v.thtd_prismriver_01_comboName = v.thtd_prismriver_01_comboName.."lunasa"
		v.thtd_prismriver_01_comboCount = v.thtd_prismriver_01_comboCount + 1

		if v.thtd_prismriver_01_comboCount >= 3 then
			if v.thtd_prismriver_01_comboName == "lyricamerlinlunasa" then
				OnLyricaMerlinLunasa(keys,caster,v)
			elseif v.thtd_prismriver_01_comboName == "merlinlyricalunasa" then
				OnMerlinLyricaLunasa(keys,caster,v)
			end
			v.thtd_prismriver_01_comboName = ""
			v.thtd_prismriver_01_comboCount = 0
		end
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lunasa/ability_lunasa_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnLunasa02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = thtd_lunasa02_star_bonus[caster:THTD_GetStar()]

	if keys.ability:GetLevel() < 1 then return end

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)

   	local count = 0

   	target:SetContextThink(DoUniqueString("thtd_lunasa02_debuff"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if count > 8 then return nil end
			count = count + 1
			
			local damage = thtd_lunasa01_star_bonus[caster:THTD_GetStar()]
			local DamageTable = {
					ability = keys.ability,
			        victim = target, 
			        attacker = caster, 
			        damage = damage, 
			        damage_type = keys.ability:GetAbilityDamageType(), 
			        damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
			return 0.5
		end, 
	0)

	if target.thtd_prismriver_01_comboName == nil then
		target.thtd_prismriver_01_comboName = ""
		target.thtd_prismriver_01_comboCount = 0
	end

	target.thtd_prismriver_01_comboName = target.thtd_prismriver_01_comboName.."lunasa"
	target.thtd_prismriver_01_comboCount = target.thtd_prismriver_01_comboCount + 1

	if target.thtd_prismriver_01_comboCount >= 3 then
		if target.thtd_prismriver_01_comboName == "lyricamerlinlunasa" then
			OnLyricaMerlinLunasa(keys,caster,target)
		elseif target.thtd_prismriver_01_comboName == "merlinlyricalunasa" then
			OnMerlinLyricaLunasa(keys,caster,target)
		end
		target.thtd_prismriver_01_comboName = ""
		target.thtd_prismriver_01_comboCount = 0
	end

   	local abilty_01 = caster:FindAbilityByName("thtd_lunasa_01")

	abilty_01:ApplyDataDrivenModifier(caster, target, "modifier_lunasa_01_debuff", {Duration = caster.thtd_lunasa_duration})
end

function OnLyricaMerlinLunasa(keys,caster,target)
	local modifier = target:FindModifierByName("modifier_lunasa_01_pause")
	if modifier ~= nil then
		modifier:SetDuration(1.0)
	else
		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_lunasa_01_pause",{Duration = 1.0})
	end
end

function OnMerlinLyricaLunasa(keys,caster,target)
	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)
	for k,v in pairs(targets) do
		local modifier = v:FindModifierByName("modifier_lunasa_01_pause")
		if modifier ~= nil then
			modifier:SetDuration(0.5)
		else
			keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_lunasa_01_pause",{Duration = 0.5})
		end
	end
end