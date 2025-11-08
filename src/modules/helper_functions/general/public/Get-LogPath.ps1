#=================================================================================================================
#                                         Helper Function - Get Log Path
#=================================================================================================================

<#
.SYNTAX
    Get-LogPath
        -User
        [<CommonParameters>]
#>

function Get-LogPath
{
    [CmdletBinding()]
    param
    (
        [switch] $User
    )

    process
    {
        $LogPath = Resolve-Path -Path "$PSScriptRoot\..\..\..\..\.."
        $LogPath = $LogPath.ToString() + '\log'
        if ($User)
        {
            $LogPath += "\$((Get-LoggedOnUserInfo).UserName)"
        }
        $LogPath
    }
}
