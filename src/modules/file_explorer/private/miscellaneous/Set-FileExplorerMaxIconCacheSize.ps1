#=================================================================================================================
#                                   File Explorer - Misc > Max Icon Cache Size
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerMaxIconCacheSize
        [-KB] <int>
        [<CommonParameters>]
#>

function Set-FileExplorerMaxIconCacheSize
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerMaxIconCacheSize -KB 4096
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange('NonNegative')]
        [int] $KB
    )

    process
    {
        # default: 512 KB

        $MaxIconCacheSize = [HkcuExplorer]::new('MaxCachedIcons', $KB, 'String')
        $MaxIconCacheSize.WriteVerboseMsg('File Explorer - Max Icon Cache Size', $KB)
        $MaxIconCacheSize.SetRegistryEntry()
    }
}
