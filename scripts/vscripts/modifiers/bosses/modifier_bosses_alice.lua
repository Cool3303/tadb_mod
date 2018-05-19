modifier_bosses_alice = class({})

local public = modifier_bosses_alice

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:OnCreated(kv)
	if IsServer() then
		local caster = self:GetParent()

	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local caster = self:GetParent()

		for i=1,3 do
			local unit = CreateUnitByName(
				"creature_alice_ningyou", 
				caster:GetOrigin() + RandomVector(300), 
				false, 
				caster, 
				caster, 
				caster:GetTeam() 
			)
			
			FindClearSpaceForUnit(unit, unit:GetOrigin(), false)

			local health = caster:GetMaxHealth()*0.3
			unit:SetBaseMaxHealth(health)
			unit:SetMaxHealth(health)
			unit:SetHealth(unit:GetMaxHealth())
			unit:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue())
			unit:SetBaseMagicalResistanceValue(caster:GetBaseMagicalResistanceValue())

			unit.thtd_player_index = caster.thtd_player_index
			unit.thtd_poison_buff = 0
			
			unit:AddNewModifier(unit, nil, "modifier_phased", {duration=9999})
					
			table.insert(THTD_EntitiesRectInner[caster.thtd_player_index],unit)

			unit.next_move_point = caster.next_move_point 
			unit.next_move_forward = caster.next_move_forward 

			local currentWave = SpawnSystem:GetWave() - 51
			local special = DoUniqueString("thtd_creep_buff")
			local damageDecrease = math.max(-25*(1+(GameRules:GetCustomGameDifficulty()-1)*0.5),-currentWave*4)
			ModifyDamageIncomingPercentage(unit,damageDecrease,special)

			unit:SetContextThink(DoUniqueString("AttackingBase"), 
				function ()
					if unit~=nil and unit:IsNull()==false and unit:IsAlive() and unit.thtd_is_outer ~= true then
						local origin = unit:GetOrigin()
						if not(origin.x < 4432 and origin.x > -4432 and origin.y < 3896 and origin.y > -3896) then
							unit.thtd_is_outer = true
							table.insert(THTD_EntitiesRectOuter,unit)
						end
					end
					unit:MoveToPosition(unit.next_move_point)
					return 0.1
				end, 
			0) 
		end
	end
end