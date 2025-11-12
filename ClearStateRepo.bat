net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

net stop StateRepository
cd C:\ProgramData\Microsoft\Windows\AppRepository
takeown /A /F StateRepository-*
icacls StateRepository-* /grant Administrators:F
del StateRepository-*
net start StateRepository