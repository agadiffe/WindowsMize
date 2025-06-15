#=================================================================================================================
#                                  Privacy & Security > App Permissions > Email
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsEmail
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsEmail
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsEmail -State 'Disabled' -GPO 'NotConfigured'
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
        $EmailMsg = 'Email'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Email = [AppPermissionAccess]::new('email', $State)
                $Email.WriteVerboseMsg($EmailMsg)
                $Email.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access email
                # not configured: delete (default) | on: 1 | off: 2

                $EmailGpo = [AppPermissionPolicy]::new('LetAppsAccessEmail', $GPO)
                $EmailGpo.WriteVerboseMsg("$EmailMsg (GPO)")
                $EmailGpo.SetRegistryEntry()
            }
        }
    }
}
