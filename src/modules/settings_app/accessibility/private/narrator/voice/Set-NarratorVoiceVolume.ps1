#=================================================================================================================
#                               Accessibility > Narrator > Choose A Voice > Volume
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorVoiceVolume
        [-Volume] <int>
        [<CommonParameters>]
#>

function Set-NarratorVoiceVolume
{
    <#
    .EXAMPLE
        PS> Set-NarratorVoiceVolume -Volume 100
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int] $Volume
    )

    process
    {
        # default: 100 (range: 0-100)
        $NarratorVoiceVolume = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'SpeechVolume'
                    Value = $Volume
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Voice Volume' to '$Volume%' ..."
        Set-RegistryEntry -InputObject $NarratorVoiceVolume
    }
}
