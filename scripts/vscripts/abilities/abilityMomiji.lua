function OnMomiji01Spawn(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.ability_momiji01_Spawn_unit == nil then
		caster.ability_momiji01_Spawn_unit = {}
	end

	count = 4

	for i=1,count do
		local unit = CreateUnitByName(
			"momiji_wolf"
			,caster:GetOrigin() + ( caster:GetForwardVector() + Vector(math.cos((i-1.5)*math.pi/3),math.sin((i-1.5)*math.pi/3),0) ) * 100
			,false
			,caster:GetOwner()
			,caster:GetOwner()
			,caster:GetTeam()
		)

		if unit == nil then return end

		unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false) 
		unit:SetBaseDamageMax(caster:THTD_GetPower() * caster:THTD_GetStar())
		unit:SetBaseDamageMin(caster:THTD_GetPower() * caster:THTD_GetStar())
		unit.thtd_spawn_unit_owner = caster

		keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_momiji_01_buff", {Duration = caster.thtd_lunasa_duration})

		local oldSwpanUnit = caster.ability_momiji01_Spawn_unit[i]
		if oldSwpanUnit ~=nil and oldSwpanUnit:IsNull() == false then 
			oldSwpanUnit:ForceKill(false)
		end
		caster.ability_momiji01_Spawn_unit[i] = unit

		local duration = 30
		unit:SetContextThink(DoUniqueString("modifier_momiji_02"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), unit:GetOrigin()) > 600 then
					local forward = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() 
					unit:MoveToPosition(caster:GetOrigin() + forward*600)
				end
				if duration > 0 then
					duration = duration - 1.0
				else
					unit:AddNoDraw()
					unit:ForceKill(false)
					return nil
				end
				if caster==nil or caster:IsNull() or caster:IsAlive()==false or caster:HasModifier("modifier_touhoutd_release_hidden") then
					unit:AddNoDraw()
					unit:ForceKill(false)
					return nil
				end
				return 1.0
			end,
		1.0)
	end
end

function OnMomiji02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.ability_momiji_02_target == target then return end
	if caster == target then return end

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_momiji_02", nil)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_momiji/ability_momiji_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "follow_origin", Vector(0,0,0), true)
	caster.ability_momiji_02_target = target

	local count = 0
	caster:SetContextThink(DoUniqueString("modifier_momiji_02"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster.ability_momiji_02_target ~= target then
				if target~=nil and target:IsNull()==false and target:HasModifier("modifier_momiji_02") then
					target:RemoveModifierByName("modifier_momiji_02")
				end
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				return nil
			end
			return 0.1
		end,
	0.1)

	caster:SetContextThink("modifier_momiji_02_remove", 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster:HasModifier("modifier_touhoutd_release_hidden") or keys.ability:GetLevel()<1 then
				caster.ability_momiji_02_target = nil
				return nil
			end
			return 0.1
		end,
	0.1)
end