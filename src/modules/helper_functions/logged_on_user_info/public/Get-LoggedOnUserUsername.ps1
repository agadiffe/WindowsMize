#=================================================================================================================
#                                         LoggedOn User Info - User Name
#=================================================================================================================

# Needed to be able to execute the script on standard account.
# Elevated prompt runs with all the properties of the Admin's account, not the logged-on user.
# i.e.
# 'HKEY_CURRENT_USER' will modify the Admin's HIVE.
# 'Environment variables' & 'Shell Folders paths' are the Admin's values.
# etc ...

# It should also works for Active Directory users ? (untested)

function Get-LoggedOnUserUsername
{
    $ComputerInfo = Get-CimInstance -ClassName 'Win32_ComputerSystem' -Verbose:$false
    $Username = $ComputerInfo.UserName | Split-Path -Leaf

    if (-not $Username)
    {
        Write-Error -Message 'Error to get the UserName of current logged-on user.'
        exit
    }
    $Username
}
