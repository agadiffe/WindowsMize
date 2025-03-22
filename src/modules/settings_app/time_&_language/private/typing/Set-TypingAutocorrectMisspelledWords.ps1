#=================================================================================================================
#                             Time & Language > Typing > Autocorrect Misspelled Words
#=================================================================================================================

<#
.SYNTAX
    Set-TypingAutocorrectMisspelledWords
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TypingAutocorrectMisspelledWords
{
    <#
    .EXAMPLE
        PS> Set-TypingAutocorrectMisspelledWords -State 'Disabled'
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
        $TypingAutocorrectMisspelledWords = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\TabletTip\1.7'
            Entries = @(
                @{
                    Name  = 'EnableAutocorrection'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Autocorrect Misspelled Words' to '$State' ..."
        Set-RegistryEntry -InputObject $TypingAutocorrectMisspelledWords
    }
}
