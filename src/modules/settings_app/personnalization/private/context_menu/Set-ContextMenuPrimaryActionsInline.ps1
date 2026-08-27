#=================================================================================================================
#                        Personnalization > Context Menu > Arrange Primary Actions Inline
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuPrimaryActionsInline
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuPrimaryActionsInline
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuPrimaryActionsInline -State 'Disabled'
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
        $ContextMenuPrimaryActionsInline = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\DemoteTopBar'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Arrange Primary Actions Inline' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuPrimaryActionsInline
    }
}
