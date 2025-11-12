if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Get-AppxPackage -AllUsers | ForEach-Object {
    $manifestPath = "$($_.InstallLocation)\AppxManifest.xml"
    
    if (Test-Path $manifestPath) {
        Write-Host "Re-registering $($_.Name)..." -ForegroundColor Cyan
        try {
            Add-AppxPackage -Register $manifestPath -DisableDevelopmentMode -ForceApplicationShutdown -ForceUpdateFromAnyVersion
            Write-Host "Success: $($_.Name)" -ForegroundColor Green
        } catch {
            Write-Host "Failed for $($_.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "Manifest not found for $($_.Name) at $manifestPath" -ForegroundColor Yellow
    }
}