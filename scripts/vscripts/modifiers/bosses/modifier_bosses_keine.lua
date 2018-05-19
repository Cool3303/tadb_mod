modifier_bosses_keine = class({})

local public = modifier_bosses_keine

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
		local health = caster:GetMaxHealth()*1.5
		caster:SetBaseMaxHealth(health)
		caster:SetMaxHealth(health)
		caster:SetHealth(caster:GetMaxHealth())
		caster:SetContextThink(DoUniqueString("thtd_bosses_keine_buff"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if caster:GetHealth() < caster:GetMaxHealth()*0.7 then
					caster:SetContextThink(DoUniqueString("thtd_bosses_keine_back_buff"), 
						function()
							if GameRules:IsGamePaused() then return 0.03 end
							caster:SetHealth(caster:GetMaxHealth()*0.7)
							local effectIndex = ParticleManager:CreateParticle("particles/bosses/thtd_keine/ability_bosses_keine.vpcf", PATTACH_CUSTOMORIGIN, caster)
							ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
							ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin())
							ParticleManager:SetParticleControl(effectIndex, 2, caster:GetOrigin())
							ParticleManager:DestroyParticleSystem(effectIndex,false)
							return nil
						end,
					5.0)
					return nil
				end
				return 0.1
			end, 
		0.1)
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local caster = self:GetParent()

	end
end