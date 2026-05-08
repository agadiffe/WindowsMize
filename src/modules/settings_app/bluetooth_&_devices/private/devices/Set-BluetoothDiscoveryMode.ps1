#=================================================================================================================
#                           Bluetooth & Devices > Devices > Bluetooth Devices Discovery
#=================================================================================================================

# old

<#
.SYNTAX
    Set-BluetoothDiscoveryMode
        [-Mode] {Default | Advanced}
        [<CommonParameters>]
#>

function Set-BluetoothDiscoveryMode
{
    <#
    .EXAMPLE
        PS> Set-BluetoothDiscoveryMode -Mode 'Default'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [BluetoothDiscoveryMode] $Mode
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
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Devices - Use LE Audio When Available' to '$Mode' ..."
        Set-RegistryEntry -InputObject $BluetoothDiscoveryMode
    }
}
