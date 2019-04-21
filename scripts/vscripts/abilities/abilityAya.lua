function OnAya01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	OnAya01Attack(keys,caster,target)	
end

function OnAya01Attack(keys,caster,target)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_aya/ability_aya_01.vpcf",PATTACH_CUSTOMORIGIN,caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+caster:GetForwardVector()*60)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	if target:HasModifier("modifier_aya01_news_buff") == false then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_aya/ability_aya_01_news.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
		caster:FindAbilityByName("thtd_aya_01"):ApplyDataDrivenModifier(caster,target,"modifier_aya01_news_buff", nil)
	end

	local targets = THTD_FindUnitsInRadius(caster, target:GetOrigin(), 300)
	local index = caster:GetEntityIndex()
	for _,v in pairs(targets) do
		if v.thtd_aya_damage == nil then v.thtd_aya_damage = {} end
		if v.thtd_aya_damage[index] == nil then v.thtd_aya_damage[index] = 0 end
		v.thtd_aya_damage[index] = v.thtd_aya_damage[index] + math.floor(caster:THTD_GetPower() * caster:THTD_GetStar())
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

	if caster.enable_damage_calc ~= true then 
		caster.enable_damage_calc = true
		local index = caster:GetEntityIndex()
		caster:SetContextThink(DoUniqueString("ability_aya_damage_calc"), 
			function () 
				if GameRules:IsGamePaused() then return 0.1 end				
				if caster == nil or caster:IsNull() or caster:IsAlive()==false then return nil end				
				if caster:THTD_IsHidden() then 
					caster.enable_damage_calc = false
					return nil
				end
				if caster:IsAttacking() == false then return 0.1 end

				local entities = THTD_FindUnitsAll(caster)
				for k,v in pairs(entities) do
					if v~=nil and v:IsNull()==false and v:IsAlive() and v.thtd_aya_damage ~= nil and v.thtd_aya_damage[index] ~= nil and v.thtd_aya_damage[index] > 0 then 
						local damageType = keys.ability:GetAbilityDamageType()
						local damage = v.thtd_aya_damage[index]
						v.thtd_aya_damage[index] = 0
						if v.thtd_is_outer == true then damageType = DAMAGE_TYPE_PURE end													
						local damage_table = {
							ability = keys.ability,
							victim = v,
							attacker = caster,
							damage = damage,
							damage_type = damageType, 
							damage_flags = DOTA_DAMAGE_FLAG_NONE
						}
						UnitDamageTarget(damage_table)
					end
				end				
				return 0.5
			end, 
		0)
	end

	local entities = THTD_FindUnitsAll(caster)
	for k,v in pairs(entities) do
		if v:HasModifier("modifier_hatate01_news_buff") or v:HasModifier("modifier_aya01_news_buff") then
			OnAyaAttack(keys,v,false)
		end
	end	
end

function OnAyaAttack(keys,target,isFirst)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local index = caster:GetEntityIndex()
	if target.thtd_aya_damage == nil then target.thtd_aya_damage = {} end
	if target.thtd_aya_damage[index] == nil then target.thtd_aya_damage[index] = 0 end
	target.thtd_aya_damage[index] = target.thtd_aya_damage[index] + math.floor(caster:GetAverageTrueAttackDamage(caster))
	
	if isFirst and RandomInt(1,100) <= 15 then
		OnAya01Attack(keys,caster,target)
	end

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
			if not target:HasModifier("modifier_item_2011_stun_lock") then
					target:AddNewModifier(target, nil, "modifier_item_2011_stun_lock", {Duration=2.0})
	   			UnitStunTarget(caster,target,1.0)			
	   	end
		end
	end
end

function OnAya02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	caster:SetForwardVector(Vector(math.cos(rad),math.sin(rad),0))

   	keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_aya_02_pause", nil)

	local count = 0
	local index = caster:GetEntityIndex()
	caster:SetContextThink(DoUniqueString("ability_aya_02_move"), 
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), targetPoint)>=90 and GetDistanceBetweenTwoVec2D(caster:GetOrigin(), targetPoint)<keys.ability:GetCastRange() 
			and caster:HasModifier("modifier_touhoutd_release_hidden") == false then
				local vOrgin = caster:GetOrigin()
				local vCurrent = vOrgin + Vector(math.cos(rad),math.sin(rad),0)*90
				caster:SetAbsOrigin(vCurrent)				
				if count%5 == 0 then				
					local targets = 
						FindUnitsInLine(
							caster:GetTeamNumber(), 
							vCurrent, 
							vCurrent + (vCurrent - vOrgin):Normalized() * 450, -- 5次移动距离
							nil, 
							200,
							keys.ability:GetAbilityTargetTeam(), 
							keys.ability:GetAbilityTargetType(), 
							keys.ability:GetAbilityTargetFlags()
						)					
					for _,v in pairs(targets) do					
						if v.thtd_aya_damage == nil then v.thtd_aya_damage = {} end
						if v.thtd_aya_damage[index] == nil then v.thtd_aya_damage[index] = 0 end
						v.thtd_aya_damage[index] = v.thtd_aya_damage[index] + math.floor(caster:THTD_GetPower() * caster:THTD_GetStar())						
						if caster:FindAbilityByName("thtd_aya_03"):GetLevel()>0 then
							OnAyaAttack(keys,v,true)
						end
					end
					local entities = THTD_FindUnitsAll(caster)
					for k,v in pairs(entities) do
						if v:HasModifier("modifier_hatate01_news_buff") or v:HasModifier("modifier_aya01_news_buff") then
							OnAyaAttack(keys,v,false)
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

function OnAya03WingsSpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if keys.ability:GetLevel() < 1 then 
		if caster.thtd_aya_03_wings~=nil and caster.thtd_aya_03_wings:IsNull()==false then
			caster.thtd_aya_03_wings:RemoveSelf()
			caster.thtd_aya_03_wings = nil
		end
		return 
	end

	if caster.thtd_aya_03_wings == nil then
		caster.thtd_aya_03_wings = CreateUnitByName(
				"npc_unit_aya_03_wings", 
				caster:GetOrigin(), 
				false, 
				caster, 
				caster, 
				caster:GetTeam() 
			)
		caster.thtd_aya_03_wings:FollowEntity( caster, true )
	end
end

