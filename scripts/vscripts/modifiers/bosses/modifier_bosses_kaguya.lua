modifier_bosses_kaguya = class({})

local public = modifier_bosses_kaguya

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

	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		local caster = self:GetParent()
		caster:AddNewModifier(caster,nil,"modifier_touhoutd_pause",{})
		caster:StartGesture(ACT_DOTA_DIE)
		caster.thtd_damage_lock = true
		caster:SetContextThink(DoUniqueString("thtd_modifier_kaguya_renew"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				if caster:GetHealth() >= caster:GetMaxHealth() then 
					caster.thtd_damage_lock = false
					caster:RemoveGesture(ACT_DOTA_DIE)
					caster:RemoveModifierByName("modifier_touhoutd_pause")
					return nil 
				end
				caster:SetHealth(caster:GetHealth()+caster:GetMaxHealth()*0.02)
				return 0.04
			end, 
		0)
		
	end
end