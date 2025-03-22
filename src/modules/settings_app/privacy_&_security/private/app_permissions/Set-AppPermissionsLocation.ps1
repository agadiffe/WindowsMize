#=================================================================================================================
#                                 Privacy & Security > App Permissions > Location
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsLocation
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsLocation
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsLocation -State 'Disabled' -GPO 'NotConfigured'
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
        $LocationMsg = 'Location'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Location = [AppPermissionAccess]::new('location', $State)
                $Location.WriteVerboseMsg($LocationMsg)
                $Location.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access location
                # not configured: delete (default) | on: 1 | off: 2

                $LocationGpo = [AppPermissionPolicy]::new('LetAppsAccessLocation', $GPO)
                $LocationGpo.WriteVerboseMsg("$LocationMsg (GPO)")
                $LocationGpo.SetRegistryEntry()
            }
        }
    }
}
