#=================================================================================================================
#                        System > Multitasking > Snap Windows > Show Snapped Window Group
#=================================================================================================================

# Show my snapped windows when I hover taskbar apps, in Task View, and when I press Alt+Tab

<#
.SYNTAX
    Set-SnapShowSnappedWindowGroup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SnapShowSnappedWindowGroup
{
    <#
    .EXAMPLE
        PS> Set-SnapShowSnappedWindowGroup -State 'Disabled'
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
        $SnappedWindowGroup = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'EnableTaskGroups'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $SnapTaskGroupsMsg = 'Show my snapped windows when I hover taskbar apps, in Task View, and when I press Alt+Tab'
        Write-Verbose -Message "Setting 'Snap Windows - $SnapTaskGroupsMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $SnappedWindowGroup
    }
}
