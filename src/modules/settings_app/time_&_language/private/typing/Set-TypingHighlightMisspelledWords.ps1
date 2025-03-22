#=================================================================================================================
#                              Time & Language > Typing > Highlight Misspelled Words
#=================================================================================================================

<#
.SYNTAX
    Set-TypingHighlightMisspelledWords
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TypingHighlightMisspelledWords
{
    <#
    .EXAMPLE
        PS> Set-TypingHighlightMisspelledWords -State 'Disabled'
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
        $TypingHighlightMisspelledWords = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\TabletTip\1.7'
            Entries = @(
                @{
                    Name  = 'EnableSpellchecking'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Highlight Misspelled Words' to '$State' ..."
        Set-RegistryEntry -InputObject $TypingHighlightMisspelledWords
    }
}
