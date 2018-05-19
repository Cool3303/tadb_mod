function Ran01_OnSpellStart(keys)
	local ability=keys.ability
	local caster=keys.caster
	local target=keys.target

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/ran/ability_ran_03_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, target, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 9, caster, 5, "attach_hitloc", Vector(0,0,0), true)

	local damage_table={
			victim=target, 
			attacker=caster, 
			ability=ability,
			damage=caster:THTD_GetPower()*caster:THTD_GetStar()*2,
			damage_type=ability:GetAbilityDamageType(),
		}
	UnitDamageTarget(damage_table)


	local target_unit=target
	local jump_count=1
	local jumpAmount = keys.JumpCount

	if jumpAmount>1 then
		caster:SetContextThink(
			"ran01_lazer_jumping",
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				local enemies = THTD_FindUnitsInRadius(caster,target_unit:GetOrigin(),keys.JumpRadius)

				local next_target=nil
				for _,v in pairs(enemies) do
					if v:IsAlive() then
						if v~=target_unit then
							next_target=v
							break
						end
					end
				end
				if next_target then
					-- target_unit:EmitSound("Hero_Tinker.Laser")
					effectIndex = ParticleManager:CreateParticle("particles/heroes/ran/ability_ran_03_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

					ParticleManager:SetParticleControlEnt(effectIndex , 0, target_unit, 5, "attach_hitloc", Vector(0,0,0), true)
					ParticleManager:SetParticleControlEnt(effectIndex , 1, next_target, 5, "attach_hitloc", Vector(0,0,0), true)
					ParticleManager:SetParticleControlEnt(effectIndex , 9, target_unit, 5, "attach_hitloc", Vector(0,0,0), true)

					target_unit=next_target
					local DamageTable={
						victim=target_unit, 
						attacker=caster, 
						ability=ability,
						damage=caster:THTD_GetPower()*caster:THTD_GetStar()*2,
						damage_type=ability:GetAbilityDamageType(),
					}
					UnitDamageTarget(DamageTable)
					-- next_target:EmitSoundParams("Hero_Tinker.LaserImpact",1.0,0.4,2.0)
				end

				jump_count=jump_count+1
				if jump_count>=jumpAmount or target_unit==nil then return nil end
				return keys.JumpInterval
			end,keys.JumpInterval)
	end
end

function OnRan03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if keys.ability:GetLevel()<1 then
		return
	end
	if keys.event_ability:GetAbilityName() == "thtd_ran_01" or keys.event_ability:GetManaCost(keys.event_ability:GetLevel()) <= 0 then
		return
	end

	local ability01 = caster:FindAbilityByName("thtd_ran_01")
	ability01:EndCooldown()
	caster:SetMana(caster:GetMana()+ability01:GetManaCost(ability01:GetLevel()))

	local enemies = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)
	if #enemies > 0 and enemies[1]~=nil and enemies[1]:IsNull()==false then
		caster:CastAbilityOnTarget(enemies[1],ability01,caster:GetPlayerOwnerID())
	end

	if caster.thtd_ran_01_mana_regen_buff == nil then
		caster.thtd_ran_01_mana_regen_buff = false
	end

	if caster.thtd_ran_01_mana_regen_buff == true and IsInRan03BlackList(keys.event_ability) ~= true then
		keys.unit:GiveMana(keys.event_ability:GetManaCost(keys.event_ability:GetLevel())*0.25)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/ran/ability_ran_04_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, keys.unit, 5, "follow_origin", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystemTimeFalse(effectIndex,2.0)
end

local ran_03_black_list =
{
	"thtd_lily_01",
}

function IsInRan03BlackList(ability)
	for k,v in pairs(ran_03_black_list) do
		if ability:GetAbilityName() == v then
			return true
		end
	end
	return false
end