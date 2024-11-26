$rainmeter = es -i -n 1 -r "\.exe$" "Rainmeter.exe"
Start-Process $rainmeter -Args "!Refresh" -NoNewWindow
