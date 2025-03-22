#=================================================================================================================
#                            Time & Language > Typing > Multilingual Text Suggestions
#=================================================================================================================

<#
.SYNTAX
    Set-TextSuggestionsMultilingual
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TextSuggestionsMultilingual
{
    <#
    .EXAMPLE
        PS> Set-TextSuggestionsMultilingual -State 'Disabled'
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
        $TextSuggestionsMultilingual = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Input\Settings'
            Entries = @(
                @{
                    Name  = 'MultilingualEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Multilingual Text Suggestions' to '$State' ..."
        Set-RegistryEntry -InputObject $TextSuggestionsMultilingual
    }
}
