#=================================================================================================================
#                                  Privacy & Security > App Permissions > Videos
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsVideos
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsVideos
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsVideos -State 'Disabled'
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

        $AccountInfo = [AppPermissionAccess]::new('videosLibrary', $State)
        $AccountInfo.WriteVerboseMsg('Videos')
        $AccountInfo.SetRegistryEntry()
    }
}
