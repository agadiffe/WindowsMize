#=================================================================================================================
#                                             Brave Browser Settings
#=================================================================================================================

<#
.SYNTAX
    Set-BraveBrowserSettings
        [-CreateBackupIfNotPresent]
        [-DeleteExistingBackup]
        [<CommonParameters>]
#>

function Set-BraveBrowserSettings
{
    [CmdletBinding()]
    param
    (
        [switch] $CreateBackupIfNotPresent,

        [switch] $DeleteExistingBackup
    )

    process
    {
        Write-Verbose -Message 'Setting Brave Browser Settings ...'

        $BraveProcessName = 'Brave'
        Stop-Process -Name $BraveProcessName -Force -ErrorAction 'SilentlyContinue'
        Wait-Process -Name $BraveProcessName -ErrorAction 'SilentlyContinue'
        Start-Sleep -Seconds 0.3

        $BraveAppDataPath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\BraveSoftware\Brave-Browser"
        $BraveUserDataPath = "$BraveAppDataPath\User Data"
        $BraveProfilePath = "$BraveAppDataPath\User Data\Default"

        $BackupPath = "$BraveUserDataPath.old"

        if ($DeleteExistingBackup -and (Test-Path -Path $BackupPath))
        {
            Write-Verbose -Message '  Deleting existing backup.'
            Remove-Item -Path $BackupPath -Recurse -Force
        }

        if ($CreateBackupIfNotPresent)
        {
            if (Test-Path -Path $BackupPath)
            {
                Write-Verbose -Message '  Backup already exists. Skipping backup creation.'
            }
            else
            {
                if (Test-Path -Path $BraveUserDataPath)
                {
                    Write-Verbose -Message "  Creating backup: $BackupPath"
                    Rename-Item -Path $BraveUserDataPath -NewName $BackupPath
                }
            }
        }

        Remove-Item -Path $BraveUserDataPath -Recurse -Force -ErrorAction 'SilentlyContinue'
        New-Item -ItemType 'Directory' -Path $BraveUserDataPath, $BraveProfilePath | Out-Null

        # Remove welcome splash screen on first launch (also need '"has_seen_welcome_page": true' in prefs file).
        New-Item -ItemType 'File' -Path "$BraveUserDataPath\First Run" | Out-Null

        $BraveLocalState, $BravePreferences = New-BraveBrowserConfigData
        $BraveLocalState | ConvertTo-Json -Depth 100 | Out-File -FilePath "$BraveUserDataPath\Local State"
        $BravePreferences | ConvertTo-Json -Depth 100 | Out-File -FilePath "$BraveProfilePath\Preferences"
    }
}
