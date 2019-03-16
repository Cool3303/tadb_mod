modifier_bosses_marisa = class({})

local public = modifier_bosses_marisa

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
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/marisa/marisa_01_rocket_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlForward(effectIndex,0,caster:GetForwardVector())
		ParticleManager:SetParticleControl(effectIndex, 15, Vector(0,60,255))
		local count = 5
		if caster.first_delay == nil then 
			caster.first_delay = 0.3
		else
			caster.first_delay = 0
		end
		caster:SetContextThink(DoUniqueString("thtd_marisa_delay"), 
			function ()
				if GameRules:IsGamePaused() then return 0.03 end
				if count <= 0 then 
					caster:RemoveModifierByName("modifier_bosses_marisa")
					ParticleManager:DestroyParticleSystem(effectIndex,true)
					if caster~=nil and caster:IsNull()==false and caster:IsAlive() then
						FindClearSpaceForUnit(caster, caster:GetOrigin(), false)
					end	
					return nil
				end
				if caster:IsStunned() == false and caster:IsRooted() == false then 
					caster:SetAbsOrigin(caster:GetOrigin() + caster:GetForwardVector() * 50)
				end
				count = count - 1				
				return 0.06
			end, 
		caster.first_delay)
	end
end

function public:OnDestroy(kv)
	if IsServer() then
		local caster = self:GetParent()		
		local count = 27
		caster:SetContextThink(DoUniqueString("thtd_marisa_delay"), 
			function ()				
				if GameRules:IsGamePaused() then return 0.03 end
				if caster==nil or caster:IsNull() or caster:IsAlive()==false then return nil end
				count = count - 1
				if count > 0 then return 0.1 end						
				caster:AddNewModifier(caster,caster,"modifier_bosses_marisa",nil)
				return nil
			end, 
		0.1) 

	end
end