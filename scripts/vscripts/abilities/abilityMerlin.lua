-- 每0.5秒触发一次，持续4秒
-- 伤害20 50 100 200 400

function OnMerlin01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_merlin_duration == nil then
		caster.thtd_merlin_duration = 4.0
	end

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)

	caster:EmitSound("Sound_THTD.thtd_merlin_01")

	for k,v in pairs(targets) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_merlin_01_debuff", {Duration = caster.thtd_merlin_duration})

		if v.thtd_prismriver_01_comboName == nil then
			v.thtd_prismriver_01_comboName = ""
			v.thtd_prismriver_01_comboCount = 0
		end

		v.thtd_prismriver_01_comboName = v.thtd_prismriver_01_comboName.."merlin"
		v.thtd_prismriver_01_comboCount = v.thtd_prismriver_01_comboCount + 1

		if v.thtd_prismriver_01_comboCount >= 3 then
			if v.thtd_prismriver_01_comboName == "lunasalyricamerlin" then
				OnLunasaLyricaMerlin(keys,caster,v)
			elseif v.thtd_prismriver_01_comboName == "lyricalunasamerlin" then
				OnLyricaLunasaMerlin(keys,caster,v)
			end
			v.thtd_prismriver_01_comboName = ""
			v.thtd_prismriver_01_comboCount = 0
		end
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/merlin/ability_merlin_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end

function OnMerlin02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = caster:THTD_GetPower()

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

	local abilty_01 = caster:FindAbilityByName("thtd_merlin_01")

	if target.thtd_prismriver_01_comboName == nil then
		target.thtd_prismriver_01_comboName = ""
		target.thtd_prismriver_01_comboCount = 0
	end

	target.thtd_prismriver_01_comboName = target.thtd_prismriver_01_comboName.."merlin"
	target.thtd_prismriver_01_comboCount = target.thtd_prismriver_01_comboCount + 1

	if target.thtd_prismriver_01_comboCount >= 3 then
		if target.thtd_prismriver_01_comboName == "lunasalyricamerlin" then
			OnLunasaLyricaMerlin(keys,caster,target)
		elseif target.thtd_prismriver_01_comboName == "lyricalunasamerlin" then
			OnLyricaLunasaMerlin(keys,caster,target)
		end
		target.thtd_prismriver_01_comboName = ""
		target.thtd_prismriver_01_comboCount = 0
	end

	abilty_01:ApplyDataDrivenModifier(caster, target, "modifier_merlin_01_debuff", {Duration = caster.thtd_merlin_duration})
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