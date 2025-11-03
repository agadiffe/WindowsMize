#=================================================================================================================
#                            Personnalization > Taskbar > System Tray Icons > Pen Menu
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarPenMenu
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarPenMenu
{
    <#
    .EXAMPLE
        PS> Set-TaskbarPenMenu -State 'Disabled'
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
        $TaskbarTrayIconsPenMenu = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PenWorkspace'
            Entries = @(
                @{
                    Name  = 'PenWorkspaceButtonDesiredVisibility'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Tray Icons - Pen Menu' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarTrayIconsPenMenu
    }
}
