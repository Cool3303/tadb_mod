modifier_bosses_minoriko = class({})

local public = modifier_bosses_minoriko

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
		caster:SetContextThink(DoUniqueString("thtd_bosses_minoriko_buff"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				local healAmount = math.min(caster:GetHealth()+caster:GetMaxHealth()*0.3,caster:GetMaxHealth())
				caster:SetHealth(healAmount)
				local effectIndex = ParticleManager:CreateParticle("particles/heroes/minoriko/ability_minoriko_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin())
				ParticleManager:DestroyParticleSystem(effectIndex,false)
				return 10.0
			end, 
		10.0)
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local caster = self:GetParent()

	end
end