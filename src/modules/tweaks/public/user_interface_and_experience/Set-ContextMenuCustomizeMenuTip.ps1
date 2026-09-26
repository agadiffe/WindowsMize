#=================================================================================================================
#                                        Context Menu "Customize Menu" Tip
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuCustomizeMenuTip
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuCustomizeMenuTip
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuCustomizeMenuTip -State 'Disabled'
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
        $ContextMenuCustomizeMenuTip = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\ShowCustomizeMenu'
            Entries = @(
                @{
                    Name  = 'CustomizeMenuTipDismissed'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu ""Customize Menu"" Tip' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuCustomizeMenuTip
    }
}
