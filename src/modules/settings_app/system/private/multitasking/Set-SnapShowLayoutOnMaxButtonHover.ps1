#=================================================================================================================
#                  System > Multitasking > Snap Windows > Show Snap Layouts On Max Button Hover
#=================================================================================================================

# Show snap layouts when I hover a window's maximize button

<#
.SYNTAX
    Set-SnapShowLayoutOnMaxButtonHover
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SnapShowLayoutOnMaxButtonHover
{
    <#
    .EXAMPLE
        PS> Set-SnapShowLayoutOnMaxButtonHover -State 'Disabled'
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
        $SnapShowLayoutOnMaxButtonHover = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'EnableSnapAssistFlyout'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $SnapMaxButtonHoverMsg = 'Show Snap Layouts When I Hover A Window''s Maximize Button'
        Write-Verbose -Message "Setting 'Snap Windows - $SnapMaxButtonHoverMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $SnapShowLayoutOnMaxButtonHover
    }
}
