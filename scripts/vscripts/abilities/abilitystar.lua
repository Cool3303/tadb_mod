

function OnStar01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

   	OnStar01Damage(keys,targetPoint)

	local fairyArea = nil
	local hero = caster:GetOwner()
	if hero~=nil and hero:IsNull()==false then
		local fairyList = GetHeroFairyList(hero)    	
		for k,v in pairs(fairyList) do
			if v.star == caster then
				fairyArea = v
				break
			end
		end
	end

	if fairyArea ~= nil then 
		local pos1 = fairyArea.sunny:GetAbsOrigin()
		local pos2 = fairyArea.star:GetAbsOrigin()
		local pos3 = fairyArea.luna:GetAbsOrigin()
		local center, radius = GetCircleCenterAndRadius(pos1,pos2,pos3) 
		local targetsTotal = {}
		local fairyTargets = THTD_FindUnitsInRadius(caster,center,radius)		
		for _,v in pairs(fairyTargets) do
			if v~=nil and v:IsNull()==false and v:IsAlive() and IsUnitInFairy(fairyArea,v) then					
				targetsTotal[v:GetEntityIndex()] = v
			end
		end
		for k,v in pairs(targetsTotal) do
			OnStar01Damage(keys,v:GetOrigin())
		end
	end
end

function OnStar01Damage(keys,targetPoint)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_star/ability_star_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	caster:SetContextThink(DoUniqueString("ability_star_01_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetStar() * caster:THTD_GetPower(), 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_star_01_slow", {Duration = 3.5})
			end
			return nil
		end,
	0.5)
end

function OnStar02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	
	local fairyArea = nil
	local hero = caster:GetOwner()
	if hero~=nil and hero:IsNull()==false then
		local fairyList = GetHeroFairyList(hero)    	
		for k,v in pairs(fairyList) do
			if v.star == caster then
				fairyArea = v
				break
			end
		end
	end

	if fairyArea == nil then 
		OnStar02Damage(keys,targetPoint)
	else
		local pos1 = fairyArea.sunny:GetAbsOrigin()
		local pos2 = fairyArea.star:GetAbsOrigin()
		local pos3 = fairyArea.luna:GetAbsOrigin()
		local center, radius = GetCircleCenterAndRadius(pos1,pos2,pos3) 

		local pos10 = GetTwoVectorSub(center, pos1, 2/1)
		local pos20 = GetTwoVectorSub(center, pos2, 2/1)
		local pos30 = GetTwoVectorSub(center, pos3, 2/1)
		local star_points = {}
		table.insert(star_points, center)
		table.insert(star_points, pos10)
		table.insert(star_points, pos20)
		table.insert(star_points, pos30)
		table.insert(star_points, GetTwoVectorSub(pos10, pos20, 1/1))
		table.insert(star_points, GetTwoVectorSub(pos20, pos30, 1/1))
		table.insert(star_points, GetTwoVectorSub(pos30, pos10, 1/1))

		local time = 4
		local count = 0
		caster:SetContextThink(DoUniqueString("ability_star_02_delay"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if time < 0 then return nil end	
				if fairyArea.sunny==nil or fairyArea.sunny:IsNull() or fairyArea.sunny:THTD_IsHidden() then return nil end
				if fairyArea.star==nil or fairyArea.star:IsNull() or fairyArea.star:THTD_IsHidden() then return nil end
				if fairyArea.luna==nil or fairyArea.luna:IsNull() or fairyArea.luna:THTD_IsHidden() then return nil end

				for _, pos in pairs(star_points) do
					local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_star/ability_star_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(effectIndex, 0, pos)
					ParticleManager:DestroyParticleSystem(effectIndex,false)
				end

				if count % 2 == 0 then 
					local targetsTotal = {}
					local targets = THTD_FindUnitsInRadius(caster,center,radius)
					for _,v in pairs(targets) do
						if v~=nil and v:IsNull()==false and v:IsAlive() and IsUnitInFairy(fairyArea,v) then					
							table.insert(targetsTotal, v)
						end
					end
					targets = {}
					local targetsBonus = 1
					if #targetsTotal > 3 then 
						targetsBonus = 1 + math.min(2, #targetsTotal/10)
					end
					for _, v in pairs(targetsTotal) do
						local DamageTable = {
							ability = keys.ability,
							victim = v, 
							attacker = caster, 
							damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 2 * (1.05^count) * targetsBonus, 
							damage_type = keys.ability:GetAbilityDamageType(), 
							damage_flags = DOTA_DAMAGE_FLAG_NONE
						}						
						UnitDamageTarget(DamageTable)
					end
				end

				count = count + 1
				time = time - 0.2
				return 0.2
			end,
		0)

	end
end

function OnStar02Damage(keys,targetPoint)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 2	
	local time = 4
	local count = 0
	
	caster:SetContextThink(DoUniqueString("ability_star_02_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time < 0 then return nil end			

		   	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_star/ability_star_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			if count % 2 == 0 then
				caster:SetContextThink(DoUniqueString("ability_star_02_delay"), 
					function()
						local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
						for k,v in pairs(targets) do						
							local DamageTable = {
								ability = keys.ability,
								victim = v, 
								attacker = caster, 
								damage = damage * (1.05^count), 
								damage_type = keys.ability:GetAbilityDamageType(), 
								damage_flags = DOTA_DAMAGE_FLAG_NONE									
							}						
							UnitDamageTarget(DamageTable)
						end
						return nil
					end,
				0.5)
			end

			count = count + 1
			time = time - 0.2
			return 0.2
		end,
	0)
end