; Do NOT change this file unless you are sure you know what you are doing !!!
; ========================================================================

; © 2024 by xenium

;Weather.com API

[Variables]
@Include=#@#Variables.inc

Location=(?siU)"v3-location-point":.*{"location":{"latitude":(.*),"longitude":(.*),.*,"adminDistrict":(.*),"adminDistrictCode":(.*),.*,"country":(.*),"countryCode":(.*),.*,"displayName":(.*),.*}

CurrentObservations=(?siU)"v3-wx-observations-current":.*{"cloudCeiling":.*,"cloudCoverPhrase":".*","dayOfWeek":".*","dayOrNight":".*","expirationTimeUtc":.*,"iconCode":(.*),"iconCodeExtend":.*,"obsQualifierCode":.*,"obsQualifierSeverity":.*,"precip1Hour":.*,"precip6Hour":.*,"precip24Hour":.*,"pressureAltimeter":(.*),"pressureChange":(.*),"pressureMeanSeaLevel":.*,"pressureTendencyCode":.*,"pressureTendencyTrend":"(.*)","relativeHumidity":(.*),"snow1Hour":.*,"snow6Hour":.*,"snow24Hour":.*,"sunriseTimeLocal":.*,"sunriseTimeUtc":.*,"sunsetTimeLocal":.*,"sunsetTimeUtc":.*,"temperature":(.*),"temperatureChange24Hour":.*,"temperatureDewPoint":(.*),"temperatureFeelsLike":(.*),"temperatureHeatIndex":.*,"temperatureMax24Hour":.*,"temperatureMaxSince7Am":.*,"temperatureMin24Hour":.*,"temperatureWindChill":.*,"uvDescription":"(.*)","uvIndex":(.*),"validTimeLocal":"(.*)","validTimeUtc":.*,"visibility":(.*),"windDirection":(.*),"windDirectionCardinal":"(.*)","windGust":(.*),"windSpeed":(.*),"wxPhraseLong":"(.*)","wxPhraseMedium":.*,"wxPhraseShort":.*}

DailyForecastMOON=(?siU)"v3-wx-forecast-daily-15day":.*{.*"moonPhase":."(.*)",.*,"moonPhaseCode":.*"(.*)",.*"moonriseTimeLocal":.*"(.*)","(.*)",.*,"moonsetTimeLocal":.*"(.*)","(.*)",.*

DailyForecastSUN=(?siU)"v3-wx-forecast-daily-15day":.*{.*"sunriseTimeLocal":.*"(.*)","(.*)",.*,"sunsetTimeLocal":.*"(.*)","(.*)",.*

DailyForecastTempMax=(?siU)"v3-wx-forecast-daily-15day":.*{.*"temperatureMax":(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),.*

DailyForecastTempMin=(?siU)"v3-wx-forecast-daily-15day":.*{.*"temperatureMin":(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),.*

DailyForecastDate=(?siU)"v3-wx-forecast-daily-15day":.*{.*"validTimeLocal":.*"(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)"

DailyForecastDayPart=(?siU)"v3-wx-forecast-daily-15day":.*{.*"daypartName":(.*),"(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)"

DailyForecastIconCode=(?siU)"v3-wx-forecast-daily-15day":.*{.*"iconCode":(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),.*

DailyForecastDetails=(?siU)"v3-wx-forecast-daily-15day":.*{.*"iconCode":.*"narrative":(.*),"(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)"

DailyForecastPrecip=(?siU)"v3-wx-forecast-daily-15day":.*{.*"precipChance":(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),.*

DailyForecastCondition=(?siU)"v3-wx-forecast-daily-15day":.*{.*"wxPhraseLong":(.*),"(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)"

HourlyForecastIconCode=(?siU)"v3-wx-forecast-hourly-12hour":.*{.*"iconCode":(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),.*

HourlyForecastTemp=(?siU)"v3-wx-forecast-hourly-12hour":.*{.*"temperature":(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),.*

HourlyForecastHour=(?siU)"v3-wx-forecast-hourly-12hour":.*{.*"validTimeLocal":.*"(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)"

HourlyForecastCondition=(?siU)"v3-wx-forecast-hourly-12hour":.*{.*"wxPhraseLong":(.*),"(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)","(.*)"

PlanetsRiseSet=(?siU)(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>.*</td></tr><tr><td>Set</td><td>.*</td></tr></table></td>).*(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>(.*)</td></tr><tr><td>Set</td><td>(.*)</td></tr></table></td>).*(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>(.*)</td></tr><tr><td>Set</td><td>(.*)</td></tr></table></td>).*(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>(.*)</td></tr><tr><td>Set</td><td>(.*)</td></tr></table></td>).*(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>(.*)</td></tr><tr><td>Set</td><td>(.*)</td></tr></table></td>).*(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>(.*)</td></tr><tr><td>Set</td><td>(.*)</td></tr></table></td>).*(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>(.*)</td></tr><tr><td>Set</td><td>(.*)</td></tr></table></td>).*(?(?=.*<td><table class="risesetinfo">).*<tr><td>Rise</td><td>(.*)</td></tr><tr><td>Set</td><td>(.*)</td></tr></table></td>).*



; © 2024 by xenium






