local thtd_kokoro_model_list = 
{
	[1] = "models/thd_hero/kokoro/kokoro_fan.vmdl",
	[2] = "models/thd_hero/kokoro/kokoro_knife.vmdl",
	[3] = "models/thd_hero/kokoro/kokoro_mask.vmdl",
	[4] = "models/thd_hero/kokoro/kokoro.vmdl",
}

function OnKokoro04Think(keys)
	if GameRules:IsGamePaused() then return end
	if keys.ability:GetLevel() < 1 then return end

	-- local caster = EntIndexToHScript(keys.caster_entindex)
	-- local randomType = RandomInt(1,4)

	-- caster:SetModel(thtd_kokoro_model_list[randomType])
	-- caster:SetOriginalModel(thtd_kokoro_model_list[randomType])

	-- caster.thtd_kokoro_change_type = randomType
end

function OnCreatedKokoro01Debuff(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	if target:GetTeam() ~= DOTA_TEAM_BADGUYS then return end

	local unit = CreateUnitByName(
		"kokoro_mask", 
		target:GetAbsOrigin() + RandomVector(100), 
		false, 
		caster:GetOwner(), 
		caster:GetOwner(), 
		caster:GetTeam() 
	)
	if (unit == nil) then return end		

	keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_kokoro_01_rooted", {})	
	unit:AddNewModifier(unit, nil, "modifier_phased", nil)
	unit:SetContextThink(DoUniqueString("thtd_kokoro_01"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end	
			if unit==nil or unit:IsNull() or unit:IsAlive()==false then	return nil end	
			if target==nil or target:IsNull() or target:IsAlive()==false then	
				unit:AddNoDraw()
				unit:ForceKill(false)	
				return nil
			end
			if caster==nil or caster:IsNull() or caster:IsAlive()==false or caster:THTD_IsHidden() or target:HasModifier("modifier_kokoro_01_debuff")==false then
				if target.thtd_kokoro_01 ~= nil then 
					target:SetPhysicalArmorBaseValue(target:GetPhysicalArmorBaseValue() + target.thtd_kokoro_01)
					target.thtd_kokoro_01 = nil
				end
				unit:AddNoDraw()
				unit:ForceKill(false)	
				return nil
			end

			if target.thtd_kokoro_01 == nil and target:HasModifier("modifier_patchouli_01_mercury_poison_debuff") == false then
				local baseArmor = target:GetPhysicalArmorBaseValue()	
				target:SetPhysicalArmorBaseValue(baseArmor - keys.Armor)
				target.thtd_kokoro_01 = keys.Armor				
			end

			if target.thtd_kokoro_01 ~= nil and target:HasModifier("modifier_patchouli_01_mercury_poison_debuff") then
				local baseArmor = target:GetPhysicalArmorBaseValue()	
				target:SetPhysicalArmorBaseValue(baseArmor + target.thtd_kokoro_01)
				target.thtd_kokoro_01 = nil		
			end
			
			unit:SetAbsOrigin(target:GetAbsOrigin())	
			unit:MoveToTargetToAttack(target)	
			
			local damage = caster:THTD_GetPower()*caster:THTD_GetStar() * 2
			if caster:HasModifier("modifier_kokoro_04_buff_1") then
				damage = damage * 1.5
			end
			local DamageTable = {
				ability = keys.ability,
				victim = target, 
				attacker = caster, 
				damage = damage, 
				damage_type = keys.ability:GetAbilityDamageType(),  
				damage_flags = DOTA_DAMAGE_FLAG_NONE
			}
			UnitDamageTarget(DamageTable)
				
			return 0.4			
		end,
	0)
end

function OnKokoro02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local enemies = THTD_FindUnitsInRadius(caster, target:GetAbsOrigin(), 600)			
	local count = 0
	local maxCount = 7	

	if caster:THTD_GetStar() == 5 then 
		if caster.buff_index == nil then 
			caster.buff_index = RandomInt(1,3) 
		else
			caster.buff_index = caster.buff_index + 1
			if caster.buff_index > 3 then caster.buff_index = 1 end
		end
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_kokoro_04_buff_"..tostring(caster.buff_index), {Duration = 2.0})	
	end

	if caster.buff_index == 2 then 
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()) / 2)
	end

	for k,v in pairs(enemies) do
		if count < maxCount then 
			local unit = CreateUnitByName(
				"kokoro_jin_yin", 
				caster:GetAbsOrigin(), 
				false, 
				caster:GetOwner(), 
				caster:GetOwner(), 
				caster:GetTeam() 
			)
			if unit ~= nil then 			
				keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_kokoro_02_rooted", {})	
				unit:MoveToTargetToAttack(v)
				local forward = 1
				unit:SetContextThink(
					DoUniqueString("kokoro02_move"),
					function ()
						if GameRules:IsGamePaused() then return 0.03 end						
						if v==nil or v:IsNull() or v:IsAlive()==false then	
							unit:AddNoDraw()
							unit:ForceKill(false)	
							return nil
						end
						if caster==nil or caster:IsNull() or caster:IsAlive()==false or caster:THTD_IsHidden() then							
							unit:AddNoDraw()
							unit:ForceKill(false)	
							return nil
						end					
						
						unit:MoveToTargetToAttack(v)
						local vecMove=(unit:GetOrigin()-v:GetOrigin()):Normalized()*50
						unit:SetAbsOrigin(GetGroundPosition(unit:GetOrigin()-vecMove, unit))
						if (unit:GetOrigin()-v:GetOrigin()):Length() < 50 then 							
							local DamageTable = {
								ability = keys.ability,
								victim = v, 
								attacker = caster, 
								damage = caster:THTD_GetPower()*caster:THTD_GetStar()*5, 
								damage_type = keys.ability:GetAbilityDamageType(),  
								damage_flags = DOTA_DAMAGE_FLAG_NONE
							}
							UnitDamageTarget(DamageTable)							
							UnitStunTarget(caster,v,1.0)
							unit:AddNoDraw()
							unit:ForceKill(false)								
							return nil
						end

						return 0.05
					end,
				0.1)			
			end	
			count = count + 1
		end
	end
end
