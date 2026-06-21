# AzureAD Entra Device Diagnostic Toolkit

A PowerShell toolkit for Entra ID device-registration diagnostics and selected guarded local repairs.

## Diagnostic script

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\AzureAD_Entra_Device_Diagnostic_Toolkit.ps1
```

## Repair script

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Entra_Device_Repair_Toolkit.ps1 -RefreshPrt -DryRun
```

Examples:

```powershell
.\Entra_Device_Repair_Toolkit.ps1 -RefreshPrt
.\Entra_Device_Repair_Toolkit.ps1 -TriggerDeviceJoin
.\Entra_Device_Repair_Toolkit.ps1 -RestartIdentityServices
.\Entra_Device_Repair_Toolkit.ps1 -RunRegistrationDiagnostics
```

## What the repair does

- Requests Primary Refresh Token renewal with `dsregcmd /refreshprt`.
- Starts the built-in Automatic-Device-Join scheduled task.
- Restarts selected Windows identity and device-registration services.
- Captures detailed registration diagnostics and before-and-after join state.
- Supports `-DryRun`, confirmation prompts, logs and clear exit codes.

## Safety

The tool does not run `dsregcmd /leave`, remove workplace accounts, delete certificates or alter tenant-side device records. Device-join repair still requires correct tenant, DNS, network and policy configuration.

## Author

Dewald Pretorius — L2 IT Support Engineer
