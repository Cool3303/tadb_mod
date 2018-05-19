function OnSizuha02StarImprove(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:THTD_IsTower() and target:GetUnitName()~=caster:GetUnitName() and target:THTD_GetStar() < caster:THTD_GetStar() and target:GetUnitName() ~= "minoriko" and target:GetUnitName() ~= "sizuha" then
		target:THTD_SetStar(target:THTD_GetStar()+1)
		target:THTD_SetLevel(THTD_MAX_LEVEL)

		caster.thtd_isChanged = true
		caster.thtd_star = caster:THTD_GetStar() - 1
		caster:THTD_OpenAbility()
		caster:THTD_DestroyLevelEffect()
		caster:THTD_CreateLevelEffect()
	end
end