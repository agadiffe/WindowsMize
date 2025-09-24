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
        $LogPath = "$PSScriptRoot\..\..\..\..\..\log"
        if ($User)
        {
            $LogPath += "\$((Get-LoggedOnUserInfo).UserName)"
        }
        $LogPath
    }
}
