#=================================================================================================================
#                                                    User Info
#=================================================================================================================

<#
.SYNTAX
    Get-UserInfo
        User <String>
        [<CommonParameters>]
#>

function Get-UserInfo
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $User
    )

    process
    {
        $UserName = $User
        if ($User.Contains('\'))
        {
            $Domain, $UserName = $User.Split('\')
        }

        $Sid = Get-UserSid -User $User
        if ($Sid)
        {
            @{
                UserName = $UserName
                Domain   = $Domain
                Sid      = $Sid
            }
        }
        else
        {
            $null
        }
    }
}
