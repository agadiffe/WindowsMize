#=================================================================================================================
#                                Bluetooth & Devices > Mouse > Scrolling Direction
#=================================================================================================================

<#
.SYNTAX
    Set-MouseScrollingDirection
        [-Direction] {DownMotionScrollsDown | DownMotionScrollsUp}
        [<CommonParameters>]
#>

function Set-MouseScrollingDirection
{
    <#
    .EXAMPLE
        PS> Set-MouseScrollingDirection -Direction 'DownMotionScrollsDown'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ScrollingDirectionMode] $Direction
    )

    process
    {
        # down motion scrolls down: 0 (default) | down motion scrolls up: 1
        $MouseScrollingDirection = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Mouse'
            Entries = @(
                @{
                    Name  = 'ReverseMouseWheelDirection'
                    Value = $Direction -eq 'DownMotionScrollsDown' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Scrolling Direction' to '$Direction' ..."
        Set-RegistryEntry -InputObject $MouseScrollingDirection
    }
}
