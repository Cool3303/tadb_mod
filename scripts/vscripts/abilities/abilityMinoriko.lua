function OnMinoriko02StarChange(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:GetUnitName() == "minoriko" or target:GetUnitName() == "sizuha" then
		return
	end

	if target:THTD_IsTower() and target:GetOwner() == caster:GetOwner() and target:GetUnitName()~=caster:GetUnitName() then
		local hero = caster:GetOwner()

		if hero.thtd_minoriko_02_change == nil then
			hero.thtd_minoriko_02_change = 0
		end
		if hero.thtd_minoriko_02_change >= 3 then
			CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner() , "show_message", {msg="minoriko_max_change", duration=5, params={count=1}, color="#0ff"} )
			return
		end
		
		hero.thtd_minoriko_02_change = hero.thtd_minoriko_02_change + 1

		local star = target:THTD_GetStar()
		target:THTD_SetStar(caster:THTD_GetStar())
		target:THTD_SetLevel(THTD_MAX_LEVEL)

		caster.thtd_isChanged = true
		caster.thtd_star = star
		caster:THTD_OpenAbility()
		caster:THTD_DestroyLevelEffect()
		caster:THTD_CreateLevelEffect()
	end
end