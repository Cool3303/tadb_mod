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
	if HasCombo(combo,"ld_cirno") then
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
	if HasCombo(combo,"ld_cirno") then
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
	if HasCombo(combo,"reimu_marisa") then
		if ability01:GetLevel()~=2 then
			ability01:SetLevel(2)
			table.insert(comboVoiceTable,self:THTD_GetComboVoice("reimu_marisa"))
		end
	else
		if ability01:GetLevel()>1 then
			ability01:SetLevel(1)
		end
	end
	local ability03 = self:FindAbilityByName("thtd_marisa_03")
	if HasCombo(combo,"reimu_marisa") then
		if ability03:GetLevel()==1 then
			ability03:SetLevel(2)
		end
	else
		if ability03:GetLevel()==2 then
			ability03:SetLevel(1)
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

function HasCombo(combo,name)
	for k,v in pairs(combo) do
		if k == name then
			return true
		end
	end
	return false
end