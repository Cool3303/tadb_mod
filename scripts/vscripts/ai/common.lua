if THTDSystem == nil then
	THTDSystem = {}
end

function CDOTA_BaseNPC:THTD_AI_Init()
	self:SetContextThink(DoUniqueString("thtd_ai_think"), 
		function()
			if self.thtd_close_ai == true or self:HasModifier("modifier_touhoutd_release_hidden") then
				return 0.5
			end
			local func = self["THTD_"..self:GetUnitName().."_thtd_ai"]
			if func then
				func(self)
			elseif self:IsAttacking() == false then
				self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
			end
			return 0.5
		end, 
	0.5)
end

function CDOTA_BaseNPC:THTD_lily_thtd_ai()
	local ability = self:FindAbilityByName("thtd_lily_01")
	local ability2 = self:FindAbilityByName("thtd_lily_02")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability2:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability2:IsCooldownReady() and ability2:GetLevel() > 0 and self:HasModifier("thtd_lily_02") == false then
		THTDSystem:CastAbility(self,ability2)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_cirno_thtd_ai()
	local ability = self:FindAbilityByName("thtd_cirno_02")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_letty_thtd_ai()
	local ability = self:FindAbilityByName("thtd_letty_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_kogasa_thtd_ai()
	local ability = self:FindAbilityByName("thtd_kogasa_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_lyrica_thtd_ai()
	local ability = self:FindAbilityByName("thtd_lyrica_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_lunasa_thtd_ai()
	local ability = self:FindAbilityByName("thtd_lunasa_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_merlin_thtd_ai()
	local ability = self:FindAbilityByName("thtd_merlin_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_satori_thtd_ai()
	local ability = self:FindAbilityByName("thtd_satori_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_iku_thtd_ai()
	local ability = self:FindAbilityByName("thtd_iku_02")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_marisa_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_marisa_01")
	local ability2 = self:FindAbilityByName("thtd_marisa_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability2:GetLevel() > 0 and ability2:IsCooldownReady() and self:IsChanneling() == false then
		if self:GetMana() >= ability2:GetManaCost(ability2:GetLevel()) then
			THTDSystem:CastAbility(self,ability2)
		end
	elseif unit~=nil and unit:IsNull()==false and ability1:IsCooldownReady() and self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) and self:IsChanneling() == false then
		THTDSystem:CastAbility(self,ability1)
	elseif self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_tenshi_thtd_ai()
	local ability = self:FindAbilityByName("thtd_tenshi_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_patchouli_thtd_ai()
	local ability = self:FindAbilityByName("thtd_patchouli_01")
	local ability4 = self:FindAbilityByName("thtd_patchouli_04")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif unit~=nil and unit:IsNull()==false and ability4:GetLevel()>0 and ability4:IsCooldownReady() and THTDSystem:FindRadiusUnitCount(self,800) > 5 then
		THTDSystem:CastAbility(self,ability4)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function THTDSystem:FindReiSenUnFearedNearestOneUnit(entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	local target = nil
	local mindist = 0
	for i=1,#enemies do
		local unit = enemies[i]
		if unit~=nil and unit:IsNull()==false and unit.thtd_is_feared_by_reisen_01~=true then
			local dist = GetDistanceBetweenTwoVec2D(entity:GetOrigin(), unit:GetOrigin())
			if target==nil or mindist>dist then
				target = unit
				mindist = dist
			end
		end
	end
	return target
end

function CDOTA_BaseNPC:THTD_reisen_thtd_ai()
	local ability = self:FindAbilityByName("thtd_reisen_03")
	local unit = THTDSystem:FindReiSenUnFearedNearestOneUnit(self, self:GetAttackRange()-250)
	local curTarget = self:GetAttackTarget()
	local newTarget = THTDSystem:FindReiSenUnFearedNearestOneUnit(self, self:GetAttackRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) and unit.thtd_is_feared_by_reisen_01~=true then
		THTDSystem:CastAbility(self,ability)
	elseif newTarget~=nil and newTarget:IsNull()==false and newTarget.thtd_is_feared_by_reisen_01~=true then
		if curTarget==nil or curTarget:IsNull()==true or curTarget.thtd_is_feared_by_reisen_01==true then
			self:SetForceAttackTarget(newTarget)
		else
			self:SetForceAttackTarget(nil)
		end
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end	
end

function THTDSystem:FindRadiusWeakUnitCount( entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local weakUnitCount = 0
		for k,v in pairs(enemies) do
			if v:GetHealthPercent() <= 30 then
				weakUnitCount = weakUnitCount + 1
			end
		end
		return weakUnitCount
	else
		return 0
	end
end

function CDOTA_BaseNPC:THTD_yuyuko_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_yuyuko_01")
	local ability2 = self:FindAbilityByName("thtd_yuyuko_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())
	local weekCount1 = THTDSystem:FindRadiusWeakUnitCount(self,ability2:GetCastRange())
	local weekCount2 = THTDSystem:FindRadiusWeakUnitCount(self,ability2:GetCastRange()-200)

	if ability2:GetLevel()>0 and ability2:IsCooldownReady() and self:IsChanneling() == false and 
		(THTDSystem:FindRadiusWeakUnitCount(self,ability2:GetCastRange())>=2 or THTDSystem:FindRadiusWeakUnitCount(self,ability2:GetCastRange()-400)>=1) 
	then
		local unit2 = THTDSystem:FindRadiusWeakOneUnit(self,ability2:GetCastRange())
		THTDSystem:CastAbilityToUnit(self,ability2,unit2)
	elseif unit~=nil and unit:IsNull()==false and ability1:IsCooldownReady() and self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) and self:IsChanneling() == false and
		(THTDSystem:FindRadiusUnitCount(self, ability1:GetCastRange())>2 or THTDSystem:FindRadiusUnitCount(self, ability1:GetCastRange()-300)>0)
	then
		THTDSystem:CastAbility(self,ability1)
	elseif self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_youmu_thtd_ai()
	local ability = self:FindAbilityByName("thtd_youmu_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_rin_thtd_ai()
	local ability = self:FindAbilityByName("thtd_rin_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function THTDSystem:FindNearestOneUnit( entity, maxrange)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local unit = nil
		local mindist = 0
		for k,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false then
				local dist = GetDistanceBetweenTwoVec2D(entity:GetOrigin(), v:GetOrigin())
				if unit==nil or dist<mindist then
					unit = v
					mindist = dist
				end
			end
		end
		return unit
	end
	return nil
end

function THTDSystem:FindUtsuhoPerfectPoint(entity, unit)
	local dangerUnit = THTDSystem:FindRadiusOneUnit(entity, 400)
	if dangerUnit ~= nil and dangerUnit:IsNull() == false then
		local dangerPoint = dangerUnit:GetOrigin() - dangerUnit:GetForwardVector() * 350
		return dangerPoint
	end
	local enemies = THTD_FindUnitsInRadius(entity, unit:GetOrigin(), 500)
	if #enemies > 5 then
		local centerPoint = nil
		local count = 0
		for k,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false then
				if centerPoint == nil then
					centerPoint = v:GetOrigin()
				else
					centerPoint = centerPoint + v:GetOrigin()
				end
				count = count + 1
			end
		end
		centerPoint = 1.0 / count * centerPoint

		local sumEffect = 0
		for k,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false then
				local dist = GetDistanceBetweenTwoVec2D(centerPoint, v:GetOrigin())
				if dist < 400 then
					sumEffect = sumEffect + dist
				end
				if sumEffect >= 888 then
					return centerPoint
				end
			end
		end
	end
	return nil
end

function CDOTA_BaseNPC:THTD_utsuho_thtd_ai()
	local ability = self:FindAbilityByName("thtd_utsuho_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:IsChanneling() == false then
		local point = THTDSystem:FindUtsuhoPerfectPoint(self, unit)
		if point ~= nil then
			THTDSystem:CastAbilityToPoint(self,ability, unit, point)
		end
	elseif self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_reimu_thtd_ai()
	local ability = self:FindAbilityByName("thtd_reimu_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_daiyousei_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_daiyousei_01")
	local ability2 = self:FindAbilityByName("thtd_daiyousei_02")
	local unit = THTDSystem:FindFriendlyRadiusOneUnit(self,ability1:GetCastRange())
	local target = THTDSystem:FindFriendlyHighestStarRadiusOneUnit(self,ability1:GetCastRange())

	if unit~=nil and unit:IsNull()==false and unit:THTD_IsTower() and ability1:IsCooldownReady() and target~=nil then
		self:CastAbilityOnTarget(target,ability1,self:GetPlayerOwnerID())
	elseif unit~=nil and unit:IsNull()==false and unit:THTD_IsTower() and ability2:IsCooldownReady() and self:GetMana() >= ability2:GetManaCost(ability2:GetLevel()) then
		THTDSystem:CastAbilityFriendly(self,ability2)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_remilia_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_remilia_01")
	local ability2 = self:FindAbilityByName("thtd_remilia_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,1500)

	if unit~=nil and unit:IsNull()==false and ability2:GetLevel()>0 and ability2:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability2)
	elseif unit~=nil and unit:IsNull()==false and ability1:IsCooldownReady() and self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) then
		THTDSystem:CastAbility(self,ability1)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_flandre_thtd_ai()
	local ability = self:FindAbilityByName("thtd_flandre_01")
	local ability2 = self:FindAbilityByName("thtd_flandre_04")
	local unit2 = THTDSystem:FindRadiusWeakOneUnit(self,ability2:GetCastRange())

	if ability:GetLevel()>0 and ability:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability)
	elseif unit2~=nil and unit2:IsNull()==false and ability2:GetLevel()>0 and ability2:IsCooldownReady() then
		local damage = self:THTD_GetStar() * self:THTD_GetPower() * 16

		if self:FindAbilityByName("thtd_flandre_03"):GetLevel()>0 then
			damage = damage * (2 - unit2:GetHealth()/unit2:GetMaxHealth())
		end

		if damage > unit2:GetHealth()*3 then
			THTDSystem:CastAbilityToUnit(self,ability2,unit2)
		end
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end	
end

local sakuya_02_black_list =
{
	"thtd_lily_01",
	"thtd_daiyousei_01",
	"thtd_koishi_04",
	"thtd_sakuya_02",
	"thtd_sakuya_03",
	"thtd_yuuka_04",
	"thtd_yukari_03",
	"thtd_yukari_04",
	"thtd_flandre_01",
	"thtd_mokou_03",
	"thtd_eirin_03",
	"thtd_patchouli_04",
	"thtd_hatate_02",
	"thtd_sanae_03",
	"thtd_minamitsu_02",
	"thtd_minamitsu_03",
	"thtd_toramaru_01",
	"thtd_toramaru_02",
	"thtd_toramaru_03",
	"thtd_kanako_04",
	"thtd_sanae_04",
	"thtd_miko_04",
	"thtd_keine_01",
}

function IsInSakuya02BlackList(ability)
	for k,v in pairs(sakuya_02_black_list) do
		if ability:GetAbilityName() == v then
			return true
		end
	end
	return false
end

function THTDSystem:NeedSakuya(target)
	if target:THTD_IsTower() and target:HasModifier("modifier_sakuya_02_buff") == false then
		for i=2,5 do
			local ability = target:GetAbilityByIndex(i)
			if ability~=nil and IsInSakuya02BlackList(ability) == false and 
				( (ability:IsCooldownReady() == false and ability:GetCooldownTimeRemaining() > 1) or (ability:GetManaCost(ability:GetLevel()) > 0 and target:GetManaPercent() < 50)) then
				return true
			end
		end
	end
	return false
end

function CDOTA_BaseNPC:THTD_sakuya_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_sakuya_01")
	local ability2 = self:FindAbilityByName("thtd_sakuya_02")
	local ability3 = self:FindAbilityByName("thtd_sakuya_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())
	local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self,ability2:GetCastRange())

	if target~=nil and target:IsNull()==false and ability2:GetLevel()>0 and target:THTD_IsTower() and ability2:IsCooldownReady() and THTDSystem:NeedSakuya(target)==true then
		self:CastAbilityOnTarget(target,ability2,self:GetPlayerOwnerID())
	elseif unit~=nil and unit:IsNull()==false and ability3:GetLevel()>0 and ability3:IsCooldownReady() and 
		(THTDSystem:FindRadiusUnitCount(self, 800) > 4 or THTDSystem:FindRadiusUnitCount(self, 400) > 0) 
	then
		THTDSystem:CastAbility(self,ability3)
	elseif unit~=nil and unit:IsNull()==false and ability1:IsCooldownReady() and self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) then
		THTDSystem:CastAbility(self,ability1)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_keine_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_keine_01")
	local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self, ability1:GetCastRange())

	if target~=nil and target:IsNull()==false and ability1:GetLevel()>0 and target:THTD_IsTower() and ability1:IsCooldownReady() and THTDSystem:FindRadiusUnitCount(target, target:GetAttackRange())>0 and (target.thtd_keine_01_open==nil or target.thtd_keine_01_open==false) then
		self:CastAbilityOnTarget(target,ability1,self:GetPlayerOwnerID())
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_mugiyousei_thtd_ai()
	local target = self:GetAttackTarget()

	local min_thtd_poison_buff = 0
	if target~=nil then
		min_thtd_poison_buff = target.thtd_poison_buff
	end
	local unit = target

	local enemies = THTD_FindUnitsInRadius(self, self:GetOrigin(), self:GetAttackRange())
	if #enemies > 0 then
		for k,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false and v.thtd_poison_buff < min_thtd_poison_buff then
				unit = v
				min_thtd_poison_buff = v.thtd_poison_buff
			end
		end
	end

	if unit~=nil and unit:IsNull()==false and unit~=target then
		self:SetForceAttackTarget(unit)
	else
		self:SetForceAttackTarget(nil)
	end
	if self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end	
end


function CDOTA_BaseNPC:THTD_koishi_thtd_ai()
	local ability = self:FindAbilityByName("thtd_koishi_03")
	local ability4 = self:FindAbilityByName("thtd_koishi_04")
	local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self,ability:GetCastRange())

	if target~=nil and target:IsNull()==false and ability:GetLevel()>0 and target:THTD_IsTower() and ability:IsCooldownReady() and 
		(target.thtd_koishi_03_bonus==nil or target.thtd_koishi_03_bonus==false) and 
		(THTDSystem:FindRadiusUnitCount(target, target:GetAttackRange())>1 or THTDSystem:FindRadiusUnitCount(target, 400)>0)
	then
		self:CastAbilityOnTarget(target,ability,self:GetPlayerOwnerID())
	elseif ability4:GetLevel()>0 and ability4:IsCooldownReady() and self:GetMana() >= ability4:GetManaCost(ability4:GetLevel()) and 
		(THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange()-200)>4 or THTDSystem:FindRadiusUnitCount(self, 300)>0 )
	then
		THTDSystem:CastAbility(self,ability4)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end


function CDOTA_BaseNPC:THTD_koakuma_thtd_ai()
	local ability = self:FindAbilityByName("thtd_koakuma_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,800)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		self:CastAbilityOnTarget(unit,ability,self:GetPlayerOwnerID())
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_meirin_thtd_ai()

end

function CDOTA_BaseNPC:THTD_yuuka_thtd_ai()
	local ability = self:FindAbilityByName("thtd_yuuka_01")
	local ability2 = self:FindAbilityByName("thtd_yuuka_04")
	local unit = THTDSystem:FindRadiusOneUnit(self,800)

	if unit~=nil and unit:IsNull()==false and ability2:GetLevel() > 0 and ability2:IsCooldownReady() and self:IsChanneling() == false then
		THTDSystem:CastAbility(self,ability2)
	elseif unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) and self:IsChanneling() == false then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
	
end

function THTDSystem:FindFriendlyNazrin(entity, range)
	local friends = THTD_FindFriendlyUnitsInRadius(entity,entity:GetOrigin(), range)
	if #friends > 0 then
		for k,v in pairs(friends) do
			if v:THTD_IsTower() and v:GetUnitName()=="nazrin" then
				return v
			end
		end
	end
	return nil
end

function THTDSystem:FindThirdHealthyUnitOfTargetInRange(entity, range, target)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	local ncnt = 0
	if #enemies > 0 then
		local unhealthy_enemy = nil
		for k,v in pairs(enemies) do
			if v~=nil and v:IsNull()==false and v:IsAlive() then
				if GetDistanceBetweenTwoVec2D(target:GetOrigin(),v:GetOrigin()) > target:GetAttackRange()-200 then
					if v:GetHealthPercent()>70 then
						return v
					elseif unhealthy_enemy == nil then
						unhealthy_enemy = v
					end
				else
					ncnt = ncnt + 1 
					if ncnt > 3 then
						if v:GetHealthPercent()>70 then
							return v
						elseif unhealthy_enemies == nil then
							unhealthy_enemy = v
						end
					end
				end
			end
		end
		return unhealthy_enemy
	end
	return nil
end

function CDOTA_BaseNPC:THTD_yukari_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_yukari_01")
	local ability2 = self:FindAbilityByName("thtd_yukari_02")
	local ability4 = self:FindAbilityByName("thtd_yukari_04")

	local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())
	local target = THTDSystem:FindRadiusLonelyOneUnit(self,ability1:GetCastRange(),2)

	if self.thtd_yukari_01_hidden_table == nil then
		self.thtd_yukari_01_hidden_table = {}
	end
	
	if self.thtd_yukari_01_stock == nil then
		self.thtd_yukari_01_stock = 3
	end

	local nazrinUnit = THTDSystem:FindFriendlyNazrin(self, ability2:GetCastRange())
	
	if nazrinUnit ~=nil and nazrinUnit:IsNull() == false then -- 配合纳兹琳
		target = THTDSystem:FindThirdHealthyUnitOfTargetInRange(self, ability1:GetCastRange(), nazrinUnit)
		if target~=nil and target:IsNull()==false and ability1:GetLevel()>0 and ability1:IsCooldownReady() and 
			self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) and #self.thtd_yukari_01_hidden_table < self.thtd_yukari_01_stock and 
			(target.thtd_yukari_01_hidden_count == nil or target.thtd_yukari_01_hidden_count < 2)
		then
			THTDSystem:CastAbilityToUnit(self,ability1,target)
		elseif target==nil and ability2:GetLevel()>0 and ability2:IsCooldownReady() and #self.thtd_yukari_01_hidden_table > 0 and
			THTDSystem:FindRadiusUnitCount(nazrinUnit, 0.6 * nazrinUnit:GetAttackRange()) == 0 
		then
			THTDSystem:CastAbilityToUnit(self,ability2, nazrinUnit)
		elseif unit~=nil and unit:IsNull()==false and ability4:GetLevel()>0 and ability4:IsCooldownReady() and THTDSystem:FindRadiusUnitCount(self,1000) > 5 then
			THTDSystem:CastAbility(self,ability4)
		elseif self:IsAttacking() == false then
			self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
		end
	else
		if 	target~=nil and target:IsNull()==false and ability1:GetLevel()>0 and ability1:IsCooldownReady() and 
			self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) and #self.thtd_yukari_01_hidden_table < self.thtd_yukari_01_stock and 
			(target.thtd_yukari_01_hidden_count == nil or target.thtd_yukari_01_hidden_count < 2)
		then
			THTDSystem:CastAbilityToUnit( self,ability1,target)
		elseif unit~=nil and unit:IsNull()==false and ability1:GetLevel()>0 and ability1:IsCooldownReady() and 
			self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) and #self.thtd_yukari_01_hidden_table < self.thtd_yukari_01_stock and 
			(unit.thtd_yukari_01_hidden_count == nil or unit.thtd_yukari_01_hidden_count < 2)
		then
			THTDSystem:CastAbilityToUnit( self,ability1,unit)
		elseif unit~=nil and unit:IsNull()==false and ability2:GetLevel()>0 and ability2:IsCooldownReady() and #self.thtd_yukari_01_hidden_table > 0 then
			THTDSystem:CastAbility(self,ability2)
		elseif unit~=nil and unit:IsNull()==false and ability4:GetLevel()>0 and ability4:IsCooldownReady() and THTDSystem:FindRadiusUnitCount(self,1000) > 5 then
			THTDSystem:CastAbility(self,ability4)
		elseif self:IsAttacking() == false then
			self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
		end		
	end
end

function CDOTA_BaseNPC:THTD_ran_thtd_ai()
	local ability = self:FindAbilityByName("thtd_ran_01")
	local ability2 = self:FindAbilityByName("thtd_ran_02")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif unit~=nil and unit:IsNull()==false and ability2:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability2)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_chen_thtd_ai()
	local ability = self:FindAbilityByName("thtd_chen_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) and 
		self.thtd_chen_01_last_origin ~= nil and GetDistanceBetweenTwoVec2D(self.thtd_chen_01_last_origin,self:GetOrigin()) < ability:GetCastRange() 
	then
		self:CastAbilityOnPosition(self.thtd_chen_01_last_origin,ability,self:GetPlayerOwnerID())
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_eirin_thtd_ai()
	local ability = self:FindAbilityByName("thtd_eirin_03")
	local ability2 = self:FindAbilityByName("thtd_eirin_04")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif unit~=nil and unit:IsNull()==false and ability2:GetLevel()>0 and ability2:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) and self.thtd_eirin_03_position~=nil then
		self:CastAbilityOnPosition(self.thtd_eirin_03_position,ability2,self:GetPlayerOwnerID())
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_mokou_thtd_ai()
	local ability = self:FindAbilityByName("thtd_mokou_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and 
		(THTDSystem:FindRadiusUnitCount(self, self:GetAttackRange()) > 2 or THTDSystem:FindRadiusUnitCount(self, 400) > 1)
	then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_kaguya_thtd_ai()
	local ability = self:FindAbilityByName("thtd_kaguya_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_aya_thtd_ai()
	local ability = self:FindAbilityByName("thtd_aya_02")
	local unit = nil
	local entities = THTD_FindUnitsInner(self)
	for k,v in pairs(entities) do
		local forward = (v:GetAbsOrigin() - self:GetAbsOrigin()):Normalized()
		if THTDSystem:FindRadiusUnitCountInLine( self, 300, v:GetOrigin()+forward*700) > 3 then
			unit = v
			break
		end
	end

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() then
		local forward = (unit:GetAbsOrigin() - self:GetAbsOrigin()):Normalized()
		self:CastAbilityOnPosition(unit:GetOrigin()+forward*700,ability,self:GetPlayerOwnerID())
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_hatate_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_hatate_01")
	local ability2 = self:FindAbilityByName("thtd_hatate_02")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability1:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability2:GetLevel()>0 and ability2:IsCooldownReady() and self:IsChanneling() == false then
		THTDSystem:CastAbility(self,ability2)
	elseif unit~=nil and unit:IsNull()==false and ability1:IsCooldownReady() and self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) and self:IsChanneling() == false then
		THTDSystem:CastAbility(self,ability1)
	elseif self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_sanae_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_sanae_01")
	local ability2 = self:FindAbilityByName("thtd_sanae_02")
	local ability3 = self:FindAbilityByName("thtd_sanae_03")
	local ability4 = self:FindAbilityByName("thtd_sanae_04")
	local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self,1000)
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)


	if unit~=nil and unit:IsNull()==false and ability4:GetLevel()>0 and ability4:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability4)
	elseif unit~=nil and unit:IsNull()==false and target~=nil and target:IsNull()==false and ability1:GetLevel()>0 and target:THTD_IsTower() and ability1:IsCooldownReady() and self:GetMana() >= ability1:GetManaCost(ability1:GetLevel()) then
		self:CastAbilityOnTarget(target,ability1,self:GetPlayerOwnerID())
	elseif unit~=nil and unit:IsNull()==false and ability2:GetLevel()>0 and ability2:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability2)
	elseif unit~=nil and unit:IsNull()==false and ability3:GetLevel()>0 and ability3:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability3)
	elseif self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_kanako_thtd_ai()
	local ability = self:FindAbilityByName("thtd_kanako_01")
	local ability4 = self:FindAbilityByName("thtd_kanako_04")
	local unit = THTDSystem:FindRadiusOneUnit(self,ability:GetCastRange())

	if unit~=nil and unit:IsNull()==false and ability4:GetLevel()>0 and ability4:IsCooldownReady() and self:IsChanneling() == false then
		THTDSystem:CastAbility(self,ability4)
	elseif unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and self:IsChanneling() == false then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_momiji_thtd_ai()
	local ability = self:FindAbilityByName("thtd_momiji_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_minamitsu_thtd_ai()
	local ability = self:FindAbilityByName("thtd_minamitsu_02")
	local ability3 = self:FindAbilityByName("thtd_minamitsu_03")
	local ability4 = self:FindAbilityByName("thtd_minamitsu_04")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability)
	elseif unit~=nil and unit:IsNull()==false and ability3:GetLevel()>0 and ability3:IsCooldownReady() and unit:HasModifier("modifier_minamitsu_01_slow_buff") then
		self:CastAbilityOnPosition(unit:GetOrigin(),ability3,self:GetPlayerOwnerID())
	elseif unit~=nil and unit:IsNull()==false and ability4:GetLevel()>0 and unit:HasModifier("modifier_minamitsu_01_slow_buff") and ability4:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability4)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_nue_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_nue_01")
	local ability2 = self:FindAbilityByName("thtd_nue_02")
	local unit = THTDSystem:FindRadiusOneUnit(self,1200)

	if unit~=nil and unit:IsNull()==false and ability2:IsInAbilityPhase() == false and ability1:GetLevel()>0 and ability1:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability1)
	elseif unit~=nil and unit:IsNull()==false and ability2:IsInAbilityPhase() == false and ability2:GetLevel()>0 and ability2:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability2)
	elseif self:IsAttacking() == false and ability2:IsInAbilityPhase() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_toramaru_thtd_ai()
	local ability = self:FindAbilityByName("thtd_toramaru_01")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_suwako_thtd_ai()
	local ability = self:FindAbilityByName("thtd_suwako_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,500)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_soga_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_soga_01")
	local ability2 = self:FindAbilityByName("thtd_soga_02")
	local ability3 = self:FindAbilityByName("thtd_soga_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability3:GetLevel()>0 and ability3:IsCooldownReady() and THTDSystem:FindRadiusUnitCountInPoint(self,1000,unit:GetOrigin()) > 3 then
		self:CastAbilityOnPosition(unit:GetOrigin(),ability3,self:GetPlayerOwnerID())
	elseif unit~=nil and unit:IsNull()==false and ability1:GetLevel()>0 and ability1:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability1)
	elseif unit~=nil and unit:IsNull()==false and ability2:GetLevel()>0 and ability2:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability2)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_futo_thtd_ai()
	local ability = self:FindAbilityByName("thtd_futo_03")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and THTDSystem:FindRadiusUnitCountInPoint(self,800,unit:GetOrigin()) > 3  then
		self:CastAbilityOnPosition(unit:GetOrigin(),ability,self:GetPlayerOwnerID())
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_miko_thtd_ai()
	local ability1 = self:FindAbilityByName("thtd_miko_01")
	local ability2 = self:FindAbilityByName("thtd_miko_04")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability2:GetLevel()>0 and ability2:IsInAbilityPhase() == false and self:IsChanneling() == false and ability2:IsCooldownReady() and THTDSystem:FindRadiusUnitCountInPoint(self,1000,unit:GetOrigin()) > 5 then
		THTDSystem:CastAbility(self,ability2)
	elseif unit~=nil and unit:IsNull()==false and ability1:GetLevel()>0 and ability1:IsInAbilityPhase() == false and self:IsChanneling() == false and ability1:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability1)
	elseif self:IsAttacking() == false and ability1:IsInAbilityPhase() == false and ability2:IsInAbilityPhase() == false and self:IsChanneling() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_yoshika_thtd_ai()
	local ability = self:FindAbilityByName("thtd_yoshika_02")
	local unit = THTDSystem:FindRadiusOneUnit(self,1000)

	if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() then
		THTDSystem:CastAbility(self,ability)
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function CDOTA_BaseNPC:THTD_seiga_thtd_ai()
	local ability2 = self:FindAbilityByName("thtd_seiga_02")
	local target = THTDSystem:FindFriendlyRadiusOneUnitLast(self,ability2:GetCastRange())

	if target~=nil and target:IsNull()==false and ability2:GetLevel()>0 and target:THTD_IsTower() and ability2:IsCooldownReady() and THTDSystem:FindRadiusUnitCount(target, target:GetAttackRange())>0 then
		self:CastAbilityOnTarget(target,ability2,self:GetPlayerOwnerID())
	elseif self:IsAttacking() == false then
		self:MoveToPositionAggressive(self:GetOrigin() + Vector(0,-100,0))
	end
end

function THTDSystem:CastAbility( unit,ability)
	if ability:IsUnitTarget() then
		local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
		if target then
			unit:CastAbilityOnTarget(target,ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsPoint() or ability:GetBehavior() == 24 then
		local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
	    if target then
			unit:CastAbilityOnPosition(target:GetOrigin(),ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsNoTarget() then
		ability:CastAbility()
	end
end

function THTDSystem:CastAbilityFriendly( unit,ability)
	if ability:IsUnitTarget() then
		local teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindFriendlyRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
		if target then
			unit:CastAbilityOnTarget(target,ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsPoint() or ability:GetBehavior() == 24 then
		local teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	    local types =  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local flags = 0
	    local target = THTDSystem:FindFriendlyRadiusOneUnit( unit,ability:GetCastRange(),teams,types,flags)
	    if target then
			unit:CastAbilityOnPosition(target:GetOrigin(),ability,target:GetPlayerOwnerID())
		end
	elseif ability:IsNoTarget() then
		ability:CastAbility()
	end
end

function THTDSystem:CastAbilityToUnit( unit,ability,target)
	if ability:IsUnitTarget() then
		unit:CastAbilityOnTarget(target,ability,target:GetPlayerOwnerID())
	elseif ability:IsPoint() or ability:GetBehavior() == 24 then
		unit:CastAbilityOnPosition(target:GetOrigin(),ability,target:GetPlayerOwnerID())
	end
end

function THTDSystem:CastAbilityToPoint( unit,ability,target,point)
	if ability:IsPoint() or ability:GetBehavior() == 24 then
		unit:CastAbilityOnPosition(point,ability, target:GetPlayerOwnerID())
	end
end

function THTDSystem:FindRadiusOneUnit( entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		return enemies[index]
	else
		return nil
	end
end

function THTDSystem:FindRadiusUnitCount( entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		return #enemies
	else
		return 0
	end
end

function THTDSystem:FindRadiusUnitCountInPoint( entity, range, point)
	local enemies = THTD_FindUnitsInRadius(entity, point, range)
	if #enemies > 0 then
		return #enemies
	else
		return 0
	end
end

function THTDSystem:FindRadiusUnitCountInLine( entity, width, point)
	local enemies = FindUnitsInLine(entity:GetTeamNumber(),entity:GetOrigin(),point, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
	if #enemies > 0 then
		return #enemies
	else
		return 0
	end
end

function THTDSystem:FindFriendlyRadiusOneUnitLast( entity, range)
	if entity.thtd_last_cast_unit ~= nil and entity.thtd_last_cast_unit:IsNull() == false and entity.thtd_last_cast_unit:IsAlive() and GetDistanceBetweenTwoVec2D(entity:GetOrigin(),entity.thtd_last_cast_unit:GetOrigin()) <= range then
		return entity.thtd_last_cast_unit
	end
	local friends = THTD_FindFriendlyUnitsInRadius(entity,entity:GetOrigin(),range)
	if #friends > 0 then
		local index = RandomInt( 1, #friends )
		return friends[index]
	else
		return nil
	end
end

function THTDSystem:FindRadiusWeakOneUnit( entity, range)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local weakUnit = nil
		for k,v in pairs(enemies) do
			if v:GetHealth() > 0 then
				if weakUnit == nil then
					weakUnit = v
				end
				if v~=nil and v:IsNull()==false and v:IsAlive() and weakUnit~=nil and weakUnit:IsNull()==false and weakUnit:IsAlive() then
					if v:GetHealth() < weakUnit:GetHealth() then
						weakUnit = v
					end
				end
			end
		end
		return weakUnit
	else
		return nil
	end
end

function THTDSystem:FindRadiusLonelyOneUnit( entity, range , lonelyCount)
	local enemies = THTD_FindUnitsInRadius(entity, entity:GetOrigin(), range)
	if #enemies > 0 then
		local lonelyUnit = nil
		for k,v in pairs(enemies) do
			local units = THTD_FindFriendlyUnitsInRadius(entity,v:GetOrigin(),range)
			if #units <= lonelyCount then
				lonelyUnit = v
				break
			end
		end
		return lonelyUnit
	else
		return nil
	end
end

function THTDSystem:FindFriendlyRadiusOneUnit( entity, range)
	local friends = THTD_FindFriendlyUnitsInRadius(entity,entity:GetOrigin(),range)
	if #friends > 0 then
		local index = RandomInt( 1, #friends )
		return friends[index]
	else
		return nil
	end
end
function THTDSystem:FindFriendlyHighestStarRadiusOneUnit( entity, range)
	local friends = THTD_FindFriendlyUnitsInRadius(entity,entity:GetOrigin(),range)
	if #friends > 0 then
		local highestUnit = nil
		for k,v in pairs(friends) do
			if v:THTD_IsTower()	and v~=entity and v:THTD_GetLevel()<10 then
				if highestUnit == nil then
					highestUnit = v
				end
				if v:THTD_GetStar() > highestUnit:THTD_GetStar() then
					highestUnit = v
				end
			end
		end
		return highestUnit
	else
		return nil
	end
end