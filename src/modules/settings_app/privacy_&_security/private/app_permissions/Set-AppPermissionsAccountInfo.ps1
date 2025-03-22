#=================================================================================================================
#                               Privacy & Security > App Permissions > Account Info
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsAccountInfo
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsAccountInfo
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsAccountInfo -State 'Disabled' -GPO 'NotConfigured'
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
        $AccountInfoMsg = 'Account Info'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $AccountInfo = [AppPermissionAccess]::new('userAccountInformation', $State)
                $AccountInfo.WriteVerboseMsg($AccountInfoMsg)
                $AccountInfo.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access account information
                # not configured: delete (default) | on: 1 | off: 2

                $AccountInfoGpo = [AppPermissionPolicy]::new('LetAppsAccessAccountInfo', $GPO)
                $AccountInfoGpo.WriteVerboseMsg("$AccountInfoMsg (GPO)")
                $AccountInfoGpo.SetRegistryEntry()
            }
        }
    }
}
