#=================================================================================================================
#       Accounts > Sign-In Options > If You've Been Away, When Should Windows Require You To Sign In Again
#=================================================================================================================

# Only available if your account has a password.

<#
.SYNTAX for Standard Standby (S3)
    Set-SigninRequiredIfAway
        [[-Delay] {Never | OnWakesUpFromSleep}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]

.SYNTAX for Modern Standby (S0)
    Set-SigninRequiredIfAway
        [[-Delay] {Never | Always | OneMin | ThreeMins | FiveMins | FifteenMins}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-SigninRequiredIfAway
{
    <#
    .EXAMPLE
        PS> Set-SigninRequiredIfAway -Delay 'Never' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [ValidateSet([SigninRequiredIfAwayS0orS3Generator])]
        [string] $Delay,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $SettingGUID = '0e796bdb-100d-47d6-a2d5-f7d2daa51f51' # CONSOLELOCK

        $SigninRequiredIfAwayMsg = 'Sign-In Options - When Should Windows Require You To Sign In Again'

        switch ($PSBoundParameters.Keys)
        {
            'Delay'
            {
                Write-Verbose -Message "Setting '$SigninRequiredIfAwayMsg' to '$Delay' ..."

                if (Test-ModernStandbyAvailability)
                {
                    $SettingValue = switch ($Delay)
                    {
                        'Never'       { [uint]::MaxValue }
                        'Always'      { 0 }
                        'OneMin'      { 60 }
                        'ThreeMins'   { 180 }
                        'FiveMins'    { 300 }
                        'FifteenMins' { 900 }
                    }

                    # never: 4294967295 (UINT_MAX) | every time: 0 (default)
                    # 1 minute: 60 | 3 minutes: 180 | 5 minutes: 300 | 15 minutes: 900
                    $SigninRequiredIfAway = @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Control Panel\Desktop'
                        Entries = @(
                            @{
                                Name  = 'DelayLockInterval'
                                Value = $SettingValue
                                Type  = 'DWord'
                            }
                        )
                    }

                    Set-RegistryEntry -InputObject $SigninRequiredIfAway
                }
                else
                {
                    $Value = $Delay -eq 'Never' ? 0 : 1

                    $SubGroupGUID = 'fea3413e-7e05-4911-9a71-700331f1c294' # SUB_NONE
                    $PowerPlanGUID = Get-PowerPlanGUID

                    foreach ($GUID in $PowerPlanGUID)
                    {
                        # If GPO is defined, powercfg cannot change the user setting. Use registry editing.

                        # never: 0 | when PC wakes up from sleep: 1 (default)
                        $SigninRequiredIfAway = @{
                            Hive    = 'HKEY_LOCAL_MACHINE'
                            Path    = "SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\$GUID\$SubGroupGUID\$SettingGUID"
                            Entries = @(
                                @{
                                    Name  = 'ACSettingIndex'
                                    Value = $Value
                                    Type  = 'DWord'
                                }
                                @{
                                    Name  = 'DCSettingIndex'
                                    Value = $Value
                                    Type  = 'DWord'
                                }
                            )
                        }

                        Set-RegistryEntrySystemProtected -InputObject $SigninRequiredIfAway
                    }
                }

                powercfg.exe -SetActive SCHEME_CURRENT
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                # gpo\ computer config > administrative tpl > system > power management > sleep settings
                #   require a password when a computer wakes (on battery)
                #   require a password when a computer wakes (plugged in)
                # not configured: delete (default) | off: 0
                $SigninRequiredIfAwayGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Policies\Microsoft\Power\PowerSettings\$SettingGUID"
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ACSettingIndex'
                            Value = '0'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'DCSettingIndex'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$SigninRequiredIfAwayMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $SigninRequiredIfAwayGpo
            }
        }
    }
}
