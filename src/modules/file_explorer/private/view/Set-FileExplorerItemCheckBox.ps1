#=================================================================================================================
#                             File Explorer - View > Use Check Boxes To Select Items
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerItemsCheckBoxes
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerItemsCheckBoxes
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerItemsCheckBoxes -State 'Enabled'
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

        $ItemsCheckBoxes = [HkcuExplorerAdvanced]::new('AutoCheckSelect', [int]$State, 'DWord')
        $ItemsCheckBoxes.WriteVerboseMsg('File Explorer - Use Check Boxes To Select Items', $State)
        $ItemsCheckBoxes.SetRegistryEntry()
    }
}
