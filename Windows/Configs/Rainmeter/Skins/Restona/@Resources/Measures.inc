
; © 2023 by xenium

;Weather.com API


[WEATHER.COMSuperParent]
Measure=WebParser
URL=#URL#
UpdateRate=600
UserAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0
Flags=Resync | NoCookies
DecodeCharacterReference=1
LogSubstringErrors=0
RegExp=(?siU)^(.*)$
StringIndex=1
FinishAction=[!EnableMeasureGroup Parents]


; ========================================
;                 LOCATION
; ========================================

[MeasureLocation]
Measure=WebParser
Group=Parents
URL=[WEATHER.COMSuperParent]
Disabled=1
StringIndex=1
RegExp=#Location#
LogSubstringErrors=0

[MeasureAdminDistrictCode]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=4
Substitute="null":"",'"':""
DecodeCodePoints=1

[MeasureCountry]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=5
Substitute="null":"",'"':""
DecodeCodePoints=1

[MeasureCity]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=7
Substitute="null":"",'"':""
DecodeCodePoints=1



; ========================================
;             CURRENT WEATHER
; ========================================


[MeasureCurrentObservations]
Measure=WebParser
Group=Parents
URL=[WEATHER.COMSuperParent]
Disabled=1
StringIndex=1
RegExp=#CurrentObservations#
LogSubstringErrors=0
FinishAction=[!EnableMeasureGroup Time]

[MeasureIcon]
Measure=WebParser
Url=[MeasureCurrentObservations]
StringIndex=1

[MeasureTemperature]
Measure=WebParser
Url=[MeasureCurrentObservations]
StringIndex=6

[MeasureFeelsLike]
Measure=WebParser
Url=[MeasureCurrentObservations]
StringIndex=8

[MeasureUpdate]
Measure=WebParser
Url=[MeasureCurrentObservations]
StringIndex=11
RegExpSubstitute=1
Substitute="^.*T(.*):.*$":"\1"

[MeasureUpdateTimeFormat12H]
Measure=Time
DynamicVariables=1
TimeStamp=[MeasureUpdate]
TimeStampFormat=%H:%M
Format=%#I:%M %p
Substitute="AM":"am","PM":"pm"
Group=Time
Disabled=1

[MeasureCondition]
Measure=WebParser
Url=[MeasureCurrentObservations]
StringIndex=16
Substitute="\u002F":"/"

[MeasureUpdateTimeZoneAbbrev]
Measure=WebParser
URL=https://api.weather.com/v3/dateTime?geocode=#Latitude#,#Longitude#&format=json&apiKey=#APIKey#
RegExp=(?siU)"timeZoneAbbreviation":"(.*)"
UpdateRate=600
Flags=Resync | NoCookies
UserAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0
StringIndex=1



;===== DAILY PRECIPITATION CHANCE ======


[MeasureDailyForecastPrecip]
Measure=WebParser
Group=Parents
URL=[WEATHER.COMSuperParent]
Disabled=1
StringIndex=1
RegExp=#DailyForecastPrecip#
LogSubstringErrors=0

[MeasureDailyPrecipDay1]
Measure=WebParser
Url=[MeasureDailyForecastPrecip]
StringIndex=1
Substitute="[":"","null":"[MeasureDailyPrecipNight1]"
DynamicVariables=1

[MeasureDailyPrecipNight1]
Measure=WebParser
Url=[MeasureDailyForecastPrecip]
StringIndex=2



;===== DAILY PRECIPITATION TYPE ======


[MeasureDailyForecastPrecipType]
Measure=WebParser
Group=Parents
URL=[WEATHER.COMSuperParent]
Disabled=1
StringIndex=1
RegExp=#DailyForecastPrecipType#
LogSubstringErrors=0

[MeasureDailyPrecipTypeDay1]
Measure=WebParser
Url=[MeasureDailyForecastPrecipType]
StringIndex=1
Substitute="[":"","null":"[MeasureDailyPrecipTypeNight1]"
DynamicVariables=1

[MeasureDailyPrecipTypeNight1]
Measure=WebParser
Url=[MeasureDailyForecastPrecipType]
StringIndex=2



; ========================================
;             AIR QUALITY
; ========================================


[WEATHER.COMAirQualitySuperParent]
Measure=WebParser
URL=#URL3#
UpdateRate=600
Flags=Resync | NoCookies
UserAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0
DecodeCharacterReference=1
LogSubstringErrors=0
RegExp=(?siU)^(.*)$
StringIndex=1
FinishAction=[!EnableMeasureGroup AirQualityParents]

[MeasureAirQuality]
Measure=WebParser
Group=AirQualityParents
Url=[WEATHER.COMAirQualitySuperParent]
Disabled=1
StringIndex=1
RegExp=#AirQuality#
LogSubstringErrors=0

[MeasureAirQualityIndex]
Measure=WebParser
Url=[MeasureAirQuality]
StringIndex=1

[MeasureAirQualityCategory]
Measure=WebParser
Url=[MeasureAirQuality]
StringIndex=2

[MeasureAirQualityCategoryIndex]
Measure=WebParser
Url=[MeasureAirQuality]
StringIndex=3



; © 2023 by xenium



















































