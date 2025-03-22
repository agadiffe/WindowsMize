#=================================================================================================================
#                           File Explorer - View > Hide Extensions For Known File Types
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerHideFileExtensions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerHideFileExtensions
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerHideFileExtensions -State 'Disabled'
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

        $FileExtensions = [HkcuExplorerAdvanced]::new('HideFileExt', [int]$State, 'DWord')
        $FileExtensions.WriteVerboseMsg('File Explorer - Hide Extensions For Known File Types', $State)
        $FileExtensions.SetRegistryEntry()
    }
}
