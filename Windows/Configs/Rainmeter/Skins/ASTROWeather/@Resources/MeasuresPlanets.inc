
; © 2024 by xenium


[MeasurePlanets]
Measure=WebParser
Url=#URLPlanets#
RegExp=#PlanetsRiseSet#
UpdateRate=3600
UserAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0
Flags=Resync | NoCookies
LogSubstringErrors=0
FinishAction=[!EnableMeasureGroup Time]

[MeasureMercuryRise]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=1

[MeasureMercurySet]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=2

[MeasureMercuryRiseTimeFormat12H]
Measure=Time
TimeStamp=[MeasureMercuryRise]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureMercurySetTimeFormat12H]
Measure=Time
TimeStamp=[MeasureMercurySet]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureVenusRise]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=3

[MeasureVenusSet]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=4

[MeasureVenusRiseTimeFormat12H]
Measure=Time
TimeStamp=[MeasureVenusRise]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureVenusSetTimeFormat12H]
Measure=Time
TimeStamp=[MeasureVenusSet]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureMarsRise]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=5

[MeasureMarsSet]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=6

[MeasureMarsRiseTimeFormat12H]
Measure=Time
TimeStamp=[MeasureMarsRise]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureMarsSetTimeFormat12H]
Measure=Time
TimeStamp=[MeasureMarsSet]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureJupiterRise]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=7

[MeasureJupiterSet]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=8

[MeasureJupiterRiseTimeFormat12H]
Measure=Time
TimeStamp=[MeasureJupiterRise]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureJupiterSetTimeFormat12H]
Measure=Time
TimeStamp=[MeasureJupiterSet]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureSaturnRise]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=9

[MeasureSaturnSet]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=10

[MeasureSaturnRiseTimeFormat12H]
Measure=Time
TimeStamp=[MeasureSaturnRise]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureSaturnSetTimeFormat12H]
Measure=Time
TimeStamp=[MeasureSaturnSet]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureUranusRise]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=11

[MeasureUranusSet]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=12

[MeasureUranusRiseTimeFormat12H]
Measure=Time
TimeStamp=[MeasureUranusRise]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureUranusSetTimeFormat12H]
Measure=Time
TimeStamp=[MeasureUranusSet]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureNeptuneRise]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=13

[MeasureNeptuneSet]
Measure=WebParser
Url=[MeasurePlanets]
StringIndex=14

[MeasureNeptuneRiseTimeFormat12H]
Measure=Time
TimeStamp=[MeasureNeptuneRise]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1

[MeasureNeptuneSetTimeFormat12H]
Measure=Time
TimeStamp=[MeasureNeptuneSet]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
DynamicVariables=1
Group=Time
Disabled=1




; © 2024 by xenium