; © 2021 by Saber Akiyama

; Modified by Saber Akiyama. September 15th, 2020 :: Combined variables to work as an @include file for TWC weather data retrieval

; ################# ONE-TIME SETUP INSTRUCTIONS #############################

; ===========================================================================
; DO NOT CHANGE THIS FILE UNLESS YOU ARE SURE YOU KNOW WHAT YOU ARE DOING !!!
; ===========================================================================

[Variables]

LangLoc=en-CA

LocationCode=SFXX0010

; ===========================================================================
; Weather Data

URL=https://weather.com/#LangLoc#/weather/today/l/#LocationCode#

Weather=(?siU)\\"getSunV3LocationPointUrlConfig\\":.*{.*\\"country\\":\\"(.*)\\",.*\\"displayName\\":\\"(.*)\\",.*}.*\\"getSunV3CurrentObservationsUrlConfig\\":{.*\\"iconCode\\":(.*),.*\\"relativeHumidity\\":(.*),.*\\"temperature\\":(.*),.*\\"temperatureFeelsLike\\":(.*),.*\\"visibility\\":(.*),.*\\"windDirectionCardinal\\":\\"(.*)\\",.*\\"windSpeed\\":(.*),\\"wxPhraseLong\\":\\"(.*)\\",.*}.*\\"getSunV3DailyForecastWithHeadersUrlConfig\\":.*{.*\\"dayOfWeek\\":.*,\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",.*\\"moonriseTimeLocal\\":.\\"(.*)\\",.*\\"moonsetTimeLocal\\":.\\"(.*)\\",.*\\"sunriseTimeLocal\\":.\\"(.*)\\",.*\\"sunsetTimeLocal\\":.\\"(.*)\\",.*\\"temperatureMax\\":.*,(.*),(.*),(.*),(.*),(.*),(.*),.*\\"temperatureMin\\":.*,(.*),(.*),(.*),(.*),(.*),(.*),.*\\"iconCode\\":.*,.*,(.*),.*,(.*),.*,(.*),.*,(.*),.*,(.*),.*,(.*),.*\\"wxPhraseLong\\":.*,.*,\\"(.*)\\",.*,\\"(.*)\\",.*,\\"(.*)\\",.*,\\"(.*)\\",.*,\\"(.*)\\",.*,\\"(.*)\\",.*}.*(?siU)\\"wxu-general\\":{.*\\"km\\":\\"(.*)\\",\\"km/h\\":\\"(.*)\\",.*\\"mi\\":\\"(.*)\\",.*\\"mph\\":\\"(.*)\\",.*},.*\\"wxu-today-details\\":{.*\\"feelsLike\\":\\"(.*)\\",.*},.*
