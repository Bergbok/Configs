[Title]
Meter=String
MeterStyle=InfoTitle
Text=SA Suite
X=300
Y=100

[Version]
Meter=String
MeterStyle=InfoVersion
Text=v#Version#
X=5R
Y=-10r

[Author]
Meter=String
MeterStyle=InfoAuthor
Text="Author by: Saber Akiyama"
X=300
Y=60r

[AuthorLinkActive]
Meter=String
MeterStyle=InfoActive
X=92r
Y=20r
Text="deviantart.com/akiyama4809"
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Author')"
MouseOverAction=[!SetOption AuthorLinkActive FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption AuthorLinkActive FontColor "255,255,255"][!Update]

;-------------------------------------------------------------
;-------------------------------------------------------------

[LicenseHeader]
Meter=String
MeterStyle=InfoHeader
Text=License
X=300
Y=50r

[LicenseImageActive]
Meter=Image
ImageName=#@#Images\Settings\Creative Commons.png
ImageTint=255,255,255
X=r
Y=20r
W=180
AntiAlias=1
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Creative Commons')"
MouseOverAction=[!SetOption LicenseImageActive ImageTint "255,215,0"][!Update]
MouseLeaveAction=[!SetOption LicenseImageActive ImageTint "255,255,255"][!Update]

[LicenseText]
Meter=String
MeterStyle=InfoLicense
Text="BY-NC-SA (Attribution-NonCommercial-ShareAlike)#CRLF#4.0 International Public License"
X=r
Y=70r

;-------------------------------------------------------------
;-------------------------------------------------------------

[CreditsHeader]
Meter=String
MeterStyle=InfoHeader
X=r
Y=25R
Text=Credits + Inspirations

[Cred1Active]
Meter=String
MeterStyle=InfoActive
Text=Eduardo Tunni - Merienda fonts
X=r
Y=30r
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Credit1')"
MouseOverAction=[!SetOption Cred1Active FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption Cred1Active FontColor "255,255,255"][!Update]

[Cred2Active]
Meter=String
MeterStyle=InfoActive
Text=Olexa Volochay - TT Squares Condensed fonts
X=r
Y=5R
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Credit2')"
MouseOverAction=[!SetOption Cred2Active FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption Cred2Active FontColor "255,255,255"][!Update]

[Cred3Active]
Meter=String
MeterStyle=InfoActive
X=r
Y=5R
Text=Christian Robertson - Roboto fonts
LeftMouseUpAction=!CommandMeasure "LuaPage" "setInfo('Credit3')"
MouseOverAction=[!SetOption Cred3Active FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption Cred3Active FontColor "255,255,255"][!Update]

[Cred4Active]
Meter=String
MeterStyle=InfoActive
X=r
Y=5R
Text="Roberto Ierusalimschy - Programming Language (Lua)"
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Credit4')"
MouseOverAction=[!SetOption Cred4Active FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption Cred4Active FontColor "255,255,255"][!Update]

[Cred5Active]
Meter=String
MeterStyle=InfoActive
X=r
Y=5R
Text="Khanhas - Spicetify CLI (a Spotify Command Line Tool)"
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Credit5')"
MouseOverAction=[!SetOption Cred5Active FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption Cred5Active FontColor "255,255,255"][!Update]

[Cred6Active]
Meter=String
MeterStyle=InfoActive
X=r
Y=5R
Text=Trevor Hamilton (tjhruz) - WebNowPlaying plugin
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Credit6')"
MouseOverAction=[!SetOption Cred6Active FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption Cred6Active FontColor "255,255,255"][!Update]

[Cred7Active]
Meter=String
MeterStyle=InfoActive
X=r
Y=5R
Text="Rainmeter Developer Team"
LeftMouseUpAction=!CommandMeasure LuaPage "setInfo('Credit7')"
MouseOverAction=[!SetOption Cred7Active FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption Cred7Active FontColor "255,255,255"][!Update]
