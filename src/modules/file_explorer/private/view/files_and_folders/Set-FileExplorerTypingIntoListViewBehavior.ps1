#=================================================================================================================
#                                File Explorer - View > When Typing Into List View
#=================================================================================================================

# When typing into list view:
#   Automatically type into the Search Box
#   Select the typed item in the view

<#
.SYNTAX
    Set-FileExplorerTypingIntoListViewBehavior
        [-Mode] {SelectItemInView | AutoTypeInSearchBox}
        [<CommonParameters>]
#>

function Set-FileExplorerTypingIntoListViewBehavior
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerTypingIntoListViewBehavior -Mode 'SelectItemInView'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TypingIntoListViewMode] $Mode
    )

    process
    {
        # select the typed item in the view: 0 (default) | automatically type into the Search Box: 1

        $HideEmptyDrives = [HkcuExplorerAdvanced]::new('TypeAhead', [int]$Mode, 'DWord')
        $HideEmptyDrives.WriteVerboseMsg('File Explorer - When Typing Into List View', $Mode)
        $HideEmptyDrives.SetRegistryEntry()
    }
}
