#=================================================================================================================
#                         File Explorer - View > Restore Previous Folder Windows At Logon
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerRestorePreviousFoldersAtLogon
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerRestorePreviousFoldersAtLogon
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerRestorePreviousFoldersAtLogon -State 'Disabled'
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

        $RestorePreviousFolders = [HkcuExplorerAdvanced]::new('PersistBrowsers', [int]$State, 'DWord')
        $RestorePreviousFolders.WriteVerboseMsg('File Explorer - Restore Previous Folder Windows At Logon', $State)
        $RestorePreviousFolders.SetRegistryEntry()
    }
}
