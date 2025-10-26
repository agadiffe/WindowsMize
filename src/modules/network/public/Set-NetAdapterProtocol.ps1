#=================================================================================================================
#                                            Network Adapter Protocol
#=================================================================================================================

# settings > network & internet > advanced network settings > Ethernet and/or Wi-FI:
#   more adapter options > edit

# See also 'services & scheduled tasks > services > system driver' to unload the related system driver.

# STIG recommendation:
#   LLDP: Disabled on external facing interfaces (e.g. router)
#   LLTD: Disabled

<#
.SYNTAX
    Set-NetAdapterProtocol
        [-Name] {Lldp | LltdIo | LltdResponder | BridgeDriver | QosPacketScheduler | HyperVExtensibleVirtualSwitch |
                 IPv4 | IPv6 | MicrosoftMultiplexor | FileSharingClient | FileSharingServer}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetAdapterProtocol
{
    <#
    .EXAMPLE
        PS> Set-NetAdapterProtocol -Name 'LLDP', 'LLTD', 'FileAndPrinterSharing' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(
            'Lldp',
            'LltdIo',
            'LltdResponder',
            'BridgeDriver', #  old ?
            'QosPacketScheduler',
            'HyperVExtensibleVirtualSwitch',
            'IPv4',
            'IPv6',
            'MicrosoftMultiplexor',
            'FileSharingClient',
            'FileSharingServer')]
        [string[]] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        $NetAdapterProtocol = @{
            Lldp = @{
                DisplayName = 'Microsoft LLDP Protocol Driver'
                ComponentID = 'ms_lldp'
                Enabled     = $IsEnabled
                Default     = $true
            }
            LltdIo = @(
                @{
                    DisplayName = 'Link-Layer Topology Discovery Mapper I/O Driver'
                    ComponentID = 'ms_lltdio'
                    Enabled     = $IsEnabled
                    Default     = $true
                }
            )
            LltdResponder = @(
                @{
                    DisplayName = 'Link-Layer Topology Discovery Responder'
                    ComponentID = 'ms_rspndr'
                    Enabled     = $IsEnabled
                    Default     = $true
                }
            )
            BridgeDriver = @{
                DisplayName = 'Bridge Driver'
                ComponentID = 'ms_l2bridge'
                Enabled     = $IsEnabled
                Default     = $true
                Comment     = 'create a bridge connection that combines two or more network adapters.
                               e.g. used by the Mobile Hotspot feature to share the internet connection.'
            }

            QosPacketScheduler = @{
                DisplayName = 'QoS Packet Scheduler'
                ComponentID = 'ms_pacer'
                Enabled     = $IsEnabled
                Default     = $true
                Comment     = 'somehow useless for (small) Home network'
            }

            HyperVExtensibleVirtualSwitch = @{
                DisplayName = 'Hyper-V Extensible Virtual Switch'
                ComponentID = 'vms_pp'
                Enabled     = $IsEnabled
                Default     = $false
            }

            IPv4 = @{
                DisplayName = 'Internet Protocol Version 4 (TCP/IPv4)'
                ComponentID = 'ms_tcpip'
                Enabled     = $IsEnabled
                Default     = $true
            }

            IPv6 = @{
                DisplayName = 'Internet Protocol Version 6 (TCP/IPv6)'
                ComponentID = 'ms_tcpip6'
                Enabled     = $IsEnabled
                Default     = $true
            }

            MicrosoftMultiplexor = @{
                DisplayName = 'Microsoft Network Adapter Multiplexor Protocol'
                ComponentID = 'ms_implat'
                Enabled     = $IsEnabled
                Default     = $false
            }

            FileSharingClient = @(
                @{
                    DisplayName = 'Client for Microsoft Networks'
                    ComponentID = 'ms_msclient'
                    Enabled     = $IsEnabled
                    Default     = $true
                    Comment     = 'SMB client (access other computer)'
                }
            )
            FileSharingServer = @(
                @{
                    DisplayName = 'File and Printer Sharing for Microsoft Networks'
                    ComponentID = 'ms_server'
                    Enabled     = $IsEnabled
                    Default     = $true
                    Comment     = 'SMB server (be accessible by other computer)'
                }
            )
        }

        foreach ($Protocol in $Name)
        {
            $NetAdapterProtocol.$Protocol | Set-NetAdapterProtocolState
        }
    }
}
