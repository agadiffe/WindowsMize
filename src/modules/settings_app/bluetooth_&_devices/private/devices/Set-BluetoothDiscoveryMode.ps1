#=================================================================================================================
#                           Bluetooth & Devices > Devices > Bluetooth Devices Discovery
#=================================================================================================================

# This feature is deprecated.

<#
.SYNTAX
    Set-BluetoothDiscoveryMode
        [-Value] {Default | Advanced}
        [<CommonParameters>]
#>

function Set-BluetoothDiscoveryMode
{
    <#
    .EXAMPLE
        PS> Set-BluetoothDiscoveryMode -Value 'Default'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [BluetoothDiscoveryMode] $Value
    )

    process
    {
        # default: 0 (default) | advanced: 1
        $BluetoothDiscoveryMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Bluetooth'
            Entries = @(
                @{
                    Name  = 'AdvancedDiscoveryMode'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Devices - Use LE Audio When Available' to '$Value' ..."
        Set-RegistryEntry -InputObject $BluetoothDiscoveryMode
    }
}
