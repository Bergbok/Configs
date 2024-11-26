--; ============================================================
--; Lua Weather
--; ============================================================

function setWeather()
	SKIN:Bang('!CommandMeasure MeterSkinInputWeather "ExecuteBatch 1"')
	
end

function setWeatherApply()
	SKIN:Bang('!RefreshGroup WeatherSuite')

end

function openLocation()
	SKIN:Bang('"https://weather.codes"')

end
