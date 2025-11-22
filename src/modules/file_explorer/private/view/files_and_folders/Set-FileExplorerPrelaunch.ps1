#=================================================================================================================
#                     File Explorer - View > Enable Window Preloading For Faster Launch Times
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerPrelaunch
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerPrelaunch
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerPrelaunch -State 'Enabled'
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

        $CompactView = [HkcuExplorerAdvanced]::new('ShouldPrelaunchFileExplorer', [int]$State, 'DWord')
        $CompactView.WriteVerboseMsg('File Explorer - Enable Window Preloading For Faster Launch Times', $State)
        $CompactView.SetRegistryEntry()
    }
}
