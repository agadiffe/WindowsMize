#=================================================================================================================
#                             File Explorer - General > Show Frequently Used Folders
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowFrequentFolders
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowFrequentFolders
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowFrequentFolders -State 'Enabled'
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

        $ShowFrequentFolders = [HkcuExplorer]::new('ShowFrequent', [int]$State, 'DWord')
        $ShowFrequentFolders.WriteVerboseMsg('File Explorer - Show Frequently Used Folders', $State)
        $ShowFrequentFolders.SetRegistryEntry()
    }
}
