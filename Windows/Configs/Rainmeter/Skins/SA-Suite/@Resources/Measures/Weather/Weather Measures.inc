; © 2021 by Saber Akiyama

; Modified by Saber Akiyama. September 15th, 2020 :: Designed to work as an @include file for TWC weather data retrieval

[MeasureInternetConnectivity]
; Returns the status of the internet connection.
; Changes error text depending on situation.
Measure=Plugin
Plugin=SysInfo
SysInfoType=INTERNET_CONNECTIVITY
SysInfoData=Best
; -1: No Internet, 1: Connected
IfCondition=(MeasureInternetConnectivity=-1)
IfTrueAction=[!CommandMeasure LuaWeather "netError()"]
IfFalseAction=[!CommandMeasure LuaWeather "netConnect()"]

[MeasureWeatherCore]
Measure=WebParser
Url=#URL#
UserAgent=Mozilla/5.0 (Windows NT 10; Win64; x64; rx:85.0) Gecko/20100101 Firefox/85.0
Flags=Resync | ForceReload
RegExp=(?siU)^(.*)$
UpdateRate=1
LogSubstringErrors=0
OnRegExpErrorAction=[!CommandMeasure LuaWeather "errorNet()"]
OnConnectErrorAction=[!CommandMeasure LuaWeather "errorNet()"]
UpdateDivider=-1
Paused=1

[MeasureWeatherUpdate]
; Returns weather update every 30 minutes (or 1800 seconds).
Measure=Time
Format=%#H:%M
OnUpdateAction=[!CommandMeasure LuaWeather "updateWeather()"]
DynamicVariables=1
UpdateDivider=1800

[MeasureWeatherTime]
; Sets Time Format enabled or disabled depending on #SunMoonToggle# (which is controlled by context menu options).
Measure=Calc
; 0: Disabled Trim Text, 1: Enabled Trim Text
IfCondition=(#SunMoonToggle#=0)
IfTrueAction=[!CommandMeasure LuaWeather "setSunMoon('12 Hours')"]
IfFalseAction=[!CommandMeasure LuaWeather "setSunMoon('24 Hours')"]
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
UpdateDivider=-1
Paused=1
Disabled=1

; ====================================================================
; 							CURRENT MEASURES
; ====================================================================

[MeasureWeather]
Measure=WebParser
Url=[MeasureWeatherCore]
RegExp=#Weather#
LogSubstringErrors=0
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
FinishAction=[!CommandMeasure LuaWeather "finishWeather()"]
DynamicVariables=1
UpdateDivider=-1
Paused=1

[MeasureCountry]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=1
Substitute='"':""
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureCity]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=2
Substitute='"':""
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureIcon]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=3
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
Paused=1
Disabled=1

[MeasureHumidity]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=4
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
Paused=1
Disabled=1

[MeasureCurrentTemperature]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=5
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
Paused=1
Disabled=1

[MeasureFeelsLike]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=6
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
Paused=1
Disabled=1

[MeasureVisibility]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=7
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
Paused=1
Disabled=1

[MeasureWindCardinal]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=8
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWindSpeed]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=9
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
Paused=1
Disabled=1

[MeasureCondition]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=10
DecodeCharacterReference=1
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

; ====================================================================================================

[MeasureWeatherDay1]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=11
Substitute=#WeatherDateText#
OnChangeAction=[!UpdateMeter MeterDay1]
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWeatherDay2]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=12
Substitute=#WeatherDateText#
OnChangeAction=[!UpdateMeter MeterDay2]
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWeatherDay3]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=13
Substitute=#WeatherDateText#
OnChangeAction=[!UpdateMeter MeterDay3]
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWeatherDay4]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=14
Substitute=#WeatherDateText#
OnChangeAction=[!UpdateMeter MeterDay4]
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWeatherDay5]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=15
Substitute=#WeatherDateText#
OnChangeAction=[!UpdateMeter MeterDay5]
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWeatherDay6]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=16
Substitute=#WeatherDateText#
OnChangeAction=[!UpdateMeter MeterDay6]
Group=SuiteWeatherMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

; ====================================================================================================

[MeasureMoonrise24H]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=17
RegExpSubstitute=1
Substitute="^.*T(.*):.*$":"\1"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

[MeasureMoonset24H]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=18
RegExpSubstitute=1
Substitute="^.*T(.*):.*$":"\1"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

[MeasureMoonrise12H]
Measure=Time
TimeStamp=[MeasureMoonrise24H]
TimeStampFormat=%H:%S
Format=%#I:%S %p
Substitute="AM":"am","PM":"pm"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

[MeasureMoonset12H]
Measure=Time
TimeStamp=[MeasureMoonset24H]
TimeStampFormat=%H:%S
Format=%#I:%S %p
Substitute="AM":"am","PM":"pm"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

; ====================================================================================================

[MeasureSunrise24H]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=19
RegExpSubstitute=1
Substitute="^.*T(.*):.*$":"\1"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

[MeasureSunset24H]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=20
RegExpSubstitute=1
Substitute="^.*T(.*):.*$":"\1"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

[MeasureSunrise12H]
Measure=Time
TimeStamp=[MeasureSunrise24H]
TimeStampFormat=%H:%S
Format=%#I:%S %p
Substitute="AM":"am","PM":"pm"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

[MeasureSunset12H]
Measure=Time
TimeStamp=[MeasureSunset24H]
TimeStampFormat=%H:%S
Format=%#I:%S %p
Substitute="AM":"am","PM":"pm"
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure
DynamicVariables=1
Paused=1
Disabled=1

; ===============================TEMP MAX MEASURES==================================

[MeasureTempMax1]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=21
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMax2]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=22
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMax3]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=23
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMax4]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=24
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMax5]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=25
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMax6]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=26
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

;===============================TEMP MIN MEASURES==================================

[MeasureTempMin1]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=27
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMin2]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=28
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMin3]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=29
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMin4]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=30
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMin5]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=31
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureTempMin6]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=32
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

;========================DAILY ICON CODES MEASURES============================

[MeasureDailyIconDay1]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=33
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyIconDay2]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=34
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyIconDay3]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=35
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyIconDay4]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=36
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyIconDay5]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=37
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyIconDay6]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=38
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

;========================DAILY CONDITION MEASURES============================

[MeasureDailyConditionDay1]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=39
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyConditionDay2]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=40
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyConditionDay3]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=41
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyConditionDay4]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=42
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyConditionDay5]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=43
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

[MeasureDailyConditionDay6]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=44
Group=SuiteWeatherMeasure
Paused=1
Disabled=1

; ====================================================================
; 						WEATHER PARAMETER MEASURES
; ====================================================================

[MeasureVisKm]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=45
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWindKmh]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=46
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureVisMi]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=47
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureWindMph]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=48
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
DecodeCodePoints=1
Paused=1
Disabled=1

[MeasureFeelsLikeText]
Measure=WebParser
Url=[MeasureWeather]
StringIndex=49
Group=SuiteWeatherMeasure | SuiteWeatherSlimMeasure | SuiteWeatherSlimExtraMeasure
DecodeCodePoints=1
Paused=1
Disabled=1
