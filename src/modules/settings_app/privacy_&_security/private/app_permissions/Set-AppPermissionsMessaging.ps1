#=================================================================================================================
#                                Privacy & Security > App Permissions > Messaging
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsMessaging
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsMessaging
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsMessaging -State 'Disabled' -GPO 'NotConfigured'
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
        $MessagingMsg = 'Messaging'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Messaging = [AppPermissionAccess]::new('chat', $State)
                $Messaging.WriteVerboseMsg($MessagingMsg)
                $Messaging.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access messaging
                # not configured: delete (default) | on: 1 | off: 2

                $MessagingGpo = [AppPermissionPolicy]::new('LetAppsAccessMessaging', $GPO)
                $MessagingGpo.WriteVerboseMsg("$MessagingMsg (GPO)")
                $MessagingGpo.SetRegistryEntry()
            }
        }
    }
}
