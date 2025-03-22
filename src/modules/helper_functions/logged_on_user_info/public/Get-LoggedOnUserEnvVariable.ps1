#=================================================================================================================
#                                    LoggedOn User Info - Environment Variable
#=================================================================================================================

function Get-LoggedOnUserEnvVariable
{
    $UserSID = Get-LoggedOnUserSID
    $LoggedUserEnvRegPath = "Registry::HKEY_USERS\$UserSID\Volatile Environment"
    $EnvVariable = Get-ItemProperty -Path $LoggedUserEnvRegPath | Select-Object -Property '*' -Exclude 'PS*'
    $EnvVariable
}
