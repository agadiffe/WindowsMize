#=================================================================================================================
#                      Bluetooth & Devices > Touchpad > Scroll & Zoom > Scrolling Direction
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadScrollingDirection
        [-Value] {DownMotionScrollsDown | DownMotionScrollsUp}
        [<CommonParameters>]
#>

function Set-TouchpadScrollingDirection
{
    <#
    .EXAMPLE
        PS> Set-TouchpadScrollingDirection -Value 'DownMotionScrollsUp'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ScrollingDirectionMode] $Value
    )

    process
    {
        # down motion scrolls up: 0 (default) | down motion scrolls down: 1
        $TouchpadScrollingDirection = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'ScrollDirection'
                    Value = $Value -eq 'DownMotionScrollsDown' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Scrolling Direction' to '$Value' ..."
        Set-RegistryEntry -InputObject $TouchpadScrollingDirection
    }
}
