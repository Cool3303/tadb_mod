modifier_bosses_rumia = class({})

local public = modifier_bosses_rumia

function public:IsHidden()
	return true
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end

function public:OnCreated(kv)
	if IsServer() then
		local caster = self:GetParent()		
		local count = 1
		local thinkcount = 10
		caster:SetContextThink(DoUniqueString("thtd_rumia_think"), 
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				if caster==nil or caster:IsNull() or caster:IsAlive()==false then return nil end
				thinkcount = thinkcount - 1
				if thinkcount > 0 then return 0.1 end

				if count == 4 then
					caster.thtd_damage_lock = true
					local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/rumia/ability_rumia01_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
					ParticleManager:DestroyParticleSystemTime(effectIndex,1.0)
					count = 1
				else
					caster.thtd_damage_lock = false
					count = count + 1
				end

				thinkcount = 10
				return 0.1
			end, 
		0.1) 

	end
end