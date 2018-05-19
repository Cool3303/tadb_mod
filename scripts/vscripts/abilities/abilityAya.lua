function OnAya01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	OnAya01Attack(keys,caster,target)
end

function OnAya01Attack(keys,caster,target)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_aya/ability_aya_01.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+caster:GetForwardVector()*60)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local targets = THTD_FindUnitsInRadius(caster, target:GetOrigin(), 300)

	for _,v in pairs(targets) do
		local deal_damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = deal_damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		UnitDamageTarget(damage_table)
		if v:HasModifier("modifier_aya01_news_buff") == false then
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_aya/ability_aya_01_news.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
	   		keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_aya01_news_buff", nil)
	   	end
	end

	local effectIndex = ParticleManager:CreateParticle(
	"particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_cascade.vpcf", 
	PATTACH_CUSTOMORIGIN, 
	nil)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 3, target:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(effectIndex,2)

	if caster:FindAbilityByName("thtd_aya_03"):GetLevel()>0 then
		local ability02 = caster:FindAbilityByName("thtd_aya_02")

		if ability02~=nil then
			ability02:EndCooldown()
		end
	end
end

function OnAya01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.__thtd_aya_01_lock == true then return end
	caster.__thtd_aya_01_lock = true

	local entities = THTD_FindUnitsAll(caster)
	for k,v in pairs(entities) do
		if v:HasModifier("modifier_hatate01_news_buff") or v:HasModifier("modifier_aya01_news_buff") then
			OnAyaAttack(keys,v)
		end
	end
	caster.__thtd_aya_01_lock = false
end

function OnAya02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	caster:SetForwardVector(Vector(math.cos(rad),math.sin(rad),0))

   	keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_aya_02_pause", nil)

   	local count = 0
	caster:SetContextThink(DoUniqueString("ability_aya_02_move"), 
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), targetPoint)>=90 and GetDistanceBetweenTwoVec2D(caster:GetOrigin(), targetPoint)<keys.ability:GetCastRange() 
			and caster:HasModifier("modifier_touhoutd_release_hidden") == false then
				caster:SetOrigin(caster:GetOrigin() + Vector(math.cos(rad),math.sin(rad),0)*90)
				if count%5 == 0 then
					local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),300)

					for _,v in pairs(targets) do
						local deal_damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5
						local damage_table = {
								ability = keys.ability,
							    victim = v,
							    attacker = caster,
							    damage = deal_damage,
							    damage_type = keys.ability:GetAbilityDamageType(), 
					    	    damage_flags = DOTA_DAMAGE_FLAG_NONE
						}
						UnitDamageTarget(damage_table)
						if caster:FindAbilityByName("thtd_aya_03"):GetLevel()>0 then
							OnAyaAttack(keys,v)
						end
					end
				end
				count = count + 1
			else
				FindClearSpaceForUnit(caster, caster:GetOrigin(), false)
				caster:THTD_DestroyLevelEffect()
				caster:THTD_CreateLevelEffect()
				caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
				caster:RemoveModifierByName("modifier_aya_02_pause")
				return nil
			end
			return 0.03
		end, 
	0.03)
end

function OnAyaAttack(keys,target)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local damage_table = {
			ability = keys.ability,
		    victim = target,
		    attacker = caster,
		    damage = caster:GetAttackDamage(),
		    damage_type = keys.ability:GetAbilityDamageType(), 
    	    damage_flags = DOTA_DAMAGE_FLAG_NONE
	}
	UnitDamageTarget(damage_table)

	local chance =  RandomInt(0,100)

	if chance < 12 then
		OnAya01Attack(keys,caster,target)
	end

	OnAya01AttackLanded(keys)

	if caster:HasModifier("modifier_eirin_02_spell_buff") then
		local eirin = THTD_GetFirstTowerByName(caster,"eirin") 
		if eirin ~= nil then
			local eirin01 = eirin:FindAbilityByName("thtd_eirin_01")
			if eirin01~=nil and eirin01:GetLevel()>1 then
				OnAyaLinkToEirin01(caster,target,eirin01,eirin)
			end
		end
	end

	if caster:HasModifier("modifier_item_2011_attack_stun") then
		if RandomInt(0,100) < 10 then
			if target.thtd_is_lock_item_2011_stun ~= true then
				target.thtd_is_lock_item_2011_stun = true
	   			UnitStunTarget(caster,target,1.0)
	   			target:SetContextThink(DoUniqueString("ability_item_2011_stun"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						target.thtd_is_lock_item_2011_stun = false
						return nil
					end,
				2.0)
	   		end
		end
	end
end

function OnAyaLinkToEirin01(caster,target,ability,source)
	if caster:GetMana() > 10 then
		caster:SetMana(caster:GetMana() - 10)
		if RandomInt(0,100) < caster:THTD_GetStar() * 10 then
			if caster:GetMana() < caster:GetMaxMana() * 0.6 then
				caster:SetMana(caster:GetMana() + caster:GetMaxMana() * 0.4)
			else
				caster:SetMana(caster:GetMaxMana())
			end
		end

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
		local info = 
		{
			Target = target,
			Source = caster,
			Ability = ability,	
			EffectName = "particles/heroes/thtd_eirin/ability_eirin_01.vpcf",
	        iMoveSpeed = 1400,
			vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
		    bDodgeable = true,                                -- Optional
		  	bIsAttack = false,                                -- Optional
		    bVisibleToEnemies = true,                         -- Optional
		    bReplaceExisting = false,                         -- Optional
		    flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
			bProvidesVision = true,                           -- Optional
			iVisionRadius = 400,                              -- Optional
			iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
			ExtraData = { 
				source=source
			}
		}
		local projectile = ProjectileManager:CreateTrackingProjectile(info)
		ParticleManager:DestroyLinearProjectileSystem(projectile,false)
	end
end
