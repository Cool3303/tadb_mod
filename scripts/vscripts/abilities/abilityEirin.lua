function OnEirin01AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local ability = keys.ability

	OnEirin01TrackingProjectileToTarget(caster,target,ability,caster)
	caster:EmitSound("Sound_THTD.thtd_eirin_01.start")
end


function OnEirin01TrackingProjectileToTarget(caster,target,ability,source)
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

thtd_eirin_01 = class({})

function thtd_eirin_01:OnProjectileHit_ExtraData( hTarget, vLocation, data )
	local caster = self:GetCaster()
	local target = hTarget
	local source = data.source

	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)

	target:EmitSound("Sound_THTD.thtd_eirin_01.end")

	if caster.thtd_eirin_01_damage_increase == nil then
		caster.thtd_eirin_01_damage_increase = 1.0
	end

	if source~=nil and source:THTD_IsTower() then
		local damage = source:THTD_GetPower() * source:THTD_GetStar() * 0.5 * caster.thtd_eirin_01_damage_increase

		local DamageTable = {
				ability = self,
		        victim = target, 
		        attacker = caster, 
		        damage = damage, 
		        damage_type = self:GetAbilityDamageType(), 
		        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	else
		local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.5 * caster.thtd_eirin_01_damage_increase

		local DamageTable = {
				ability = self,
		        victim = target, 
		        attacker = caster, 
		        damage = damage, 
		        damage_type = self:GetAbilityDamageType(), 
		        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end

	return false
end

function OnEirin02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ability = caster:FindAbilityByName("thtd_eirin_01")

	local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),900)

	if #targets>0 and targets[1]~=nil and targets[1]:IsNull()==false and ability~=nil then
		OnEirin01TrackingProjectileToTarget(caster,targets[1],ability,keys.attacker)
	end
end

function OnEirin03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local hero = caster:GetOwner()

	if hero.thtd_eirin_03_lock == nil then
		hero.thtd_eirin_03_lock = false
	end

	if hero.thtd_eirin_03_lock == true then
		return
	end
	hero.thtd_eirin_03_lock = true

	if caster.thtd_eirin_03_position == nil then
		caster.thtd_eirin_03_position = targetPoint
	end
	
	caster:EmitSound("Sound_THTD.thtd_eirin_02")

	local time = 3.5

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_eirin/ability_eirin_03.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(400,0,0))
	ParticleManager:SetParticleControl(effectIndex, 2, Vector(400,0,0))
	ParticleManager:SetParticleControl(effectIndex, 4, targetPoint)
	ParticleManager:SetParticleControl(effectIndex, 15, targetPoint)

	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/thtd_eirin/ability_eirin_03_aeons.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex2, 0, targetPoint)
	ParticleManager:SetParticleControl(effectIndex2, 1, Vector(400,400,400))


	local hitblockTag = DoUniqueString("hitblock")

	local hitblock = {
		circlePoint = targetPoint,
		radius = 400,
		tag = hitblockTag,
	}
	table.insert(THTD_Custom_Hit_Block,hitblock)

	caster:SetContextThink(DoUniqueString("thtd_eirin_03_spell_think"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time <= 0 then 
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				ParticleManager:DestroyParticleSystem(effectIndex2,true)
				for index,block in pairs(THTD_Custom_Hit_Block) do
					if block.tag == hitblockTag then
						table.remove(THTD_Custom_Hit_Block,index)
					end
				end
				caster.thtd_eirin_03_position = nil
				hero.thtd_eirin_03_lock = false
				return nil 
			end
			time = time - 0.1
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,450)
			
			for k,v in pairs(targets) do
				if GetDistanceBetweenTwoVec2D(targetPoint, v:GetOrigin()) > 400 then
					local forward = (v:GetAbsOrigin() - targetPoint):Normalized()
					v:SetOrigin(targetPoint+forward*400)
				end
			end
			return 0.1
		end, 
	0.1)
end

function OnEirin04SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local vecCaster = keys.target_points[1]
	local targetPoint = keys.target_points[1]
	local pointRad = 0

	if GetHitCustomBlock(vecCaster,targetPoint) ~= nil then
		return
	end

	caster:EmitSound("Sound_THTD.thtd_eirin_04")

	local maxRad = math.pi*150/180

	for i=0,36 do
		local forwardVec = Vector(math.cos(pointRad-maxRad/2+maxRad/12*i)*1500,math.sin(pointRad-maxRad/2+maxRad/12*i)*1500,0):Normalized()

		local BulletTable = {
		    Ability        	 	=   keys.ability,
			EffectName			=	"particles/heroes/thtd_eirin/ability_eirin_04.vpcf",
			vSpawnOrigin		=	vecCaster,
			vSpawnOriginNew		=	vecCaster,
			fDistance			=	5000,
			fStartRadius		=	120,
			fEndRadius			=	120,
			Source         	 	=   caster,
			bHasFrontalCone		=	false,
			bRepalceExisting 	=   false,
			iUnitTargetTeams		=	"DOTA_UNIT_TARGET_TEAM_ENEMY",
			iUnitTargetTypes		=	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP",
			iUnitTargetFlags		=	"DOTA_UNIT_TARGET_FLAG_NONE",
			fExpireTime     =   GameRules:GetGameTime() + 10.0,
			bDeleteOnHit    =   false,
			vVelocity       =   forwardVec,
			bProvidesVision	=	true,
			iVisionRadius	=	400,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iReflexCount = 0,
			bReflexByBlock = true,
		}

		if i%2 == 0 then
			BulletTable.EffectName = "particles/heroes/thtd_eirin/ability_eirin_04_red.vpcf"
		end

		ShushanCreateProjectileMoveToTargetPoint(BulletTable,caster,2000,0,0,
			function(v,vecProjectile,reflexCount)
				if v:IsNull()==false and v~=nil then
					local reflexDamageIncrease = math.min(reflexCount,5)
					local damage_table = {
						victim = v,
						attacker = caster,
						ability = keys.ability,
						damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.1 * (1 + reflexDamageIncrease/5),
						damage_type = keys.ability:GetAbilityDamageType(), 
						damage_flags = keys.ability:GetAbilityTargetFlags()
					}
					UnitDamageTarget(damage_table)
				end
			end
		)
	end
end