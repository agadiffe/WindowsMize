#=================================================================================================================
#                                    Personnalization > Context Menu > Send To
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuSendTo
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuSendTo
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuSendTo -State 'Disabled'
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
        $ContextMenuSendTo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\verbs\sendto'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Send To' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuSendTo
    }
}
