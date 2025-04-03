#=================================================================================================================
#                       File Explorer - View > Display File Size Information In Folder Tips
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowFileSizeInFolderTips
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowFileSizeInFolderTips
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowFileSizeInFolderTips -State 'Enabled'
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

        $FileSizeInFolderTips = [HkcuExplorerAdvanced]::new('FolderContentsInfoTip', [int]$State, 'DWord')
        $FileSizeInFolderTips.WriteVerboseMsg('File Explorer - Display File Size Information In Folder Tips', $State)
        $FileSizeInFolderTips.SetRegistryEntry()
    }
}
