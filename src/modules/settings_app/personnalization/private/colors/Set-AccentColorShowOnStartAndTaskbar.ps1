#=================================================================================================================
#                       Personnalization > Colors > Show Accent Color On Start And Taskbar
#=================================================================================================================

# Requires dark mode enabled.

<#
.SYNTAX
    Set-AccentColorShowOnStartAndTaskbar
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AccentColorShowOnStartAndTaskbar
{
    <#
    .EXAMPLE
        PS> Set-AccentColorShowOnStartAndTaskbar -State 'Disabled'
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
        $AccentColorStartAndTaskbar = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
            Entries = @(
                @{
                    Name  = 'ColorPrevalence'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Colors - Show Accent Color On Start And Taskbar' to '$State' ..."
        Set-RegistryEntry -InputObject $AccentColorStartAndTaskbar
    }
}
