Remove-Item "$env:USERPROFILE\AppData\Local\IconCache.db" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "explorer" -Force
Start-Process "explorer.exe"
