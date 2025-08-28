#=================================================================================================================
#                                      Network - LAN Manager Hosts (LMHOSTS)
#=================================================================================================================

# LAN Manager Hosts (LMHOSTS): old/legacy protocol.
# Windows service: TCP/IP NetBIOS Helper

# settings > network & internet > advanced network settings > Wi-FI
#   more adapter options > edit > Internet Protocol Version 4 (TCP/IPv4) > properties
#     general > advanced > WINS > LMHOSTS lookup

<#
.SYNTAX
    Set-NetLmhosts
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetLmhosts
{
    <#
    .EXAMPLE
        PS> Set-NetLmhosts -State 'Disabled'
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
        $NetworkLmhosts = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\NetBT\Parameters'
            Entries = @(
                @{
                    Name  = 'EnableLMHOSTS'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Network LAN Manager Hosts (LMHOSTS)' to '$State' ..."
        Set-RegistryEntry -InputObject $NetworkLmhosts
    }
}
