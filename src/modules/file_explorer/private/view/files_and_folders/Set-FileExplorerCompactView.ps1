#=================================================================================================================
#                       File Explorer - View > Decrease Space Between Items (Compact View)
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerCompactView
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerCompactView
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerCompactView -State 'Enabled'
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

        $CompactView = [HkcuExplorerAdvanced]::new('UseCompactMode', [int]$State, 'DWord')
        $CompactView.WriteVerboseMsg('File Explorer - Decrease Space Between Items (Compact View)', $State)
        $CompactView.SetRegistryEntry()
    }
}
