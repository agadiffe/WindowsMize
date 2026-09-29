#=================================================================================================================
#                             Accessibility > Narrator > Math Reading > Pause Factor
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathSpeechPauseFactor
        [-Factor] <int>
        [<CommonParameters>]
#>

function Set-NarratorMathSpeechPauseFactor
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathSpeechPauseFactor -Factor 50
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int] $Factor
    )

    process
    {
        # default: 50 (range: 0-100)
        $NarratorMathSpeechPauseFactor = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathReadingPauseFactor'
                    Value = $Factor
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading: Speech Pause Factor' to '$Factor' ..."
        Set-RegistryEntry -InputObject $NarratorMathSpeechPauseFactor
    }
}
