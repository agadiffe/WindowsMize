#=================================================================================================================
#                                   File Explorer - Misc > Max Icon Cache Size
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerMaxIconCacheSize
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-FileExplorerMaxIconCacheSize
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerMaxIconCacheSize -Value 4096
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange('NonNegative')]
        [int] $Value
    )

    process
    {
        # default: 512 KB

        $MaxIconCacheSize = [HkcuExplorer]::new('MaxCachedIcons', $Value, 'String')
        $MaxIconCacheSize.WriteVerboseMsg('File Explorer - Max Icon Cache Size', $Value)
        $MaxIconCacheSize.SetRegistryEntry()
    }
}
