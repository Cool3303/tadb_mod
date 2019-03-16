
function OnLyrica01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_lyrica_increase_damage == nil then
		caster.thtd_lyrica_increase_damage = 1.0
	end

	local isEnabled = false
	if caster:FindAbilityByName("thtd_lyrica_02"):GetLevel() >= 1 then 
		isEnabled = true
	end
	
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)
	for k,v in pairs(targets) do
		UpdatePrismriver01ComboName(caster,v)

		local damage = 1
		if isEnabled then 
			damage = damage + 0.5 * GetCountPrismriver01ComboName(v)
			if v:HasModifier("modifier_lunasa_01_debuff") then			
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/lunasa/ability_lunasa_music_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end
			if v:HasModifier("modifier_merlin_01_debuff") then				
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/merlin/ability_merlin_music_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end
		end
		damage = damage * caster:THTD_GetStar() * caster:THTD_GetPower() * caster.thtd_lyrica_increase_damage
		local DamageTable = {
			ability = keys.ability,
			victim = v, 
			attacker = caster, 
			damage = damage, 
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}  
	   	UnitDamageTarget(DamageTable)

	   	if GetCountPrismriver01ComboName(v) >= 3 then
			local comboName = GetPrismriver01ComboName(v)		
			if comboName == "merlinlunasalyrica" then
				OnMerlinLunasaLyrica(keys,caster,v)
				ResetPrismriver01ComboName(v)
			elseif comboName == "lunasamerlinlyrica" then
				OnLunasaMerlinLyrica(keys,caster,v)
				ResetPrismriver01ComboName(v)		
			end
		end
	end
	
	caster:EmitSound("Sound_THTD.thtd_lyrica_01")

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lyrica/ability_lyrica_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnMerlinLunasaLyrica(keys,caster,target)
	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * caster.thtd_lyrica_increase_damage
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
	end
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lyrica/ability_lyrica_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnLunasaMerlinLyrica(keys,caster,target)	
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 4 * caster.thtd_lyrica_increase_damage
	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end