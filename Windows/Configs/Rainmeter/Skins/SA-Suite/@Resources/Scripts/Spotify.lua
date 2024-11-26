--; ============================================================
--; Lua Media
--; ============================================================

trimText = {
	["Enabled"] = {
		varTrim = "1",
		coreTrim = "1"
	},
	["Disabled"] ={
		varTrim = "0",
		coreTrim = "0"
	}
}

function setTrim(selectedTrim)
	SKIN:Bang('!SetVariable TrimText "' .. trimText[selectedTrim]['varTrim'] .. '"')
	SKIN:Bang('!WriteKeyValue Variables TrimText "' .. trimText[selectedTrim]['coreTrim'] .. '" #CoreFilePath#')
	SKIN:Bang('!UpdateMeasure MeasureTrimText')

end

function disabledTrim()
	SKIN:Bang('!SetOption MeasureTitle RegExpSubstitute "0"')
	SKIN:Bang('!SetOption MeasureArtist RegExpSubstitute "0"')
	SKIN:Bang('!SetOption MeasureAlbum RegExpSubstitute "0"')
	SKIN:Bang('!UpdateMeasureGroup SpotifyMeasure')
	SKIN:Bang('!UpdateMeterGroup SpotifyMeter')

end

function enabledTrim()
	SKIN:Bang('!SetOption MeasureTitle RegExpSubstitute "1"')
	SKIN:Bang('!SetOption MeasureArtist RegExpSubstitute "1"')
	SKIN:Bang('!SetOption MeasureAlbum RegExpSubstitute "1"')
	SKIN:Bang('!UpdateMeasureGroup SpotifyMeasure')
	SKIN:Bang('!UpdateMeterGroup SpotifyMeter')

end

function scaleUpSpotify()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#CoreFilePath#"')
	SKIN:Bang('!UpdateMeterGroup SpotifyMeter')

end

function scaleDownSpotify()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#CoreFilePath#"')
	SKIN:Bang('!UpdateMeterGroup SpotifyMeter')

end
