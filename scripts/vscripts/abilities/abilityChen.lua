function OnChen01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)

	if caster.thtd_chen_01_last_origin == nil then
		caster.thtd_chen_01_last_origin = caster:GetOrigin()
	end

	caster.thtd_chen_01_last_origin = caster:GetOrigin()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

   	keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_chen_01_pause", nil)
	caster:SetContextThink(DoUniqueString("ability_chen_01_move"), 
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), targetPoint)>=30 and GetDistanceBetweenTwoVec2D(caster:GetOrigin(), targetPoint)<keys.ability:GetCastRange() 
			and caster:HasModifier("modifier_touhoutd_release_hidden") == false then
				caster:SetOrigin(caster:GetOrigin() + Vector(math.cos(rad),math.sin(rad),0)*30)
			else
				FindClearSpaceForUnit(caster, caster:GetOrigin(), false)
				caster:THTD_DestroyLevelEffect()
				caster:THTD_CreateLevelEffect()
				caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
				caster:RemoveModifierByName("modifier_chen_01_pause")
				return nil
			end
			return 0.03
		end, 
	0.03)
end

function OnChen01SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.thtd_chen_01_vector == nil then
		caster.thtd_chen_01_vector = caster:GetOrigin()
	end

	if caster.thtd_chen_01_distance_max == nil then
		caster.thtd_chen_01_distance_max = 5
	end

	if caster.thtd_chen_01_distance_increase == nil then
		caster.thtd_chen_01_distance_increase = 100
	end

	if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), caster.thtd_chen_01_vector) > 30 and caster:HasModifier("modifier_touhoutd_release_hidden")==false then
		local dis = GetDistanceBetweenTwoVec2D(caster:GetOrigin(), caster.thtd_chen_01_vector)
		caster.thtd_chen_01_vector = caster:GetOrigin()
		local increase = math.min(dis/caster.thtd_chen_01_distance_increase,caster.thtd_chen_01_distance_max)

		caster:EmitSoundParams("Sound_THTD.thtd_chen_01",1.0,0.2*(1+increase/8),2.0)

		local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),400*(1+increase/8))
		
		for k,v in pairs(targets) do
			local DamageTable = {
	   			ability = keys.ability,
	            victim = v, 
	            attacker = caster, 
	            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * increase * 0.7, 
	            damage_type = keys.ability:GetAbilityDamageType(), 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
		end
		
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_chen/ability_chen_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, Vector(400*(1+increase/8),400*(1+increase/8),400*(1+increase/8)))
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end