function OnKoishi01Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.__koishi_lock ~= true then 
		caster.__koishi_lock = true
		local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)

		for i=1,#targets do
			local unit = targets[i]
			if unit~=nil and unit:IsNull()==false and unit~=target and unit:IsAlive() then
				caster:PerformAttack(unit,true,false,true,false,true,false,true)
				if RandomInt(0,100)<=30 then
					local DamageTable = {
				   			ability = keys.ability,
				            victim = unit, 
				            attacker = caster, 
				            damage = caster:THTD_GetStar() * caster:THTD_GetPower(), 
				            damage_type = keys.ability:GetAbilityDamageType(), 
				            damage_flags = DOTA_DAMAGE_FLAG_NONE
				   	}
				   	UnitDamageTarget(DamageTable)

				   	local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(effectIndex , 0, unit, 5, "follow_origin", Vector(0,0,0), true)
					ParticleManager:DestroyParticleSystemTimeFalse(effectIndex,1.0)
				end
			end
		end
		caster.__koishi_lock = false
	end
end

function OnKoishi02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local modifer = caster:FindModifierByName("modifier_koishi_02_attack_speed")

	if modifer == nil then
		modifer = keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_koishi_02_attack_speed", nil)
	end

	local max_count = 10
	if caster:HasModifier("passive_koishi_04_attack") then max_count = 20 end

	if modifer:GetStackCount() < max_count then
		modifer:SetStackCount(modifer:GetStackCount()+1)
	end
	if modifer:GetStackCount() <= max_count then
		modifer:SetDuration(5.0, false)
	end
end

local thtd_koishi_03_bonus = 
{
	[3] = 200,
	[4] = 400,
	[5] = 1000,
}

function OnKoishi03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.thtd_koishi_03_duration == nil then
		caster.thtd_koishi_03_duration = 10
	end

	local bonus = thtd_koishi_03_bonus[caster:THTD_GetStar()]

	if target.thtd_koishi_03_bonus==nil then
		target.thtd_koishi_03_bonus = false
	end

	if target:THTD_IsTower() and target.thtd_koishi_03_bonus == false then
		target:THTD_AddPower(bonus)
		target:THTD_AddAttack(bonus)
		caster.thtd_last_cast_unit = target
		target.thtd_koishi_03_bonus = true
		target:EmitSound("Hero_OgreMagi.Bloodlust.Target")

		caster:SetContextThink(DoUniqueString("thtd_koishi03_buff_remove"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				target:THTD_AddPower(-bonus)
				target:THTD_AddAttack(-bonus)
				target.thtd_koishi_03_bonus = false
			end,
		caster.thtd_koishi_03_duration)
	end
end

function OnKoishi04AttackStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local count = 3
	caster:SetContextThink(DoUniqueString("thtd_koishi03_buff_remove"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local num = RandomInt(1,6)
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_koishi/ability_koishi_04_attack_0"..num..".vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex , 0, caster:GetOrigin() - Vector(0,0,20))
			ParticleManager:SetParticleControlForward(effectIndex , 0, caster:GetForwardVector()+Vector(0,0,num/12))
			ParticleManager:SetParticleControlForward(effectIndex , 1, caster:GetForwardVector())
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			local DamageTable = {
		   			ability = keys.ability,
		            victim = target, 
		            attacker = caster, 
		            damage = caster:THTD_GetStar() * caster:THTD_GetPower() / 5, 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)

		   	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_koishi/ability_koishi_04_attack_landed.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex , 0, target:GetOrigin() + Vector(0,0,-260))
			ParticleManager:SetParticleControl(effectIndex , 1, target:GetOrigin() + Vector(0,0,0))
			ParticleManager:SetParticleControl(effectIndex , 2, target:GetOrigin() + Vector(0,0,0))
			ParticleManager:SetParticleControl(effectIndex , 3, target:GetOrigin() + Vector(0,0,0))
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			if count > 0 then
				count = count - 1
				return 0.1
			else
				return nil
			end
		end,
	0.1)
end

function OnKoishi04Kill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.unit

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/moluo/ability_moluo03_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex , 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex , 3, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex,false)

end

function OnKoishi04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local bonusPower = caster:THTD_GetPower()
	local bonusAttack = caster:THTD_GetAttack()

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	caster:THTD_AddPower(bonusPower)
	caster:THTD_AddAttack(bonusAttack)
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	keys.ability:ApplyDataDrivenModifier(caster, caster, "passive_koishi_04_attack",nil)
	caster:EmitSound("Voice_Thdots_Koishi.AbilityKoishi041")
	caster:EmitSound("Hero_VengefulSpirit.WaveOfTerror")

	local effectIndex = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_lvl2_black.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:DestroyParticleSystemTimeFalse(effectIndex,0.8)

	caster:SetContextThink(DoUniqueString("thtd_koishi04_buff_remove"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			caster:SetModel("models/thd_hero/koishi/eva/koishi_eva.vmdl")
			caster:SetOriginalModel("models/thd_hero/koishi/eva/koishi_eva.vmdl")
			caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)

			caster:SetContextThink(DoUniqueString("thtd_koishi04_buff_remove"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
					local effectIndex = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_lvl2_black.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
					ParticleManager:DestroyParticleSystemTimeFalse(effectIndex,0.25)
					caster:EmitSound("Voice_Thdots_Koishi.AbilityKoishi042")
					caster:EmitSound("Hero_VengefulSpirit.WaveOfTerror")

					caster:SetContextThink(DoUniqueString("thtd_koishi04_buff_remove"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4_END)
							caster:SetModel("models/thd_hero/koishi/koishi.vmdl")
							caster:SetOriginalModel("models/thd_hero/koishi/koishi.vmdl")
							caster:THTD_AddPower(-bonusPower)
							caster:THTD_AddAttack(-bonusAttack)
							caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
							caster:RemoveModifierByName("passive_koishi_04_attack")
							return nil
						end,
					0.25)

					return nil
				end,
			10.0)
			return nil
		end,
	0.8)
end