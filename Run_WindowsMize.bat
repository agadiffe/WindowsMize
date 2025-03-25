::================================================================================================================
::                               WindowsMize - Install PowerShell 7 and Run script
::================================================================================================================
@echo off

echo Installing PowerShell 7 ...

winget.exe install --exact --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements


echo Running WindowsMize ...

set scriptFolder=%~dp0
set windowsMizeFilePath=%scriptFolder%WindowsMize.ps1

:: "Start-Process pwsh.exe" is not launched in Windows Terminal (it opens a pwsh.exe window)
WHERE wt.exe >nul 2>nul
IF %ERRORLEVEL% EQU 0 (
    REM Windows Terminal is installed
    set process=wt.exe
    set wtArgument=pwsh.exe
) ELSE (
    set process=pwsh.exe
)

set argumentList=%wtArgument% -NoExit -NoProfile -ExecutionPolicy Bypass -File ""%windowsMizeFilePath%""

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "& { Start-Process -Verb 'RunAs' -FilePath '%process%' -ArgumentList '%argumentList%' }"
