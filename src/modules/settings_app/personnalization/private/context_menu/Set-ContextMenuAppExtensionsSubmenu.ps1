#=================================================================================================================
#                 Personnalization > Context Menu > App Extensions > Show App Extensions Submenu
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuAppExtensionsSubmenu
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuAppExtensionsSubmenu
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuAppExtensionsSubmenu -State 'Enabled'
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
        $ContextMenuAppExtensionsSubmenu = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\ShowExtensions'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Show App Extensions Submenu' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuAppExtensionsSubmenu
    }
}
