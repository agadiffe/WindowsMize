#=================================================================================================================
#                               Privacy & Security > App Permissions > Phone Calls
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsPhoneCalls
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsPhoneCalls
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsPhoneCalls -State 'Disabled' -GPO 'NotConfigured'
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
        $PhoneCallsMsg = 'Phone Calls'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $PhoneCalls = [AppPermissionAccess]::new('phoneCall', $State)
                $PhoneCalls.WriteVerboseMsg($PhoneCallsMsg)
                $PhoneCalls.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps make phone calls
                # not configured: delete (default) | on: 1 | off: 2

                $PhoneCallsGpo = [AppPermissionPolicy]::new('LetAppsAccessPhone', $GPO)
                $PhoneCallsGpo.WriteVerboseMsg("$PhoneCallsMsg (GPO)")
                $PhoneCallsGpo.SetRegistryEntry()
            }
        }
    }
}
