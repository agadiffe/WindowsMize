#=================================================================================================================
#                           File Explorer - View > Always Show Icons, Never Thumbnails
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowIconsOnly
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowIconsOnly
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowIconsOnly -State 'Disabled'
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

        $ShowIconsOnly = [HkcuExplorerAdvanced]::new('IconsOnly', [int]$State, 'DWord')
        $ShowIconsOnly.WriteVerboseMsg('File Explorer - Always Show Icons, Never Thumbnails', $State)
        $ShowIconsOnly.SetRegistryEntry()
    }
}
