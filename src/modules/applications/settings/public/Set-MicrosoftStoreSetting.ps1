#=================================================================================================================
#                                             Microsoft Store Setting
#=================================================================================================================

<#
.SYNTAX
    Set-MicrosoftStoreSetting
        [-AutoAppsUpdates {Disabled | Enabled}]
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
        [state] $AutoAppsUpdates,
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
            'AutoAppsUpdates'
            {
                # on: 1 (default) | off: 0
                $AutoAppsUpdatesReg = @{
                    Name  = 'UpdateAppsAutomatically'
                    Value = $AutoAppsUpdate -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $MicrosoftStoreSettings.Add([PSCustomObject]$AutoAppsUpdatesReg) | Out-Null
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

        Set-UwpAppSetting -Name 'MicrosoftStore' -Setting $MicrosoftStoreSettings
    }
}
