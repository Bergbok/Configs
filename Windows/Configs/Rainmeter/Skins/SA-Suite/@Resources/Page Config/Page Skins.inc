[MeterStyleText]
Meter=String
MeterStyle=SkinText
X=555
Y=230
Text="< <  Skins  > >"

; ============================================================
; ============================================================

[MeterTypeFace]
Meter=String
MeterStyle=SkinInfo
X=320
Y=280
Text=Typeface

[MeterTypeColor]
Meter=String
MeterStyle=SkinInfo
X=0r
Y=50r
Text=Color Code

; ============================================================
; ============================================================

[TypeFaceArrow]
Meter=String
MeterStyle=SkinArrow
X=530
Y=280
Text=">>>>"

[TypeColorArrow]
Meter=String
MeterStyle=SkinArrow
X=0r
Y=50r
Text=">>>>"

; ============================================================
; ============================================================

[MeterTypeFaceActive]
Meter=String
MeterStyle=SkinTypefaceActive
FontFace=#TypeFace#
X=692
Y=280
Text=#TypeFace#
ToolTipText=Type your "Font Face" and press the "Enter" key to Apply changes.
LeftMouseUpAction=!CommandMeasure LuaPage "setTypeface('Typeface')"
MouseOverAction=[!SetOption MeterTypeFaceActive FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterTypeFaceActive FontColor "255,255,255"][!Update]

[MeterColorCodeActive]
Meter=String
MeterStyle=SkinActive
X=0r
Y=50r
Text=#ColorCode#
ToolTipText=Type "Color Code" and press the "Enter" key to Apply changes.#CRLF#You can use RGB or HEX color codes.
LeftMouseUpAction=!CommandMeasure LuaPage "setColor('Color Code')"
MouseOverAction=[!SetOption MeterColorCodeActive FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterColorCodeActive FontColor "255,255,255"][!Update]

; ============================================================
; ============================================================

[MeterApplyButton]
Meter=String
MeterStyle=SkinActive
X=555
Y=110r
Text="Apply Changes"
ToolTipText="Once is done, click "Apply" button to refresh skin"
LeftMouseUpAction=!CommandMeasure LuaPage "setSkinApply()"
MouseOverAction=[!SetOption MeterApplyButton FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterApplyButton FontColor "255,255,255"][!Update]

; ============================================================
; ============================================================

[MeterSkinInputTypeface]
Measure=Plugin
Plugin=InputText.dll
StringAlign=Center
FontFace=Segoe UI
FontSize=15
W=245
H=35
AntiAlias=1
FocusDismiss=1
X=570
Command1=[!WriteKeyValue Variables TypeFace "$UserInput$""#@#Variables.inc"][!RefreshGroup SettingSuite] DefaultValue="#TypeFace#" Y=262

[MeterSkinInputColor]
Measure=Plugin
Plugin=InputText.dll
StringAlign=Center
FontFace=Segoe UI
FontSize=15
X=605
Y=312
W=175
H=35
AntiAlias=1
FocusDismiss=1
Command1=[!WriteKeyValue Variables ColorCode "$UserInput$""#@#Variables.inc"][!RefreshGroup SettingSuite] DefaultValue="#ColorCode#"
