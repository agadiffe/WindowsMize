#=================================================================================================================
#                                Bluetooth & Devices > Mouse > Scrolling Direction
#=================================================================================================================

<#
.SYNTAX
    Set-MouseScrollingDirection
        [-Value] {DownMotionScrollsDown | DownMotionScrollsUp}
        [<CommonParameters>]
#>

function Set-MouseScrollingDirection
{
    <#
    .EXAMPLE
        PS> Set-MouseScrollingDirection -Value 'DownMotionScrollsDown'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ScrollingDirectionMode] $Value
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
                    Value = $Value -eq 'DownMotionScrollsDown' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Scrolling Direction' to '$Value' ..."
        Set-RegistryEntry -InputObject $MouseScrollingDirection
    }
}
