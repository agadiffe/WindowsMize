#=================================================================================================================
#                 Bluetooth & Devices > Devices > Show Notifications To Connect Using Swift Pair
#=================================================================================================================

<#
.SYNTAX
    Set-BluetoothShowQuickPairConnectionNotif
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-BluetoothShowQuickPairConnectionNotif
{
    <#
    .EXAMPLE
        PS> Set-BluetoothShowQuickPairConnectionNotif -State 'Disabled' -GPO 'NotConfigured'
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
        $QuickPairConnectionNotifMsg = 'Devices - Show Notifications To Connect Using Swift Pair'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $DevicesNotificationsConnectSwiftPair = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Bluetooth'
                    Entries = @(
                        @{
                            Name  = 'QuickPair'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$QuickPairConnectionNotifMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $DevicesNotificationsConnectSwiftPair
            }
            'GPO'
            {
                # gpo\ not configured: 1 (default) | off: 0
                $DevicesNotificationsConnectSwiftPairGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\PolicyManager\default\Bluetooth\AllowPromptedProximalConnections'
                    Entries = @(
                        @{
                            Name  = 'value'
                            Value = $GPO -eq 'Disabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$QuickPairConnectionNotifMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $DevicesNotificationsConnectSwiftPairGpo
            }
        }
    }
}
