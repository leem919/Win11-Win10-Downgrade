if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
}

$successful = @()
$failed = @()
$skipped = @()

Write-Host "Removing all packages to clear paused/broken..." -ForegroundColor Yellow
Get-AppxPackage -AllUsers | ForEach-Object {
    Write-Host "Removing $($_.Name)..." -ForegroundColor Cyan
    try {
        Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue
    } catch {
        # Silently continue if removal fails
    }
}

Write-Host "`nRe-registering all packages..." -ForegroundColor Yellow
Get-AppxPackage -AllUsers | ForEach-Object {
    $manifestPath = "$($_.InstallLocation)\AppxManifest.xml"
    
    if (Test-Path $manifestPath) {
        Write-Host "Re-registering $($_.Name)..." -ForegroundColor Cyan
        try {
            Add-AppxPackage -Register $manifestPath -DisableDevelopmentMode -ForceApplicationShutdown -ForceUpdateFromAnyVersion -ErrorAction Stop
            Write-Host "  SUCCESS: $($_.Name)" -ForegroundColor Green
            $successful += $_.Name
        } catch {
            Write-Host "  FAILED: $($_.Name) - $($_.Exception.Message)" -ForegroundColor Red
            $failed += [PSCustomObject]@{
                Name = $_.Name
                Error = $_.Exception.Message
            }
        }
    } else {
        Write-Host "  SKIPPED: Manifest not found for $($_.Name)" -ForegroundColor Yellow
        $skipped += $_.Name
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Successfully re-registered: $($successful.Count)" -ForegroundColor Green
Write-Host "Failed: $($failed.Count)" -ForegroundColor Red
Write-Host "Skipped (no manifest): $($skipped.Count)" -ForegroundColor Yellow

# Save failed packages to file
if ($failed.Count -gt 0) {
    $outputPath = Join-Path $PSScriptRoot "FailedPackages.txt"
    
    $output = @()
    $output += ""
    
    foreach ($item in $failed) {
        $output += "Error: $($item.Error)"
        $output += "-----------------------------------------"
        $output += ""
    }
    
    $output | Out-File -FilePath $outputPath -Encoding UTF8
    
    Write-Host "`nFailed packages saved to: $outputPath" -ForegroundColor Yellow
}

if ($skipped.Count -gt 0) {
    Write-Host "`n----------------------------------------" -ForegroundColor Yellow
    Write-Host "SKIPPED PACKAGES (No Manifest): $($skipped.Count)" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Yellow
}

Write-Host "`nDone! Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
