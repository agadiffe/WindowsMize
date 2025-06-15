#=================================================================================================================
#                                  Privacy & Security > App Permissions > Tasks
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsTasks
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsTasks
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsTasks -State 'Disabled' -GPO 'NotConfigured'
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
        $TasksMsg = 'Tasks'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Tasks = [AppPermissionAccess]::new('userDataTasks', $State)
                $Tasks.WriteVerboseMsg($TasksMsg)
                $Tasks.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access Tasks
                # not configured: delete (default) | on: 1 | off: 2

                $TasksGpo = [AppPermissionPolicy]::new('LetAppsAccessTasks', $GPO)
                $TasksGpo.WriteVerboseMsg("$TasksMsg (GPO)")
                $TasksGpo.SetRegistryEntry()
            }
        }
    }
}
