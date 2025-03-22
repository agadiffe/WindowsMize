#=================================================================================================================
#                               Privacy & Security > App Permissions > File System
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsFileSystem
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsFileSystem
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsFileSystem -State 'Disabled'
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

        $FileSystem = [AppPermissionAccess]::new('broadFileSystemAccess', $State)
        $FileSystem.WriteVerboseMsg('File System')
        $FileSystem.SetRegistryEntry()
    }
}
