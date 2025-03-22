#=================================================================================================================
#                                  Privacy & Security > App Permissions > Camera
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsCamera
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsCamera
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsCamera -State 'Disabled' -GPO 'NotConfigured'
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
        $CameraMsg = 'Camera'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Camera = [AppPermissionAccess]::new('webcam', $State)
                $Camera.WriteVerboseMsg($CameraMsg)
                $Camera.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access the camera
                # not configured: delete (default) | on: 1 | off: 2

                $CameraGpo = [AppPermissionPolicy]::new('LetAppsAccessCamera', $GPO)
                $CameraGpo.WriteVerboseMsg("$CameraMsg (GPO)")
                $CameraGpo.SetRegistryEntry()
            }
        }
    }
}
