#=================================================================================================================
#                                               Logged-On User Info
#=================================================================================================================

# Needed to be able to execute the script on standard account.
# Elevated prompt runs with all the properties of the Admin's account, not the logged-on user.
# i.e.
# 'HKEY_CURRENT_USER' will modify the Admin's HIVE.
# 'Environment variables' & 'Shell Folders paths' are the Admin's values.
# etc ...

<#
.SYNTAX
    Get-LoggedOnUserInfo [<CommonParameters>]
#>

function Get-LoggedOnUserInfo
{
    [CmdletBinding()]
    param ()

    process
    {
        $SessionId = (Get-Process -Id $PID).SessionId
        $Query = "SELECT * FROM Win32_Process WHERE SessionId='$SessionId' AND Name='explorer.exe'"
        $ClassName = 'System.Management.ManagementObjectSearcher'
        $ProcessInfo = (New-Object -TypeName $ClassName -ArgumentList $Query).Get() | Select-Object -First 1

        if ($ProcessInfo)
        {
            $OwnerData = $ProcessInfo.GetOwner()
            @{
                UserName = $OwnerData.User
                Domain   = $OwnerData.Domain
                Sid      = $ProcessInfo.GetOwnerSid().Sid
            }
        }
        else
        {
            Write-Error -Message 'Error: explorer.exe process not found. Cannot retrieve logged-on user info.'
            exit
        }
    }
}
