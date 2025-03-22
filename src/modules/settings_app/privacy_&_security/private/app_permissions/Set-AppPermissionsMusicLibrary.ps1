#=================================================================================================================
#                              Privacy & Security > App Permissions > Music Library
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsMusicLibrary
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsMusicLibrary
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsMusicLibrary -State 'Disabled'
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

        $MusicLibrary = [AppPermissionAccess]::new('musicLibrary', $State)
        $MusicLibrary.WriteVerboseMsg('Music Library')
        $MusicLibrary.SetRegistryEntry()
    }
}
