#=================================================================================================================
#                             Accessibility > Narrator > Math Reading > Speech Style
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathSpeechStyle
        [-Style] {ClearSpeak | SimpleSpeak | LiteralSpeak}
        [<CommonParameters>]
#>

function Set-NarratorMathSpeechStyle
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathSpeechStyle -Style 'ClearSpeak'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [MathSpeechStyle] $Style
    )

    process
    {
        # ClearSpeak (default) | SimpleSpeak | LiteralSpeak
        $NarratorMathSpeechStyle = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathReadingSpeechStyle'
                    Value = $Style
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading: Speech Style' to '$Style' ..."
        Set-RegistryEntry -InputObject $NarratorMathSpeechStyle
    }
}
