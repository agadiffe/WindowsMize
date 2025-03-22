#=================================================================================================================
#                              File Explorer - General > Show Files From Office.com
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowCloudFiles
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowCloudFiles
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowCloudFiles -State 'Disabled'
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

        $ShowCloudFiles = [HkcuExplorer]::new('ShowCloudFilesInQuickAccess', [int]$State, 'DWord')
        $ShowCloudFiles.WriteVerboseMsg('File Explorer - Show Files From Office.com', $State)
        $ShowCloudFiles.SetRegistryEntry()
    }
}
