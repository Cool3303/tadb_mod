function OnReimu01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if keys.ability:GetLevel() < 1 then return end

	if caster.thtd_reimu_01_attack_count == nil then
		caster.thtd_reimu_01_attack_count = 0
	end

	caster.thtd_reimu_01_attack_count = caster.thtd_reimu_01_attack_count + 1

	if caster.thtd_reimu_01_max_count == nil then
		caster.thtd_reimu_01_max_count = 6
	end

	if caster.thtd_reimu_01_attack_count >= caster.thtd_reimu_01_max_count then
		caster.thtd_reimu_01_attack_count = 0

		caster:EmitSound("Sound_THTD.thtd_reimu_01")

		local count = 1
		caster:SetContextThink(DoUniqueString("ability_reimu_01_projectile"), 
		function () 
			if GameRules:IsGamePaused() then return 0.03 end
			if count <= 3 then
				Reimu01Projectile(keys,count)
				count = count + 1
			else
				return nil
			end
			return 0.2
		end, 
		0.2)
	end
end

function OnReimu01ProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage * Reimu02GetChance(caster), 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end

function Reimu01Projectile(keys,count)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),target:GetOrigin())

	local forward = Vector(math.cos(rad),math.sin(rad),caster:GetForwardVector().z)

	local info = 
	{
			Ability = keys.ability,
        	EffectName = "particles/heroes/thtd_reimu/ability_reimu_01_projectile.vpcf",
        	vSpawnOrigin = caster:GetOrigin() + Vector(0,0,128),
        	fDistance = 1000,
        	fStartRadius = 150,
        	fEndRadius = 150,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = forward * 1500,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	ParticleManager:DestroyLinearProjectileSystem(projectile,false)

	for i=1,count do
		local iVec = Vector( math.cos(rad + math.pi/18*(i+0.5)) * 2000 , math.sin(rad + math.pi/18*(i+0.5)) * 2000 , caster:GetForwardVector().z )
		info.vVelocity = iVec
		projectile = ProjectileManager:CreateLinearProjectile(info)
		ParticleManager:DestroyLinearProjectileSystem(projectile,false)
		iVec = Vector( math.cos(rad - math.pi/18*(i+0.5)) * 2000 , math.sin(rad - math.pi/18*(i+0.5)) * 2000 , caster:GetForwardVector().z )
		info.vVelocity = iVec
		projectile = ProjectileManager:CreateLinearProjectile(info)
		ParticleManager:DestroyLinearProjectileSystem(projectile,false)
	end
end

function Reimu02GetChance(caster)
	if caster.thtd_reimu_04_ball_count == nil then
		caster.thtd_reimu_04_ball_count = 0
	end
	if caster.thtd_reimu_04_hot_duration == nil then
		caster.thtd_reimu_04_hot_duration = 0
	end
	if caster.thtd_ability_reimu_02_chance == nil then
		caster.thtd_ability_reimu_02_chance = 20
	end
	if caster:FindAbilityByName("thtd_reimu_02") ~= nil then
		if RandomInt(0, 100) < caster.thtd_ability_reimu_02_chance then
			if caster.thtd_reimu_04_ball_count < 7 then
				caster:EmitSound("Sound_THTD.thtd_reimu_02")
				caster.thtd_reimu_04_ball_count = caster.thtd_reimu_04_ball_count + 1
				caster.thtd_reimu_04_hot_duration = 20.0
			end
			return 2.0
		end
	end
	return 1.0
end

function OnReimu03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	caster:EmitSound("Sound_THTD.thtd_reimu_03_01")

	Reimu03ThrowBallToPoint(keys,caster:GetOrigin(),targetPoint,120,1)
end

function Reimu03ThrowBallToPoint(keys,origin,targetpoint,vhigh,count)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local curOrigin = Vector(origin.x,origin.y,origin.z)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/reimu/reimu_01_ball.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, curOrigin)
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(1/count,0,0))
	ParticleManager:SetParticleControl(effectIndex, 2, Vector(500/count,0,0))

	local g = -10
	local dis = GetDistanceBetweenTwoVec2D(origin,targetpoint)
	local vh = vhigh
	local t = math.abs(2*vh/g)
	local speed = dis/t
	local rad = GetRadBetweenTwoVec2D(origin,targetpoint)

	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5


	caster:SetContextThink(DoUniqueString("ability_reimu_03"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			vh = vh + g
			curOrigin = Vector(curOrigin.x + math.cos(rad) * speed,curOrigin.y + math.sin(rad) * speed,curOrigin.z + vh)
			ParticleManager:SetParticleControl(effectIndex, 0, curOrigin)
			if curOrigin.z >= caster:GetOrigin().z - 50 then
				return 0.02
			else
				curOrigin.z = caster:GetOrigin().z
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/reimu/reimu_01_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex2, 0, curOrigin)
				ParticleManager:SetParticleControl(effectIndex2, 1, Vector(500/count,0,0))
				ParticleManager:DestroyParticleSystem(effectIndex2,false)

				local targets = THTD_FindUnitsInRadius(caster,curOrigin,500/count)
				for k,v in pairs(targets) do
					local DamageTable = {
			   			ability = keys.ability,
			            victim = v, 
			            attacker = caster, 
			            damage = damage/count * Reimu02GetChance(caster), 
			            damage_type = keys.ability:GetAbilityDamageType(), 
			            damage_flags = DOTA_DAMAGE_FLAG_NONE
				   	}
				   	UnitDamageTarget(DamageTable)
	   				UnitStunTarget(caster,v,0.5/count)
				end

				if count <= 3 then
					count = count + 1
					for i=1,count do
						Reimu03ThrowBallToPoint(keys,curOrigin,curOrigin+RandomVector(300-count*30),vhigh*400/442,count)
					end
				end
				caster:EmitSound("Sound_THTD.thtd_reimu_03_02")
				return nil
			end
		end, 
	0)
end

function OnReimu04SpellThink(keys)
	if GameRules:IsGamePaused() then return end
	if keys.ability:GetLevel() < 1 then return end

	local caster = EntIndexToHScript(keys.caster_entindex)

	-- 初始化
	if caster.thtd_reimu_04_ball_count == nil then
		caster.thtd_reimu_04_ball_count = 0
	end

	if caster.thtd_reimu_04_think_count == nil then
		caster.thtd_reimu_04_think_count = 0
	end

	if caster.thtd_reimu_04_think_count < 72 then
		caster.thtd_reimu_04_think_count = caster.thtd_reimu_04_think_count + 1
	else
		caster.thtd_reimu_04_think_count = 0
	end

	if caster.thtd_reimu_04_ball_table == nil then
		caster.thtd_reimu_04_ball_table = {}
	end

	if caster.thtd_reimu_04_damage_increase == nil then
		caster.thtd_reimu_04_damage_increase = 1.0
	end
	
	for i=1,7 do
		if caster.thtd_reimu_04_ball_table[i] == nil then
			caster.thtd_reimu_04_ball_table[i] = {}
		end
		caster.thtd_reimu_04_ball_table[i]["origin"] = 
			caster:GetOrigin() + 
			Vector(
				math.cos(i*2*math.pi/7 + caster.thtd_reimu_04_think_count * math.pi/36)*75,
				math.sin(i*2*math.pi/7 + caster.thtd_reimu_04_think_count * math.pi/36)*75,
				128)
	end

	-- 根据积累数量初始化光球
	if caster.thtd_reimu_04_ball_count > 0 then
		for i=1,caster.thtd_reimu_04_ball_count do
			if caster.thtd_reimu_04_ball_table[i]["effectIndex"] == nil then
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_reimu/ability_reimu_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 1, Vector(1/12,0,0))
				ParticleManager:SetParticleControl(effectIndex, 2, Vector(500/12,0,0))
				caster.thtd_reimu_04_ball_table[i]["effectIndex"] = effectIndex
			end
		end
	end

	-- 旋转光球
	for i=1,7 do
		if caster.thtd_reimu_04_ball_table[i]["effectIndex"] ~= nil then
			ParticleManager:SetParticleControl(caster.thtd_reimu_04_ball_table[i]["effectIndex"], 0, caster.thtd_reimu_04_ball_table[i]["origin"] )
		end
	end

	-- 光球攻击行为
	if caster.thtd_reimu_04_ball_count == 7 and caster.thtd_reimu_04_think_count%8 == 0 then
		Reimu04AttackTargetPoint(keys)
		for i=1,7 do
			if caster.thtd_reimu_04_ball_table[i]["effectIndex"] ~= nil then
				ParticleManager:SetParticleControl(caster.thtd_reimu_04_ball_table[i]["effectIndex"], 3, Vector(1000/12,0,0))
			end
		end
	end

	-- 保持热度时间，结束光球
	if caster.thtd_reimu_04_hot_duration == nil then
		caster.thtd_reimu_04_hot_duration = 0
	end

	caster.thtd_reimu_04_hot_duration = caster.thtd_reimu_04_hot_duration - 0.02

	if caster.thtd_reimu_04_hot_duration < 0 then
		Reimu04ReleaseBall(keys)
	end
end

function Reimu04ReleaseBall(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	if caster.thtd_reimu_04_ball_table ~= nil then
		caster.thtd_reimu_04_hot_duration = 0
		caster.thtd_reimu_04_ball_count = 0
		for i=1,7 do
			if caster.thtd_reimu_04_ball_table[i]["effectIndex"] ~= nil then
				ParticleManager:DestroyParticleSystem(caster.thtd_reimu_04_ball_table[i]["effectIndex"],true)
				caster.thtd_reimu_04_ball_table[i]["effectIndex"] = nil
			end
		end
	end
end

function Reimu04AttackTargetPoint(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)
	if targets[1]==nil then return end

	caster:EmitSound("Sound_THTD.thtd_reimu_04_01")

	local target = targets[1]
	local vecCaster = caster.thtd_reimu_04_ball_table[RandomInt(1,7)]["origin"]
	local pointRad = GetRadBetweenTwoVec2D(vecCaster,target:GetOrigin())

	local randomPi = RandomFloat(-2*math.pi,2*math.pi)
	local forwardVec = Vector(math.cos(pointRad+randomPi), math.sin(pointRad+randomPi),RandomFloat(0,1))

	local BulletTable = {
	    Ability        	 	=   keys.ability,
		EffectName			=	"particles/heroes/thtd_reimu/ability_reimu_04_projectile.vpcf",
		vSpawnOrigin		=	vecCaster,
		vSpawnOriginNew		=	vecCaster,
		fDistance			=	5000,
		fStartRadius		=	60,
		fEndRadius			=	60,
		Source         	 	=   caster,
		bHasFrontalCone		=	false,
		bRepalceExisting 	=  	false,
		iUnitTargetTeams	=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
		iUnitTargetTypes	=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
		iUnitTargetFlags	=	"DOTA_UNIT_TARGET_FLAG_NONE",
		fExpireTime     	=   GameRules:GetGameTime() + 10.0,
		bDeleteOnHit    	=   true,
		vVelocity       	=   forwardVec,
		bProvidesVision		=	true,
		iVisionRadius		=	400,
		iVisionTeamNumber 	= 	caster:GetTeamNumber(),
	}

	local speed = 2000
	local acc = 200
	local iVelo = 1000

	ShushanCreateProjectileMoveToTarget(BulletTable,caster,target,speed,iVelo,-acc,
		function(unit,vec)
			local targetpoint = Vector(vec.x,vec.y,caster:GetOrigin().z)
			local targets = THTD_FindUnitsInRadius(caster,targetpoint,300)
			for k,v in pairs(targets) do
				local damage_table = {
					victim = v,
					attacker = caster,
					damage = caster:THTD_GetPower()*caster:THTD_GetStar()/5*Reimu02GetChance(caster)*caster.thtd_reimu_04_damage_increase,
					ability = keys.ability,
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
				}
				UnitDamageTarget(damage_table)
			end

			caster:EmitSound("Sound_THTD.thtd_reimu_04_02")
			
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_reimu/ability_reimu_04_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetpoint)
			ParticleManager:SetParticleControl(effectIndex, 3, targetpoint)
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	)
end