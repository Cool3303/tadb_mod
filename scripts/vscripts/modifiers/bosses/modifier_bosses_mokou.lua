modifier_bosses_mokou = class({})

local public = modifier_bosses_mokou

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
	end
end