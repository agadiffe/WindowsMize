#=================================================================================================================
#               File Explorer - General > Open Desktop Folders And External Folder Links In New Tab
#=================================================================================================================

# Requires 'Open each folder in the same window'

<#
.SYNTAX
    Set-FileExplorerOpenFolderInNewTab
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerOpenFolderInNewTab
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerOpenFolderInNewTab -State 'Enabled'
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

        $OpenFolderInNewTab = [HkcuExplorer]::new('OpenFolderInNewTab', [int]$State, 'DWord')
        $OpenFolderInNewTab.WriteVerboseMsg(
            'File Explorer - Open Desktop Folders And External Folder Links In New Tab', $State)
        $OpenFolderInNewTab.SetRegistryEntry()
    }
}
