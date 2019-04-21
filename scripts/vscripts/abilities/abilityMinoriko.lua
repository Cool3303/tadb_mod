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

		if GameRules:GetCustomGameDifficulty() == 8 then
			if SpawnSystem.CurWave < 11 then 
				GameRules:SendCustomMessage("<font color='red'>娱乐模式下，秋穣子在前10波不能使用交换技能。</font>", DOTA_TEAM_GOODGUYS, 0)
				return
			end
			if SpawnSystem.CurWave < 21 and hero.thtd_minoriko_02_change >= 1 then 
				GameRules:SendCustomMessage("<font color='red'>娱乐模式下，秋穣子在前20波只能使用一次交换技能。</font>", DOTA_TEAM_GOODGUYS, 0)
				return
			end
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