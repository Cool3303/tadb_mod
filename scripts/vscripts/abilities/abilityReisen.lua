function OnReisen01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	ReisenRepelUnit(target)
end

function ReisenRepelUnit(target)
	if target.thtd_is_fearing == true then return end
	if target.next_move_point ~= nil and target.thtd_is_feared_by_reisen_01 ~= true then		
		
		target.thtd_is_feared_by_reisen_01 = true
		target.thtd_is_fearing = true
		local current_next_move_point = target.next_move_point	

		target.next_move_point = target:GetOrigin() - target:GetForwardVector() * 500

		target:EmitSound("Hero_Sniper.ProjectileImpact")

		local count = 20	
		target:SetContextThink(DoUniqueString("thtd_reisen01_move_next_point"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				count = count - 1
				if count < 0 or THTD_IsValid(target) == false then
					if target ~= nil and target:IsNull() == false then 
						if GetDistanceBetweenTwoVec2D(target:GetAbsOrigin(), current_next_move_point) < 100 then 
							target.next_move_point = THTD_GetNextPathForUnit(target,target.thtd_next_corner)
						else
							target.next_move_point = current_next_move_point										
						end																	
						target.thtd_is_fearing = false
					end
					return nil
				else
					return 0.1
				end				
			end, 
		0)
	end
end

function OnReisen02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_reisen_02_illusion_count == nil then
		caster.thtd_reisen_02_illusion_count = 0
	end

	if caster.thtd_reisen_02_illusion_count_max == nil then
		caster.thtd_reisen_02_illusion_count_max = 3
	end

	if caster.thtd_reisen_02_illusion_count < caster.thtd_reisen_02_illusion_count_max and RandomInt(0,100) < 60 then

		caster:EmitSound("Sound_THTD.thtd_reisen_02")

		local illusion = CreateUnitByName(
				"reisen_illusion", 
				caster:GetOrigin() + RandomVector(150), 
				false, 
				caster:GetOwner(), 
				caster:GetOwner(), 
				caster:GetTeam() 
			)
		illusion.thtd_spawn_unit_owner = caster
		illusion:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
		local count = 0
		keys.ability:ApplyDataDrivenModifier(caster, illusion, "modifier_reisen_02_illusion", nil)
		illusion:SetBaseDamageMax(caster:GetAttackDamage())
		illusion:SetBaseDamageMin(caster:GetAttackDamage())
		illusion:MoveToPositionAggressive(illusion:GetOrigin() + illusion:GetForwardVector() * 100)
		illusion:SetContextThink(DoUniqueString("thtd_reisen02_illusion"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if count > 10 then 
					illusion:AddNoDraw()
					illusion:ForceKill(true)
					caster.thtd_reisen_02_illusion_count = caster.thtd_reisen_02_illusion_count - 1
					return nil				
				end
				count = count + 1
				return 0.5
			end, 
		0)
		caster.thtd_reisen_02_illusion_count = caster.thtd_reisen_02_illusion_count + 1
	end
end

function OnReisen03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	caster:EmitSound("Sound_THTD.thtd_reisen_03")

	local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),450)

	for k,v in pairs(targets) do
		Reisen03RepelUnit(v)
		local DamageTable = {
   			ability = keys.ability,
            victim = v, 
            attacker = caster, 
            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 5, 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_reisen/ability_reisen_03.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 3, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 9, caster:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)
	
end

function Reisen03RepelUnit(target)
	if target.thtd_is_fearing == true then return end
	if target.next_move_point ~= nil then	
		target.thtd_is_feared_by_reisen_01 = true
		target.thtd_is_fearing = true
		local current_next_move_point = target.next_move_point	

		target.next_move_point = target:GetOrigin() - target:GetForwardVector() * 500		

		target:EmitSound("Hero_Sniper.ProjectileImpact")

		local count = 20	
		target:SetContextThink(DoUniqueString("thtd_reisen01_move_next_point"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				count = count - 1
				if count < 0 or THTD_IsValid(target) == false then
					if target ~= nil and target:IsNull() == false then 
						if GetDistanceBetweenTwoVec2D(target:GetAbsOrigin(), current_next_move_point) < 100 then 
							target.next_move_point = THTD_GetNextPathForUnit(target,target.thtd_next_corner)
						else
							target.next_move_point = current_next_move_point										
						end																	
						target.thtd_is_fearing = false
					end
					return nil
				else
					return 0.1
				end
			end, 
		0)		
	end
end