--; ============================================================
--; Lua Weather Slim
--; ============================================================

function netError()
	SKIN:Bang('!Log "Connect to internet and try again." Warning')
	SKIN:Bang('!PauseMeasure MeasureWeatherCore')

end

function netConnect()
	SKIN:Bang('!Log "Connecting..." Notice')
	SKIN:Bang('!Log "#RetrievingText#"')

	SKIN:Bang('!UnpauseMeasure MeasureWeatherCore')
	SKIN:Bang('!UnpauseMeasure MeasureWeather')
	SKIN:Bang('!UnpauseMeasureGroup SuiteWeatherSlimMeasure')
	SKIN:Bang('!HideMeterGroup SuiteWeatherSlimMeter')
	SKIN:Bang('!UpdateMeasure MeasureWeatherCore')

end

function errorNet()
	SKIN:Bang('!Log "No connection or timeout" Error')

end

function startWeather()
	SKIN:Bang('!Log "Awake!"')
	SKIN:Bang('!UpdateMeasure MeasureInternetConnectivity')
	
end

function updateWeather()
	SKIN:Bang('!UpdateMeasure MeasureWeatherCore')

	SKIN:Bang('!ShowMeter MeterWeatherRetrieve')
	SKIN:Bang('!HideMeterGroup SuiteWeatherSlimMeter')
	SKIN:Bang('!DisableMeasureGroup SuiteWeatherSlimMeasure')

end

function finishWeather()
	SKIN:Bang('!Log "#RetrievedWeatherText#"')

	SKIN:Bang('!HideMeter MeterWeatherRetrieve')
	SKIN:Bang('!ShowMeterGroup SuiteWeatherSlimMeter')
	SKIN:Bang('!EnableMeasureGroup SuiteWeatherSlimMeasure')

	SKIN:Bang('!UpdateMeter *')

end

--; ====================================================================

function scaleUpWeather()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#CoreFilePath#"')
	SKIN:Bang('!UpdateMeterGroup SuiteWeatherSlimMeter')
	
end

function scaleDownWeather()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#CoreFilePath#"')
	SKIN:Bang('!UpdateMeterGroup SuiteWeatherSlimMeter')

end

--; ====================================================================

sunmoonTime = {
	["12 Hours"] = {
		coreSMTime = "12H",
		varSMTime = "12H",
		varSMToggle = "0"
	},
	["24 Hours"] = {
		coreSMTime = "24H",
		varSMTime = "24H",
		varSMToggle = "1"
	}
}

function setSunMoon(selectedTime)
	SKIN:Bang('!SetVariable SunMoonTime "' .. sunmoonTime[selectedTime]['coreSMTime'] .. '"')
	SKIN:Bang('!WriteKeyValue Variables SunMoonTime "' .. sunmoonTime[selectedTime]['varSMTime'] .. '" "#CoreFilePath#"')
	SKIN:Bang('!WriteKeyValue Variables SunMoonTime "' .. sunmoonTime[selectedTime]['varSMTime'] .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables SunMoonToggle "' .. sunmoonTime[selectedTime]['varSMToggle'] .. '" "#@#Variables.inc"')

	SKIN:Bang('!UpdateMeterGroup WeatherSunMoonTime')
	
end
