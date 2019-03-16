local thtd_combo_voice_table = 
{
	["lyrica"] = 
	{
		["lyrica_lunasa_merlin"] = 
		{
			["comboName"] = "lyrica_lunasa_merlin",
			["delay"] = 3,
			["duration"] = 3,
			["unitName"] = "lyrica",
		}
	},

	["lunasa"] = 
	{
		["lyrica_lunasa_merlin"] = 
		{
			["comboName"] = "lyrica_lunasa_merlin",
			["delay"] = 3,
			["duration"] = 3,
			["unitName"] = "lunasa",
		}
	},

	["merlin"] = 
	{	
		["lyrica_lunasa_merlin"] = 
		{
			["comboName"] = "lyrica_lunasa_merlin",
			["delay"] = 3,
			["duration"] = 3,
			["unitName"] = "merlin",
		}
	},

	["youmu"] = 
	{	
		["yuyuko_youmu"] = 
		{
			["comboName"] = "yuyuko_youmu",
			["delay"] = 9,
			["duration"] = 5,
			["unitName"] = "yuyuko_youmu",
		}
	},

	["yuyuko"] = 
	{	
		["yuyuko_youmu"] = 
		{
			["comboName"] = "yuyuko_youmu",
			["delay"] = 13,
			["duration"] = 5,
			["unitName"] = "yuyuko",
		}
	},

	["marisa"] = 
	{	
		["reimu_marisa"] = 
		{
			["comboName"] = "reimu_marisa",
			["delay"] = 3,
			["duration"] = 2,
			["unitName"] = "marisa",
		},
		["marisa_alice"] = 
		{
			["comboName"] = "marisa_alice",
			["delay"] = 2,
			["duration"] = 3, 
			["unitName"] = "marisa",
		}
	},

	["alice"] = 
	{			
		["marisa_alice"] = 
		{
			["comboName"] = "marisa_alice",
			["delay"] = 3,
			["duration"] = 3, 
			["unitName"] = "alice",
		},
		["reimu_alice"] = 
		{
			["comboName"] = "reimu_alice",
			["delay"] = 3,
			["duration"] = 3, 
			["unitName"] = "alice",
		}
	},

	["koishi"] = 
	{	
		["koishi_satori"] = 
		{
			["comboName"] = "koishi_satori",
			["delay"] = 5,
			["duration"] = 2,
			["unitName"] = "koishi",
		}
	},

	["sakuya"] = 
	{	
		["remilia_sakuya"] = 
		{
			["comboName"] = "remilia_sakuya",
			["delay"] = 3,
			["duration"] = 3,
			["unitName"] = "sakuya",
		}
	},

	["koakuma"] = 
	{	
		["koakuma_patchouli"] = 
		{
			["comboName"] = "koakuma_patchouli",
			["delay"] = 7,
			["duration"] = 3,
			["unitName"] = "koakuma",
		}
	},

	["patchouli"] = 
	{	
		["koakuma_patchouli"] = 
		{
			["comboName"] = "koakuma_patchouli",
			["delay"] = 5,
			["duration"] = 2,
			["unitName"] = "patchouli",
		}
	},

	["eirin"] = 
	{	
		["eirin_kaguya"] = 
		{
			["comboName"] = "eirin_kaguya",
			["delay"] = 2,
			["duration"] = 2,
			["unitName"] = "eirin",
		}
	},

	["kaguya"] = 
	{	
		["eirin_kaguya"] = 
		{
			["comboName"] = "eirin_kaguya",
			["delay"] = 2,
			["duration"] = 3,
			["unitName"] = "kaguya",
		}
	},
}


function CDOTA_BaseNPC:THTD_GetComboVoice(comboName)
	return thtd_combo_voice_table[self:GetUnitName()][comboName]
end

function CDOTA_BaseNPC:THTD_cirno_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability = self:FindAbilityByName("thtd_cirno_01")
	if HasCombo(combo,"letty_cirno") then
		if ability:GetLevel()~=2 then
			ability:SetLevel(2)
		end
	else
		if ability:GetLevel()>1 then
			ability:SetLevel(1)
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_letty_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability = self:FindAbilityByName("thtd_letty_01")
	if HasCombo(combo,"letty_cirno") then
		if self.thtd_letty_01_strom_count ~=3 then
			self.thtd_letty_01_strom_count = 3
		end
	else
		if self.thtd_letty_01_strom_count ~=2 then
			self.thtd_letty_01_strom_count = 2
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_lyrica_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"lyrica_lunasa_merlin") then
		if self.thtd_lyrica_increase_damage ~= 1.5 then
			self.thtd_lyrica_increase_damage = 1.5
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("lyrica_lunasa_merlin"))
		end
	else
		if self.thtd_lyrica_increase_damage ~= 1.0 then
			self.thtd_lyrica_increase_damage = 1.0
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_lunasa_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"lyrica_lunasa_merlin") then
		if self.thtd_lunasa_duration ~= 6.0 then
			self.thtd_lunasa_duration = 6.0
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("lyrica_lunasa_merlin"))
		end
	else
		if self.thtd_lunasa_duration ~= 4.0 then
			self.thtd_lunasa_duration = 4.0
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_merlin_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"lyrica_lunasa_merlin") then
		if self.thtd_merlin_duration ~= 6.0 then
			self.thtd_merlin_duration = 6.0
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("lyrica_lunasa_merlin"))
		end
	else
		if self.thtd_merlin_duration ~= 4.0 then
			self.thtd_merlin_duration = 4.0
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_iku_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"tenshi_iku") then
		if self.thtd_iku_01_stun_duration ~= 1.0 then
			self.thtd_iku_01_stun_duration = 1.0
		end
	else
		if self.thtd_iku_01_stun_duration ~= 0.5 then
			self.thtd_iku_01_stun_duration = 0.5
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_tenshi_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"tenshi_iku") then
		if self.thtd_tenshi_03_attack_count_bonus ~= 1 then
			self.thtd_tenshi_03_attack_count_bonus = 1
		end
	else
		if self.thtd_tenshi_03_attack_count_bonus ~= 0 then
			self.thtd_tenshi_03_attack_count_bonus = 0
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_youmu_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability = self:FindAbilityByName("thtd_youmu_02")
	if HasCombo(combo,"yuyuko_youmu") then
		if ability ~= nil and self:HasModifier("modifier_youmu_02_attack_speed_buff") == false then
			ability:ApplyDataDrivenModifier(self, self, "modifier_youmu_02_attack_speed_buff", nil)
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("yuyuko_youmu"))
		end
	else
		if ability ~= nil and self:HasModifier("modifier_youmu_02_attack_speed_buff") == true then
			self:RemoveModifierByName("modifier_youmu_02_attack_speed_buff")
		end
	end
	if HasCombo(combo,"youmu_reisen") then
		if self.thtd_youmu_01_chance ~= 70 then
			self.thtd_youmu_01_chance = 70
		end
	else
		if self.thtd_youmu_01_chance ~= 30 then
			self.thtd_youmu_01_chance = 30
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_yuyuko_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"yuyuko_youmu") then
		if self.thtd_yuyuko_02_chance ~= 10 then
			self.thtd_yuyuko_02_chance = 10
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("yuyuko_youmu"))
		end
	else
		if self.thtd_yuyuko_02_chance ~= 5 then
			self.thtd_yuyuko_02_chance = 5
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_reisen_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"youmu_reisen") then
		if self.thtd_reisen_02_illusion_count_max ~= 5 then
			self.thtd_reisen_02_illusion_count_max = 5
		end
	else
		if self.thtd_reisen_02_illusion_count_max ~= 3 then
			self.thtd_reisen_02_illusion_count_max = 3
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_rin_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability = self:FindAbilityByName("thtd_rin_01")
	if HasCombo(combo,"utsuho_rin") then
		if ability ~= nil and self:HasModifier("modifier_utsuho_rin_aura") == false then
			ability:ApplyDataDrivenModifier(self, self, "modifier_utsuho_rin_aura", nil)
		end
	else
		if ability ~= nil and self:HasModifier("modifier_utsuho_rin_aura") == true then
			self:RemoveModifierByName("modifier_utsuho_rin_aura")
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_utsuho_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability = self:FindAbilityByName("thtd_utsuho_01")
	if HasCombo(combo,"utsuho_rin") then
		if ability ~= nil and self:HasModifier("modifier_utsuho_rin_aura") == false then
			ability:ApplyDataDrivenModifier(self, self, "modifier_utsuho_rin_aura", nil)
		end
	else
		if ability ~= nil and self:HasModifier("modifier_utsuho_rin_aura") == true then
			self:RemoveModifierByName("modifier_utsuho_rin_aura")
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_reimu_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"reimu_marisa") then
		if self.thtd_ability_reimu_02_chance ~= 50 then
			self.thtd_ability_reimu_02_chance = 50
		end
	else
		if self.thtd_ability_reimu_02_chance ~= 20 then
			self.thtd_ability_reimu_02_chance = 20
		end
	end
	if HasCombo(combo,"reimu_yukari") then
		if self.thtd_reimu_04_damage_increase ~= 1.5 then
			self.thtd_reimu_04_damage_increase = 1.5
		end
	else
		if self.thtd_reimu_04_damage_increase ~= 1.0 then
			self.thtd_reimu_04_damage_increase = 1.0
		end
	end
	if HasCombo(combo,"rumia_reimu") then
		if self.thtd_reimu_01_max_count ~= 3 then
			self.thtd_reimu_01_max_count = 3
		end
	else
		if self.thtd_reimu_01_max_count ~= 6 then
			self.thtd_reimu_01_max_count = 6
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_marisa_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability01 = self:FindAbilityByName("thtd_marisa_01")
	local ability03 = self:FindAbilityByName("thtd_marisa_03")
	if HasCombo(combo,"reimu_marisa") then
		if ability01:GetLevel()~=2 then
			ability01:SetLevel(2)
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("reimu_marisa"))
		end
		if ability03:GetLevel()==1 then
			ability03:SetLevel(2)
		end
	else
		if ability01:GetLevel()>1 then
			ability01:SetLevel(1)
		end
		if ability03:GetLevel()==2 then
			ability03:SetLevel(1)
		end
	end
	
	if HasCombo(combo,"marisa_alice") then
		if self.thtd_marisa_alice_crit ~= true then
			self.thtd_marisa_alice_crit = true
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("marisa_alice"))
		end
	else
		if self.thtd_marisa_alice_crit ~= false then
			self.thtd_marisa_alice_crit = false
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_alice_thtd_combo(combo)
	local comboVoiceTable = {}	

	local ability = self:FindAbilityByName("thtd_alice_04")
	if ability:GetLevel() > 0 then
		if HasCombo(combo,"marisa_alice") then
			if ability:GetLevel()~=2 then
				ability:SetLevel(2)
				table.insert(comboVoiceTable,self:THTD_GetComboVoice("marisa_alice"))
			end
		else
			if ability:GetLevel()>1 then
				ability:SetLevel(1)
			end
		end
	end

	if HasCombo(combo,"reimu_alice") then
		if self.thtd_reimu_alice_combo ~= true then
			self.thtd_reimu_alice_combo = true
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("reimu_alice"))
		end
	else
		if self.thtd_reimu_alice_combo ~= false then
			self.thtd_reimu_alice_combo = false
		end
	end

	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_koishi_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"koishi_satori") then
		if self.thtd_koishi_03_duration ~= 20 then
			self.thtd_koishi_03_duration = 20
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("koishi_satori"))
		end
	else
		if self.thtd_koishi_03_duration ~= 10 then
			self.thtd_koishi_03_duration = 10
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_satori_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"koishi_satori") then
		if self.thtd_satori_01_special_open ~= true then
			self.thtd_satori_01_special_open = true
		end
	else
		if self.thtd_satori_01_special_open ~= false then
			self.thtd_satori_01_special_open = false
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_remilia_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"remilia_sakuya") then
		if self.thtd_remilia_03_chance ~= 10 then
			self.thtd_remilia_03_chance = 10
		end
	else
		if self.thtd_remilia_03_chance ~= 5 then
			self.thtd_remilia_03_chance = 5
		end
	end

	if HasCombo(combo,"remilia_flandre") then
		if self.thtd_remilia_02_count ~= 2 then
			self.thtd_remilia_02_count = 2
		end
	else
		if self.thtd_remilia_02_count ~= 1 then
			self.thtd_remilia_02_count = 1
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_sakuya_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"remilia_sakuya") then
		if self.thtd_sakuya_02_special_open ~= true then
			self.thtd_sakuya_02_special_open = true
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("remilia_sakuya"))
		end
	else
		if self.thtd_sakuya_02_special_open ~= false then
			self.thtd_sakuya_02_special_open = false
		end
	end

	if HasCombo(combo,"meirin_sakuya") then
		if self.thtd_sakuya_01_increase ~= 0.25 then
			self.thtd_sakuya_01_increase = 0.25
		end
	else
		if self.thtd_sakuya_01_increase ~= 0 then
			self.thtd_sakuya_01_increase = 0
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_flandre_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"remilia_flandre") then
		if self.thtd_flandre_02_count ~= 2 then
			self.thtd_flandre_02_count = 2
		end
	else
		if self.thtd_flandre_02_count ~= 1 then
			self.thtd_flandre_02_count = 1
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_meirin_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"meirin_sakuya") then
		if self.thtd_meirin_01_chance_increase ~= 25 then
			self.thtd_meirin_01_chance_increase = 25
		end
	else
		if self.thtd_meirin_01_chance_increase ~= 0 then
			self.thtd_meirin_01_chance_increase = 0
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_yukari_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"reimu_yukari") then
		if self.thtd_yukari_01_stock ~= 5 then
			self.thtd_yukari_01_stock = 5
		end
	else
		if self.thtd_yukari_01_stock ~= 3 then
			self.thtd_yukari_01_stock = 3
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_koakuma_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"koakuma_patchouli") then
		if self.thtd_kuakuma_extra ~= true then
			self.thtd_kuakuma_extra = true
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("koakuma_patchouli"))
		end
	else
		if self.thtd_kuakuma_extra ~= false then
			self.thtd_kuakuma_extra = false
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_patchouli_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability = self:FindAbilityByName("thtd_patchouli_04")
	if HasCombo(combo,"koakuma_patchouli") and self:THTD_GetStar()>=5 then
		if ability:GetLevel()~=1 then
			ability:SetLevel(1)
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("koakuma_patchouli"))
		end
	else
		if ability:GetLevel()>0 then
			ability:SetLevel(0)
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_chen_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"chen_yukari_ran") then
		if self.thtd_chen_01_distance_increase ~= 75 then
			self.thtd_chen_01_distance_increase = 75
		end
		if self.thtd_chen_01_distance_max ~= 20 then
			self.thtd_chen_01_distance_max = 20
		end
	else
		if self.thtd_chen_01_distance_increase ~= 100 then
			self.thtd_chen_01_distance_increase = 100
		end
		if self.thtd_chen_01_distance_max ~= 5 then
			self.thtd_chen_01_distance_max = 5
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_ran_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"chen_yukari_ran") then
		if self.thtd_ran_01_mana_regen_buff ~= true then
			self.thtd_ran_01_mana_regen_buff = true
		end
	else
		if self.thtd_ran_01_mana_regen_buff ~= false then
			self.thtd_ran_01_mana_regen_buff = false
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_yukari_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"chen_yukari_ran") then
		if self.thtd_yukari_tram_count ~= 9 then
			self.thtd_yukari_tram_count = 9
		end
	else
		if self.thtd_yukari_tram_count ~= 4 then
			self.thtd_yukari_tram_count = 4
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_kaguya_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"eirin_kaguya") then
		if self.thtd_kaguya_01_count ~= 1 then
			self.thtd_kaguya_01_count = 1
		end
	else
		if self.thtd_kaguya_01_count ~= 0 then
			self.thtd_kaguya_01_count = 0
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_eirin_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"eirin_kaguya") then
		if self.thtd_eirin_01_damage_increase ~= 1.25 then
			self.thtd_eirin_01_damage_increase = 1.25
		end
	else
		if self.thtd_eirin_01_damage_increase ~= 1 then
			self.thtd_eirin_01_damage_increase = 1
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_rumia_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"rumia_reimu") then
		if self.thtd_rumia_04_damage_increase ~= 1.5 then
			self.thtd_rumia_04_damage_increase = 1.5
		end
	else
		if self.thtd_rumia_04_damage_increase ~= 1 then
			self.thtd_rumia_04_damage_increase = 1
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_suwako_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"suwako_kanako_sanae") then
		if self:HasModifier("modifier_thtd_ss_kill") == false then
			self:AddNewModifier(self, nil, "modifier_thtd_ss_kill", {})
		end
	else
		if self:HasModifier("modifier_thtd_ss_kill") then
			self:RemoveModifierByName("modifier_thtd_ss_kill")
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_kanako_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"suwako_kanako_sanae") then
		if self:HasModifier("modifier_thtd_ss_kill") == false then
			self:AddNewModifier(self, nil, "modifier_thtd_ss_kill", {})
		end
	else
		if self:HasModifier("modifier_thtd_ss_kill") then
			self:RemoveModifierByName("modifier_thtd_ss_kill")
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_sanae_thtd_combo(combo)
	local comboVoiceTable = {}
	local ability = self:FindAbilityByName("thtd_sanae_04")

	if HasCombo(combo,"suwako_kanako_sanae") then
		if self:HasModifier("modifier_thtd_ss_kill") == false then
			self:AddNewModifier(self, nil, "modifier_thtd_ss_kill", {})
		end
		if ability:GetLevel()~=1 then
			ability:SetLevel(1)
			ability:SetActivated(true)
		end
	else
		if self:HasModifier("modifier_thtd_ss_kill") then
			self:RemoveModifierByName("modifier_thtd_ss_kill")
		end
		if ability:GetLevel()~=0 then
			ability:SetLevel(0)
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_minamitsu_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"nue_minamitsu") then
		if self.thtd_minamitsu_02_bonus ~= 1.5 then
			self.thtd_minamitsu_02_bonus = 1.5
		end
	else
		if self.thtd_minamitsu_02_bonus ~= 1 then
			self.thtd_minamitsu_02_bonus = 1
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_futo_thtd_combo(combo)
	local comboVoiceTable = {}
	if HasCombo(combo,"futo_soga") then
		if self.thtd_futo_02_buff_max_count ~= 15 then
			self.thtd_futo_02_buff_max_count = 15
		end
	else
		if self.thtd_futo_02_buff_max_count ~= 10 then
			self.thtd_futo_02_buff_max_count = 10
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_soga_thtd_combo(combo)
	local comboVoiceTable = {}

	if HasCombo(combo,"futo_soga") then
		if self.thtd_soga_03_debuff ~= true then
			self.thtd_soga_03_debuff = true
		end
	else
		if self.thtd_soga_03_debuff ~= false then
			self.thtd_soga_03_debuff = false
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_yoshika_thtd_combo(combo)
	local comboVoiceTable = {}

	if HasCombo(combo,"yoshika_seiga") then
		if self:HasModifier("modifier_yoshika_01_attack_speed_buff") == false then
			local ability = self:FindAbilityByName("thtd_yoshika_01")
			ability:ApplyDataDrivenModifier(self, self, "modifier_yoshika_01_attack_speed_buff", nil)
		end
	else
		if self:HasModifier("modifier_yoshika_01_attack_speed_buff") then
			self:RemoveModifierByName("modifier_yoshika_01_attack_speed_buff")
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_keine_thtd_combo(combo)
	local comboVoiceTable = {}

	if HasCombo(combo,"mokou_keine") then
		if self.thtd_keine_03_chance ~= 50 then
			self.thtd_keine_03_chance = 50
		end
	else
		if self.thtd_keine_03_chance ~= 20 then
			self.thtd_keine_03_chance = 20
		end
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_sunny_thtd_combo(combo)
	local comboVoiceTable = {}

	if HasCombo(combo,"luna_star_sunny") and self.thtd_combo_fairyList == nil then		
		local hero = self:GetOwner()
		local sunny = nil
		local luna = nil
		local star = nil		
		local sunnyList = {}
		local lunaList = {}
		local starList = {}		
		for k,v in pairs(hero.thtd_hero_tower_list) do
			if v:GetUnitName() == "sunny" and v.thtd_fairy_combo_effectIndex~=true then
				table.insert(sunnyList,v)
			elseif v:GetUnitName() == "luna" and v.thtd_fairy_combo_effectIndex~=true then
				table.insert(lunaList,v)
			elseif v:GetUnitName() == "star" and v.thtd_fairy_combo_effectIndex~=true then
				table.insert(starList,v)
			end
		end		
		if #sunnyList > 0 and #lunaList > 0 and #starList > 0 then
			--最大连线距离
			local maxDistance = 2000
			for sunnyK,sunnyV in pairs(sunnyList) do
				for lunaK,lunaV in pairs(lunaList) do
					--计算连线距离，如果小于
					if math.floor(GetDistanceBetweenTwoVec2D(sunnyV:GetAbsOrigin(), lunaV:GetAbsOrigin()) + 0.5) <= maxDistance then 
						for starK,starV in pairs(starList) do
							--计算连线距离，如果小于
							if math.floor(GetDistanceBetweenTwoVec2D(starV:GetAbsOrigin(), lunaV:GetAbsOrigin()) + 0.5) <= maxDistance and math.floor(GetDistanceBetweenTwoVec2D(starV:GetAbsOrigin(), sunnyV:GetAbsOrigin()) + 0.5) <= maxDistance then 
								sunny = sunnyV
								luna = lunaV
								star = starV
								break
							end						
						end					
					end
					if sunny ~= nil then break end
				end
				if sunny ~= nil then break end
			end
		end

		if sunny~=nil and luna~=nil and star~=nil then	
			local sunny_effectIndex = ParticleManager:CreateParticle("particles/heroes/daiyousei/ability_daiyousei_03.vpcf", PATTACH_CUSTOMORIGIN, sunny)
			ParticleManager:SetParticleControlEnt(sunny_effectIndex , 0, sunny, 5, "attach_hitloc", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(sunny_effectIndex , 1, luna, 5, "attach_hitloc", Vector(0,0,0), true)

			local luna_effectIndex = ParticleManager:CreateParticle("particles/heroes/daiyousei/ability_daiyousei_03.vpcf", PATTACH_CUSTOMORIGIN, luna)
			ParticleManager:SetParticleControlEnt(luna_effectIndex , 0, luna, 5, "attach_hitloc", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(luna_effectIndex , 1, star, 5, "attach_hitloc", Vector(0,0,0), true)

			local star_effectIndex = ParticleManager:CreateParticle("particles/heroes/daiyousei/ability_daiyousei_03.vpcf", PATTACH_CUSTOMORIGIN, star)
			ParticleManager:SetParticleControlEnt(star_effectIndex , 0, star, 5, "attach_hitloc", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(star_effectIndex , 1, sunny, 5, "attach_hitloc", Vector(0,0,0), true)

			sunny.thtd_fairy_combo_effectIndex = sunny_effectIndex
			star.thtd_fairy_combo_effectIndex = luna_effectIndex
			luna.thtd_fairy_combo_effectIndex = star_effectIndex

			star.thtd_fairy_combo_sunny = sunny
			luna.thtd_fairy_combo_sunny = sunny

			self.thtd_combo_fairyList = 
			{				
				sunny = sunny,
				star = star,
				luna = luna,				
			}
		end
	elseif self.thtd_combo_fairyList ~= nil and (THTD_IsValid(self.thtd_combo_fairyList.star) == false or THTD_IsValid(self.thtd_combo_fairyList.luna) == false) then
		local v = self.thtd_combo_fairyList			
		if v.sunny~=nil and v.sunny:IsNull()==false and v.sunny.thtd_fairy_combo_effectIndex~=nil then
			ParticleManager:DestroyParticleSystem(v.sunny.thtd_fairy_combo_effectIndex,true)
			v.sunny.thtd_fairy_combo_effectIndex = nil	
			v.sunny.thtd_combo_fairyList = nil
		end
		if v.luna~=nil and v.luna:IsNull()==false and v.luna.thtd_fairy_combo_effectIndex~=nil then
			ParticleManager:DestroyParticleSystem(v.luna.thtd_fairy_combo_effectIndex,true)
			v.luna.thtd_fairy_combo_effectIndex = nil
			v.luna.thtd_fairy_combo_sunny = nil
		end
		if v.star~=nil and v.star:IsNull()==false and v.star.thtd_fairy_combo_effectIndex~=nil then
			ParticleManager:DestroyParticleSystem(v.star.thtd_fairy_combo_effectIndex,true)
			v.star.thtd_fairy_combo_effectIndex = nil
			v.star.thtd_fairy_combo_sunny = nil
		end		
	end
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_star_thtd_combo(combo)
	local comboVoiceTable = {}

	local sunny = self.thtd_fairy_combo_sunny
	local effectIndex = self.thtd_fairy_combo_effectIndex

	if effectIndex ~= nil then
		if THTD_IsValid(sunny) == false then 
			ParticleManager:DestroyParticleSystem(effectIndex,true)
			self.thtd_fairy_combo_effectIndex = nil 
			self.thtd_fairy_combo_sunny = nil 
			if sunny~=nil and sunny:IsNull()==false and sunny.thtd_fairy_combo_effectIndex~=nil then 
				ParticleManager:DestroyParticleSystem(sunny.thtd_fairy_combo_effectIndex,true)
				sunny.thtd_fairy_combo_effectIndex = nil	
				sunny.thtd_combo_fairyList = nil
			end
		end
	end
	
	combo = {}
	return comboVoiceTable
end

function CDOTA_BaseNPC:THTD_luna_thtd_combo(combo)
	return self:THTD_star_thtd_combo(combo)
end


function CDOTA_BaseNPC:THTD_junko_thtd_combo(combo)
	local comboVoiceTable = {}

	if HasCombo(combo,"junko_hecatia") then
		if self.thtd_junko_04_duration ~= 2 then
			self.thtd_junko_04_duration = 2
		end
	else
		if self.thtd_junko_04_duration ~= 1 then
			self.thtd_junko_04_duration = 1
		end
	end
	combo = {}
	return comboVoiceTable
end

function HasCombo(combo,name)
	for k,v in pairs(combo) do
		if k == name then
			return true
		end
	end
	return false
end

function UpdatePrismriver01ComboName(caster,target)
	if target.thtd_prismriver_01_comboName == nil then
		target.thtd_prismriver_01_comboName = {}		
	end
	table.insert(target.thtd_prismriver_01_comboName,caster:GetUnitName())
	if #target.thtd_prismriver_01_comboName > 3 then table.remove(target.thtd_prismriver_01_comboName,1) end
	if #target.thtd_prismriver_01_comboName > 3 then table.remove(target.thtd_prismriver_01_comboName,1) end
end

function GetPrismriver01ComboName(target)
	if target.thtd_prismriver_01_comboName == nil then return nil end
	local comboName = ""
	for k,v in pairs(target.thtd_prismriver_01_comboName) do
		comboName = comboName..v
	end
	return comboName	
end

function ResetPrismriver01ComboName(target)
	target.thtd_prismriver_01_comboName = {}
end

function GetCountPrismriver01ComboName(target)
	if target.thtd_prismriver_01_comboName == nil then return 0 end
	return #target.thtd_prismriver_01_comboName
end
