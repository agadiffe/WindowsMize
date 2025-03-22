#=================================================================================================================
#                                    Bluetooth & Devices > Devices > Bluetooth
#=================================================================================================================

<#
.SYNTAX
    Set-Bluetooth
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-Bluetooth
{
    <#
    .EXAMPLE
        PS> Set-Bluetooth -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ not configured: 2 (default) | off: 0
        $BluetoothPolicy = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\PolicyManager\default\Connectivity\AllowBluetooth'
            Entries = @(
                @{
                    Name  = 'value'
                    Value = $GPO -eq 'Disabled' ? '0' : '2'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Devices - Bluetooth (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $BluetoothPolicy
    }
}
