New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\Event Viewer Logs" -Force | Out-Null
Set-Location "$env:USERPROFILE\Documents\Event Viewer Logs"
Get-Eventlog -LogName application -EntryType Error,Warning | Export-csv application_logs.csv | Get-Eventlog -LogName System -EntryType Error,Warning | Export-Clixml system_logs.csv
