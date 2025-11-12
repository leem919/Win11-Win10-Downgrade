net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd C:\$WINDOWS.~BT\Sources
copy SetupHost.exe SetupHost2.exe
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\$WINDOWS.~BT\Sources\SetupHost2.exe" /t REG_SZ /d "WIN8RTM" /f

for /f "tokens=*" %%a in ('powershell -Command "(Get-WmiObject win32_process -Filter \"name like '%%SetupHost.exe'\").CommandLine"') do set originalCmd=%%a
set modifiedCmd=%originalCmd:SetupHost.exe=SetupHost2.exe%
taskkill /F /IM SetupHost.exe
start "" %modifiedCmd%