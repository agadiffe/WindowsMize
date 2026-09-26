#=================================================================================================================
#                                          System > Sound > Mono Audio
#=================================================================================================================

<#
.SYNTAX
    Set-SoundMonoAudio
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SoundMonoAudio
{
    <#
    .EXAMPLE
        PS> Set-SoundMonoAudio -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $SoundMonoAudio = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Multimedia\Audio'
            Entries = @(
                @{
                    Name  = 'AccessibilityMonoMixState'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Sound - Mono Audio' to '$Preference' ..."
        Set-RegistryEntry -InputObject $SoundMonoAudio
    }
}
