::================================================================================================================
::                                         Install Microsoft Office 365
::================================================================================================================
@echo off

set OfficeDeploymentToolUri=https://officecdn.microsoft.com/pr/wsus/setup.exe
set ScriptFolder=%~dp0
set OfficeSetupFilePath=%ScriptFolder%\MsOfficeDeploymentTool.exe
set ConfigFilePath=%ScriptFolder%\MsOfficeConfiguration.xml

echo Downloading Office Deployment Tool ...
curl "%OfficeDeploymentToolUri%" --output "%OfficeSetupFilePath%" --silent --fail

echo Creating the configuration file ...
(
    echo ^<Configuration^>
    echo   ^<Add OfficeClientEdition="64" Channel="Current"^>
    echo     ^<Product ID="O365ProPlusRetail"^>
    echo       ^<Language ID="MatchOS" /^>
    echo       ^<ExcludeApp ID="Access" /^>
    echo       ^<ExcludeApp ID="Groove" /^>
    echo       ^<ExcludeApp ID="Lync" /^>
    echo       ^<ExcludeApp ID="OneDrive" /^>
    echo       ^<ExcludeApp ID="OneNote" /^>
    echo       ^<ExcludeApp ID="Outlook" /^>
    echo       ^<ExcludeApp ID="OutlookForWindows" /^>
    echo       ^<ExcludeApp ID="Publisher" /^>
    echo       ^<ExcludeApp ID="Teams" /^>
    echo       ^<ExcludeApp ID="Bing" /^>
    echo     ^</Product^>
    echo   ^</Add^>
    echo   ^<Display AcceptEULA="TRUE" /^>
    echo ^</Configuration^>
) > "%ConfigFilePath%"

echo Running Office setup ...
set argumentList=/configure ""%ConfigFilePath%""
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "& { Start-Process -Verb 'RunAs' -FilePath '%OfficeSetupFilePath%' -ArgumentList '%argumentList%' }"
