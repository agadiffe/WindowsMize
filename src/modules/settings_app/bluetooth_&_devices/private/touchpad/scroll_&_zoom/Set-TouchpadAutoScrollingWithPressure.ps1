#=================================================================================================================
#               Bluetooth & Devices > Touchpad > Scroll & Zoom > Automatic Scrolling With Pressure
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadAutoScrollingWithPressure
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadAutoScrollingWithPressure
{
    <#
    .EXAMPLE
        PS> Set-TouchpadAutoScrollingWithPressure -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 4294967295 (UINT_MAX) (default) | off: 0
        $PressureAutoScrolling = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'PressureAutoPanningEnabled'
                    Value = $State -eq 'Enabled' ? [uint]::MaxValue : 0
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Automatic Scrolling With Pressure' to '$State' ..."
        Set-RegistryEntry -InputObject $PressureAutoScrolling
    }
}
