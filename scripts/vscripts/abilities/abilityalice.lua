
function OnAlice01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	caster.thtd_last_cast_point = targetPoint

	local unit = CreateUnitByName(
		"alice_boom", 
		targetPoint, 
		false, 
		caster:GetOwner(), 
		caster:GetOwner(), 
		caster:GetTeam() 
	)
	if (unit == nil) then return end

	unit.thtd_spawn_unit_owner = caster
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true) 
	FindClearSpaceForUnit(unit, targetPoint, false)
	keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_alice_01_rooted", {})	
	keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_alice_boom_tracker", {})
	unit:AddNewModifier(unit, nil, "modifier_invisible", nil)

	local ability = unit:FindAbilityByName("thtd_alice_unit_kill")
	if ability then
		ability:SetLevel(1)
	end	
	local count = 0
	caster:SetContextThink(DoUniqueString("thtd_alice_01"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end			
			if unit==nil or unit:IsNull() or unit:IsAlive()==false then							
				return nil
			end	
			if caster==nil or caster:IsNull() or caster:IsAlive()==false or caster:THTD_IsHidden() or count > 600 then
				unit:AddNoDraw()
				unit:ForceKill(false)				
				return nil
			end	

			local enemies = THTD_FindUnitsInRadius(caster, targetPoint, 150)			
			if #enemies > 0 then
				enemies = THTD_FindUnitsInRadius(caster, targetPoint, 300)
				if ability then
					local damage = caster:THTD_GetPower()*caster:THTD_GetStar()
					for k,v in pairs(enemies) do
						if v~=nil and v:IsNull()==false and v:IsAlive() then
							UnitStunTarget(caster,v,0.8)
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
					unit:CastAbilityNoTarget(ability, caster:GetPlayerOwnerID())
					unit:EmitSound("Hero_Techies.LandMine.Detonate")		
					return nil
				end	
			end	
			count = count + 1
			return 0.2
		end,
	0)	
	

end

function OnAliceUnitKillSpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	caster:SetContextThink(DoUniqueString("thtd_alice_unit"), 
		function()
			caster:AddNoDraw()
			caster:ForceKill(false) 
			return nil
		end,
	0.5)
end

function OnAlice02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	
	local unit = CreateUnitByName(
		"alice_falanxi_ningyou"
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
	Margatroid_CreateLine(caster, unit)
	FindClearSpaceForUnit(unit, unit:GetOrigin(), false)	
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false) 	
	unit:SetHasInventory(false)
	unit.thtd_spawn_unit_owner = caster	

	local oldSwpanUnit = caster.alice_spawn_unit
	if oldSwpanUnit ~=nil and oldSwpanUnit:IsNull() == false then 
		oldSwpanUnit:AddNoDraw()
		oldSwpanUnit:ForceKill(false)
	end	
	caster.alice_spawn_unit = unit

	keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_alice_02", nil)

	local ability = unit:FindAbilityByName("doom_bringer_infernal_blade")
	ability:ToggleAutoCast()
	unit:SetContextThink(DoUniqueString("modifier_alice_02"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if caster==nil or caster:IsNull() or caster:IsAlive()==false or caster:THTD_IsHidden() then
				ParticleManager:DestroyParticleSystem(unit.effect_line, true)				
				unit:AddNoDraw()
				unit:ForceKill(false)
				caster.alice_spawn_unit = nil
				return nil
			end
			
			-- attackValue = caster:GetAverageTrueAttackDamage(caster)
			unit:SetBaseDamageMax(caster:GetBaseDamageMax())
			unit:SetBaseDamageMin(caster:GetBaseDamageMin())

			if ability:GetLevel() ~= math.min(caster:THTD_GetStar(), 4) then 
				ability:SetLevel(math.min(caster:THTD_GetStar(), 4))
			end

			if GetDistanceBetweenTwoVec2D(caster:GetOrigin(), unit:GetOrigin()) > 1000 then
				local forward = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() 
				unit:MoveToPosition(caster:GetOrigin() + forward*1000)
			end
			
			local target = THTDSystem:FindRadiusMagicWeakOneUnit(unit, 600)
			if target~=nil and target:IsNull()==false and target:IsAlive() then	
				unit.thtd_attatck_target = target			
				THTDSystem:ChangeAttackTarget(unit, target)
			end

			return 0.3
		end,
	0)	
end

function OnCreatedAliceNingyouCritChance(keys)	
	local caster = EntIndexToHScript(keys.caster_entindex) -- buff提供者
	local target = keys.target -- buff接受者
	if target==nil then return end
	target:THTD_AddCritChance(keys.CritChance)	
end

function OnDestroyAliceNingyouCritChance(keys)	
	local target = keys.target
	if target==nil then return end
	target:THTD_AddCritChance(-keys.CritChance)		
end

function OnAlice02Ningyou01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex) 
	local target = keys.target

	local seed = RandomInt(1,100)
	if seed <= keys.CritChance then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf",PATTACH_CUSTOMORIGIN,caster)
		ParticleManager:SetParticleControl(particle,0,target:GetOrigin()+Vector(0,0,64))
		ParticleManager:DestroyParticleSystem(particle,false)

		local sourceAttacker = caster.thtd_spawn_unit_owner			
		if sourceAttacker ~= nil and sourceAttacker:THTD_IsTower() then
			local targets = THTD_FindUnitsInRadius(sourceAttacker, target:GetOrigin(), 300)
			local damage = sourceAttacker:THTD_GetStar() * sourceAttacker:THTD_GetPower() * 3			
			local DamageTable = {
					ability = keys.ability,
					victim = target, 
					attacker = sourceAttacker, 
					damage = damage, 
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE,					
			}
			UnitDamageTarget(DamageTable)		
		end
	end

end

function OnAlice02Ningyou02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)  --buff提供者
	local target = keys.target  -- 被攻击目标	
	local sourceAttacker = caster.thtd_spawn_unit_owner			
	if sourceAttacker == nil or sourceAttacker:THTD_IsTower() == false then return end

	local seed = RandomInt(1,100)
	if seed <= keys.CritChance then
		UnitStunTarget(caster, target, keys.StunTime)
		local DamageTable = {
			ability = keys.ability,
			victim = target, 
			attacker = sourceAttacker, 
			damage = sourceAttacker:THTD_GetStar() * sourceAttacker:THTD_GetPower() * 5, 
			damage_type = keys.ability:GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_NONE,					
		}
		UnitDamageTarget(DamageTable)	
	end
end

function OnAlice04SpellStart(keys)
	local caster=keys.caster
	local caster_pos=caster:GetOrigin()
	local direction=(keys.target:GetOrigin()-caster_pos):Normalized()
	local base_pos=caster_pos-direction*keys.Radius

	caster:MoveToTargetToAttack(keys.target)
	
	local dolls_and_pos={} -- [doll,start_pos]

	local start_pos=base_pos
	local doll=Margatroid_CreateDoll(caster,caster_pos+(start_pos-caster_pos):Normalized()*20,direction)
	keys.ability:ApplyDataDrivenModifier(caster, doll, "modifier_alice_04_rooted", {})	
	dolls_and_pos[1]={doll=doll,start_pos=start_pos}

	local rotate_angle=QAngle(0,35,0)
	local start_pos=RotatePosition(caster_pos,rotate_angle,base_pos)
	local doll=Margatroid_CreateDoll(caster,caster_pos+(start_pos-caster_pos):Normalized()*20,direction)
	keys.ability:ApplyDataDrivenModifier(caster, doll, "modifier_alice_04_rooted", {})	
	dolls_and_pos[2]={doll=doll,start_pos=start_pos}	

	local rotate_angle=QAngle(0,-35,0)
	local start_pos=RotatePosition(caster_pos,rotate_angle,base_pos)
	local doll=Margatroid_CreateDoll(caster,caster_pos+(start_pos-caster_pos):Normalized()*20,direction)
	keys.ability:ApplyDataDrivenModifier(caster, doll, "modifier_alice_04_rooted", {})	
	dolls_and_pos[3]={doll=doll,start_pos=start_pos}

	local rotate_angle=QAngle(0,70,0)
	local start_pos=RotatePosition(caster_pos,rotate_angle,base_pos)
	local doll=Margatroid_CreateDoll(caster,caster_pos+(start_pos-caster_pos):Normalized()*20,direction)
	keys.ability:ApplyDataDrivenModifier(caster, doll, "modifier_alice_04_rooted", {})	
	dolls_and_pos[4]={doll=doll,start_pos=start_pos}	

	local rotate_angle=QAngle(0,-70,0)
	local start_pos=RotatePosition(caster_pos,rotate_angle,base_pos)
	local doll=Margatroid_CreateDoll(caster,caster_pos+(start_pos-caster_pos):Normalized()*20,direction)
	keys.ability:ApplyDataDrivenModifier(caster, doll, "modifier_alice_04_rooted", {})	
	dolls_and_pos[5]={doll=doll,start_pos=start_pos}	

	for _,tab in pairs(dolls_and_pos) do
		local OnDollFinshMove=
			function (hDoll)
				local doll_pos=hDoll:GetOrigin()
				local target_dir=direction	
				hDoll:SetForwardVector(target_dir)
				local time = 2.8
				local caster = hDoll.thtd_spawn_unit_owner				

				hDoll:SetContextThink(
					DoUniqueString("margatroid02_action_delay"),
					function ()			
						if caster==nil or caster:IsNull() or caster:IsAlive()==false or caster:THTD_IsHidden() or time <= 0 then			
							ParticleManager:DestroyParticleSystem(hDoll.effect_line ,false)
							hDoll:AddNoDraw()
							hDoll:ForceKill(false)
							return nil
						end

						local effectIndex = ParticleManager:CreateParticle("particles/heroes/alice/ability_alice_02.vpcf", PATTACH_CUSTOMORIGIN, hDoll)
						ParticleManager:SetParticleControl(effectIndex, 0, hDoll:GetAttachmentOrigin(hDoll:ScriptLookupAttachment("attach_attack1"))+Vector(0,0,30))
						ParticleManager:SetParticleControl(effectIndex, 1, hDoll:GetOrigin()+hDoll:GetForwardVector()*keys.Distance)
						ParticleManager:SetParticleControl(effectIndex, 9, hDoll:GetAttachmentOrigin(hDoll:ScriptLookupAttachment("attach_attack1"))+Vector(0,0,30))
						hDoll:EmitSound("Voice_Thdots_Alice.AbilityAlice011")

						local angles=VectorToAngles(target_dir)
						angles.y=-angles.y
						--print("x0="..tostring(target_dir.x).." y0="..tostring(target_dir.y).." z0="..tostring(target_dir.z))
						--print("x1="..tostring(angles.x).." y1="..tostring(angles.y).." z1="..tostring(angles.z))
						local rotate_angle=angles
						local enemies=FindUnitsInRadius(
							caster:GetTeamNumber(),
							doll_pos+target_dir*keys.Distance*0.5,
							nil,
							keys.Distance,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							DOTA_UNIT_TARGET_FLAG_NONE,
							FIND_ANY_ORDER,
							false)
						for __,enemy in pairs(enemies) do
							local after_rotate_pos=RotatePosition(doll_pos,rotate_angle,enemy:GetOrigin())
							if math.abs(after_rotate_pos.y-doll_pos.y)<keys.LaserRadius then
								UnitDamageTarget{
									ability = keys.ability,
									victim = enemy,
									attacker = caster,
									damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 7,
									damage_type = keys.ability:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE
								}
							end
						end

						time = time - 0.4
						return 0.4
					end,
				0)
			end
		if tab.doll then
			Margatroid_MoveDoll(
				tab.doll,
				tab.start_pos,
				keys.Radius*2,			
				OnDollFinshMove,false)
		end
	end
end

function Margatroid_CreateDoll(hCaster, vecPos, vecForward)	
	local doll=CreateUnitByName(			
			"alice_boom",
			vecPos,
			false,
			hCaster,
			hCaster,
			hCaster:GetTeam()
	)
	doll.thtd_spawn_unit_owner = hCaster
	Margatroid_CreateLine(hCaster,doll)
	
	if vecForward then
		local angles = VectorToAngles(vecForward)
		doll:SetAngles(angles.x,angles.y,angles.z)
	end	
	return doll	
end

function Margatroid_MoveDoll(hDoll, vecTarget, fMoveSpeed, fnOnFinshMove,isfly)
	local tick_interval=0.03

	local distance=(hDoll:GetOrigin()-vecTarget):Length()
	local vecMove=(hDoll:GetOrigin()-vecTarget):Normalized()*fMoveSpeed*tick_interval
	local tick=math.floor(distance/(fMoveSpeed*tick_interval))
	local finish_move=false
	hDoll:SetContextThink(
		DoUniqueString("margatroid_move_doll"),
		function ()
			hDoll:SetAbsOrigin(GetGroundPosition(hDoll:GetOrigin()+vecMove,hDoll))
			tick=tick-1
			if tick<=0 then 
				if fnOnFinshMove then fnOnFinshMove(hDoll) end
				return nil 
			end
			return tick_interval
		end,0)
end

function Margatroid_CreateLine(caster,doll)
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/alice/ability_alice_line.vpcf", PATTACH_CUSTOMORIGIN, doll)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "attach_line", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, doll, 5, "attach_hitloc", Vector(0,0,0), true)
	doll.effect_line = effectIndex
end
