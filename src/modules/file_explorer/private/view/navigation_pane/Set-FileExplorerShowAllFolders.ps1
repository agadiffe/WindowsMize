#=================================================================================================================
#                                     File Explorer - View > Show All Folders
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowAllFolders
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowAllFolders
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowAllFolders -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)

        $ShowAllFolders = [HkcuExplorerAdvanced]::new('NavPaneShowAllFolders', [int]$State, 'DWord')
        $ShowAllFolders.WriteVerboseMsg('File Explorer - Show All Folders', $State)
        $ShowAllFolders.SetRegistryEntry()
    }
}
