#=================================================================================================================
#                                  Bluetooth & Devices > USB > USB Battery Saver
#=================================================================================================================

<#
.SYNTAX
    Set-UsbBatterySaver
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-UsbBatterySaver
{
    <#
    .EXAMPLE
        PS> Set-UsbBatterySaver -State 'Enabled'
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
        $UsbBatterySaver = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\USB\AutomaticSurpriseRemoval'
            Entries = @(
                @{
                    Name  = 'AttemptRecoveryFromUsbPowerDrain'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'USB - USB Battery Saver' to '$State' ..."
        Set-RegistryEntry -InputObject $UsbBatterySaver
    }
}
