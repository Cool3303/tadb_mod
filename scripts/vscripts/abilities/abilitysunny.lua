function OnSunny01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()
	
	OnSunny01Damage(keys,caster,caster,target,1)
	
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,1000)

	if targets[1]~=nil then
		OnSunny01Damage(keys,caster,target,targets[1],2.0)
	end

	if targets[2]~=nil then
		OnSunny01Damage(keys,caster,targets[1],targets[2],4.0)
	end

	local fairyArea = nil
	local hero = caster:GetOwner()
	if hero~=nil and hero:IsNull()==false then
		local fairyList = GetHeroFairyList(hero)    	
		for k,v in pairs(fairyList) do
			if v.sunny == caster then
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
		local lastTarget = caster
		for i=1,3 do
			for k,v in pairs(targetsTotal) do
				OnSunny01Damage(keys,caster,lastTarget,v,2^(i-1))
				lastTarget = v
			end
		end
	end	
end

function OnSunny01Damage(keys,caster,target1,target2,percentage)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/sunny/ability_sunny_01_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target2, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, target1, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 9, target2, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local DamageTable = {
		ability = keys.ability,
        victim = target2, 
        attacker = caster, 
        damage = caster:THTD_GetStar() * caster:THTD_GetPower() * percentage, 
        damage_type = keys.ability:GetAbilityDamageType(), 
        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end


function OnSunny02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	caster.thtd_last_cast_point = targetPoint

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/sunny/ability_sunny_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex , 0, targetPoint+Vector(0,0,32))
	ParticleManager:DestroyParticleSystemTime(effectIndex,10.0)

	local fairyArea = nil
	local hero = caster:GetOwner()
	if hero~=nil and hero:IsNull()==false then
		local fairyList = GetHeroFairyList(hero)    	
		for k,v in pairs(fairyList) do
			if v.sunny == caster then
				fairyArea = v
				break
			end
		end
	end
	local center = nil
	local radius = nil
	if fairyArea ~= nil then 
		local pos1 = fairyArea.sunny:GetAbsOrigin()
		local pos2 = fairyArea.star:GetAbsOrigin()
		local pos3 = fairyArea.luna:GetAbsOrigin()
		center, radius = GetCircleCenterAndRadius(pos1,pos2,pos3) 		
	end

	local count = 0
	caster:SetContextThink(DoUniqueString("ability_sunny_02_debuff"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end

			if count > 25 then
				return nil
			end

			local targets = THTD_FindUnitsInRadius(caster,targetPoint,400)
			if center ~= nil then 
				local targetsTotal = {}
				local fairyTargets = THTD_FindUnitsInRadius(caster,center,radius)		
				for _,v in pairs(fairyTargets) do
					if v~=nil and v:IsNull()==false and v:IsAlive() and IsUnitInFairy(fairyArea,v) then					
						targetsTotal[v:GetEntityIndex()] = v
					end
				end				
				for k,v in pairs(targetsTotal) do
					table.insert(targets,v)
				end
				targetsTotal = {}
			end

			for k,v in pairs(targets) do
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_sunny_02_debuff", {Duration = 0.6})
			end

			count = count + 1
			return 0.4
		end,
	0)
end
