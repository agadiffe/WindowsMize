#=================================================================================================================
#                                             Brave Browser Settings
#=================================================================================================================

<#
.SYNTAX
    Set-BraveBrowserSettings [<CommonParameters>]
#>

function Set-BraveBrowserSettings
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Setting Brave Browser Settings ...'

        $BraveLocalState, $BravePreferences = New-BraveBrowserConfigData

        $BraveInstallLocation = (Get-ApplicationInfo -Name 'Brave').InstallLocation
        $BraveAppDataPath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\BraveSoftware\Brave-Browser"
        $BraveUserDataPath = "$BraveAppDataPath\User Data"
        $BraveProfilePath = "$BraveAppDataPath\User Data\Default"

        if (-not (Test-Path -Path $BraveUserDataPath))
        {
            New-Item -ItemType 'Directory' -Path $BraveUserDataPath | Out-Null
        }
        if (-not (Test-Path -Path $BraveProfilePath))
        {
            New-Item -ItemType 'Directory' -Path $BraveProfilePath | Out-Null
        }

        # Remove welcome splash screen on first launch (also need '"has_seen_welcome_page": true' in prefs file).
        New-Item -ItemType 'File' -Path "$BraveUserDataPath\First Run" -ErrorAction 'SilentlyContinue' | Out-Null

        Stop-Process -Name '*Brave*' -Force -ErrorAction 'SilentlyContinue'
        Start-Sleep -Seconds 0.5

        $BraveLocalState | ConvertTo-Json -Depth 100 | Out-File -FilePath "$BraveUserDataPath\Local State"
        $BravePreferences | ConvertTo-Json -Depth 100 | Out-File -FilePath "$BraveProfilePath\Preferences"
        $BravePreferences | ConvertTo-Json -Depth 100 | Out-File -FilePath "$BraveInstallLocation\initial_preferences"
    }
}
