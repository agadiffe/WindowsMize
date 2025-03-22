#=================================================================================================================
#                                           Notifications Network Usage
#=================================================================================================================

# This policy setting blocks applications from using the network to send notifications
# to update tiles, tile badges, toast, or raw notifications.
# Turns off the connection between Windows and the Windows Push Notification Service (WNS).

# May cause some MDM processes to break.
# e.g. remote wipe, unenroll, remote find, and mandatory app installation.

# Any app that uses network-based notifications (e.g. Discord, Microsoft Teams, ...)
# will not be able to show real-time updates on their icons or in the Action Center.

<#
.SYNTAX
    Set-NotificationsNetworkUsage
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-NotificationsNetworkUsage
{
    <#
    .EXAMPLE
        PS> Set-NotificationsNetworkUsage -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > start menu and taskbar > notifications
        #   turn off notifications network usage
        # not configured: delete (default) | on: 1
        $NotificationsNetworkUsageGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'NoCloudApplicationNotification'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Notification Network Usage (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $NotificationsNetworkUsageGpo
    }
}
