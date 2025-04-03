#=================================================================================================================
#                             File Explorer - View > Display File Icon On Thumbnails
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowFileIconOnThumbnails
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowFileIconOnThumbnails
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowFileIconOnThumbnails -State 'Enabled'
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

        $FileIconOnThumbnails = [HkcuExplorerAdvanced]::new('ShowTypeOverlay', [int]$State, 'DWord')
        $FileIconOnThumbnails.WriteVerboseMsg('File Explorer - Display File Icon On Thumbnails', $State)
        $FileIconOnThumbnails.SetRegistryEntry()
    }
}
