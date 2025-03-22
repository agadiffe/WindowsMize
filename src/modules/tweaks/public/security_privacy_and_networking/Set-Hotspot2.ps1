#=================================================================================================================
#                                                   Hotspot 2.0
#=================================================================================================================

# Allows devices to automatically discover and connect to public Wi-Fi hotspots without user intervention.

<#
.SYNTAX
    Set-Hotspot2
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-Hotspot2
{
    <#
    .EXAMPLE
        PS> Set-Hotspot2 -State 'Disabled'
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
        $Hotspot2 = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\WlanSvc\AnqpCache'
            Entries = @(
                @{
                    Name  = 'OsuRegistrationStatus'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Hotspot 2.0' to '$State' ..."
        Set-RegistryEntry -InputObject $Hotspot2
    }
}
