function OnSakuya01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
	local forward = Vector(math.cos(rad),math.sin(rad),caster:GetForwardVector().z)

	local info = 
	{
			Ability = keys.ability,
        	EffectName = "particles/thd2/heroes/sakuya/ability_sakuya_01.vpcf",
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
			vVelocity = forward * 2000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	ParticleManager:DestroyLinearProjectileSystem(projectile,false)

	local count = 6

	for i=1,count do
		local iVec = Vector( math.cos(rad + math.pi/36*(i+0.5)) * 2000 , math.sin(rad + math.pi/36*(i+0.5)) * 2000 , caster:GetForwardVector().z )
		info.vVelocity = iVec
		projectile = ProjectileManager:CreateLinearProjectile(info)
		ParticleManager:DestroyLinearProjectileSystem(projectile,false)
		iVec = Vector( math.cos(rad - math.pi/36*(i+0.5)) * 2000 , math.sin(rad - math.pi/36*(i+0.5)) * 2000 , caster:GetForwardVector().z )
		info.vVelocity = iVec
		projectile = ProjectileManager:CreateLinearProjectile(info)
		ParticleManager:DestroyLinearProjectileSystem(projectile,false)
	end
end

function OnSakuya01ProjectileHit(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	local damage = caster:THTD_GetPower() * caster:THTD_GetStar()

	if target:HasModifier("modifier_sakuya_03_time_pause_debuff") then
   		damage = damage * (0.25 + caster.thtd_sakuya_01_increase)
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

function OnSakuya02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = keys.target:GetOrigin()
	local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel())

	if target:THTD_IsTower() and target:HasModifier("modifier_sakuya_02_buff") == false then
		if target:GetUnitName() == "remilia" and caster.thtd_sakuya_02_special_open == true then
			keys.ability:EndCooldown()
			keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel())/2)
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_sakuya_02_buff", {duration=cooldown/2 - 1})
		else
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_sakuya_02_buff", {duration=cooldown - 1})
		end
		caster.thtd_last_cast_unit = target

		local effectIndex = ParticleManager:CreateParticle("particles/thd2/items/item_pocket_watch.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex,false)

		for i=2,5 do
			local ability = target:GetAbilityByIndex(i)
			if ability~=nil and IsInSakuya02BlackList(ability) == false then
				ability:EndCooldown()
				target:SetMana(target:GetMana()+ability:GetManaCost(ability:GetLevel()))
			end
		end
	end
end


function OnSakuya03SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local duration = 2.0

	local pauseUnit = {}

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/muyue/ability_muyue_014_aeons.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, Vector(1000,1000,1000))

	caster:SetContextThink(DoUniqueString("ability_reimu_03"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),1000)
			
			for k,v in pairs(targets) do
				if v:HasModifier("modifier_sakuya_03_time_pause_debuff") == false then
   					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_sakuya_03_time_pause_debuff", nil)
					pauseUnit[v:GetEntityIndex()] = v
				end
			end

			if caster:GetMana()<caster:GetMaxMana() then
				caster:SetMana(caster:GetMaxMana())
			end

			local ability = caster:FindAbilityByName("thtd_sakuya_01")
			local unit = targets[1]
			if unit~=nil and unit:IsNull()==false and ability:GetLevel()>0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(ability:GetLevel()) then
				caster:CastAbilityOnPosition(unit:GetOrigin(),ability,caster:GetPlayerOwnerID())
			end

			duration = duration - 0.03
			if duration < 0 then
				for k,v in pairs(pauseUnit) do
					if v~=nil and v:IsNull()==false and v:IsAlive() then
	   					v:RemoveModifierByName("modifier_sakuya_03_time_pause_debuff")
					end
				end
				ParticleManager:DestroyParticleSystem(effectIndex,false)
				pauseUnit = {}
				return
			end
			return 0.03
		end,
	0.03)
end