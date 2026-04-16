#=================================================================================================================
#                       Gaming > Xbox Mode > Show Accessibility Control Hints In Task View
#=================================================================================================================

<#
.SYNTAX
    Set-XboxModeShowInTaskView
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-XboxModeShowControlHintsInTaskView
{
    <#
    .EXAMPLE
        PS> Set-XboxModeShowControlHintsInTaskView -State 'Disabled'
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
        $XboxModeShowControlHintsInTaskView = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\GameBar'
            Entries = @(
                @{
                    Name  = 'TaskSwitcherNexusInjectionEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Gaming - Xbox Mode: Show Accessibility Control Hints In Task View' to '$State' ..."
        Set-RegistryEntry -InputObject $XboxModeShowControlHintsInTaskView
    }
}
