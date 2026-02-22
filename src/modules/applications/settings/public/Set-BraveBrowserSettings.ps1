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

        $BraveProcessName = 'Brave'
        Stop-Process -Name $BraveProcessName -Force -ErrorAction 'SilentlyContinue'
        Wait-Process -Name $BraveProcessName -ErrorAction 'SilentlyContinue'
        Start-Sleep -Seconds 0.3

        $BraveLocalState, $BravePreferences = New-BraveBrowserConfigData

        $BraveAppDataPath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\BraveSoftware\Brave-Browser"
        $BraveUserDataPath = "$BraveAppDataPath\User Data"
        $BraveProfilePath = "$BraveAppDataPath\User Data\Default"

        Remove-Item -Recurse -Path $BraveUserDataPath -ErrorAction 'SilentlyContinue'
        New-Item -ItemType 'Directory' -Path $BraveUserDataPath, $BraveProfilePath -ErrorAction 'SilentlyContinue' | Out-Null

        # Remove welcome splash screen on first launch (also need '"has_seen_welcome_page": true' in prefs file).
        New-Item -ItemType 'File' -Path "$BraveUserDataPath\First Run" -ErrorAction 'SilentlyContinue' | Out-Null

        $BraveLocalState | ConvertTo-Json -Depth 100 | Out-File -FilePath "$BraveUserDataPath\Local State"
        $BravePreferences | ConvertTo-Json -Depth 100 | Out-File -FilePath "$BraveProfilePath\Preferences"
    }
}
