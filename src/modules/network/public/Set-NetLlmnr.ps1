#=================================================================================================================
#                             Network - Link Local Multicast Name Resolution (LLMNR)
#=================================================================================================================

# Configuring the system to disable LLMNR mitigate local name resolution poisoning.
# To completely mitigate local name resolution poisoning, in addition to this setting,
# the properties of each installed NIC should also be set to 'Disable NetBIOS over TCP/IP'.

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

        Write-Verbose -Message "Setting 'Network LLMNR (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $NetworkLlmnrGpo
    }
}
