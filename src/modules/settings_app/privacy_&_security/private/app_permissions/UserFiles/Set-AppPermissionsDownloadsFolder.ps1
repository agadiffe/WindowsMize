#=================================================================================================================
#                             Privacy & Security > App Permissions > Downloads Folder
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsDownloadsFolder
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsDownloadsFolder
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsDownloadsFolder -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: Allow (default) | off: Deny

        $DownloadsFolder = [AppPermissionAccess]::new('downloadsFolder', $State)
        $DownloadsFolder.WriteVerboseMsg('Downloads Folder')
        $DownloadsFolder.SetRegistryEntry()
    }
}
