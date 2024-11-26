[MeasureTrimText]
; Sets Trim Text enabled or disabled depending on #TrimText# (which is controlled by context menu options).
Measure=Calc
; 0: Disabled Trim Text, 1: Enabled Trim Text
IfCondition=(#TrimText#=0)
IfTrueAction=[!CommandMeasure LuaSpotify "disabledTrim()"]
IfFalseAction=[!CommandMeasure LuaSpotify "enabledTrim()"]
Group=SpotifyMeasure
DynamicVariables=1
UpdateDivider=-1

; ====================================================================================================

[MeasureTitle]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Title
Group=SpotifyMeasure
DisableLeadingZero=1
TrackChangeAction=1
RegExpSubstitute=0
Substitute="":"#FetchText#","^(?siU)^(.+) (-.+|((\(|\[).*(mix|with|feat|ft|from|version|track|live|unplugged|acoustic|bootleg|demo|cover|theme|remaster|as heard|w\/).+))+$":"\1"
UpdateDivider=1

[MeasureArtist]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Artist
Group=SpotifyMeasure
RegExpSubstitute=0
Substitute="^(?siU)^(.+)((-|,).+)+$":"\1"
UpdateDivider=1

[MeasureAlbum]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Album
Group=SpotifyMeasure
RegExpSubstitute=0
Substitute="^(?siU)^(.+) (-.+|((\(|\[).*(mix|with|feat|ft|from|version|track|live|unplugged|acoustic|bootleg|demo|cover|theme|remaster|as heard|w\/).+))+$":"\1"
UpdateDivider=1

[MeasureCover]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Cover
Group=SpotifyMeasure
DefaultPath=#@#Images\Spotify\No Cover.png
CoverPath=#@#Images\Spotify\Web Cover Art.png
Substitute="":"#@#Images\Spotify\No Cover.png"
UpdateDivider=1

[MeasureProgress]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Progress
Group=SpotifyMeasure
UpdateDivider=1

[MeasureProgressTime]
Measure=Calc
Formula=(MeasureProgress*5)

[MeasurePosition]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Position
Group=SpotifyMeasure
UpdateDivider=1

[MeasureDuration]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Duration
Group=SpotifyMeasure
UpdateDivider=1

[MeasureState]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=State
Group=SpotifyMeasure
UpdateDivider=1

[MeasureCalcPlayPause]
Measure=Calc
Formula=(((MeasureState = 0) || (MeasureState = 2)) ? 1 : 0)
Substitute="1":"Play","0":"Pause"

[MeasureStatus]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Status
Group=SpotifyMeasure
UpdateDivider=1
