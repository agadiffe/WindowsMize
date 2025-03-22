#=================================================================================================================
#                             Privacy & Security > App Permissions > App Diagnostics
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsAppDiagnostics
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsAppDiagnostics
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsAppDiagnostics -State 'Disabled' -GPO 'NotConfigured'
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
        $AppDiagnosticsMsg = 'App Diagnostics'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $AppDiagnostics = [AppPermissionAccess]::new('appDiagnostics', $State)
                $AppDiagnostics.WriteVerboseMsg($AppDiagnosticsMsg)
                $AppDiagnostics.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access diagnostic information about other apps
                # not configured: delete (default) | on: 1 | off: 2

                $AppDiagnosticsGpo = [AppPermissionPolicy]::new('LetAppsGetDiagnosticInfo', $GPO)
                $AppDiagnosticsGpo.WriteVerboseMsg("$AppDiagnosticsMsg (GPO)")
                $AppDiagnosticsGpo.SetRegistryEntry()
            }
        }
    }
}
