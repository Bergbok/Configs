[MeasureTimeFormatSet]
; Sets 12-hr or 24-hr time format depending on #24HourTimeSet# (which is controlled by context menu options).
Measure=Calc
; 0: 12-hr time format, 1: 24-hr time format
IfCondition=(#24HourTimeSet#=0)
IfTrueAction=[!CommandMeasure LuaClock "twelvehourTime()"]
IfFalseAction=[!CommandMeasure LuaClock "twentyfourhourTime()"]
DynamicVariables=1
UpdateDivider=-1

; ====================================================================================================

[MeasureTime]
Measure=Time
Format=%#I:%M
Group=TimeMeasures
OnChangeAction=[!UpdateMeasure MeasureTimeFormatSet]

[MeasureTimeSec]
Measure=Time
Format=%S
Group=TimeMeasures
OnChangeAction=[!UpdateMeasure MeasureTimeFormatSet]

[MeasureDay]
Measure=Time
Format=%A
Group=TimeMeasures
Substitute=#DateText#

[MeasureDate]
Measure=Time
Format=%B %#d, %Y
Group=TimeMeasures
Substitute=#MonthText#
