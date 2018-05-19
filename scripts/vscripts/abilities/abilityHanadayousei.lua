function OnHanadayousei01Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.__hanadayousei_lock ~= true then 
		caster.__hanadayousei_lock = true
		local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)
		local count = 0
		for i=1,#targets do
			local unit = targets[i]
			if unit~=nil and unit:IsNull()==false and unit~=target and unit:IsAlive() then
				caster:PerformAttack(unit,true,false,true,false,true,false,true)
				count = count + 1
			end
			if count > 3 then
				break
			end
		end
		caster.__hanadayousei_lock = false
	end
end