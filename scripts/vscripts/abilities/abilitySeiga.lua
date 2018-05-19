local SeigaSpawnOrigin = 
{
	[1] = Vector(-3424,2816,140),
	[2] = Vector(3424,2816,140),
	[3] = Vector(3424,-2816,140),
	[4] = Vector(-3424,-2816,140),
}

local Seiga01ItemDrop = 
{
	[1] = 
	{
		["item_1011"] = 2,
		["item_1012"] = 0,
		["item_1013"] = 0,
		["item_1014"] = 0,
	},
	[2] = 
	{
		["item_1011"] = 4,
		["item_1012"] = 0,
		["item_1013"] = 0,
		["item_1014"] = 0,
	},
	[3] = 
	{
		["item_1011"] = 4,
		["item_1012"] = 2,
		["item_1013"] = 0,
		["item_1014"] = 0,
	},
	[4] = 
	{
		["item_1011"] = 4,
		["item_1012"] = 2,
		["item_1013"] = 1,
		["item_1014"] = 0,
	},
	[5] = 
	{
		["item_1011"] = 8,
		["item_1012"] = 4,
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

	if SpawnSystem:GetWave() > 51 then 
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
			        damage = THTD_GetAllTempleOfGodTowerStarCount(caster)*caster:THTD_GetPower()*0.1, 
			        damage_type = DAMAGE_TYPE_MAGICAL, 
			        damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
		   		UnitDamageTarget(DamageTable)
			end
		end
	else
		local count = 0

		for itemName,chance in pairs(Seiga01ItemDrop[caster:THTD_GetStar()]) do
			if chance > 0 and RandomInt(0,200) < chance then
				local item = CreateItem(itemName, nil, nil)

				local index = item:GetEntityIndex()
				if caster.hero~=nil and caster.hero:IsNull()==false then
					caster.hero.thtd_hero_star_list[tostring(index)] = count + 1
					caster.hero.thtd_hero_level_list[tostring(index)] = 10
				end

				CreateItemOnPositionSync(SeigaSpawnOrigin[caster:GetPlayerOwnerID()+1] + Vector(count*100,0,0),item)
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
			local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * target.thtd_poison_buff

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