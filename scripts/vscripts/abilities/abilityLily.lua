local thtd_lily_star_bouns =
{
	[1] = 1,
	[2] = 1.8,
	[3] = 2.4,
	[4] = 3.2,
	[5] = 4,
}

function OnLily01SpellStart(keys)
	if SpawnSystem:GetWave() > 51 then return end
	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = keys.target_points[1]

	local targets = 
			FindUnitsInRadius(
				caster:GetTeamNumber(), 
				targetPoint, 
				nil, 
				keys.radius, 
				ability:GetAbilityTargetTeam(), 
				ability:GetAbilityTargetType(), 
				ability:GetAbilityTargetFlags(), 
				FIND_CLOSEST, 
				false
			)

	local exp = caster:THTD_GetPower() * 5 * thtd_lily_star_bouns[caster:THTD_GetStar()] * 1.5 or 0

	for k,v in pairs(targets) do
		if v ~= nil and v:IsNull() == false and v.thtd_istower == true and v ~= caster and v:GetOwner() == caster:GetOwner() and v:THTD_GetLevel() < THTD_MAX_LEVEL then 
			v:THTD_AddExp(exp)
		end
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lily/ability_lily_01_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
end


function OnLily02SpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability

	local targets = 
			FindUnitsInRadius(
				caster:GetTeamNumber(), 
				caster:GetOrigin(), 
				nil, 
				keys.radius, 
				ability:GetAbilityTargetTeam(), 
				ability:GetAbilityTargetType(), 
				ability:GetAbilityTargetFlags(), 
				FIND_CLOSEST, 
				false
			)

	for k,v in pairs(targets) do
		ability:ApplyDataDrivenModifier(caster, v, "modifier_lily_outgoing_damage", nil)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/lily/ability_lily_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(keys.radius,keys.radius,keys.radius))
	ParticleManager:DestroyParticleSystemTime(effectIndex,15.0)
end

function OnLily01EffectThink(keys)
	local caster = keys.caster
	local ability = keys.ability

	if ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(ability:GetLevel()) and SpawnSystem:GetWave() <= 51 then
		if caster.thtd_lily_01_effectIndex == nil then
			caster.thtd_lily_01_effectIndex = ParticleManager:CreateParticle("particles/heroes/lily/ability_lily_01_ready.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(caster.thtd_lily_01_effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		end
	elseif caster.thtd_lily_01_effectIndex ~= nil then
		ParticleManager:DestroyParticleSystem(caster.thtd_lily_01_effectIndex,true)
		caster.thtd_lily_01_effectIndex = nil
	end
end