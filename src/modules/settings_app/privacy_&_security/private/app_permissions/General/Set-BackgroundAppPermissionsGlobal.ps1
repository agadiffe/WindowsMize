#=================================================================================================================
#                            Privacy & Security > Background App Permissions (Global)
#=================================================================================================================

# Applies only to MsStore/UWP apps (e.g. Calculator, Notepad, Photos, ...).

# If disabled, it will also disable Windows Spotlight.
# May also disable/break other apps features ?
# e.g. iCloud Photos synchronization, MsTeams/Discord/etc notifications.

<#
.SYNTAX
    Set-BackgroundAppPermissionsGlobal
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-BackgroundAppPermissionsGlobal
{
    <#
    .EXAMPLE
        PS> Set-BackgroundAppPermissionsGlobal -State 'Disabled' -GPO 'NotConfigured'
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
        $BackgroundAppsMsg = 'Background Activity (Global)'

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
