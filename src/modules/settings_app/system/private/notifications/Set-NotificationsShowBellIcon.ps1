#=================================================================================================================
#                                     System > Notifications > Show Bell Icon
#=================================================================================================================

<#
.SYNTAX
    Set-NotificationsPlaySounds
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NotificationsShowBellIcon
{
    <#
    .EXAMPLE
        PS> Set-NotificationsPlaySounds -State 'Disabled'
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
        $NotificationsBellIcon = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'ShowNotificationIcon'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Notifications - Show Bell Icon' to '$State' ..."
        Set-RegistryEntry -InputObject $NotificationsBellIcon
    }
}
