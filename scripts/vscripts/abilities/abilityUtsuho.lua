function OnUtsuho01Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if keys.ability:GetLevel() < 1 then return end

	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),360)
	
	for k,v in pairs(targets) do
		local damage = caster:THTD_GetPower()
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
end

function OnUtsuho02Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_utsuho_02_attack_count == nil then
		caster.thtd_utsuho_02_attack_count = 0
	end

	caster.thtd_utsuho_02_attack_count = caster.thtd_utsuho_02_attack_count + 1

	if caster.thtd_utsuho_02_attack_count >= 6 then
		caster.thtd_utsuho_02_attack_count = 0
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/utsuho/ability_utsuho03_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)

		target:EmitSound("Hero_Invoker.ChaosMeteor.Impact")

		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),360)
		for k,v in pairs(targets) do
			local damage = caster:THTD_GetPower() * caster:THTD_GetStar()
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
	end
end


function OnUtsuho04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	keys.ability.ability_utsuho04_point_x = targetPoint.x
	keys.ability.ability_utsuho04_point_y = targetPoint.y
	keys.ability.ability_utsuho04_point_z = targetPoint.z
	local dummy = CreateUnitByName("npc_dummy_unit", 
	    	                        targetPoint, 
									false, 
								    caster, 
									caster, 
									caster:GetTeamNumber()
									)
	caster.ability_utsuho_04_dummy = dummy
	dummy:SetContextThink("ability_utsuho04_effect_release",
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			dummy:RemoveSelf() 
		end,
	3.0)
	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/utsuho/ability_utsuho04_effect.vpcf", PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 1, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 3, targetPoint)
	keys.ability.ability_utsuho04_effect_index = effectIndex
end

function OnUtsuho04SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local tx = keys.ability.ability_utsuho04_point_x
	local ty = keys.ability.ability_utsuho04_point_y
	local tz = keys.ability.ability_utsuho04_point_z
	local targetPoint = Vector(tx,ty,tz)
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,keys.Radius)

	for _,v in pairs(targets) do
		local dis = GetDistanceBetweenTwoVec2D(targetPoint,v:GetOrigin())
		local rad = GetRadBetweenTwoVec2D(targetPoint,v:GetOrigin())
		if(dis>=(keys.Gravity/10))then
			v:SetOrigin(v:GetOrigin() - keys.Gravity/10 * Vector(math.cos(rad),math.sin(rad),0))
		end
	end
end


function OnUtsuho04SpellRemove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities
	local effectIndex = keys.ability.ability_utsuho04_effect_index 
	local tx = keys.ability.ability_utsuho04_point_x
	local ty = keys.ability.ability_utsuho04_point_y
	local tz = keys.ability.ability_utsuho04_point_z
	local targetPoint = Vector(tx,ty,tz)
	ParticleManager:DestroyParticleSystem(effectIndex,true)
	if(caster.ability_utsuho_04_dummy~=nil)then
		effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/utsuho/ability_utsuho04_end.vpcf", PATTACH_CUSTOMORIGIN, caster.ability_utsuho_04_dummy)
	else
		effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/utsuho/ability_utsuho04_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
	end

	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 1, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 3, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	caster.ability_utsuho_04_dummy:SetContextThink(DoUniqueString("ability_utsuho04_effect_remove"),
		function ()
			if GameRules:IsGamePaused() then return 0.03 end
			caster.ability_utsuho_04_dummy:RemoveSelf() 
		end,
	1.0)
	for _,v in pairs(targets) do
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 3,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		UnitDamageTarget(damage_table)
	end
end