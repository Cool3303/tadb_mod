function OnRumia01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage = caster:THTD_GetPower()

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end

function OnRumia01Kill(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	if caster.rumia_01_bonus == nil then
		caster.rumia_01_bonus = 0
	end
	
	if caster.rumia_01_bonus < keys.max_bonus then
		caster.rumia_01_bonus = caster.rumia_01_bonus + 1
		caster:THTD_AddPower(1)
	end
end

function OnRumia02AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if keys.ability:GetLevel() < 1 then return end

	if caster.rumia_02_attack_count == nil then
		caster.rumia_02_attack_count = 0
	end

	caster.rumia_02_attack_count = caster.rumia_02_attack_count + 1
	
	if caster.rumia_02_attack_count >= keys.max_count then
		RumiaProjectileStart(keys)
		caster.rumia_02_attack_count = 0
	end
end

function OnRumia03AttackLanded(keys)
	if keys.ability:GetLevel()<1 then return end
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local chance = RandomInt(0,100)

	if target:GetHealth() > target:GetMaxHealth()*0.7 and chance <= 10 then

		local targetPoint = target:GetOrigin()
		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_rumia_03_pause",{})
		local pointRad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
		local randomPi = -2*math.pi

		if RandomInt(0,1) == 0 then
			randomPi = -2*math.pi
		else
			randomPi = 2*math.pi
		end

		local forwardVec = Vector(math.cos(pointRad+randomPi), math.sin(pointRad+randomPi),RandomFloat(0,1))
		local projectileTable = {
		    Ability        	 	=   keys.ability,
			EffectName			=	"particles/heroes/thtd_rumia/ability_rumia_03.vpcf",
			vSpawnOrigin		=	caster:GetOrigin(),
			vSpawnOriginNew		=	caster:GetOrigin(),
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

		local speed = 4000
		local acceleration = -400
		local iVelocity = 1000
		local ishit = false

	    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil) 
	    ParticleManager:SetParticleControlForward(effectIndex,3,(projectileTable.vVelocity*iVelocity/50 + speed/50 * (targetPoint - caster:GetOrigin()):Normalized()):Normalized())

	    local ability = projectileTable.Ability
	    local targets = {}
	    local targets_remove = {}
	    local totalDistance = 0
	    local time = 0
	    local high = 0

	    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
	        function()
	            if GameRules:IsGamePaused() then return 0.03 end

	            -- 向心力单位向量
	            local vecCentripetal = (projectileTable.vSpawnOriginNew - targetPoint):Normalized()

	            -- 向心力
	            local forceCentripetal = speed/50

	            -- 初速度单位向量
	            local vecInVelocity = projectileTable.vVelocity

	            -- 初始力
	            local forceIn = iVelocity/50

	            -- 投射物矢量
	            local vecProjectile = vecInVelocity * forceIn + forceCentripetal * vecCentripetal

	            local vec = projectileTable.vSpawnOriginNew + vecProjectile + Vector(0,0,high)

	            -- 投射物单位向量
	            local particleForward = vecProjectile:Normalized()

	            -- 目标和投射物距离
	            local dis = GetDistanceBetweenTwoVec2D(targetPoint,vec)

	            ParticleManager:SetParticleControlForward(effectIndex,3,particleForward)

	            totalDistance = totalDistance + math.sqrt(forceIn*forceIn + forceCentripetal*forceCentripetal)

	            if(dis<400)then
	            	if ishit == false then
	            		ishit = true
	            		target:StartGesture(ACT_DOTA_FLAIL)
	            	end
	            	high = high + 25
	            	target:SetOrigin(projectileTable.vSpawnOriginNew+400*Vector(forwardVec.x,forwardVec.y,0)-Vector(0,0,50))
	            end

	            if(dis<projectileTable.fEndRadius)then
	                if(projectileTable.bDeleteOnHit)then
	                    OnRumia03AbilityEnd(caster,target,keys.ability,effectIndex,time)
	                    return nil
	                end
	            end

	            if(totalDistance<projectileTable.fDistance and dis>=projectileTable.fEndRadius)then
	                ParticleManager:SetParticleControl(effectIndex,3,vec)
	                projectileTable.vSpawnOriginNew = vec
	                speed = speed + acceleration
	                time = time + 0.02
	                return 0.02
	            else
	                if func then func(projectileTable.vSpawnOriginNew) end
	                ParticleManager:DestroyParticleSystem(effectIndex,true)
	                return nil
	            end
	        end, 
	    0.02)
	end
end

function OnRumia03AbilityEnd(caster,target,ability,effectIndex,time)
	caster:SetContextThink(DoUniqueString("ability_caster_projectile_END"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            target:RemoveModifierByName("modifier_rumia_03_pause")
			ParticleManager:DestroyParticleSystem(effectIndex,true)
			local effectIndexEnd = ParticleManager:CreateParticle("particles/heroes/thtd_rumia/ability_rumia_04_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndexEnd, 0, target:GetOrigin())
			ParticleManager:SetParticleControl(effectIndexEnd, 3, target:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndexEnd,false)
			target:AddNoDraw()
			target:SetHealth(1)
			local DamageTable = {
	   			ability = ability,
	            victim = target, 
	            attacker = caster, 
	            damage = caster:THTD_GetPower() * caster:THTD_GetStar(), 
	            damage_type = DAMAGE_TYPE_PURE, 
	            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
            return nil
        end, 
   	1.5 - time)
end

function RumiaProjectileStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	caster:EmitSound("Sound_THTD.thtd_rumia_01")

	for i=1,12 do
		local forwardCos = caster:GetForwardVector().x
		local forwardSin = caster:GetForwardVector().y
		local angle = (39 - 6.5 * i) / 180 * math.pi
		local forward = Vector(	math.cos(angle)*forwardCos - math.sin(angle)*forwardSin,
								forwardSin*math.cos(angle) + forwardCos*math.sin(angle),0)
		local info = 
		{
				Ability = keys.ability,
	        	EffectName = "particles/heroes/rumia/ability_rumia_02_projectile.vpcf",
	        	vSpawnOrigin = caster:GetOrigin() + forward * 500 - caster:GetForwardVector() * 500 + Vector(0,0,128),
	        	fDistance = 800,
	        	fStartRadius = 150,
	        	fEndRadius = 150,
	        	Source = caster,
	        	bHasFrontalCone = false,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit = true,
				vVelocity = caster:GetForwardVector() * 1800,
				bProvidesVision = true,
				iVisionRadius = 1000,
				iVisionTeamNumber = caster:GetTeamNumber()
		}
		if caster:THTD_IsTowerEx() == true then
			info.EffectName = "particles/heroes/rumia/ability_rumia_02_ex_projectile.vpcf"
		end
		local projectile = ProjectileManager:CreateLinearProjectile(info)
		ParticleManager:DestroyLinearProjectileSystem(projectile,false)
	end
end

function OnRumiaProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage = caster:THTD_GetPower()

	if caster:THTD_IsTowerEx() == true then
		damage = caster:THTD_GetPower() * caster:THTD_GetStar() / 2
	end

	local DamageTable = {
			ability = keys.ability,
	        victim = target, 
	        attacker = caster, 
	        damage = damage, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
end


function Rumia04AttackTargetPoint(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)
	if keys.ability:GetLevel()<1 then return end
	if targets[1]==nil then return end

	local target = targets[1]
	local vecCaster = caster:GetOrigin()
	local pointRad = GetRadBetweenTwoVec2D(vecCaster,target:GetOrigin())

	local randomPi = RandomFloat(-2*math.pi,2*math.pi)
	local forwardVec = Vector(math.cos(pointRad+randomPi), math.sin(pointRad+randomPi),RandomFloat(0,1))

	local BulletTable = {
	    Ability        	 	=   keys.ability,
		EffectName			=	"particles/heroes/thtd_rumia/ability_rumia_04.vpcf",
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

	if caster.thtd_rumia_04_damage_increase == nil then
		caster.thtd_rumia_04_damage_increase = 1
	end

	ShushanCreateProjectileMoveToPoint(BulletTable,caster,target:GetOrigin(),speed,iVelo,-acc,
		function(vec)
			local targetpoint = Vector(vec.x,vec.y,caster:GetOrigin().z)
			local targets = THTD_FindUnitsInRadius(caster,targetpoint,300)
			for k,v in pairs(targets) do
				local damage_table = {
					victim = v,
					attacker = caster,
					damage = caster:THTD_GetPower()*caster:THTD_GetStar()/3*caster.thtd_rumia_04_damage_increase,
					ability = keys.ability,
					damage_type = keys.ability:GetAbilityDamageType(), 
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
				}
				UnitDamageTarget(damage_table)
			end
			
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_rumia/ability_rumia_04_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetpoint)
			ParticleManager:SetParticleControl(effectIndex, 3, targetpoint)
			ParticleManager:DestroyParticleSystem(effectIndex,false)
		end
	)
end