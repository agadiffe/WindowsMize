#=================================================================================================================
#                              Accessibility > Visual Effects > Open Apps Maximized
#=================================================================================================================

<#
.SYNTAX
    Set-VisualEffectsOpenAppsMaximized
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffectsOpenAppsMaximized
{
    <#
    .EXAMPLE
        PS> Set-VisualEffectsOpenAppsMaximized -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 | off: 1 (default)
        $VisualEffectsOpenAppsMaximized = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Accessibility'
            Entries = @(
                @{
                    Name  = 'MaximizeWindowsByDefault'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Visual Effects - Open Apps Maximized' to '$State' ..."
        Set-RegistryEntry -InputObject $VisualEffectsOpenAppsMaximized
    }
}
