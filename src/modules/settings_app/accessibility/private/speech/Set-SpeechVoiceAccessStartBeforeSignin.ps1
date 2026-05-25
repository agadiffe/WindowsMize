#=================================================================================================================
#            Accessibility > Speech > Voice Access > Start Voice Access Before You Sign In To Your PC
#=================================================================================================================

<#
.SYNTAX
    Set-SpeechVoiceAccessStartBeforeSignin
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SpeechVoiceAccessStartBeforeSignin
{
    <#
    .EXAMPLE
        PS> Set-SpeechVoiceAccessStartBeforeSignin -State 'Disabled'
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
        $VoiceAccessStartBeforeSignin = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Accessibility'
            Entries = @(
                @{
                    Name  = 'Configuration'
                    Value = $State -eq 'Enabled' ? 'voiceaccess' : ''
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Speech - Start Voice Access Before Signin' to '$State' ..."
        Set-RegistryEntry -InputObject $VoiceAccessStartBeforeSignin
    }
}
