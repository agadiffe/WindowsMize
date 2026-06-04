#=================================================================================================================
#              Accessibility > Narrator > Verbosity Level > Pause Slightly When Reading Punctuation
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorPunctuationPause
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorPunctuationPause
{
    <#
    .EXAMPLE
        PS> Set-NarratorPunctuationPause -State 'Enabled'
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
        $NarratorPunctuationPause = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'IntonationPause'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Verbosity Level: Pause Slightly When Reading Punctuation' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorPunctuationPause
    }
}
