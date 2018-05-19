local thtd_satori_02 = 
{
	[4] = 0.4,
	[5] = 1.0,
}

function OnSatori01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.radius)

	caster:EmitSound("Sound_THTD.thtd_satori_01")

	for k,v in pairs(targets) do
		local modifier = v:FindModifierByName("modifier_satori_01_debuff")
		if modifier == nil then
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_satori_01_debuff", {Duration=3.0})
			local ability_02 = caster:FindAbilityByName("thtd_satori_02") 

			if ability_02~=nil and ability_02:GetLevel() > 0 then
				local health = v:GetHealth()
				v:SetContextThink(DoUniqueString("thtd_satori02_debuff"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						if v~=nil and v:IsNull()==false and v:IsAlive() then
							local DamageTable = {
						   			ability = ability_02,
						            victim = v, 
						            attacker = caster, 
						            damage = (health - v:GetHealth())*thtd_satori_02[caster:THTD_GetStar()], 
						            damage_type = ability_02:GetAbilityDamageType(), 
						            damage_flags = DOTA_DAMAGE_FLAG_NONE
						   	}
						   	UnitDamageTarget(DamageTable)
						end
						return nil
					end, 
				3.0)
			end
		else
			modifier:SetDuration(3.0,false)
		end
	end
end

function OnSatori01ModifierCreated(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_satori_01_special_open == true then
		target.thtd_satori_01_debuff = DoUniqueString("thtd_satori_01_debuff")
		ModifyPhysicalDamageIncomingPercentage(target,20,target.thtd_satori_01_debuff)
	end
end

function OnSatori01ModifierDestroy(keys)
	local target = keys.target

	if target.thtd_satori_01_debuff ~= nil then
		RemovePhysicalDamageIncoming(target,target.thtd_satori_01_debuff)
		target.thtd_satori_01_debuff = nil
	end
end
