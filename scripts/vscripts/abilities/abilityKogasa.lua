local thtd_kogasa_star_bouns =
{
	[1] = 60,
	[2] = 120,
	[3] = 240,
	[4] = 480,
	[5] = 960,
}

local thtd_kogasa_star_bouns_2 =
{
	[1] = 15,
	[2] = 30,
	[3] = 60,
	[4] = 120,
	[5] = 240,
}

function OnKogasa01SpellStart(keys)
	local caster = keys.caster
	local targetPoint = keys.target_points[1]
	local count = 5

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)

	caster:EmitSound("Sound_THTD.thtd_kogasa_01")

	for k,v in pairs(targets) do
		local DamageTable = {
   			ability = keys.ability,
            victim = v, 
            attacker = caster, 
            damage = thtd_kogasa_star_bouns[caster:THTD_GetStar()], 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	if caster:HasModifier("modifier_byakuren_03_buff") then
	   		DamageTable.damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 4
	   	end
	   	UnitDamageTarget(DamageTable)
		if caster:HasModifier("modifier_byakuren_03_buff") then
	   		keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_kogasa_upgrade_debuff", nil)
		else
	   		keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_kogasa_debuff", nil)
	   	end
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/kogasa/ability_kogasa_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	caster:SetContextThink(DoUniqueString("thtd_kogasa01_spell_start"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			
			for k,v in pairs(targets) do
				if v~=nil and v:IsNull()==false and v:IsAlive() then
					local DamageTable = {
			   			ability = keys.ability,
			            victim = v, 
			            attacker = caster, 
			            damage = thtd_kogasa_star_bouns_2[caster:THTD_GetStar()], 
			            damage_type = keys.ability:GetAbilityDamageType(), 
			            damage_flags = DOTA_DAMAGE_FLAG_NONE
				   	}
				   	if caster:HasModifier("modifier_byakuren_03_buff") then
				   		DamageTable.damage = caster:THTD_GetPower() * caster:THTD_GetStar()
				   	end
				   	UnitDamageTarget(DamageTable)
				end
			end

			count = count - 1
			if count > 0 then
				return 1.0
			else
				return nil
			end
		end, 
	1.0)
end