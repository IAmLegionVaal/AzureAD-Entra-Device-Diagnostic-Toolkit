# AzureAD Entra Device Diagnostic Toolkit

A read-only PowerShell toolkit for Entra ID / Azure AD device registration diagnostics.

## Features

- dsregcmd status capture
- Join-state evidence export
- AAD and workplace join event summaries
- PRT indicator extraction from text output
- CSV, TXT, and HTML reports

## How to run

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\AzureAD_Entra_Device_Diagnostic_Toolkit.ps1
```

## Safety

Diagnostic-only. It does not join, unjoin, register, or modify device state.
