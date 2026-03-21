#=================================================================================================================
#                                         Set OneDrive Backup Notif Toast
#=================================================================================================================

<#
.SYNTAX
    Set-OneDriveBackupNotifToast
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-OneDriveBackupNotifToast
{
    <#
    .EXAMPLE
        PS> Set-OneDriveBackupNotifToast -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete key (default) or Timer value (e.g. now + 7 days) | off: 2099-01-01 as UnixTimeSeconds
        $OneDriveBackupNotifToast = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\OneDrive'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'TimerGrowthToast'
                    Value = ([DateTimeOffset](Get-Date -Date '2099-01-01')).ToUnixTimeSeconds()
                    Type  = 'QWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'OneDrive Backup Notif - Toast' to '$State' ..."
        Set-RegistryEntry -InputObject $OneDriveBackupNotifToast
    }
}
