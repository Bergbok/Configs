net start w32time
Start-Sleep -Seconds 5
w32tm  /config /manualpeerlist:"time.windows.com time.nist.gov time-a.nist.gov time-b.nist.gov time-a.timefreq.bldrdoc.gov time-b.timefreq.bldrdoc.gov time-c.timefreq.bldrdoc.gov utcnist.colorado.edu" /syncfromflags:manual /update
Start-Sleep -Seconds 5
w32tm /resync
