
function OnMerlin01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_merlin_duration == nil then
		caster.thtd_merlin_duration = 4.0
	end

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)

	caster:EmitSound("Sound_THTD.thtd_merlin_01")
	local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
	for k,v in pairs(targets) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_merlin_01_debuff", {Duration = caster.thtd_merlin_duration})

		UpdatePrismriver01ComboName(caster,v)
		if GetCountPrismriver01ComboName(v) >= 3 then 
			local comboName = GetPrismriver01ComboName(v)		
			if comboName == "lunasalyricamerlin" then
				OnLunasaLyricaMerlin(keys,caster,v)
				ResetPrismriver01ComboName(v)
			elseif comboName == "lyricalunasamerlin" then
				OnLyricaLunasaMerlin(keys,caster,v)	
				ResetPrismriver01ComboName(v)		
			end
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

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/merlin/ability_merlin_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnMerlin02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_merlin_duration == nil then
		caster.thtd_merlin_duration = 4.0
	end
	local abilty_01 = caster:FindAbilityByName("thtd_merlin_01")
	abilty_01:ApplyDataDrivenModifier(caster, target, "modifier_merlin_01_debuff", {Duration = caster.thtd_merlin_duration})

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = caster:THTD_GetPower() * caster:THTD_GetStar(), 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
	UnitDamageTarget(DamageTable)

	UpdatePrismriver01ComboName(caster,target)	
end

function OnLunasaLyricaMerlin(keys,caster,target)
	local targets = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1000)
	for k,v in pairs(targets) do
		if v:GetUnitName() == "lunasa" or v:GetUnitName() == "merlin" or v:GetUnitName() == "lyrica" then
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_merlin_01_buff", {Duration = 10.0})
		end
	end
end

function OnLyricaLunasaMerlin(keys,caster,target)
	local targets = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1000)
	for k,v in pairs(targets) do
		if v:GetUnitName() == "lunasa" or v:GetUnitName() == "merlin" or v:GetUnitName() == "lyrica" then
			v:GiveMana(40)
		end
	end
end
