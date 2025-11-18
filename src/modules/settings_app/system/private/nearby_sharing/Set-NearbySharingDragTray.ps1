#=================================================================================================================
#                                       System > Nearby Sharing > Drag Tray
#=================================================================================================================

<#
.SYNTAX
    Set-NearbySharingDragTray
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NearbySharingDragTray
{
    <#
    .EXAMPLE
        PS> Set-NearbySharingDragTray -State 'Disabled'
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
        $NearbySharingDragTray = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP'
            Entries = @(
                @{
                    Name  = 'DragTrayEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Nearby Sharing - Drag Tray' to '$State' ..."
        Set-RegistryEntry -InputObject $NearbySharingDragTray
    }
}
