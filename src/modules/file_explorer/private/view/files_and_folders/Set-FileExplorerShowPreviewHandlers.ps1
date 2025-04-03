#=================================================================================================================
#                          File Explorer - View > Show Preview Handlers In Preview Pane
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowPreviewHandlers
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowPreviewHandlers
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowPreviewHandlers -State 'Enabled'
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

        $PreviewHandlers = [HkcuExplorerAdvanced]::new('ShowPreviewHandlers', [int]$State, 'DWord')
        $PreviewHandlers.WriteVerboseMsg('File Explorer - Show Preview Handlers In Preview Pane', $State)
        $PreviewHandlers.SetRegistryEntry()
    }
}
