#=================================================================================================================
#                    Bluetooth & Devices > Touchpad > Scroll & Zoom > Single-Finger Scrolling
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadSingleFingerToScroll
        [-Mode] {Disabled | LeftSide | RightSide}
        [<CommonParameters>]
#>

function Set-TouchpadSingleFingerToScroll
{
    <#
    .EXAMPLE
        PS> Set-TouchpadSingleFingerToScroll -Mode 'RightSide'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [SingleFingerScrollMode] $Mode
    )

    process
    {
        # disabled: 0 | Left Side: 1 | Right Side: 2
        $SingleFingerToScroll = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'SingleFingerPanningMode'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Single-Finger Scrolling' to '$Mode' ..."
        Set-RegistryEntry -InputObject $SingleFingerToScroll
    }
}
