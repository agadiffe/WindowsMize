#=================================================================================================================
#                                 LoggedOn User Info - Security Identifier (SID)
#=================================================================================================================

function Get-LoggedOnUserSID
{
    (Get-LocalUser -Name (Get-LoggedOnUserUsername)).SID.Value
}
