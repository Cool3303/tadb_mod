local thtd_nazrin_star_bouns =
{
	[1] = 0.02,
	[2] = 0.02,
	[3] = 0.02,
	[4] = 0.02,
	[5] = 0.02,
}

local thtd_nazrin_star_bouns_constant =
{
	[1] = 2.4,
	[2] = 8.8,
	[3] = 21.6,
	[4] = 43.2,
	[5] = 170.4,
}


function OnNazrin01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if SpawnSystem:GetWave() > 51 then 
		if caster:HasModifier("modifier_byakuren_03_buff") then
			local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),400)

			for k,v in pairs(targets) do
				local DamageTable = {
					ability = keys.ability,
			        victim = v, 
			        attacker = caster, 
			        damage = PlayerResource:GetGold(caster:GetPlayerOwnerID())*caster:THTD_GetStar()*0.08, 
			        damage_type = DAMAGE_TYPE_PHYSICAL, 
			        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
		   		UnitDamageTarget(DamageTable)
			end
		end
		return 
	end

	local seed = RandomInt(1,100)
	if seed >= 50 then
		local gold = math.floor(caster:THTD_GetPower() * thtd_nazrin_star_bouns[caster:THTD_GetStar()]) + thtd_nazrin_star_bouns_constant[caster:THTD_GetStar()]

		PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold , true, DOTA_ModifyGold_CreepKill)
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, target, gold, caster:GetPlayerOwner() )
		caster:EmitSound("Sound_THTD.thtd_nazrin_01")
	end
end

function OnNazrin02ConsumeTower(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local location = target:GetOrigin()
	local count = 0
	
	if target:THTD_IsTower() and target:GetOwner() == caster:GetOwner() then
		local gain = (target:THTD_GetStar() - 1) - ( caster:THTD_GetStar() - (target:THTD_GetStar()) -1 )
		if gain == 0 then
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="nazrin_no_gain", duration=5, params={count=1}, color="#0ff"} )
			return
		end
		
		for i=1, gain do
			local itemName = "item_100" .. (target:THTD_GetStar() + 1)
			local item = CreateItem(itemName, nil, nil)

			local index = item:GetEntityIndex()
			if caster.hero~=nil and caster.hero:IsNull()==false then
				caster.hero.thtd_hero_star_list[tostring(index)] = count + 1
				caster.hero.thtd_hero_level_list[tostring(index)] = 10
			end

			CreateItemOnPositionSync(location + Vector(count*100,0,0),item)
		end
		
		for i=0,8 do
			local targetItem = target:GetItemInSlot(i)
			if targetItem~=nil and targetItem:IsNull()==false then
				target:DropItemAtPositionImmediate(targetItem, target:GetOrigin())
			end
		end

		for i=0,8 do
			local targetItem = target:GetItemInSlot(i)
			if targetItem~=nil and targetItem:IsNull()==false then
				target:DropItemAtPositionImmediate(targetItem, target:GetOrigin())
			end
		end

		target:AddNewModifier(caster, nil, "modifier_touhoutd_release_hidden", {})
		target:SetOrigin(Vector(0,0,0))
		target:AddNoDraw()
		target:THTD_DestroyLevelEffect()
		target:RemoveModifierByName("modifier_touhoutd_no_health_bar")
		target.thtd_tower_damage = 0

		local item = EntIndexToHScript(target.thtd_item)
		caster:AddItem(item)

		if target:THTD_GetStar() > 1 then
			item.thtd_item_owner = caster
		end

		for k,v in pairs(caster.thtd_hero_tower_list) do
			if v == target then
				table.remove(caster.thtd_hero_tower_list,k)
			end
		end

		-- 组合刷新
		local combo = target:THTD_GetCombo()
		local func = target["THTD_"..target:GetUnitName().."_thtd_combo"]
		if func then
			func(target,combo)
		end
	end
end