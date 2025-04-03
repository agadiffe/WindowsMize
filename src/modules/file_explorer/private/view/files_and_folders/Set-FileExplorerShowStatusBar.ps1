#=================================================================================================================
#                                     File Explorer - View > Show Status Bar
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowStatusBar
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowStatusBar
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowStatusBar -State 'Enabled'
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

        $StatusBar = [HkcuExplorerAdvanced]::new('ShowStatusBar', [int]$State, 'DWord')
        $StatusBar.WriteVerboseMsg('File Explorer - Show Status Bar', $State)
        $StatusBar.SetRegistryEntry()
    }
}
