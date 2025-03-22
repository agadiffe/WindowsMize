#=================================================================================================================
#                              Privacy & Security > App Permissions > Cellular Data
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsCellularData
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsCellularData
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsCellularData -State 'Disabled' -GPO 'NotConfigured'
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
        $CellularDataMsg = 'Cellular Data'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $CellularData = [AppPermissionAccess]::new('cellularData', $State)
                $CellularData.WriteVerboseMsg($CellularDataMsg)
                $CellularData.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > network > wwan service
                #   let Windows apps access cellular data
                # not configured: delete (default) | on: 1 | off: 2

                $CellularDataGpo = [AppPermissionPolicy]::new('LetAppsAccessCellularData', $GPO)
                $CellularDataGpo.WriteVerboseMsg("$CellularDataMsg (GPO)")
                $CellularDataGpo.SetRegistryEntry()
            }
        }
    }
}
