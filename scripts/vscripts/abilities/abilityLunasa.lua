
function OnLunasa01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_lunasa_duration == nil then
		caster.thtd_lunasa_duration = 4.0
	end

	caster:EmitSound("Sound_THTD.thtd_lunasa_01")

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)
	for k,v in pairs(targets) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_lunasa_01_debuff", {Duration = caster.thtd_lunasa_duration})

		UpdatePrismriver01ComboName(caster,v)
		if GetCountPrismriver01ComboName(v) >= 3 then
			local comboName = GetPrismriver01ComboName(v)		
			if comboName == "lyricamerlinlunasa" then
				OnLyricaMerlinLunasa(keys,caster,v)
				ResetPrismriver01ComboName(v)
			elseif comboName == "merlinlyricalunasa" then
				OnMerlinLyricaLunasa(keys,caster,v)
				ResetPrismriver01ComboName(v)		
			end
		end

		local count = 0
	   	v:SetContextThink(DoUniqueString("thtd_lunasa01_debuff"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if count > 8 then return nil end
				if v==nil or v:IsNull() or v:IsAlive()==false then return nil end

				count = count + 1				
				local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5
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
		
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lunasa/ability_lunasa_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnLunasa02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target	

	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_lunasa_duration == nil then
		caster.thtd_lunasa_duration = 4.0
	end
	local abilty_01 = caster:FindAbilityByName("thtd_lunasa_01")
	abilty_01:ApplyDataDrivenModifier(caster, target, "modifier_lunasa_01_debuff", {Duration = caster.thtd_lunasa_duration})	
	
   	local count = 0
   	target:SetContextThink(DoUniqueString("thtd_lunasa02_debuff"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if count > 8 then return nil end
			if target==nil or target:IsNull() or target:IsAlive()==false then return nil end

			count = count + 1	
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5
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

	UpdatePrismriver01ComboName(caster,target)	
end

function OnLyricaMerlinLunasa(keys,caster,target)
	local modifier = target:FindModifierByName("modifier_lunasa_01_pause")
	if modifier ~= nil then
		modifier:SetDuration(1.0,false)
	else
		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_lunasa_01_pause",{Duration = 1.0})
	end
end

function OnMerlinLyricaLunasa(keys,caster,target)
	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)
	for k,v in pairs(targets) do
		local modifier = v:FindModifierByName("modifier_lunasa_01_pause")
		if modifier ~= nil then
			modifier:SetDuration(0.5,false)
		else
			keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_lunasa_01_pause",{Duration = 0.5})
		end
	end
end