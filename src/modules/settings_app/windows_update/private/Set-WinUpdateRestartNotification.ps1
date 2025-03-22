#=================================================================================================================
#                    Windows Update > Notify Me When A Restart Is Required To Finish Updating
#=================================================================================================================

# The Group Policy setting will also disable 'Get me up to date'.

<#
.SYNTAX
    Set-WinUpdateRestartNotification
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinUpdateRestartNotification
{
    <#
    .EXAMPLE
        PS> Set-WinUpdateRestartNotification -State 'Disabled' -GPO 'NotConfigured'
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
        $WinUpdateRestartNotificationMsg = 'Windows Update - Notify Me When A Restart Is Required To Finish Updating'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $WinUpdateRestartNotification = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
                    Entries = @(
                        @{
                            Name  = 'RestartNotificationsAllowed2'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateRestartNotificationMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinUpdateRestartNotification
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > windows update > legacy policies
                #   turn off auto-restart notifications for update installations
                # not configured: delete (default) | on: 1
                $WinUpdateRestartNotificationGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'SetAutoRestartNotificationDisable'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateRestartNotificationMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinUpdateRestartNotificationGpo
            }
        }
    }
}
