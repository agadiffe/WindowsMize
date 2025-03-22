#=================================================================================================================
#                               Privacy & Security > App Permissions > Eye Tracker
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsEyeTracker
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsEyeTracker
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsEyeTracker -State 'Disabled' -GPO 'NotConfigured'
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
        $EyeTrackerMsg = 'Eye Tracker'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $EyeTracker = [AppPermissionAccess]::new('gazeInput', $State)
                $EyeTracker.WriteVerboseMsg($EyeTrackerMsg)
                $EyeTracker.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access an eye tracker device
                # not configured: delete (default) | on: 1 | off: 2

                $EyeTrackerGpo = [AppPermissionPolicy]::new('LetAppsAccessGazeInput', $GPO)
                $EyeTrackerGpo.WriteVerboseMsg("$EyeTrackerMsg (GPO)")
                $EyeTrackerGpo.SetRegistryEntry()
            }
        }
    }
}
