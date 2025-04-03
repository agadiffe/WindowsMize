#=================================================================================================================
#                                    File Explorer - View > Hide Empty Drives
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerHideEmptyDrives
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerHideEmptyDrives
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerHideEmptyDrives -State 'Enabled'
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

        $HideEmptyDrives = [HkcuExplorerAdvanced]::new('HideDrivesWithNoMedia', [int]$State, 'DWord')
        $HideEmptyDrives.WriteVerboseMsg('File Explorer - Hide Empty Drives', $State)
        $HideEmptyDrives.SetRegistryEntry()
    }
}
