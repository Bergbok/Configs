[MeterLangCurText]
Meter=String
MeterStyle=LanguageText
X=515
Y=222
Text="Current Language"

[MeterLanguageCurrent]
Meter=String
MeterStyle=LanguageCurrent
X=0r
Y=20R
Text="#Language#"

[MeterLanguageDetails]
Meter=String
MeterStyle=LanguageInfo
X=0r
Y=75R
Text="Language URL: #LangLoc##CRLF#Temp Units: #VarTempUnits##CRLF#Wind Units: #VarWindUnits##CRLF#Visibility Units: #VarVisUnits#"

; ============================================================
; ============================================================

[MeterLanguageEnglishUS]
Meter=String
MeterStyle=LanguageActive
X=772
Y=170
Text=English (US)
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('English (US)')"
MouseOverAction=[!SetOption MeterLanguageEnglishUS FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageEnglishUS FontColor "255,255,255"][!Update]

[MeterLanguageEnglishGB]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=English (GB)
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('English (GB)')"
MouseOverAction=[!SetOption MeterLanguageEnglishGB FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageEnglishGB FontColor "255,255,255"][!Update]

[MeterLanguageEnglishWorld]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=English (World)
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('English (World)')"
MouseOverAction=[!SetOption MeterLanguageEnglishWorld FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageEnglishWorld FontColor "255,255,255"][!Update]

[MeterLanguageCroatian]
Meter=String
MeterStyle=LanguageActive
X=772
Y=25R
Text=Croatian
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Croatian')"
MouseOverAction=[!SetOption MeterLanguageCroatian FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageCroatian FontColor "255,255,255"][!Update]

[MeterLanguageCzech]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Czech
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Czech')"
MouseOverAction=[!SetOption MeterLanguageCzech FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageCzech FontColor "255,255,255"][!Update]

[MeterLanguageDanish]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Danish
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Danish')"
MouseOverAction=[!SetOption MeterLanguageDanish FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageDanish FontColor "255,255,255"][!Update]

[MeterLanguageDutch]
Meter=String
MeterStyle=LanguageActive
X=772
Y=25R
Text=Dutch
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Dutch')"
MouseOverAction=[!SetOption MeterLanguageDutch FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageDutch FontColor "255,255,255"][!Update]

[MeterLanguageFrench]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=French
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('French')"
MouseOverAction=[!SetOption MeterLanguageFrench FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageFrench FontColor "255,255,255"][!Update]

[MeterLanguageGerman]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=German
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('German')"
MouseOverAction=[!SetOption MeterLanguageGerman FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageGerman FontColor "255,255,255"][!Update]

[MeterLanguageGreek]
Meter=String
MeterStyle=LanguageActive
X=772
Y=25R
Text=Greek
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Greek')"
MouseOverAction=[!SetOption MeterLanguageGreek FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageGreek FontColor "255,255,255"][!Update]

[MeterLanguageHungarian]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Hungarian
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Hungarian')"
MouseOverAction=[!SetOption MeterLanguageHungarian FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageHungarian FontColor "255,255,255"][!Update]

[MeterLanguageItalian]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Italian
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Italian')"
MouseOverAction=[!SetOption MeterLanguageItalian FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageItalian FontColor "255,255,255"][!Update]

[MeterLanguagePolish]
Meter=String
MeterStyle=LanguageActive
X=772
Y=25R
Text=Polish
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Polish')"
MouseOverAction=[!SetOption MeterLanguagePolish FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguagePolish FontColor "255,255,255"][!Update]

[MeterLanguagePortuguese]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Portuguese
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Portuguese')"
MouseOverAction=[!SetOption MeterLanguagePortuguese FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguagePortuguese FontColor "255,255,255"][!Update]

[MeterLanguageRussian]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Russian
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Russian')"
MouseOverAction=[!SetOption MeterLanguageRussian FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageRussian FontColor "255,255,255"][!Update]

[MeterLanguageSpanish]
Meter=String
MeterStyle=LanguageActive
X=772
Y=25R
Text=Spanish
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Spanish')"
MouseOverAction=[!SetOption MeterLanguageSpanish FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageSpanish FontColor "255,255,255"][!Update]

[MeterLanguageSwedish]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Swedish
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Swedish')"
MouseOverAction=[!SetOption MeterLanguageSwedish FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageSwedish FontColor "255,255,255"][!Update]

[MeterLanguageTurkish]
Meter=String
MeterStyle=LanguageActive
X=175r
Y=0r
Text=Turkish
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Turkish')"
MouseOverAction=[!SetOption MeterLanguageTurkish FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageTurkish FontColor "255,255,255"][!Update]

[MeterLanguageUkrainian]
Meter=String
MeterStyle=LanguageActive
X=947
Y=25R
Text=Ukrainian
LeftMouseUpAction=!CommandMeasure LuaPage "setLanguage('Ukrainian')"
MouseOverAction=[!SetOption MeterLanguageUkrainian FontColor "255,215,0"][!Update]
MouseLeaveAction=[!SetOption MeterLanguageUkrainian FontColor "255,255,255"][!Update]
