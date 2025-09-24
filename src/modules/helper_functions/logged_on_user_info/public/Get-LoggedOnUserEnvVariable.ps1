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
        $UserSid = (Get-LoggedOnUserInfo).Sid
        $LoggedUserEnvRegPath = "Registry::HKEY_USERS\$UserSid\Volatile Environment"
        $EnvVariable = Get-ItemProperty -Path $LoggedUserEnvRegPath | Select-Object -Property '*' -Exclude 'PS*'
        $EnvVariable
    }
}
