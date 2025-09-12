#=================================================================================================================
#                             Network - Link Local Multicast Name Resolution (LLMNR)
#=================================================================================================================

# Configuring the system to disable LLMNR mitigate local name resolution poisoning.
# To completely mitigate local name resolution poisoning, in addition to this setting,
# the properties of each installed NIC should also be set to 'Disable NetBIOS over TCP/IP'.
# See also: Multicast DNS (mDNS).

# LLMNR resolve DNS names to their respective IP addresses.
# e.g. File Explorer > Network > Computer_Name
# If disabled, double-clicking on Computer_Name will probably fail with the error: Path not found.
# You will need to access the computer using its IP address.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-NetLlmnr
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-NetLlmnr
{
    <#
    .EXAMPLE
        PS> Set-NetLlmnr -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > network > dns client
        #   turn off multicast name resolution
        # not configured: delete (default) | on: 0
        $NetworkLlmnrGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'EnableMulticast'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Network - Link Local Multicast Name Resolution (LLMNR) (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $NetworkLlmnrGpo
    }
}
