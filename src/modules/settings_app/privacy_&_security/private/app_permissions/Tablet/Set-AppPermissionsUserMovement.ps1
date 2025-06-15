#=================================================================================================================
#                              Privacy & Security > App Permissions > User Movement
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsUserMovement
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsUserMovement
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsUserMovement -State 'Disabled' -GPO 'NotConfigured'
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
        $UserMovementMsg = 'User Movement'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $UserMovement = [AppPermissionAccess]::new('spatialPerception', $State)
                $UserMovement.WriteVerboseMsg($UserMovementMsg)
                $UserMovement.SetRegistryEntry()

                $UserMovementBackground = [AppPermissionAccess]::new('backgroundSpatialPerception', $State)
                $UserMovementBackground.WriteVerboseMsg("$UserMovementMsg (Background)")
                $UserMovementBackground.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access user movements while running in the background
                # not configured: delete (default) | on: 1 | off: 2

                $UserMovementGpo = [AppPermissionPolicy]::new('LetAppsAccessBackgroundSpatialPerception', $GPO)
                $UserMovementGpo.WriteVerboseMsg("$UserMovementMsg (GPO)")
                $UserMovementGpo.SetRegistryEntry()
            }
        }
    }
}
