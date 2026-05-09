#=================================================================================================================
#                   Bluetooth & Devices > Touchpad > Taps > Tap Twice And Drag To Multi-Select
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadTapTwiceAndDragToMultiSelect
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadTapTwiceAndDragToMultiSelect
{
    <#
    .EXAMPLE
        PS> Set-TouchpadTapTwiceAndDragToMultiSelect -State 'Enabled'
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
        $TouchpadTapTwiceAndDragToMultiSelect = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'TapAndDrag'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Tap Twice And Drag To Multi-Select' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadTapTwiceAndDragToMultiSelect
    }
}
