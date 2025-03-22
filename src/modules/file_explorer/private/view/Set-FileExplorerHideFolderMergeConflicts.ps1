#=================================================================================================================
#                               File Explorer - View > Hide Folder Merge Conflicts
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerHideFolderMergeConflicts
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerHideFolderMergeConflicts
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerHideFolderMergeConflicts -State 'Enabled'
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

        $FolderMergeConflicts = [HkcuExplorerAdvanced]::new('HideMergeConflicts', [int]$State, 'DWord')
        $FolderMergeConflicts.WriteVerboseMsg('File Explorer - Hide Folder Merge Conflicts', $State)
        $FolderMergeConflicts.SetRegistryEntry()
    }
}
