if (Get-NetFirewallRule | Where-Object DisplayName -EQ "Block-Steam") {
    Get-NetFirewallRule | Where-Object DisplayName -eq "Block-Steam" | Remove-NetFirewallRule
	Write-Output "Unblocked Steam"
} else {
	$steam = es -i -n 1 -r "\.exe$" "steam.exe"
	New-NetFirewallRule -Action block -Program "$steam" -Profile any -direction Inbound -Displayname "Block-Steam" | Out-Null
	New-NetFirewallRule -Action block -Program "$steam" -Profile any -direction Outbound -Displayname "Block-Steam" | Out-Null

	$steamservice = es -i -n 1 -r "\.exe$" "steamservice.exe"
	New-NetFirewallRule -Action block -Program "$steamservice" -Profile any -Direction Inbound -Displayname "Block-Steam" | Out-Null
    New-NetFirewallRule -Action block -Program "$steamservice" -Profile any -Direction Outbound -Displayname "Block-Steam" | Out-Null

	$steamwebhelper = es -i -n 1 -r "\.exe$" "steamwebhelper.exe"
	New-NetFirewallRule -Action block -Program "$steamwebhelper" -Profile any -Direction Inbound -Displayname "Block-Steam" | Out-Null
	New-NetFirewallRule -Action block -Program "$steamwebhelper" -Profile any -Direction Outbound -Displayname "Block-Steam" | Out-Null

    Write-Output "Blocked Steam"
}
