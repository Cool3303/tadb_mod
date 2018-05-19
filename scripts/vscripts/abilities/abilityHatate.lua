function OnHatate01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hatate/ability_hatate_01_news.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+caster:GetForwardVector()*60)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local targets = THTD_FindUnitsInRadius(caster,targetPoint,500)
	for _,v in pairs(targets) do
		if v:HasModifier("modifier_hatate01_news_buff") == false then
   			keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_hatate01_news_buff", nil)
   		end
	end
	local entities = THTD_FindUnitsAll(caster)
	for k,v in pairs(entities) do
		if v:HasModifier("modifier_hatate01_news_buff") or v:HasModifier("modifier_aya01_news_buff") then
			local deal_damage = caster:THTD_GetPower() * caster:THTD_GetStar()
			local damage_table = {
					ability = keys.ability,
				    victim = v,
				    attacker = caster,
				    damage = deal_damage,
				    damage_type = keys.ability:GetAbilityDamageType(), 
		    	    damage_flags = 0
			}
			UnitDamageTarget(damage_table)
			
	   		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hatate/ability_hatate_01.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	end
end

function OnHatate01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.__thtd_hatate_01_lock == true then return end
	caster.__thtd_hatate_01_lock = true

	local entities = THTD_FindUnitsAll(caster)
	for k,v in pairs(entities) do
		local findNum =  string.find(v:GetUnitName(), 'creature')
		if v:HasModifier("modifier_hatate01_news_buff") or v:HasModifier("modifier_aya01_news_buff") then
			OnHatateAttack(keys,v)
		end
	end

	caster.__thtd_hatate_01_lock = false
end

function OnHatate02SpellStart(keys)
	if GameRules:IsGamePaused() then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local inners = THTD_FindUnitsInner(caster)
	local outers = THTD_FindUnitsOuter(caster)

	for k,v in pairs(inners) do
		if v:HasModifier("modifier_hatate01_news_buff") == false then
   			keys.ability:ApplyDataDrivenModifier(caster,v,"modifier_hatate01_news_buff", nil)
   		end
		local deal_damage = caster:THTD_GetPower() * caster:THTD_GetStar() / 2.5
		local damage_table = {
				ability = keys.ability,
			    victim = v,
			    attacker = caster,
			    damage = deal_damage,
			    damage_type = keys.ability:GetAbilityDamageType(), 
	    	    damage_flags = 0
		}
		UnitDamageTarget(damage_table)
		if RandomInt(0,4) == 1 then
	   		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hatate/ability_hatate_01.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	end

	for k,v in pairs(outers) do
   		if v:HasModifier("modifier_hatate01_news_buff") or v:HasModifier("modifier_aya01_news_buff") then
			local deal_damage = caster:THTD_GetPower() * caster:THTD_GetStar() / 2.5
			local damage_table = {
					ability = keys.ability,
				    victim = v,
				    attacker = caster,
				    damage = deal_damage,
				    damage_type = keys.ability:GetAbilityDamageType(), 
		    	    damage_flags = 0
			}
			UnitDamageTarget(damage_table)
			if RandomInt(0,4) == 1 then
		   		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_hatate/ability_hatate_01.vpcf",PATTACH_CUSTOMORIGIN,caster)
				ParticleManager:SetParticleControl(effectIndex, 0, v:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
			end
		end
	end
end

function OnHatateAttack(keys,target)
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