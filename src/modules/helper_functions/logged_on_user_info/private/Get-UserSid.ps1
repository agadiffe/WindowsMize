#=================================================================================================================
#                                                  Get User Sid
#=================================================================================================================

<#
.SYNTAX
    Get-UserSid
        -User <string>
        [<CommonParameters>]
#>

function Get-UserSid
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $User
    )

    process
    {
        try
        {
            $NTAccount = [System.Security.Principal.NTAccount]::New($User)
            $NTAccount.Translate([System.Security.Principal.SecurityIdentifier]).Value
        }
        catch
        {
            $null
        }
    }
}
