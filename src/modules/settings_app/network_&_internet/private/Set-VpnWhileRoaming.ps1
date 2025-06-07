#=================================================================================================================
#                               Network & Internet > VPN > Allow VPN While Roaming
#=================================================================================================================

<#
.SYNTAX
    Set-VpnWhileRoaming
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VpnWhileRoaming
{
    <#
    .EXAMPLE
        PS> Set-VpnWhileRoaming -State 'Disabled'
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
        $VpnWhileRoaming = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\RasMan\Parameters\Config\VpnCostedNetworkSettings'
            Entries = @(
                @{
                    Name  = 'NoRoamingNetwork'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'VPN - Allow VPN While Roaming' to '$State' ..."
        Set-RegistryEntry -InputObject $VpnWhileRoaming
    }
}
