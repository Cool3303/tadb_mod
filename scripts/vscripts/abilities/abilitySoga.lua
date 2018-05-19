function OnSoga01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster:HasModifier("modifier_miko_02_buff") then
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(4)
	end

	if caster.thtd_soga_01_effect_list == nil then
		caster.thtd_soga_01_effect_list = {}
	end

	if caster.thtd_soga_01_rect_last ~= nil then
		for index,point in pairs(caster.thtd_soga_01_rect_last) do
			local forward = (point - caster:GetAbsOrigin()):Normalized()

			for i=1,8 do
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin() + 100 * i * forward)
				ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin() + 100 * i * forward)
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end

			caster:SetContextThink(DoUniqueString("thtd_soga_01_spell_delay"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
					local targets = 
						FindUnitsInLine(
							caster:GetTeamNumber(), 
							caster:GetOrigin(), 
							caster:GetOrigin() + 800 * forward, 
							nil, 
							200,
							keys.ability:GetAbilityTargetTeam(), 
							keys.ability:GetAbilityTargetType(), 
							keys.ability:GetAbilityTargetFlags()
						)
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
				   		UnitStunTarget(caster,v,1.0)
					end

					for k,v in pairs(caster.thtd_soga_01_effect_list) do
						ParticleManager:DestroyParticleSystem(v,true)
					end
					caster.thtd_soga_01_effect_list = {}
					caster.thtd_soga_01_rect_last = {}
					return nil
				end,
			0.2)
		end
	else
		caster.thtd_soga_01_rect_last = {}
	end

	local forward = (targetPoint - caster:GetAbsOrigin()):Normalized()

	for i=1,8 do
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin() + 100 * i * forward)
		ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin() + 100 * i * forward)
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end

	caster:SetContextThink(DoUniqueString("thtd_soga_01_spell_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
			local targets = 
				FindUnitsInLine(
					caster:GetTeamNumber(), 
					caster:GetOrigin(), 
					caster:GetOrigin() + 800 * forward, 
					nil, 
					200,
					keys.ability:GetAbilityTargetTeam(), 
					keys.ability:GetAbilityTargetType(), 
					keys.ability:GetAbilityTargetFlags()
				)
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
		   		UnitStunTarget(caster,v,1.0)
			end

			table.insert(caster.thtd_soga_01_rect_last,targetPoint)

			for i=1,8 do
				local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_thtd_soga_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex2, 0, caster:GetOrigin() + 100 * i * forward)
				table.insert(caster.thtd_soga_01_effect_list,effectIndex2)
			end
			return nil
		end,
	0.2)
end

function OnSoga02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_soga_02_effect_list == nil then
		caster.thtd_soga_02_effect_list = {}
	end

	if caster.thtd_soga_02_rect_last ~= nil then
		for index,point in pairs(caster.thtd_soga_02_rect_last) do
			caster:SetContextThink(DoUniqueString("thtd_soga_02_spell_delay"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(effectIndex, 0, point)
					ParticleManager:SetParticleControl(effectIndex, 1, point)
					ParticleManager:DestroyParticleSystem(effectIndex,false)
					return nil
				end,
			0.5)

			caster:SetContextThink(DoUniqueString("thtd_soga_02_spell_delay"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
					local targets = THTD_FindUnitsInRadius(caster,point,300)
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
					for k,v in pairs(caster.thtd_soga_02_effect_list) do
						ParticleManager:DestroyParticleSystem(v,true)
					end
					caster.thtd_soga_02_effect_list = {}
					caster.thtd_soga_02_rect_last = {}
					return nil
				end,
			0.7)
		end
	else
		caster.thtd_soga_02_rect_last = {}
	end

	caster:SetContextThink(DoUniqueString("thtd_soga_02_spell_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
			ParticleManager:SetParticleControl(effectIndex, 1, targetPoint)
			ParticleManager:DestroyParticleSystem(effectIndex,false)
			return nil
		end,
	0.5)

	caster:SetContextThink(DoUniqueString("thtd_soga_02_spell_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
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

			for i=1,12 do
				local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_thtd_soga_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex2, 0, targetPoint+Vector(math.cos(i*math.pi*2/12),math.sin(i*math.pi*2/12),0)*300)
				table.insert(caster.thtd_soga_02_effect_list,effectIndex2)
			end
			
			table.insert(caster.thtd_soga_02_rect_last,targetPoint)
			return nil
		end,
	0.7)
			
end

function OnSoga03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	
	if caster:HasModifier("modifier_miko_02_buff") then
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(10)
	end

	if caster.thtd_soga_03_effect_list == nil then
		caster.thtd_soga_03_effect_list = {}
	end

	if caster.thtd_soga_03_rect_last ~= nil then
		for index,point in pairs(caster.thtd_soga_03_rect_last) do
			caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_delay"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					local count = 0
					caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_think"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							if count < 9 then
								count = count + 1
								local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
								ParticleManager:SetParticleControl(effectIndex, 0, point+Vector(math.cos(math.pi/2+count*math.pi*2/18),math.sin(math.pi/2+count*math.pi*2/18),0)*500)
								ParticleManager:SetParticleControl(effectIndex, 1, point+Vector(math.cos(math.pi/2+count*math.pi*2/18),math.sin(math.pi/2+count*math.pi*2/18),0)*500)
								ParticleManager:DestroyParticleSystem(effectIndex,false)
								local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
								ParticleManager:SetParticleControl(effectIndex2, 0, point+Vector(math.cos(-math.pi/2+count*math.pi*2/18),math.sin(-math.pi/2+count*math.pi*2/18),0)*500)
								ParticleManager:SetParticleControl(effectIndex2, 1, point+Vector(math.cos(-math.pi/2+count*math.pi*2/18),math.sin(-math.pi/2+count*math.pi*2/18),0)*500)
								ParticleManager:DestroyParticleSystem(effectIndex2,false)
								return 0.1
							else
								return nil
							end
						end,
					0.1)
					return nil
				end,
			0)

			caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_effect_delay"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end

					for i=1,6 do
						local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(effectIndex, 0, point+Vector(math.cos(-math.pi/2+i*math.pi*2/6),math.sin(-math.pi/2+i*math.pi*2/6),0)*400)
						ParticleManager:SetParticleControl(effectIndex, 1, point+Vector(math.cos(-math.pi/2+i*math.pi*2/6),math.sin(-math.pi/2+i*math.pi*2/6),0)*400)
						ParticleManager:DestroyParticleSystem(effectIndex,false)
					end

					for i=1,3 do
						local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(effectIndex, 0, point+Vector(math.cos(-math.pi/2+i*math.pi*2/3),math.sin(-math.pi/2+i*math.pi*2/3),0)*200)
						ParticleManager:SetParticleControl(effectIndex, 1, point+Vector(math.cos(-math.pi/2+i*math.pi*2/3),math.sin(-math.pi/2+i*math.pi*2/3),0)*200)
						ParticleManager:DestroyParticleSystem(effectIndex,false)
					end

					for i=1,1 do
						local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(effectIndex, 0, point+Vector(math.cos(-math.pi/2+i*math.pi*2/1),math.sin(-math.pi/2+i*math.pi*2/1),0)*100)
						ParticleManager:SetParticleControl(effectIndex, 1, point+Vector(math.cos(-math.pi/2+i*math.pi*2/1),math.sin(-math.pi/2+i*math.pi*2/1),0)*100)
						ParticleManager:DestroyParticleSystem(effectIndex,false)
					end

					return nil
				end,
			1.1)

			caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_delay"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 4
					local targets = THTD_FindUnitsInRadius(caster,point,500)
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
					   	if caster.thtd_soga_03_debuff == true and v:HasModifier("modifier_soga_03_debuff") == false then
					   		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_soga_03_debuff", {Duration = 10.0})
			   				ModifyMagicalDamageIncomingPercentage(v,20,nil)
			   				v:SetContextThink(DoUniqueString("thtd_soga_03_buff_remove"), 
								function()
									if GameRules:IsGamePaused() then return 0.03 end
									ModifyMagicalDamageIncomingPercentage(v,-20,nil)
									return nil
								end,
							10.0)
					   	end
					end
					for k,v in pairs(caster.thtd_soga_03_effect_list) do
						ParticleManager:DestroyParticleSystem(v,true)
					end
					caster.thtd_soga_03_effect_list = {}
					caster.thtd_soga_03_rect_last = {}
					return nil
				end,
			1.3)
		end
	else
		caster.thtd_soga_03_rect_last = {}
	end

	caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local count = 0
			caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_think"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					if count < 9 then
						count = count + 1
						local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(effectIndex, 0, targetPoint+Vector(math.cos(math.pi/2+count*math.pi*2/18),math.sin(math.pi/2+count*math.pi*2/18),0)*500)
						ParticleManager:SetParticleControl(effectIndex, 1, targetPoint+Vector(math.cos(math.pi/2+count*math.pi*2/18),math.sin(math.pi/2+count*math.pi*2/18),0)*500)
						ParticleManager:DestroyParticleSystem(effectIndex,false)
						local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(effectIndex2, 0, targetPoint+Vector(math.cos(-math.pi/2+count*math.pi*2/18),math.sin(-math.pi/2+count*math.pi*2/18),0)*500)
						ParticleManager:SetParticleControl(effectIndex2, 1, targetPoint+Vector(math.cos(-math.pi/2+count*math.pi*2/18),math.sin(-math.pi/2+count*math.pi*2/18),0)*500)
						ParticleManager:DestroyParticleSystem(effectIndex2,false)
						return 0.1
					else
						return nil
					end
				end,
			0.1)
			return nil
		end,
	0)


	caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_effect_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end

			for i=1,6 do
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, targetPoint+Vector(math.cos(-math.pi/2+i*math.pi*2/6),math.sin(-math.pi/2+i*math.pi*2/6),0)*400)
				ParticleManager:SetParticleControl(effectIndex, 1, targetPoint+Vector(math.cos(-math.pi/2+i*math.pi*2/6),math.sin(-math.pi/2+i*math.pi*2/6),0)*400)
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end

			for i=1,3 do
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, targetPoint+Vector(math.cos(-math.pi/2+i*math.pi*2/3),math.sin(-math.pi/2+i*math.pi*2/3),0)*200)
				ParticleManager:SetParticleControl(effectIndex, 1, targetPoint+Vector(math.cos(-math.pi/2+i*math.pi*2/3),math.sin(-math.pi/2+i*math.pi*2/3),0)*200)
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end

			for i=1,1 do
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_soga_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, targetPoint+Vector(math.cos(-math.pi/2+i*math.pi*2/1),math.sin(-math.pi/2+i*math.pi*2/1),0)*100)
				ParticleManager:SetParticleControl(effectIndex, 1, targetPoint+Vector(math.cos(-math.pi/2+i*math.pi*2/1),math.sin(-math.pi/2+i*math.pi*2/1),0)*100)
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end

			return nil
		end,
	1.1)

	caster:SetContextThink(DoUniqueString("thtd_soga_03_spell_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 10
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,500)
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
			   	if caster.thtd_soga_03_debuff == true and v:HasModifier("modifier_soga_03_debuff") == false then
			   		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_soga_03_debuff", {Duration = 10.0})
			   		ModifyMagicalDamageIncomingPercentage(v,20,nil)
	   				v:SetContextThink(DoUniqueString("thtd_soga_03_buff_remove"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							ModifyMagicalDamageIncomingPercentage(v,-20,nil)
							return nil
						end,
					10.0)
			   	end
			end

			for i=1,18 do
				local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/thtd_soga/ability_thtd_soga_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex2, 0, targetPoint+Vector(math.cos(i*math.pi*2/18),math.sin(i*math.pi*2/18),0)*500)
				table.insert(caster.thtd_soga_03_effect_list,effectIndex2)
			end
			
			table.insert(caster.thtd_soga_03_rect_last,targetPoint)
			return nil
		end,
	1.3)
			
end