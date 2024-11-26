--; ============================================================
--; Lua Clock
--; ============================================================

function twelvehourTime()
	SKIN:Bang('!SetOption MeasureTime Format "%#I:%M"')
	SKIN:Bang('!SetOption MeasureTimeSec Format "%S%p"')
	SKIN:Bang('!UpdateMeasureGroup TimeMeasures')
	SKIN:Bang('!UpdateMeterGroup TimeMeter')

end

function twentyfourhourTime()
	SKIN:Bang('!SetOption MeasureTime Format "%#H:%M"')
	SKIN:Bang('!SetOption MeasureTimeSec Format "%S"')
	SKIN:Bang('!UpdateMeasureGroup TimeMeasures')
	SKIN:Bang('!UpdateMeterGroup TimeMeter')

end

function scaleUpClock()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#+#ScrollMouseIncrement#)" "#CoreFilePath#"')
	SKIN:Bang('!UpdateMeterGroup ClockGroup')

end

function scaleDownClock()
	SKIN:Bang('!WriteKeyValue Variables SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#@#Variables.inc"')
	SKIN:Bang('!SetVariable SuiteScale "(#SuiteScale#-#ScrollMouseIncrement# < 0.5 ? 0.5 : #SuiteScale#-#ScrollMouseIncrement#)" "#CoreFilePath#"')
	SKIN:Bang('!UpdateMeterGroup ClockGroup')

end

timeSet = {
	["12 Hours"] = {
		varTime = "0",
		coreTime = "0"
	},
	["24 Hours"] = {
		varTime = "1",
		coreTime = "1"
	}
}

function setTime(selectedTime)
	SKIN:Bang('!SetVariable 24HourTimeSet "' .. timeSet[selectedTime]['varTime'] .. '"')
	SKIN:Bang('!WriteKeyValue Variables 24HourTimeSet "' .. timeSet[selectedTime]['coreTime'] .. '" #CoreFilePath#')
	SKIN:Bang('!UpdateMeasure MeasureTimeFormatSet')

end
