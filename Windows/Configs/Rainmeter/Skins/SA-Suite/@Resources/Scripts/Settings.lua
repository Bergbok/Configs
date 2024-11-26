--; ============================================================
--; Lua Settings
--; ============================================================

settingSelect = {
	["Info"] = {
		pageLine = "80"
	},
	["Skins"] = {
		pageLine = "130"
	},
	["Weather"] = {
		pageLine = "180",
	},
	["Language"] = {
		pageLine = "230"
	}
}

function setSettings(selectedSettings)
	SKIN:Bang('!WriteKeyValue Variables Page "' .. selectedSettings .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables PageLine "' .. settingSelect[selectedSettings]['pageLine'] .. '" "#@#Variables.inc"')

	SKIN:Bang('!Refresh')

end

function resetSuite()
	SKIN:Bang('!WriteKeyValue Variables TypeFace "Roboto" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables ColorCode "255,255,255" "#@#Variables.inc"')

	SKIN:Bang('!RefreshGroup Suite')

end

function closeSettings()
	SKIN:Bang('!DeactivateConfig "#ROOTCONFIG#" "Settings.ini"')
	SKIN:Bang('!WriteKeyValue Variables Page "Info" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables PageLine "80" "#@#Variables.inc"')

end
