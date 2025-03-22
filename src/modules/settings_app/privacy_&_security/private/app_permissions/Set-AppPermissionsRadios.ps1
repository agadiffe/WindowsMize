#=================================================================================================================
#                                  Privacy & Security > App Permissions > Radios
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsRadios
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsRadios
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsRadios -State 'Disabled' -GPO 'NotConfigured'
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
        $RadiosMsg = 'Radios'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Radios = [AppPermissionAccess]::new('radios', $State)
                $Radios.WriteVerboseMsg($RadiosMsg)
                $Radios.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps control radios
                # not configured: delete (default) | on: 1 | off: 2

                $RadiosGpo = [AppPermissionPolicy]::new('LetAppsAccessRadios', $GPO)
                $RadiosGpo.WriteVerboseMsg("$RadiosMsg (GPO)")
                $RadiosGpo.SetRegistryEntry()
            }
        }
    }
}
