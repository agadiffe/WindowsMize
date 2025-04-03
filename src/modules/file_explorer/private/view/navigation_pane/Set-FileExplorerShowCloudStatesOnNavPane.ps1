#=================================================================================================================
#                             File Explorer - View > Always Show Availability Status
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowCloudStatesOnNavPane
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowCloudStatesOnNavPane
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowCloudStatesOnNavPane -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0

        $ShowCloudStates = [HkcuExplorerAdvanced]::new('NavPaneShowAllCloudStates', [int]$State, 'DWord')
        $ShowCloudStates.WriteVerboseMsg('File Explorer - Always Show Availability Status', $State)
        $ShowCloudStates.SetRegistryEntry()
    }
}
