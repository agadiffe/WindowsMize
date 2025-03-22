#=================================================================================================================
#                     System > Multitasking > Snap Windows > Snap Before Reaching Screen Edge
#=================================================================================================================

# When I drag a window, let me snap it without dragging all the way to the screen edge

<#
.SYNTAX
    Set-SnapBeforeReachingScreenEdge
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SnapBeforeReachingScreenEdge
{
    <#
    .EXAMPLE
        PS> Set-SnapBeforeReachingScreenEdge -State 'Disabled'
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
        $SnapBeforeScreenEdge = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'DITest'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $SnapProximityMsg = 'When I Drag A Window, Let Me Snap It Without Dragging All The Way To The Screen Edge'
        Write-Verbose -Message "Setting 'Snap Windows - $SnapProximityMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $SnapBeforeScreenEdge
    }
}
