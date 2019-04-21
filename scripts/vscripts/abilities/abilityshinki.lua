
function OnShinki03Spell(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target	

	if target:THTD_IsTower() and target:GetOwner() == caster:GetOwner() and caster ~= target then
		local hero = caster:GetOwner()

		if hero.thtd_shinki_03_count == nil then
			hero.thtd_shinki_03_count = 0
		end
		if target.thtd_shinki_03_count == nil then
			target.thtd_shinki_03_count = 0
		end
		if hero.thtd_shinki_03_count >= 3 or target.thtd_shinki_03_count >= 3 then
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="shinki_max_count", duration=5, params={count=1}, color="#0ff"} )
			return
		end
		
		hero.thtd_shinki_03_count = hero.thtd_shinki_03_count + 1
		target.thtd_shinki_03_count = target.thtd_shinki_03_count + 1

		target:THTD_AddPower(180)
		target:EmitSound("Sound_THTD.thtd_level_up")
	else
		keys.ability:EndCooldown()
	end
end


local baseModel = 1.0

function OnShinki04Spawn(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local entities = Entities:FindAllByClassname("npc_dota_creature")						
	for k,v in pairs(entities) do
		local findNum = string.find(v:GetUnitName(), 'shinki_dragon')
		if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() then
			local c = v.thtd_spawn_unit_owner
			if c:GetOwner() == caster:GetOwner() then 
				return 
			end			
		end		
	end

	if caster.ability_shinki04_devour_count == nil then
		caster.ability_shinki04_devour_count = 0
	end
	
	local unit = CreateUnitByName(
		"shinki_dragon"
		,caster:GetOrigin() + caster:GetForwardVector() * 500
		,false
		,caster:GetOwner()
		,caster:GetOwner()
		,caster:GetTeam()
	)	
	if unit == nil then 
		keys.ability:EndCooldown()
		return 
	end
	FindClearSpaceForUnit(unit, unit:GetOrigin(), false)

	local attackValue = math.floor(caster:THTD_GetPower() * caster:THTD_GetStar() * (1 + caster.ability_shinki04_devour_count * 0.02))	
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false) 
	unit:SetBaseDamageMax(attackValue)
	unit:SetBaseDamageMin(attackValue)
	unit:SetModelScale(baseModel * (1 + caster.ability_shinki04_devour_count * 0.02))	
	unit:SetHasInventory(false)
	unit.thtd_spawn_unit_owner = caster	

	local ability = unit:GetAbilityByIndex(0)
	if ability ~= nil then 
		ability:SetActivated(true)
		ability:SetLevel(1)
	end
	ability = unit:GetAbilityByIndex(1)
	if ability ~= nil then 
		ability:SetActivated(true)
		ability:SetLevel(1)
	end
	ability = unit:GetAbilityByIndex(2)
	if ability ~= nil then 
		ability:SetActivated(true)
		ability:SetLevel(1)
	end
	ability = unit:GetAbilityByIndex(3)
	if ability ~= nil then 
		ability:SetActivated(true)
		ability:SetLevel(1)
	end
	ability = unit:GetAbilityByIndex(4)
	if ability ~= nil then 
		ability:SetActivated(true)
		ability:SetLevel(1)
	end

	ability = unit:FindAbilityByName("shinki_dragon_01")
	if ability ~= nil and caster.ability_shinki04_devour_count > 0 then	
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_shinki_dragon_01_buff", nil)
		unit:SetModifierStackCount("modifier_shinki_dragon_01_buff", unit, caster.ability_shinki04_devour_count)
	end		

	keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_shinki_04_buff", nil)

	local oldSwpanUnit = caster.ability_shinki04_spawn_unit
	if oldSwpanUnit ~=nil and oldSwpanUnit:IsNull() == false then 
		oldSwpanUnit:AddNoDraw()
		oldSwpanUnit:ForceKill(false)
	end
	caster.ability_shinki04_spawn_unit = unit
	
	unit:SetContextThink(DoUniqueString("modifier_shinki_04"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster==nil or caster:IsNull() or caster:IsAlive()==false or caster:THTD_IsHidden() then
				unit:AddNoDraw()
				unit:ForceKill(false)
				caster.ability_shinki04_spawn_unit = nil
				return nil
			end
			
			attackValue = math.floor(caster:THTD_GetPower() * caster:THTD_GetStar() * (1 + caster.ability_shinki04_devour_count * 0.02))
			unit:SetBaseDamageMax(attackValue)
			unit:SetBaseDamageMin(attackValue)

			if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), unit:GetOrigin()) > 1000 then
				local forward = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() 
				unit:MoveToPosition(caster:GetOrigin() + forward*1000)
			end

			enemy = unit:GetAttackTarget()	

			ability = unit:FindAbilityByName("shinki_dragon_01")			
			if unit:IsReadyToCastAbility(ability) and enemy ~= nil and enemy.thtd_damage_lock ~= true then	
				if enemy~=nil and enemy:IsNull()==false and enemy:IsAlive() then 									
					unit:CastAbilityOnTarget(enemy, ability, caster:GetPlayerOwnerID())					
				end
			end	
			
			ability = unit:FindAbilityByName("shinki_dragon_03")			
			if unit:IsReadyToCastAbility(ability) then
				if enemy~=nil and enemy:IsNull()==false and enemy:IsAlive() then 									
					unit:CastAbilityNoTarget(ability, caster:GetPlayerOwnerID())
				end
			end	

			return math.floor(100/unit:GetAttacksPerSecond()) / 100
		end,
	0)	
end


function OnShinkiDragon01SpellStart(keys)	
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local owner = caster.thtd_spawn_unit_owner
	if owner==nil or owner:IsNull() or owner:IsAlive()==false or owner:THTD_IsHidden() then return end
	if target.thtd_damage_lock == true then return end	

	keys.ability:StartCooldown(math.max(math.floor(target:GetHealth() / caster:GetAverageTrueAttackDamage(caster)), 30))
	
	THTD_Kill(caster, target, nil)	

	if owner.ability_shinki04_devour_count < 100 then 
		owner.ability_shinki04_devour_count = owner.ability_shinki04_devour_count + 1	
		caster:SetModelScale(baseModel * (1 + owner.ability_shinki04_devour_count * 0.02))
		if not caster:HasModifier("modifier_shinki_dragon_01_buff") then 
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_shinki_dragon_01_buff", nil)
		end	
		caster:SetModifierStackCount("modifier_shinki_dragon_01_buff", caster, owner.ability_shinki04_devour_count)	
	end	
end


function OnShinki02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local owner = caster.thtd_spawn_unit_owner
	if owner==nil or owner:IsNull() or owner:IsAlive()==false or owner:THTD_IsHidden() then return end
	local target = keys.target
	local chance = RandomInt(0,100)
	if chance > keys.Chance then return end

	local enemies = THTD_FindUnitsInRadius(owner, target:GetOrigin(), keys.StunRange)
	local damage = caster:GetAverageTrueAttackDamage(caster)
	if #enemies > 0 then
		for k,v in pairs(enemies) do
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_bash_stun_datadriven", {Duration = keys.Duration})
			local DamageTable = {
				ability = keys.ability,
				victim = v, 
				attacker = caster, 
				damage = damage, 
				damage_type = keys.ability:GetAbilityDamageType(),  
				damage_flags = DOTA_DAMAGE_FLAG_NONE
			}
			if v == target then DamageTable.damage = damage * keys.DamageTimes end
			UnitDamageTarget(DamageTable)
		end			
	end	
	caster:EmitSound("Hero_Slardar.Bash")	
end


function OnShinkiDragon03SpellStart(keys)	
	local caster = EntIndexToHScript(keys.caster_entindex)
	local owner = caster.thtd_spawn_unit_owner
	if owner==nil or owner:IsNull() or owner:IsAlive()==false or owner:THTD_IsHidden() then return end

	local enemies = THTD_FindUnitsInRadius(owner, caster:GetOrigin(), keys.RangeRadius)
	local damage = caster:GetAverageTrueAttackDamage(caster) * keys.DamageTimes
	local debuff = "modifier_earthshock_debuff_datadriven"
	if #enemies > 0 then
		for k,v in pairs(enemies) do
			keys.ability:ApplyDataDrivenModifier(caster, v, debuff, {Duration = keys.Duration})
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
	end	
end