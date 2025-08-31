#=================================================================================================================
#                             Privacy & Security > App Permissions > Background Apps
#=================================================================================================================

# Applies only to the apps installed from Microsoft Store (e.g. Calculator, Photos, Notepad, ...).

# If disabled, it will also disable Windows Spotlight.
# May also disable/break other apps features ?
# e.g. iCloud Photos synchronization, MsTeams/Discord/etc notifications.

<#
.SYNTAX
    Set-AppPermissionsBackgroundApps
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsBackgroundApps
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsBackgroundApps -State 'Disabled' -GPO 'NotConfigured'
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
        $BackgroundAppsMsg = 'Background Apps'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 0 (default) | off: 1
                $BackgroundApps = [AppPermissionSetting]::new(@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications'
                    Entries = @(
                        @{
                            Name  = 'GlobalUserDisabled'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                })

                $BackgroundApps.WriteVerboseMsg($BackgroundAppsMsg, $State)
                $BackgroundApps.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps run in the background
                # not configured: delete (default) | on: 1 | off: 2

                $BackgroundAppsGpo = [AppPermissionPolicy]::new('LetAppsRunInBackground', $GPO)
                $BackgroundAppsGpo.WriteVerboseMsg("$BackgroundAppsMsg (GPO)")
                $BackgroundAppsGpo.SetRegistryEntry()
            }
        }
    }
}
