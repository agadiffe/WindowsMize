#=================================================================================================================
#                                           Network - IP Source Routing
#=================================================================================================================

# Configuring the system to disable IP source routing protects against spoofing.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-NetIPSourceRouting
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetIPSourceRouting
{
    <#
    .EXAMPLE
        PS> Set-NetIPSourceRouting -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # on: delete (default) | off: 2
        $NetworkIPSourceRouting = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
                Entries = @(
                    @{
                        RemoveEntry = $IsEnabled
                        Name  = 'DisableIPSourceRouting'
                        Value = '2'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
                Entries = @(
                    @{
                        RemoveEntry = $IsEnabled
                        Name  = 'DisableIPSourceRouting'
                        Value = '2'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Network IP Source Routing' to '$State' ..."
        $NetworkIPSourceRouting | Set-RegistryEntry
    }
}
