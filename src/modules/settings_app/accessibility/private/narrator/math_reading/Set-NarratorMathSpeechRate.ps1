#=================================================================================================================
#                              Accessibility > Narrator > Math Reading > Speech Rate
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathSpeechRate
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-NarratorMathSpeechRate
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathSpeechRate -Speed 50
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int] $Speed
    )

    process
    {
        # default: 50 (range: 0-100)
        $NarratorMathSpeechRate = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathReadingSpeechRate'
                    Value = $Speed
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading: Speech Rate' to '$Speed' ..."
        Set-RegistryEntry -InputObject $NarratorMathSpeechRate
    }
}
