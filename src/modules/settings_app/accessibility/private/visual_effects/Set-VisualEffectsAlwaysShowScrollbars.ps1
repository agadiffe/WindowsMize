#=================================================================================================================
#                             Accessibility > Visual Effects > Always Show Scrollbars
#=================================================================================================================

<#
.SYNTAX
    Set-VisualEffectsAlwaysShowScrollbars
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffectsAlwaysShowScrollbars
{
    <#
    .EXAMPLE
        PS> Set-VisualEffectsAlwaysShowScrollbars -State 'Disabled'
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
        $VisualEffectsAlwaysShowScrollbars = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility'
            Entries = @(
                @{
                    Name  = 'DynamicScrollbars'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Visual Effects - Always Show Scrollbars' to '$State' ..."
        Set-RegistryEntry -InputObject $VisualEffectsAlwaysShowScrollbars
    }
}
