#=================================================================================================================
#                                  Privacy & Security > App Permissions > Motion
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsMotion
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsMotion
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsMotion -State 'Disabled' -GPO 'NotConfigured'
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
        $MotionMsg = 'Motion'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Motion = [AppPermissionAccess]::new('activity', $State)
                $Motion.WriteVerboseMsg($MotionMsg)
                $Motion.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access motion
                # not configured: delete (default) | on: 1 | off: 2

                $MotionGpo = [AppPermissionPolicy]::new('LetAppsAccessMotion', $GPO)
                $MotionGpo.WriteVerboseMsg("$MotionMsg (GPO)")
                $MotionGpo.SetRegistryEntry()
            }
        }
    }
}
