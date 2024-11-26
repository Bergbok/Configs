--; ============================================================
--; Lua Weather Extra Slim
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
	SKIN:Bang('!UnpauseMeasureGroup SuiteWeatherSlimExtraMeasure')
	SKIN:Bang('!HideMeterGroup SuiteWeatherSlimExtraMeter')
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
	SKIN:Bang('!HideMeterGroup SuiteWeatherSlimExtraMeter')
	SKIN:Bang('!DisableMeasureGroup SuiteWeatherSlimExtraMeasure')

end

function finishWeather()
	SKIN:Bang('!Log "#RetrievedWeatherText#"')

	SKIN:Bang('!HideMeter MeterWeatherRetrieve')
	SKIN:Bang('!ShowMeterGroup SuiteWeatherSlimExtraMeter')
	SKIN:Bang('!EnableMeasureGroup SuiteWeatherSlimExtraMeasure')

	SKIN:Bang('!UpdateMeter *')

end

--; ====================================================================

function scaleUpWeather()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#CoreFilePath#"')

	SKIN:Bang('!UpdateMeterGroup SuiteWeatherSlimExtraMeter')

end

function scaleDownWeather()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#CoreFilePath#"')

	SKIN:Bang('!UpdateMeterGroup SuiteWeatherSlimExtraMeter')

end
