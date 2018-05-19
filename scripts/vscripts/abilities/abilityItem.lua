function OnItem2001_SpellStart(keys)
	local caster = keys.caster
	if caster:GetUnitName() == "npc_dota_hero_lina" then
		local entities = Entities:FindAllByClassname("npc_dota_creature")

		for k,v in pairs(entities) do
			local findNum =  string.find(v:GetUnitName(), 'creature')
			if findNum ~= nil and v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_player_index == caster:GetPlayerOwnerID() then
				v:SetHealth(1)
				local DamageTable = {
						ability = keys.ability,
				        victim = v, 
				        attacker = caster, 
				        damage = 10000, 
				        damage_type = DAMAGE_TYPE_PURE, 
				        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	ApplyDamage(DamageTable)
			end
		end

		local particle = ParticleManager:CreateParticle("particles/heroes/yumemi/ability_yumemi_04_exolosion.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControl(particle,0,caster:GetOrigin())
		ParticleManager:DestroyParticleSystem(particle,false)

		if keys.ability:IsItem() then
			local charge = keys.ability:GetCurrentCharges()
			if charge > 1 then
				keys.ability:SetCurrentCharges(charge-1)
			else
				caster:RemoveItem(keys.ability)
			end
		end
	end
end

function OnItem2002_SpellStart(keys)
	local caster = keys.caster
	if caster:GetUnitName() == "npc_dota_hero_lina" then
		if keys.ability:IsItem() then
			local select_cards = {}
			for k,v in pairs(towerPlayerList[caster:GetPlayerOwnerID()+1]) do
				if v["quality"] == 4 and string.find(v["itemName"],"item_20") == nil and v["count"] > 0 then
					select_cards[v["itemName"]] = v["itemName"]
				end
			end
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_select_card_panel", {cards=select_cards} )
			caster.thtd_last_select_item = keys.ability
		end
	end
end

function OnItem2003_SpellStart(keys)
	local caster = keys.caster
	if caster:GetUnitName() == "npc_dota_hero_lina" then
		if keys.ability:IsItem() then
			local select_cards = {}
			for k,v in pairs(towerPlayerList[caster:GetPlayerOwnerID()+1]) do
				if v["quality"] == 3 and string.find(v["itemName"],"item_20") == nil and v["count"] > 0 then
					select_cards[v["itemName"]] = v["itemName"]
				end
			end
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_select_card_panel", {cards=select_cards} )
			caster.thtd_last_select_item = keys.ability
		end
	end
end

function OnItem2004_SpellStart(keys)
	local caster = keys.caster
	if caster:GetUnitName() == "npc_dota_hero_lina" then
		if keys.ability:IsItem() then
			local select_cards = {}
			for k,v in pairs(towerPlayerList[caster:GetPlayerOwnerID()+1]) do
				if v["quality"] == 2 and string.find(v["itemName"],"item_20") == nil and v["count"] > 0 then
					select_cards[v["itemName"]] = v["itemName"]
				end
			end
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_select_card_panel", {cards=select_cards} )
			caster.thtd_last_select_item = keys.ability
		end
	end
end

function OnItem2021_SpellStart(keys)
	if SpawnSystem:GetWave() > 51 then return end
	local caster = keys.caster
	local target = keys.target

	if caster:GetUnitName() == "npc_dota_hero_lina" then
		target:SetHealth(1)
		local DamageTable = {
				ability = keys.ability,
		        victim = target, 
		        attacker = caster, 
		        damage = 10000, 
		        damage_type = DAMAGE_TYPE_PURE, 
		        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	ApplyDamage(DamageTable)
		PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 500 , true, DOTA_ModifyGold_CreepKill)
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, target, 500, caster:GetPlayerOwner() )
		
		local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_donation_box.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetAbsOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end

function OnItem2022_SpellStart(keys)
	if SpawnSystem:GetWave() > 51 then return end
	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = keys.target_points[1]

	if caster:GetUnitName() == "npc_dota_hero_lina" then
		local targets = 
				FindUnitsInRadius(
					caster:GetTeamNumber(), 
					targetPoint, 
					nil, 
					1000, 
					ability:GetAbilityTargetTeam(), 
					ability:GetAbilityTargetType(), 
					ability:GetAbilityTargetFlags(), 
					FIND_CLOSEST, 
					false
				)

		local exp = 1000

		for k,v in pairs(targets) do
			if v ~= nil and v:IsNull() == false and v.thtd_istower == true and v:GetOwner() == caster and v:THTD_GetLevel() < THTD_MAX_LEVEL then 
				v:THTD_AddExp(exp)
			end
		end

		local effectIndex = ParticleManager:CreateParticle("particles/thtd_item/ability_item_2022.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end
end

function OnItem2023_SpellStart(keys)
	if SpawnSystem:GetWave() > 51 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster:GetUnitName() == "npc_dota_hero_lina" then
		if target:THTD_IsTower() and target:THTD_GetLevel()<THTD_MAX_LEVEL then
			target:THTD_SetLevel(THTD_MAX_LEVEL)
		end
	end
end