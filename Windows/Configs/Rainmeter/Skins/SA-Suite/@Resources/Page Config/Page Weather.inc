[MeterWeatherText]
Meter=String
MeterStyle=WeatherText
X=770
Y=150
Text="< <  Weather  > >"

; ============================================================
; ============================================================

[MeterWeatherActive]
Meter=String
MeterStyle=WeatherActive
X=770
Y=200
Text="Open Weather Codes"
LeftMouseUpAction=!CommandMeasure LuaPage "openLocation()"
MouseOverAction=[!SetOption MeterWeatherActive FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterWeatherActive FontColor "255,255,255"][!Update]

[MeterLocationActive]
Meter=String
MeterStyle=WeatherActive
X=770
Y=75r
W=750
H=50
Text=Click here for Location Code
SolidColor=0,0,0,32
LeftMouseUpAction=!CommandMeasure LuaPage "setWeather()"
MouseOverAction=[!SetOption MeterLocationActive FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLocationActive FontColor "255,255,255"][!Update]

; ============================================================
; ============================================================

[MeterWeatherNote]
Meter=String
MeterStyle=WeatherNote
X=770
Y=115r
Text="Copy and enter that as the value for LocationCode#CRLF#The Country/Region codes (e.g.: USNY0996)#CRLF#will also work as the LocationCode#CRLF#Or use the long number at the end of the resulting URL.#CRLF#INFO: If you want change language and parameters, go to "Language" page."

; ============================================================
; ============================================================

[MeterApplyButton]
Meter=String
MeterStyle=WeatherActive
X=770
Y=100r
Text="Apply Changes"
ToolTipText="Once is done, click "Apply" button to retrieve Weather skin"
LeftMouseUpAction=!CommandMeasure LuaPage "setWeatherApply()"
MouseOverAction=[!SetOption MeterApplyButton FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterApplyButton FontColor "255,255,255"][!Update]

; ============================================================
; ============================================================

[MeterSkinInputWeather]
Measure=Plugin
Plugin=InputText
StringAlign=Center
FontFace=Segoe UI
FontSize=15
X=395
Y=250
W=750
H=50
Command1=[!WriteKeyValue Variables LocationCode "$UserInput$" "#@#Measures\Weather\Weather Variables.inc"][!RefreshGroup SettingSuite]
AntiAlias=1
FocusDismiss=1
