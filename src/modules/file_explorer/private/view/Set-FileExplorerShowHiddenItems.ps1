#=================================================================================================================
#                          File Explorer - View > Show Hidden Files, Folders, And Drives
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowHiddenItems
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowHiddenItems
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowHiddenItems -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 2 (default)

        $Value = $State -eq 'Enabled' ? '1' : '2'
        $ShowHiddenItems = [HkcuExplorerAdvanced]::new('Hidden', $Value, 'DWord')
        $ShowHiddenItems.WriteVerboseMsg('File Explorer - Show Hidden Files, Folders, And Drives', $State)
        $ShowHiddenItems.SetRegistryEntry()
    }
}
