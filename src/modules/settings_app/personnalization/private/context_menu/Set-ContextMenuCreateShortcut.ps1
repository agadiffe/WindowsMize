#=================================================================================================================
#                                Personnalization > Context Menu > Create Shortcut
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuCreateShortcut
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuCreateShortcut
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuCreateShortcut -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $ContextMenuCreateShortcut = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\verbs\link'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Create Shortcut' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuCreateShortcut
    }
}
