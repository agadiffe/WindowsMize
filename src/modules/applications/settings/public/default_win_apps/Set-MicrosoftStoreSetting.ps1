#=================================================================================================================
#                                             Microsoft Store Setting
#=================================================================================================================

<#
.SYNTAX
    Set-MicrosoftStoreSetting
        [-AutoAppUpdates {Disabled | Enabled}]
        [-AutoAppUpdatesGPO {Disabled | Enabled | NotConfigured}]
        [-AppInstallNotifications {Disabled | Enabled}]
        [-VideoAutoplay {Disabled | Enabled}]
        [-PersonalizedExperiences {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-MicrosoftStoreSetting
{
    <#
    .EXAMPLE
        PS> Set-MicrosoftStoreSetting -AutoAppsUpdates 'Enabled' -VideoAutoplay 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AutoAppUpdates,
        [GpoState] $AutoAppUpdatesGPO,
        [state] $AppInstallNotifications,
        [state] $VideoAutoplay,
        [state] $PersonalizedExperiences
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $MicrosoftStoreSettings = [System.Collections.ArrayList]::new()

        switch ($PSBoundParameters.Keys)
        {
            'AutoAppUpdates'
            {
                # settings.dat registry key: UpdateAppsAutomatically (5f5e10b).
                # Applied only when Microsoft Store is launched.

                # on: 4 (default) | off: 2
                $AutoAppUpdatesReg = @(
                    @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate'
                        Entries = @(
                            @{
                                Name  = 'AutoDownload'
                                Value = $AutoAppUpdates -eq 'Enabled' ? '4' : '2'
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\InstallService\State'
                        Entries = @(
                            @{
                                Name  = 'AutoUpdatePauseEndTime'
                                Value = (Get-Date).AddDays(7).ToString('yyyy-MM-ddTHH:mm:ssK')
                                Type  = 'String'
                            }
                        )
                    }
                )
                Write-Verbose -Message "Setting 'Microsoft Store - Auto App Updates' to '$AutoAppUpdates' ..."
                $AutoAppUpdatesReg | Set-RegistryEntry
            }
            'AutoAppUpdatesGPO'
            {
                # gpo\ computer config > administrative tpl > windows components > store
                #   turn off automatic download and install of updates
                # not configured: delete (default) | on: 4 | off: 2
                $AutoAppUpdatesRegGPO = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\WindowsStore'
                    Entries = @(
                        @{
                            RemoveEntry = $AutoAppUpdatesGPO -eq 'NotConfigured'
                            Name  = 'AutoDownload'
                            Value = $AutoAppUpdatesGPO -eq 'Enabled' ? '4' : '2'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Store - Auto App Updates (GPO)' to '$AutoAppUpdatesGPO' ..."
                Set-RegistryEntry -InputObject $AutoAppUpdatesRegGPO
            }
            'AppInstallNotifications'
            {
                # on: 1 (default) | off: 0
                $AppInstallNotificationsReg = @{
                    Name  = 'EnableAppInstallNotifications'
                    Value = $AppInstallNotifications -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $MicrosoftStoreSettings.Add([PSCustomObject]$AppInstallNotificationsReg) | Out-Null
            }
            'VideoAutoplay'
            {
                # on: 1 (default) | off: 0
                $VideoAutoplayReg = @{
                    Name  = 'VideoAutoplay'
                    Value = $VideoAutoplay -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $MicrosoftStoreSettings.Add([PSCustomObject]$VideoAutoplayReg) | Out-Null
            }
            'PersonalizedExperiences'
            {
                # on: 1 (default) | off: 0
                $PersonalizedExperiencesReg = @{
                    Path  = 'LocalState\PersistentSettings'
                    Name  = 'PersonalizationEnabled'
                    Value = $PersonalizedExperiences -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $MicrosoftStoreSettings.Add([PSCustomObject]$PersonalizedExperiencesReg) | Out-Null
            }
        }

        if ($MicrosoftStoreSettings.Count)
        {
            Set-UwpAppSetting -Name 'MicrosoftStore' -Setting $MicrosoftStoreSettings
        }
    }
}
