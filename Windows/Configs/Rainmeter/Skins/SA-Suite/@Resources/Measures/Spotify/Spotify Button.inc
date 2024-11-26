[SpotifyLogo]
Meter=Image
MeterStyle=SpotifyLogo
Group=SpotifyMeter
X=(400*#SuiteScale#)
Y=0
H=(120*#SuiteScale#)
UpdateDivider=1

[TitleIcon]
Meter=Image
MeterStyle=SpotifyIcon
Group=SpotifyMeter
ImageName=Title.png
X=(25*#SuiteScale#)
Y=(10*#SuiteScale#)
H=(25*#SuiteScale#)
UpdateDivider=1

[ArtistIcon]
Meter=Image
MeterStyle=SpotifyIcon
Group=SpotifyMeter
ImageName=Artist.png
X=0r
Y=0R
H=(25*#SuiteScale#)
UpdateDivider=1

[AlbumIcon]
Meter=Image
MeterStyle=SpotifyIcon
Group=SpotifyMeter
ImageName=Album.png
X=0r
Y=0R
H=(25*#SuiteScale#)
UpdateDivider=1

[PlayPauseButton]
Meter=Image
MeterStyle=PlayPause | SpotifyIcon
Group=SpotifyMeter
MeasureName=MeasureCalcPlayPause
LeftMouseUpAction=[!CommandMeasure MeasureTitle "PlayPause"]

[PlayPause]
Meter=Image
Group=SpotifyMeter
SolidColor=0,0,0,1
X=0r
Y=0R
H=(25*#SuiteScale#)
