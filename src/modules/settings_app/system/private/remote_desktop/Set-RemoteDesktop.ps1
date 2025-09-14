#=================================================================================================================
#                                             System > Remote Desktop
#=================================================================================================================

<#
.SYNTAX
    Set-RemoteDesktop
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-RemoteDesktop
{
    <#
    .EXAMPLE
        PS> Set-RemoteDesktop -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $RemoteDesktopMsg = 'Remote Desktop'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $IsEnabled = $State -eq 'Enabled'

                # on: 0 1 | off: 1 0 (default)
                $RemoteDesktop = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SYSTEM\CurrentControlSet\Control\Terminal Server'
                    Entries = @(
                        @{
                            Name  = 'fDenyTSConnections'
                            Value = $IsEnabled ? '0' : '1'
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'updateRDStatus'
                            Value = $IsEnabled ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RemoteDesktopMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $RemoteDesktop

                Write-Verbose -Message "  Setting 'Firewall rules (group: @FirewallAPI.dll,-28752)' to '$State'"
                Set-NetFirewallRule -Group '@FirewallAPI.dll,-28752' -Enabled ($IsEnabled ? 'True' : 'False')
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > remote desktop services > remote desktop session host > connections
                #   allow users to connect remotely by using remote desktop services
                # not configured: delete (default) | on: 0 | off: 1
                $RemoteDesktopGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'fDenyTSConnections'
                            Value = $GPO -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RemoteDesktopMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $RemoteDesktopGpo
            }
        }
    }
}
