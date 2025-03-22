#=================================================================================================================
#              Time & Language > Typing > Show Text Suggestions When Typing On The Software Keyboard
#=================================================================================================================

# Only works in Windows 10 ? (setting not present in Windows 11)

<#
.SYNTAX
    Set-TextSuggestionsOnSoftwareKeyboard
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TextSuggestionsOnSoftwareKeyboard
{
    <#
    .EXAMPLE
        PS> Set-TextSuggestionsOnSoftwareKeyboard -State 'Disabled'
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
        $TextSuggestionsSoftwareKeyboard = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\TabletTip\1.7'
            Entries = @(
                @{
                    Name  = 'EnableTextPrediction'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Show Text Suggestions When Typing On The Software Keyboard' to '$State' ..."
        Set-RegistryEntry -InputObject $TextSuggestionsSoftwareKeyboard
    }
}
