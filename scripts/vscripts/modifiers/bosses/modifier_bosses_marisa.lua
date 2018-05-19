modifier_bosses_marisa = class({})

local public = modifier_bosses_marisa

local m_modifier_funcs=
{
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}

function public:IsHidden()
	return true
end

function public:IsDebuff()
	return false
end

function public:IsPurgable()
	return false
end

function public:DeclareFunctions()
	return m_modifier_funcs
end

function public:GetModifierMoveSpeed_Max()
	return 10000
end

function public:GetModifierMoveSpeedBonus_Constant()
	return 2000
end

function public:OnCreated(kv)
	if IsServer() then
		local caster = self:GetParent()
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/marisa/marisa_01_rocket_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
		ParticleManager:SetParticleControl(effectIndex, 15, Vector(0,60,255))

		caster:SetContextThink(DoUniqueString("thtd_marisa_delay"), 
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				caster:RemoveModifierByName("modifier_bosses_marisa")
				ParticleManager:DestroyParticleSystem(effectIndex,true)
				return nil
			end, 
		0.3) 
	end
end

function public:OnDestroy(kv)
	if IsServer() then
		local caster = self:GetParent()

		caster:SetContextThink(DoUniqueString("thtd_marisa_delay"), 
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				caster:AddNewModifier(caster,caster,"modifier_bosses_marisa",nil)
				return nil
			end, 
		2.7) 
	end
end