#=================================================================================================================
#                                 File Explorer - View > Expand To Current Folder
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerExpandToCurrentFolder
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerExpandToCurrentFolder
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerExpandToCurrentFolder -State 'Disabled'
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

        $ExpandToCurrentFolder = [HkcuExplorerAdvanced]::new('NavPaneExpandToCurrentFolder', [int]$State, 'DWord')
        $ExpandToCurrentFolder.WriteVerboseMsg('File Explorer - Expand To Current Folder', $State)
        $ExpandToCurrentFolder.SetRegistryEntry()
    }
}
