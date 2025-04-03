#=================================================================================================================
#                               File Explorer - Search > Include System Directories
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerIncludeSystemFolders
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerIncludeSystemFolders
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerIncludeSystemFolders -State 'Enabled'
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

        $SystemFolders = [HkcuExplorerSearchPrefs]::new('SystemFolders', [int]$State, 'DWord')
        $SystemFolders.WriteVerboseMsg('File Explorer - Include System Directories', $State)
        $SystemFolders.SetRegistryEntry()
    }
}
