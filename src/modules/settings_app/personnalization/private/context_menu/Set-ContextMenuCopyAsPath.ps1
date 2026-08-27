#=================================================================================================================
#                                 Personnalization > Context Menu > Copy As Path
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuCopyAsPath
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuCopyAsPath
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuCopyAsPath -State 'Enabled'
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
        $ContextMenuCopyAsPath = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\verbs\copyaspath'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Copy As Path' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuCopyAsPath
    }
}
