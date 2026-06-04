#=================================================================================================================
#                                Accessibility > Narrator > Choose A Voice > Pitch
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorVoicePitch
        [-Level] <int>
        [<CommonParameters>]
#>

function Set-NarratorVoicePitch
{
    <#
    .EXAMPLE
        PS> Set-NarratorVoicePitch -Level 10
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 20)]
        [int] $Level
    )

    process
    {
        # default: 10 (range: 0-20)
        $NarratorVoicePitch = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'SpeechPitch'
                    Value = $Level
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Voice Pitch' to 'Level: $Level' ..."
        Set-RegistryEntry -InputObject $NarratorVoicePitch
    }
}
