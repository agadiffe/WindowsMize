#=================================================================================================================
#                               File Explorer - General > Show Recommended Section
#=================================================================================================================

# Requires "Include account-based insights, recent, favorite, and recommended files (ShowCloudFiles)".

<#
.SYNTAX
    Set-FileExplorerShowRecommendedSection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowRecommendedSection
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowRecommendedSection -State 'Enabled'
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

        $OpenFolderInNewTab = [HkcuExplorer]::new('ShowRecommendations', [int]$State, 'DWord')
        $OpenFolderInNewTab.WriteVerboseMsg( 'File Explorer - Show Recommended Section', $State)
        $OpenFolderInNewTab.SetRegistryEntry()
    }
}
