#requires -Version 5.1
<#
.SYNOPSIS
    AzureAD Entra Device Diagnostic Toolkit.
.DESCRIPTION
    Read-only Entra ID device registration evidence collector for Windows support.
#>
[CmdletBinding()]
param([string]$OutputPath,[int]$Hours=72)
$RunStamp=Get-Date -Format 'yyyyMMdd_HHmmss'
if([string]::IsNullOrWhiteSpace($OutputPath)){$OutputPath=Join-Path ([Environment]::GetFolderPath('Desktop')) 'Entra_Device_Reports'}
New-Item -Path $OutputPath -ItemType Directory -Force|Out-Null
$dsPath=Join-Path $OutputPath "dsregcmd_status_$RunStamp.txt"
try{dsregcmd.exe /status|Out-File $dsPath -Encoding UTF8;$ds=Get-Content $dsPath -Raw}catch{$ds='dsregcmd failed'}
$patterns='AzureAdJoined','EnterpriseJoined','DomainJoined','WorkplaceJoined','AzureAdPrt','TenantName','TenantId','DeviceId'
$rows=foreach($p in $patterns){$line=($ds -split "`r?`n")|Where-Object{$_ -match "^\s*$p\s+:"}|Select-Object -First 1;[PSCustomObject]@{Field=$p;Value=($line -replace '^\s*[^:]+:\s*','')}}
$rows|Export-Csv (Join-Path $OutputPath "entra_join_summary_$RunStamp.csv") -NoTypeInformation -Encoding UTF8
$start=(Get-Date).AddHours(-1*$Hours)
$events=@();foreach($log in 'Microsoft-Windows-AAD/Operational','Microsoft-Windows-User Device Registration/Admin'){try{$events+=Get-WinEvent -FilterHashtable @{LogName=$log;StartTime=$start;Level=1,2,3} -ErrorAction Stop|Select-Object @{n='Log';e={$log}},TimeCreated,Id,LevelDisplayName,Message}catch{}}
$events|Export-Csv (Join-Path $OutputPath "entra_device_events_$RunStamp.csv") -NoTypeInformation -Encoding UTF8
$html="<h1>Entra Device Diagnostic - $env:COMPUTERNAME</h1><p>Generated $(Get-Date)</p><h2>Join Summary</h2>$($rows|ConvertTo-Html -Fragment)<h2>Recent Events</h2>$($events|Select-Object -First 100|ConvertTo-Html -Fragment)"
$html|ConvertTo-Html -Title 'Entra Device Diagnostic'|Set-Content (Join-Path $OutputPath "entra_device_$RunStamp.html") -Encoding UTF8
$rows|Format-Table -AutoSize
Write-Host "Reports saved to: $OutputPath" -ForegroundColor Green
Start-Process explorer.exe -ArgumentList "`"$OutputPath`"" -ErrorAction SilentlyContinue
