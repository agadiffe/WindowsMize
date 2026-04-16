#=================================================================================================================
#                                Gaming > Xbox Mode > Show Xbox Mode In Task View
#=================================================================================================================

<#
.SYNTAX
    Set-XboxModeShowInTaskView
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-XboxModeShowInTaskView
{
    <#
    .EXAMPLE
        PS> Set-XboxModeShowInTaskView -State 'Disabled'
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
        $XboxModeShowInTaskView = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\GamingConfiguration'
            Entries = @(
                @{
                    Name  = 'ShowOnDesktopSwitcher'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Gaming - Xbox Mode: Show In Task View' to '$State' ..."
        Set-RegistryEntry -InputObject $XboxModeShowInTaskView
    }
}
