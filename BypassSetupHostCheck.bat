@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

for /f "tokens=*" %%a in ('powershell -Command "(Get-WmiObject win32_process -Filter \"name like '%%SetupHost.exe'\").CommandLine"') do set originalCmd=%%a

taskkill /F /IM SetupHost.exe

start cmd /c "set __COMPAT_LAYER=WIN8RTM && %originalCmd%"
