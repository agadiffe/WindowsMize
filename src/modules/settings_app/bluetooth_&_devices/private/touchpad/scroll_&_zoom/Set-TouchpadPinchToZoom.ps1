#=================================================================================================================
#                         Bluetooth & Devices > Touchpad > Scroll & Zoom > Pinch To Zoom
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadPinchToZoom
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadPinchToZoom
{
    <#
    .EXAMPLE
        PS> Set-TouchpadPinchToZoom -State 'Enabled'
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
        $TouchpadPinchToZoom = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'ZoomEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Pinch To Zoom' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadPinchToZoom
    }
}
