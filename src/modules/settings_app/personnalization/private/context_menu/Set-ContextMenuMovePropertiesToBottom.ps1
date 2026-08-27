#=================================================================================================================
#               Personnalization > Context Menu > Move Properties To The Bottom Of The Context Menu
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuMovePropertiesToBottom
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuMovePropertiesToBottom
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuMovePropertiesToBottom -State 'Disabled'
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
        $ContextMenuMovePropertiesToBottom = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\MoveProperties'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Move Properties To The Bottom Of The Context Menu' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuMovePropertiesToBottom
    }
}
