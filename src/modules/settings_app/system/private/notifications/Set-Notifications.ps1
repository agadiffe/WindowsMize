#=================================================================================================================
#                                             System > Notifications
#=================================================================================================================

<#
.SYNTAX
    Set-Notifications
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-Notifications
{
    <#
    .EXAMPLE
        PS> Set-Notifications -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $NotificationsMsg = 'Notifications'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $Notifications = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\PushNotifications'
                    Entries = @(
                        @{
                            Name  = 'ToastEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NotificationsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $Notifications
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > start menu and taskbar > notifications
                #   turn off toast notifications
                # not configured: delete (default) | on: 1
                $NotificationsGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'NoToastApplicationNotification'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NotificationsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NotificationsGpo
            }
        }
    }
}
