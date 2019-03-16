local suika_model_scale_table = 
{
	[1] = 0.5,
	[2] = 0.7,
	[3] = 0.8,
	[4] = 1.0,
	[5] = 1.2,
	[6] = 2.0,
	[7] = 3.0,
}

local suika_count_table = 
{
	[1] = 7,
	[2] = 3,
	[3] = 1,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
}

local suika_damage_increase = 
{
	[1] = 0.125,
	[2] = 0.25,
	[3] = 0.5,
	[4] = 1,
	[5] = 2,
	[6] = 4,
	[7] = 8,
}

local suika_damage_chance = 
{
	[1] = 50,
	[2] = 50,
	[3] = 50,
	[4] = 50,
	[5] = 25,
	[6] = 12.5,
	[7] = 6.25,
}

local suika_damage_radius = 
{
	[1] = 200,
	[2] = 200,
	[3] = 200,
	[4] = 400,
	[5] = 600,
	[6] = 800,
	[7] = 1000,
}

function OnSuika01SpellStartUp(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_suika_01_scale == nil then
		caster.thtd_suika_01_scale = 4
	end

	if caster.thtd_suika_01_scale > 1 then
		caster.thtd_suika_01_scale = caster.thtd_suika_01_scale - 1
		caster:SetModelScale(suika_model_scale_table[caster.thtd_suika_01_scale])
		RemoveAllSuikaTinySuika(keys)
		SuikaCreateTinySuika(keys)
	end
end

function OnSuika01SpellStartDown(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_suika_01_scale == nil then
		caster.thtd_suika_01_scale = 4
	end

	if caster.thtd_suika_01_scale < 7 then
		caster.thtd_suika_01_scale = caster.thtd_suika_01_scale + 1
		caster:SetModelScale(suika_model_scale_table[caster.thtd_suika_01_scale])
		RemoveAllSuikaTinySuika(keys)
		SuikaCreateTinySuika(keys)
	end
end

function RemoveAllSuikaTinySuika(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.thtd_suika_01_tiny_suika_table == nil then
		caster.thtd_suika_01_tiny_suika_table = {}
	end
	for k,v in pairs(caster.thtd_suika_01_tiny_suika_table) do
		if v~=nil and v:IsNull() == false and v:IsAlive() then
			v:AddNoDraw()
			v:ForceKill(true)
		end
	end
	caster.thtd_suika_01_tiny_suika_table = {}
end

function SuikaCreateTinySuika(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local count = suika_count_table[caster.thtd_suika_01_scale]

	if caster.thtd_suika_01_tiny_suika_table == nil then
		caster.thtd_suika_01_tiny_suika_table = {}
	end

	local particle = ParticleManager:CreateParticle("particles/heroes/thtd_suika/ability_suika_01_smoke.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(particle,0,caster:GetOrigin())
	ParticleManager:SetParticleControl(particle,1,Vector(100,100,100))
	ParticleManager:DestroyParticleSystem(particle,false)

	for i=1,count do
		local offset = 100
		local rad = math.pi/2
		if i > 3 then
			offset = 200
			rad = rad - math.pi/4 - 3*math.pi/2
		end
		local tinySuika = CreateUnitByName(
				"tiny_suika", 
				caster:GetOrigin() + Vector(math.cos(rad*(i+1)),math.sin(rad*(i+1)),0)*offset, 
				false, 
				caster:GetOwner(), 
				caster:GetOwner(), 
				caster:GetTeam() 
			)
		tinySuika.thtd_spawn_unit_owner = caster
		local suikaAbility01 = caster:FindAbilityByName("thtd_suika_01")
		if suikaAbility01~=nil then
			suikaAbility01:ApplyDataDrivenModifier(caster, tinySuika, "passive_suika_01_attack_landed", nil)
		end
		keys.ability:ApplyDataDrivenModifier(caster, tinySuika, "modifier_suika_02_illusion", nil)
		tinySuika:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		tinySuika:SetBaseDamageMax(caster:GetAttackDamage())
		tinySuika:SetBaseDamageMin(caster:GetAttackDamage())
		tinySuika:SetModelScale(suika_model_scale_table[caster.thtd_suika_01_scale])
		tinySuika:SetForwardVector(caster:GetForwardVector())
		table.insert(caster.thtd_suika_01_tiny_suika_table,tinySuika)

		local particle = ParticleManager:CreateParticle("particles/heroes/thtd_suika/ability_suika_01_smoke.vpcf",PATTACH_CUSTOMORIGIN,tinySuika)
		ParticleManager:SetParticleControl(particle,0,tinySuika:GetOrigin())
		ParticleManager:SetParticleControl(particle,1,Vector(100,100,100))
		ParticleManager:DestroyParticleSystem(particle,false)
	end
end

function OnSuika01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster:GetUnitName() ==  "tiny_suika" then
		caster = caster.thtd_spawn_unit_owner
	end

	if caster.thtd_suika_01_scale == nil then
		caster.thtd_suika_01_scale = 4
	end

	if RandomInt(0,100) < suika_damage_chance[caster.thtd_suika_01_scale] then
		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),suika_damage_radius[caster.thtd_suika_01_scale])

		for k,v in pairs(targets) do
			local damage_table = {
				victim = v,
				attacker = caster,
				damage = caster:THTD_GetPower()*caster:THTD_GetStar()*suika_damage_increase[caster.thtd_suika_01_scale],
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
			}
			UnitDamageTarget(damage_table)

			local suikaAbility01 = caster:FindAbilityByName("thtd_suika_01")
			if suikaAbility01~=nil then
				suikaAbility01:ApplyDataDrivenModifier(caster, v, "modifier_suika_01_slow_debuff", nil)
			end
		end

		local particle = ParticleManager:CreateParticle("particles/heroes/thtd_suika/ability_suika_01.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControl(particle,0,target:GetOrigin()+Vector(0,0,64))
		ParticleManager:SetParticleControl(particle,1,Vector(suika_damage_radius[caster.thtd_suika_01_scale],suika_damage_radius[caster.thtd_suika_01_scale],suika_damage_radius[caster.thtd_suika_01_scale]))
		ParticleManager:DestroyParticleSystem(particle,false)
	end
end

function OnSuika01Think(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster==nil or caster:IsNull() or caster:IsAlive() == false or caster:THTD_IsHidden() then
		RemoveAllSuikaTinySuika(keys)
	end
end

function OnSuika03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	if caster.thtd_suika_01_scale == nil then
		caster.thtd_suika_01_scale = 4
	end

	if caster.thtd_suika_01_tiny_suika_table == nil then
		caster.thtd_suika_01_tiny_suika_table = {}
	end

	Suika03ThrowBallToPoint(keys,caster:GetOrigin(),targetPoint,120)
	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)
	for k,v in pairs(caster.thtd_suika_01_tiny_suika_table) do
		if v~=nil and v:IsNull() == false and v:IsAlive() and #targets>0 then
			Suika03ThrowBallToPoint(keys,v:GetOrigin(),targets[RandomInt(1,#targets)]:GetOrigin(),120)
		end
	end
end

function Suika03ThrowBallToPoint(keys,origin,targetpoint,vhigh)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local curOrigin = Vector(origin.x,origin.y,origin.z)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_suika/ability_suika_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, curOrigin)
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(suika_damage_radius[caster.thtd_suika_01_scale]/1000,0,0))
	ParticleManager:SetParticleControl(effectIndex, 2, Vector(suika_damage_radius[caster.thtd_suika_01_scale]/2,0,0))

	local g = -10
	local dis = GetDistanceBetweenTwoVec2D(origin,targetpoint)
	local vh = vhigh
	local t = math.abs(2*vh/g)
	local speed = dis/t
	local rad = GetRadBetweenTwoVec2D(origin,targetpoint)

	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * suika_damage_increase[caster.thtd_suika_01_scale]


	caster:SetContextThink(DoUniqueString("ability_suika_03"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			vh = vh + g
			curOrigin = Vector(curOrigin.x + math.cos(rad) * speed,curOrigin.y + math.sin(rad) * speed,curOrigin.z + vh)
			ParticleManager:SetParticleControl(effectIndex, 0, curOrigin)
			if curOrigin.z >= caster:GetOrigin().z - 50 then
				return 0.02
			else
				curOrigin.z = caster:GetOrigin().z
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				local effectIndex2 = ParticleManager:CreateParticle("particles/thd2/heroes/suika/ability_suika_04_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex2, 0, curOrigin)
				ParticleManager:DestroyParticleSystem(effectIndex2,false)

				local targets = THTD_FindUnitsInRadius(caster,curOrigin,suika_damage_radius[caster.thtd_suika_01_scale]/2)
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
				return nil
			end
		end, 
	0)
end

function OnSuika04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_suika_01_scale == nil then
		caster.thtd_suika_01_scale = 4
	end

	if caster.thtd_suika_01_tiny_suika_table == nil then
		caster.thtd_suika_01_tiny_suika_table = {}
	end

	for k,v in pairs(caster.thtd_suika_01_tiny_suika_table) do
		if v~=nil and v:IsNull() == false and v:IsAlive() then
			local targets = THTD_FindUnitsInRadius(caster,v:GetOrigin(),800)
			if #targets>0 then
				for index,lockTarget in pairs(targets) do
					if lockTarget.thtd_suika_04_lock~=true then
						lockTarget.thtd_suika_04_lock = true
						OnSuika04LockToTarget(keys,v,lockTarget)
					end
				end
			end
		end
	end
end

function OnSuika04LockToTarget(keys,caster,target)
	local originalCaster = EntIndexToHScript(keys.caster_entindex)
	local vecHook = target:GetOrigin()

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_suika/ability_suika_04.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effectIndex, 1, vecHook)
	ParticleManager:SetParticleControlEnt(effectIndex , 3, target, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effectIndex, 4, Vector(2400,0,0))
	ParticleManager:SetParticleControl(effectIndex, 5, Vector(2400,0,0))
	ParticleManager:SetParticleControl(effectIndex, 6, vecHook)

	local timecount = 3.5

	caster:SetContextThink(DoUniqueString("ability_suika_04"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if timecount <= 0 or target==nil or target:IsNull() or target:IsAlive()==false then
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				target.thtd_suika_04_lock = false
				FindClearSpaceForUnit(target, target:GetOrigin(), false)
				return nil
			end
			if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), target:GetOrigin()) > 800 then
				local forward = (target:GetOrigin() - caster:GetAbsOrigin()):Normalized()
				target:SetAbsOrigin(caster:GetOrigin()+forward*800)
				local damage = originalCaster:THTD_GetPower() * originalCaster:THTD_GetStar() * suika_damage_increase[originalCaster.thtd_suika_01_scale]
				local DamageTable = {
		   			ability = keys.ability,
		            victim = target, 
		            attacker = originalCaster, 
		            damage = damage, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
			end

			local damage = originalCaster:THTD_GetPower() * originalCaster:THTD_GetStar() * suika_damage_increase[originalCaster.thtd_suika_01_scale]
			local DamageTable = {
	   			ability = keys.ability,
	            victim = target, 
	            attacker = originalCaster, 
	            damage = damage, 
	            damage_type = keys.ability:GetAbilityDamageType(), 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)

			timecount = timecount - 0.1
			return 0.1
		end, 
	0)
end