#=================================================================================================================
#                   Personnalization > Context Menu > Show "Customize Menu" On The Context Menu
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuShowCustomizeMenu
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuShowCustomizeMenu
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuShowCustomizeMenu -State 'Disabled'
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
        $ContextMenuShowCustomizeMenu = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\ShowCustomizeMenu'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Show ""Customize Menu"" On The Context Menu' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuShowCustomizeMenu
    }
}
