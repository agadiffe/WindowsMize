#=================================================================================================================
#                           Bluetooth & Devices > Touchpad > Scroll & Zoom > Zoom Speed
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadPinchToZoomSpeed
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-TouchpadPinchToZoomSpeed
{
    <#
    .EXAMPLE
        PS> Set-TouchpadPinchToZoomSpeed -Speed 5
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 10)]
        [int] $Speed
    )

    process
    {
        # default: 50 (range 0-100)
        $TouchpadZoomSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'ZoomSensitivity'
                    Value = $Speed * 10
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Pinch To Zoom Speed' to '$Speed' ..."
        Set-RegistryEntry -InputObject $TouchpadZoomSpeed
    }
}
