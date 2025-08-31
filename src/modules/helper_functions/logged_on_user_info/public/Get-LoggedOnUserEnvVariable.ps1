#=================================================================================================================
#                                    LoggedOn User Info - Environment Variable
#=================================================================================================================

<#
.SYNTAX
    Get-LoggedOnUserEnvVariable [<CommonParameters>]
#>

function Get-LoggedOnUserEnvVariable
{
    [CmdletBinding()]
    param ()

    process
    {
        $UserSID = Get-LoggedOnUserSID
        $LoggedUserEnvRegPath = "Registry::HKEY_USERS\$UserSID\Volatile Environment"
        $EnvVariable = Get-ItemProperty -Path $LoggedUserEnvRegPath | Select-Object -Property '*' -Exclude 'PS*'
        $EnvVariable
    }
}
