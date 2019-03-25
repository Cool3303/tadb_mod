local Seiga01ItemDrop = 
{
	[1] = 
	{
		["item_1011"] = 1,
		["item_1012"] = 0,
		["item_1013"] = 0,
		["item_1014"] = 0,
	},
	[2] = 
	{
		["item_1011"] = 2,
		["item_1012"] = 0,
		["item_1013"] = 0,
		["item_1014"] = 0,
	},
	[3] = 
	{
		["item_1011"] = 2,
		["item_1012"] = 1,
		["item_1013"] = 0,
		["item_1014"] = 0,
	},
	[4] = 
	{
		["item_1011"] = 0,
		["item_1012"] = 2,
		["item_1013"] = 1,
		["item_1014"] = 0,
	},
	[5] = 
	{
		["item_1011"] = 0,
		["item_1012"] = 0,
		["item_1013"] = 2,
		["item_1014"] = 1,
	},
}

function OnSeiga01Death(keys)
	if keys.caster==nil or keys.caster:IsNull() or keys.caster:IsAlive()==false then 
		return 
	end

	local caster = keys.caster
	local target = keys.unit

	if SpawnSystem.IsUnLimited or GameRules:GetCustomGameDifficulty() == 10 then 
		if caster:HasModifier("modifier_miko_02_buff") then
			local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_seiga/ability_seiga_03.vpcf",PATTACH_CUSTOMORIGIN,caster)
			ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			for k,v in pairs(targets) do
				local DamageTable = {
					ability = keys.ability,
			        victim = v, 
			        attacker = caster, 
			        damage = THTD_GetTempleOfGodBuffedTowerStarCount(caster)*caster:THTD_GetPower()*0.1, 
			        damage_type = DAMAGE_TYPE_MAGICAL, 
			        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
		   		UnitDamageTarget(DamageTable)
			end
		end
	else
		if caster.thtd_chance_count == nil then 
			caster.thtd_chance_count = {}
		end
		local hero = caster:GetOwner()
		local count = 0
		for itemName,chance in pairs(Seiga01ItemDrop[caster:THTD_GetStar()]) do
			if chance > 0 then
				if caster.thtd_chance_count[itemName] == nil then 
					caster.thtd_chance_count[itemName] = 0
				end
				local randChance = chance
				if caster.thtd_chance_count[itemName] >= math.floor(100/chance) then 
					randChance = 100
				end
				if RandomInt(1,100) <= randChance then
					caster.thtd_chance_count[itemName] = 0
					local item = CreateItem(itemName, nil, nil)						
					item.owner_player_id = caster:GetPlayerOwnerID()
					item:SetPurchaser(hero)
					item:SetPurchaseTime(1.0)
					local pos = GetSpawnLineOffsetVector(hero.thtd_spawn_id, hero.spawn_position, count * 130, 150)						
					CreateItemOnPositionSync(pos,item)					
				else
					caster.thtd_chance_count[itemName] = caster.thtd_chance_count[itemName] + 1
				end
			end			
			count = count + 1			
		end
	end
end

function OnSeiga02SpellStart(keys)
	local caster = keys.caster
	local target = keys.target

	if target:THTD_IsTower() and target:GetUnitName() ~= "nazrin" then
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_seiga_02_attack_speed_buff", {Duration=10.0})
		caster.thtd_last_cast_unit = target
	end
end

function OnSeiga03Death(keys)
	if keys.caster==nil or keys.caster:IsNull() or keys.caster:IsAlive()==false then 
		return 
	end
	if keys.ability:GetLevel()<1 then return end

	local caster = keys.caster
	local target = keys.unit

	if target.thtd_poison_buff ~= nil and target.thtd_poison_buff > 0 then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_seiga/ability_seiga_03.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)

		local targets = THTD_FindUnitsInRadius(caster,target:GetOrigin(),300)
	
		for k,v in pairs(targets) do
			local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * target.thtd_poison_buff * 0.5

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