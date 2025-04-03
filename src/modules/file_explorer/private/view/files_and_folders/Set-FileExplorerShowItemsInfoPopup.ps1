#=================================================================================================================
#                   File Explorer - View > Show Pop-Up Description For Folder And Desktop Items
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowItemsInfoPopup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowItemsInfoPopup
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowItemsInfoPopup -State 'Enabled'
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

        $ItemsInfoPopup = [HkcuExplorerAdvanced]::new('ShowInfoTip', [int]$State, 'DWord')
        $ItemsInfoPopup.WriteVerboseMsg('File Explorer - Show Pop-Up Description For Folder And Desktop Items', $State)
        $ItemsInfoPopup.SetRegistryEntry()
    }
}
