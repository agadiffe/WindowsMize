#=================================================================================================================
#                            Accessibility > Narrator > Math Reading > Verbosity Level
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathSpeechVerbosity
        [-Mode] {Terse | Medium | Verbose}
        [<CommonParameters>]
#>

function Set-NarratorMathSpeechVerbosity
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathSpeechVerbosity -Mode 'Medium'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [MathReadingVerbosityLevel] $Mode
    )

    process
    {
        # default: 50 (range: 0-100)
        $NarratorMathSpeechVerbosity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathReadingVerbosity'
                    Value = $Mode
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading: Verbosity Level' to '$Mode' ..."
        Set-RegistryEntry -InputObject $NarratorMathSpeechVerbosity
    }
}
