#=================================================================================================================
#                                         Network - Multicast DNS (mDNS)
#=================================================================================================================

# Configuring the system to disable Multicast DNS (mDNS) mitigate local name resolution poisoning.
# See also: Link Local Multicast Name Resolution (LLMNR) and NetBIOS over TCP/IP.

# mDNS resolve DNS names to their respective IP addresses.
# e.g. File Explorer > Network > Computer_Name
# If disabled, double-clicking on Computer_Name will probably fail with the error: Path not found.
# You will need to access the computer using its IP address.

# Workstations may not be able to find wireless screen mirroring devices.
# e.g. Chromecasts, Apple AirPlay, Printers and anything else that relies on MDNS.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-NetMulicastDns
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetMulicastDns
{
    <#
    .EXAMPLE
        PS> Set-NetMulicastDns -State 'Disabled'
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
        $NetworkMulicastDnsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\Dnscache\Parameters'
            Entries = @(
                @{
                    Name  = 'EnableMDNS'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Network - Multicast DNS (mDNS)' to '$State' ..."
        Set-RegistryEntry -InputObject $NetworkMulicastDnsGpo

        Write-Verbose -Message "  set 'Firewall rules (group: @FirewallAPI.dll,-37302)' to '$State'"
        Set-NetFirewallRule -Group '@FirewallAPI.dll,-37302' -Enabled ($State -eq 'Enabled' ? 'True' : 'False')
    }
}
