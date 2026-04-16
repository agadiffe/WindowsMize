#=================================================================================================================
#                                        System > Multitasking > Drop Tray
#=================================================================================================================

<#
.SYNTAX
    Set-MultitaskingDropTray
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MultitaskingDropTray
{
    <#
    .EXAMPLE
        PS> Set-MultitaskingDropTray -State 'Disabled'
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
        $MultitaskingDropTray = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP'
            Entries = @(
                @{
                    Name  = 'DragTrayEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Multitasking - Drop Tray' to '$State' ..."
        Set-RegistryEntry -InputObject $MultitaskingDropTray
    }
}
