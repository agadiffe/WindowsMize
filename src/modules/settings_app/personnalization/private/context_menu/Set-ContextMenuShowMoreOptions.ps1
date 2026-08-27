#=================================================================================================================
#                               Personnalization > Context Menu > Show More Options
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuShowMoreOptions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuShowMoreOptions
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuShowMoreOptions -State 'Disabled'
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
        $ShowMoreOptions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\ShowMore'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Show More Options' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowMoreOptions
    }
}
