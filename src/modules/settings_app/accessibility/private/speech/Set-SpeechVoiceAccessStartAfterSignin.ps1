#=================================================================================================================
#             Accessibility > Speech > Voice Access > Start Voice Access After You Sign In To Your PC
#=================================================================================================================

<#
.SYNTAX
    Set-SpeechVoiceAccessStartAfterSignin
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SpeechVoiceAccessStartAfterSignin
{
    <#
    .EXAMPLE
        PS> Set-SpeechVoiceAccessStartAfterSignin -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: voiceaccess | off: empty value (default)
        $VoiceAccessStartAfterSignin = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows NT\CurrentVersion\Accessibility'
            Entries = @(
                @{
                    Name  = 'Configuration'
                    Value = $State -eq 'Enabled' ? 'voiceaccess' : ''
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Speech - Start Voice Access After Signin' to '$State' ..."
        Set-RegistryEntry -InputObject $VoiceAccessStartAfterSignin
    }
}
