
thtd_koakuma_01 = class({})

function thtd_koakuma_01:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local ExtraData = { 
			count=0
		}
		
	caster:EmitSound("Sound_THTD.thtd_koakuma_01")
	self:Koakuma01PassToNextUnit(caster,caster:GetOrigin(),target,ExtraData)
end


function thtd_koakuma_01:Koakuma01PassToNextUnit(target,target_1,target_2,data)
	local caster = self:GetCaster()

	local info = 
	{
		Target = target_2,
		Source = target,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf",
        iMoveSpeed = 1400,
		vSourceLoc= target_1,                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
	    bDodgeable = true,                                -- Optional
	  	bIsAttack = false,                                -- Optional
	    bVisibleToEnemies = true,                         -- Optional
	    bReplaceExisting = false,                         -- Optional
	    flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,
		iVisionRadius = 400,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = { 
			count=data.count + 1
		}
	}
	local projectile = ProjectileManager:CreateTrackingProjectile(info)
end

--------------------------------------------------------------------------------

function thtd_koakuma_01:OnProjectileHit_ExtraData( hTarget, vLocation, data )
	local caster = self:GetCaster()
	local target = hTarget

	local DamageTable = {
   			ability = self,
            victim = target, 
            attacker = caster, 
            damage = caster:THTD_GetPower() * caster:THTD_GetStar(), 
            damage_type = self:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
	caster:EmitSound("Sound_THTD.thtd_koakuma_01.hit")

   	local targets = THTD_FindUnitsInRadius(caster,vLocation,500)

	if caster.thtd_kuakuma_extra == nil then
		caster.thtd_kuakuma_extra = false
	end

	if caster.thtd_kuakuma_extra == true then
		local enemies = THTD_FindUnitsInRadius(caster,vLocation,300)
		
		for k,v in pairs(enemies) do
			local DamageTable = {
		   			ability = self,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 0.35, 
		            damage_type = self:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
		   	}
		   	UnitDamageTarget(DamageTable)
		end
		local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)
	end

	for k,v in pairs(targets) do
		if v~=nil and v~=target and data.count < 25 then
			self:Koakuma01PassToNextUnit(target,vLocation,v,data)
			break
		end
	end

	return true
end