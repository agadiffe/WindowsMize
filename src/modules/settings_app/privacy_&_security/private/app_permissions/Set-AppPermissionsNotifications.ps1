#=================================================================================================================
#                              Privacy & Security > App Permissions > Notifications
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsNotifications
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsNotifications
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsNotifications -State 'Disabled' -GPO 'NotConfigured'
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
        $NotificationsMsg = 'Notifications'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Notifications = [AppPermissionAccess]::new('userNotificationListener', $State)
                $Notifications.WriteVerboseMsg($NotificationsMsg)
                $Notifications.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access notifications
                # not configured: delete (default) | on: 1 | off: 2

                $NotificationsGpo = [AppPermissionPolicy]::new('LetAppsAccessNotifications', $GPO)
                $NotificationsGpo.WriteVerboseMsg("$NotificationsMsg (GPO)")
                $NotificationsGpo.SetRegistryEntry()
            }
        }
    }
}
