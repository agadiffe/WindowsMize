#=================================================================================================================
#                                     Personnalization > Context Menu > Print
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuPrint
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuPrint
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuPrint -State 'Disabled'
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
        $ContextMenuPrint = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\verbs\print'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Print' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuPrint
    }
}
