#=================================================================================================================
#                         File Explorer - Search > Include Compressed Files (ZIP, CAB...)
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerIncludeCompressedFiles
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerIncludeCompressedFiles
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerIncludeCompressedFiles -State 'Disabled'
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

        $SystemFolders = [HkcuExplorerSearchPrefs]::new('ArchivedFiles', [int]$State, 'DWord')
        $SystemFolders.WriteVerboseMsg('File Explorer - Include Compressed Files (ZIP, CAB...)', $State)
        $SystemFolders.SetRegistryEntry()
    }
}
