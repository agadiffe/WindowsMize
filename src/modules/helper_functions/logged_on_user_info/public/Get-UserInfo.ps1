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
        $Sid = Get-UserSid -User $User

        if ($Sid)
        {
            $SecurityIdentifier = [System.Security.Principal.SecurityIdentifier]::New($Sid)
            $UserName = $SecurityIdentifier.Translate([System.Security.Principal.NTAccount]).Value

            @{
                UserName = $UserName
                Sid      = $Sid
            }
        }
        else
        {
            $null
        }
    }
}
