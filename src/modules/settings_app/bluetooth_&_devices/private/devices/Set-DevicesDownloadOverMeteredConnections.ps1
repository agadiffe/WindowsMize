#=================================================================================================================
#          Bluetooth & Devices > Devices > Download Drivers And Device Software Over Metered Connections
#=================================================================================================================

# The same settings is also available in: System > Bluetooth & Devices > Printers & Scanners

<#
.SYNTAX
    Set-DevicesDownloadOverMeteredConnections
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DevicesDownloadOverMeteredConnections
{
    <#
    .EXAMPLE
        PS> Set-DevicesDownloadOverMeteredConnections -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $DevicesDownloadOverMeteredConnections = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceSetup'
            Entries = @(
                @{
                    Name  = 'CostedNetworkPolicy'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Devices - Download Drivers And Device Software Over Metered Connections' to '$State' ..."
        Set-RegistryEntry -InputObject $DevicesDownloadOverMeteredConnections
    }
}
