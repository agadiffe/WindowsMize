#=================================================================================================================
#                               Network - Smart Multi-Homed Name Resolution (SMHNR)
#=================================================================================================================

# The feature is designed to speed up DNS resolution by sending out DNS queries across all available network adapters.
# While this feature may improve performance, it can introduce privacy issues (potential DNS leaks).

# Recommendation (especially when using a VPN): Disabled

<#
.SYNTAX
    Set-NetSmhnr
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-NetSmhnr
{
    <#
    .EXAMPLE
        PS> Set-NetSmhnr -GPO 'Disabled'
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
        #   turn off smart multi-homed name resolution
        # not configured: delete (default) | on: 1
        $NetworkSmhnrGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableSmartNameResolution'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Network SMHNR (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $NetworkSmhnrGpo
    }
}
