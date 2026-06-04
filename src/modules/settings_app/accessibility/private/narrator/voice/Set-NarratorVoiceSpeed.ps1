#=================================================================================================================
#                                Accessibility > Narrator > Choose A Voice > Speed
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorVoiceSpeed
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-NarratorVoiceSpeed
{
    <#
    .EXAMPLE
        PS> Set-NarratorVoiceSpeed -Speed 10
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 20)]
        [int] $Speed
    )

    process
    {
        # default: 10 (range: 0-20)
        $NarratorVoiceSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'SpeechSpeed'
                    Value = $Speed
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Voice Speed' to '$Speed' ..."
        Set-RegistryEntry -InputObject $NarratorVoiceSpeed
    }
}
