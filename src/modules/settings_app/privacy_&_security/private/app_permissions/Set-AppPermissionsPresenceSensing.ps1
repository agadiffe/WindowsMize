#=================================================================================================================
#                             Privacy & Security > App Permissions > Presence Sensing
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsPresenceSensing
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsPresenceSensing
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsPresenceSensing -State 'Disabled' -GPO 'NotConfigured'
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
        $PresenceSensingMsg = 'Presence Sensing'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $PresenceSensing = [AppPermissionAccess]::new('humanPresence', $State)
                $PresenceSensing.WriteVerboseMsg($PresenceSensingMsg)
                $PresenceSensing.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access presence sensing
                # not configured: delete (default) | on: 1 | off: 2

                $PresenceSensingGpo = [AppPermissionPolicy]::new('LetAppsAccessHumanPresence', $GPO)
                $PresenceSensingGpo.WriteVerboseMsg("$PresenceSensingMsg (GPO)")
                $PresenceSensingGpo.SetRegistryEntry()
            }
        }
    }
}
