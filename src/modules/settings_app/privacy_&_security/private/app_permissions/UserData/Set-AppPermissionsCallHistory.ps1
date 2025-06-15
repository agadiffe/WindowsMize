#=================================================================================================================
#                               Privacy & Security > App Permissions > Call History
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsCallHistory
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsCallHistory
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsCallHistory -State 'Disabled' -GPO 'NotConfigured'
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
        $CallHistoryMsg = 'Call History'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $CallHistory = [AppPermissionAccess]::new('phoneCallHistory', $State)
                $CallHistory.WriteVerboseMsg($CallHistoryMsg)
                $CallHistory.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access call history
                # not configured: delete (default) | on: 1 | off: 2

                $CallHistoryGpo = [AppPermissionPolicy]::new('LetAppsAccessCallHistory', $GPO)
                $CallHistoryGpo.WriteVerboseMsg("$CallHistoryMsg (GPO)")
                $CallHistoryGpo.SetRegistryEntry()
            }
        }
    }
}
