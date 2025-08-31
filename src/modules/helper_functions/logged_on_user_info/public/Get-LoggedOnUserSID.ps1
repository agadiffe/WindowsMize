#=================================================================================================================
#                                 LoggedOn User Info - Security Identifier (SID)
#=================================================================================================================

<#
.SYNTAX
    Get-LoggedOnUserSID [<CommonParameters>]
#>

function Get-LoggedOnUserSID
{
    [CmdletBinding()]
    param ()

    process
    {
        (Get-LocalUser -Name (Get-LoggedOnUserUsername)).SID.Value
    }
}
