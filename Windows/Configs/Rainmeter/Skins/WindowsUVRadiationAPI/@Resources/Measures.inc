
; © 2023 by xenium

;Weather.com API


[WEATHER.COMSuperParent]
Measure=WebParser
URL=#URL#
UpdateRate=600
UserAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
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

[MeasureLatitude]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=1
Substitute="null":"",'"':""

[MeasureLongitude]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=2
Substitute="null":"",'"':""

[MeasureAdminDistrict]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=3
Substitute="null":"",'"':""

[MeasureAdminDistrictCode]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=4
Substitute="null":"",'"':""

[MeasureCountry]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=5
Substitute="null":"",'"':""

[MeasureCountryCode]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=6
Substitute="null":"",'"':""

[MeasureCity]
Measure=WebParser
Url=[MeasureLocation]
StringIndex=7
Substitute="null":"",'"':""



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

[MeasureUVDescription]
Measure=WebParser
Url=[MeasureCurrentObservations]
StringIndex=9

[MeasureUVIndex]
Measure=WebParser
Url=[MeasureCurrentObservations]
StringIndex=10


; © 2023 by xenium



















































