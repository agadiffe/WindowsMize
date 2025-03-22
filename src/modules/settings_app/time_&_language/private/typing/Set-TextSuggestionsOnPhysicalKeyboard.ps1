#=================================================================================================================
#              Time & Language > Typing > Show Text Suggestions When Typing On The Physical Keyboard
#=================================================================================================================

<#
.SYNTAX
    Set-TextSuggestionsOnPhysicalKeyboard
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TextSuggestionsOnPhysicalKeyboard
{
    <#
    .EXAMPLE
        PS> Set-TextSuggestionsOnPhysicalKeyboard -State 'Disabled'
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
        $TextSuggestionsPhysicalKeyboard = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Input\Settings'
            Entries = @(
                @{
                    Name  = 'EnableHwkbTextPrediction'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Show Text Suggestions When Typing On The Physical Keyboard' to '$State' ..."
        Set-RegistryEntry -InputObject $TextSuggestionsPhysicalKeyboard
    }
}
