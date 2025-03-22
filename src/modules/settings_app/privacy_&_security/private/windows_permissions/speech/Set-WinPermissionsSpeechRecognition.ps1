#=================================================================================================================
#                             Privacy & Security > Speech > Online Speech Recognition
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsSpeechRecognition
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsSpeechRecognition
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsSpeechRecognition -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $WinPermissionsSpeechRecognitionMsg = 'Windows Permissions - Speech: Online Speech Recognition'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsSpeechRecognition = @(
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy'
                        Entries = @(
                            @{
                                Name  = 'HasAccepted'
                                Value = $State -eq 'Enabled' ? '1' : '0'
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechLogging'
                        Entries = @(
                            @{
                                Name  = 'LoggingAllowed' # contributing my voice clips (default: off)
                                Value = '0'
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting '$WinPermissionsSpeechRecognitionMsg' to '$State' ..."
                $WinPermissionsSpeechRecognition | Set-RegistryEntry
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > control panel > regional and language options
                #   allow users to enable online speech recognition services
                # not configured: delete (default) | off: 0
                $WinPermissionsSpeechRecognitionGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\InputPersonalization'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowInputPersonalization'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsSpeechRecognitionMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsSpeechRecognitionGpo
            }
        }
    }
}
