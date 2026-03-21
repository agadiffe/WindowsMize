#=================================================================================================================
#                              Set OneDrive Backup Notif Start Menu And Settings App
#=================================================================================================================

<#
.SYNTAX
    Set-OneDriveBackupNotifStartMenuAndSettingsApp
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-OneDriveBackupNotifStartMenuAndSettingsApp
{
    <#
    .EXAMPLE
        PS> Set-OneDriveBackupNotifStartMenuAndSettingsApp -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete key (default) | off: json value
        $OneDriveBackupNotifStartMenuAndSettingsApp = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\RulesEngine\StateManager'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'LastSuppressionTimes'
                    Value = '{"settingshomealertbanner":"2099-01-01T00:00:00Z","startmenu":"2099-01-01T00:00:00Z"}'
                    Type  = 'String'
                }
                @{
                    RemoveEntry = $true
                    Name  = 'Data'
                    Value = ''
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'OneDrive Backup Notif - Start Menu And Settings App' to '$State' ..."
        Set-RegistryEntry -InputObject $OneDriveBackupNotifStartMenuAndSettingsApp
    }
}
