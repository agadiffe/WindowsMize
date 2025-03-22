#=================================================================================================================
#                                   Time & Language > Typing > Typing Insights
#=================================================================================================================

# Typing and correction history.

<#
.SYNTAX
    Set-TypingInsights
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TypingInsights
{
    <#
    .EXAMPLE
        PS> Set-TypingInsights -State 'Disabled'
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
        $TypingInsights = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Input\Settings'
            Entries = @(
                @{
                    Name  = 'InsightsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Typing Insights' to '$State' ..."
        Set-RegistryEntry -InputObject $TypingInsights
    }
}
