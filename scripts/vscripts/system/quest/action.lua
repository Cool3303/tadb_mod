
-- 通关
Subquest:AddAction( function ( subquest, event )
	if event.Type ~= "wave_clear" or subquest:GetType() ~= "wave_clear" then return end

	if event.Wave >= subquest.hData["Wave"] then
		subquest:SetState(SUBQUEST_STATE_FINISHED)
	end
end)


-- 通关无尽
Subquest:AddAction( function ( subquest, event )
	if event.Type ~= "endless_wave_clear" or subquest:GetType() ~= "endless_wave_clear" then return end

	if event.Wave >= subquest.hData["Wave"] then
		subquest:SetState(SUBQUEST_STATE_FINISHED)
	end
end)

-- 通关
Subquest:AddAction( function ( subquest, event )
	if event.Type ~= "finished_game" or subquest:GetType() ~= "finished_game" then return end

	if event.Difficulty == subquest.hData["Difficulty"] then
		subquest:SetState(SUBQUEST_STATE_FINISHED)
	end
end)


------------------------------------------------------------------------


-- 奖励阴阳玉
Quest:OnGiveReward( function ( quest, reward )
	if reward[1] ~= "yinyangyu" then return end
	GiveTouhouGamePoints( quest.iPlayerID, reward[2] )
end)