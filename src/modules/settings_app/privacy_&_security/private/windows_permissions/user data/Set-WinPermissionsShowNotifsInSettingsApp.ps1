#=================================================================================================================
#                    Privacy & Security > General > Show Me Notifications In The Settings App
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsShowNotifsInSettingsApp
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsShowNotifsInSettingsApp
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsShowNotifsInSettingsApp -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $WinPermissionsNotifsInSettingsApp = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications'
            Entries = @(
                @{
                    Name  = 'EnableAccountNotifications'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Show Me Notifications In The Settings App' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsNotifsInSettingsApp
    }
}
