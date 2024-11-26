Start-Process "$env:WINDIR\System32\SndVol.exe"

$volumeMixerWidth = 800
$volumeMixerHeight = 600

nircmd win setsize title "Volume Mixer" 560 340 $volumeMixerWidth $volumeMixerHeight

nircmd win active title "Volume Mixer"
