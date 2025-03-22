#=================================================================================================================
#                                          Network - NetBIOS over TCP/IP
#=================================================================================================================

# Used by 'file and printer sharing' to contact computer using this old/legacy protocol.

# settings > network & internet > advanced network settings > Wi-FI
#   more adapter options > edit > Internet Protocol Version 4 (TCP/IPv4) > properties
#     general > advanced > WINS > disable NetBIOS over TCP/IP

# Configuring the system to disable NetBIOS over TCP/IP mitigate local name resolution poisoning.
# See also: Link Local Multicast Name Resolution (LLMNR)

# Recommendation: Disabled

<#
.SYNTAX
    Set-NetBiosOverTcpIP
        [-State] {Disabled | Enabled | Default}
        [<CommonParameters>]
#>

function Set-NetBiosOverTcpIP
{
    <#
    .EXAMPLE
        PS> Set-NetBiosOverTcpIP -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Disabled', 'Enabled', 'Default')]
        [string] $State
    )

    process
    {
        $Value = switch ($State)
        {
            'Default'  { '0' }
            'Enabled'  { '1' }
            'Disabled' { '2' }
        }

        # default: 0 (default) | on: 1 | off: 2
        $NetBiosTcpIP = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\Tcpip_*'
            Entries = @(
                @{
                    Name  = 'NetbiosOptions'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'NetBIOS over TCP/IP' to '$State' ..."
        Set-RegistryEntry -InputObject $NetBiosTcpIP
    }
}
