#=================================================================================================================
#                           Bluetooth & Devices > Devices > Use LE Audio When Available
#=================================================================================================================

<#
.SYNTAX
    Set-BluetoothLowEnergyAudio
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-BluetoothLowEnergyAudio
{
    <#
    .EXAMPLE
        PS> Set-BluetoothLowEnergyAudio -State 'Disabled'
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
        $BluetoothLowEnergyAudio = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\BthAvctpSvc\Parameters\Bats'
            Entries = @(
                @{
                    Name  = 'UserPrefersClassicAudio'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Devices - Use LE Audio When Available' to '$State' ..."
        Set-RegistryEntry -InputObject $BluetoothLowEnergyAudio
    }
}
