#=================================================================================================================
#                             Privacy & Security > App Permissions > Voice Activation
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsVoiceActivation
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsVoiceActivation
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsVoiceActivation -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $VoiceActivationMsg = 'Voice Activation'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $Value = $State -eq 'Enabled' ? '1' : '0'

                # on: 1 1 1 (default) | off: 0 0 0
                $VoiceActivation = [AppPermissionSetting]::new(@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps'
                    Entries = @(
                        @{
                            Name  = 'AgentActivationEnabled'
                            Value = $Value
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'AgentActivationLastUsed'
                            Value = $Value
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'AgentActivationOnLockScreenEnabled'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                })

                $VoiceActivation.WriteVerboseMsg($VoiceActivationMsg, $State)
                $VoiceActivation.SetRegistryEntry()
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'
                $GpoValue = $GPO -eq 'Enabled' ? '1' : '2'

                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps activate with voice
                #   let Windows apps activate with voice while the system is locked
                # not configured: delete (default) | on: 1 | off: 2
                $VoiceActivationGpo = [AppPermissionSetting]::new(@{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\AppPrivacy'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'LetAppsActivateWithVoice'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'LetAppsActivateWithVoiceAboveLock'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                    )
                })

                $VoiceActivationGpo.WriteVerboseMsg("$VoiceActivationMsg (GPO)", $GPO)
                $VoiceActivationGpo.SetRegistryEntry()
            }
        }
    }
}
