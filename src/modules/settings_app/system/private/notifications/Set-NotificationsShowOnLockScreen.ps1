#=================================================================================================================
#                                  System > Notifications > Show On Lock Screen
#=================================================================================================================

<#
.SYNTAX
    Set-NotificationsShowOnLockScreen
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NotificationsShowOnLockScreen
{
    <#
    .EXAMPLE
        PS> Set-NotificationsShowOnLockScreen -State 'Disabled' -GPO 'NotConfigured'
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
        $NotificationsOnLockScreenMsg = 'Notifications - Show On Lock Screen'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $IsEnabled = $State -eq 'Enabled'

                # on: 1 delete (default) | off: 0 0
                $NotificationsOnLockScreen = @(
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Windows\CurrentVersion\PushNotifications'
                        Entries = @(
                            @{
                                Name  = 'LockScreenToastEnabled'
                                Value = $IsEnabled ? '1' : '0'
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Windows\CurrentVersion\Notifications\Settings'
                        Entries = @(
                            @{
                                RemoveEntry = $IsEnabled
                                Name  = 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK'
                                Value = '0'
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting '$NotificationsOnLockScreenMsg' to '$State' ..."
                $NotificationsOnLockScreen | Set-RegistryEntry
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > start menu and taskbar > notifications
                #   turn off toast notifications on the lock screen
                # not configured: delete (default) | on: 1
                $NotificationsOnLockScreenGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'NoToastApplicationNotificationOnLockScreen'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NotificationsOnLockScreenMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NotificationsOnLockScreenGpo
            }
        }
    }
}
