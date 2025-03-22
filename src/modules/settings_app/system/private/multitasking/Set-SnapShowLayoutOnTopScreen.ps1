#=================================================================================================================
#                   System > Multitasking > Snap Windows > Show Snap Layouts To The Top Screen
#=================================================================================================================

# Show snap layouts when I drag a window to the top of my screen

<#
.SYNTAX
    Set-SnapShowLayoutOnTopScreen
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SnapShowLayoutOnTopScreen
{
    <#
    .EXAMPLE
        PS> Set-SnapShowLayoutOnTopScreen -State 'Disabled'
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
        $SnapShowLayoutOnTopScreen = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'EnableSnapBar'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $SnapTopScreenMsg = 'Show Snap Layouts When I Drag A Window To The Top Of My Screen'
        Write-Verbose -Message "Setting 'Snap Windows - $SnapTopScreenMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $SnapShowLayoutOnTopScreen
    }
}
