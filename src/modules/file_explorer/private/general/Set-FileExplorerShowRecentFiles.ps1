#=================================================================================================================
#                               File Explorer - General > Show Recently Used Files
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowRecentFiles
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowRecentFiles
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowRecentFiles -State 'Enabled'
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

        $ShowRecentFiles = [HkcuExplorer]::new('ShowRecent', [int]$State, 'DWord')
        $ShowRecentFiles.WriteVerboseMsg('File Explorer - Show Recently Used Files', $State)
        $ShowRecentFiles.SetRegistryEntry()
    }
}
