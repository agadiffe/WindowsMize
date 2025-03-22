#=================================================================================================================
#                        System > Display > Graphics > Hardware-Accelerated GPU Scheduling
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayGraphicsGpuScheduling
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DisplayGraphicsGpuScheduling
{
    <#
    .EXAMPLE
        PS> Set-DisplayGraphicsGpuScheduling -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 2 | off: 1 (default)
        $HardwareAcceleratedGpuScheduling = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\GraphicsDrivers'
            Entries = @(
                @{
                    Name  = 'HwSchMode'
                    Value = $State -eq 'Enabled' ? '2' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Display Graphics - Hardware-Accelerated GPU Scheduling' to '$State' ..."
        Set-RegistryEntry -InputObject $HardwareAcceleratedGpuScheduling
    }
}
