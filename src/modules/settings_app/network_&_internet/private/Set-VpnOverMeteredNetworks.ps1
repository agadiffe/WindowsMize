#=================================================================================================================
#                           Network & Internet > VPN > Allow VPN Over Metered Networks
#=================================================================================================================

<#
.SYNTAX
    Set-VpnOverMeteredNetworks
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VpnOverMeteredNetworks
{
    <#
    .EXAMPLE
        PS> Set-VpnOverMeteredNetworks -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $VpnOverMeteredNetworks = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\RasMan\Parameters\Config\VpnCostedNetworkSettings'
            Entries = @(
                @{
                    Name  = 'NoCostedNetwork'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'VPN - Allow VPN Over Metered Networks' to '$State' ..."
        Set-RegistryEntry -InputObject $VpnOverMeteredNetworks
    }
}
