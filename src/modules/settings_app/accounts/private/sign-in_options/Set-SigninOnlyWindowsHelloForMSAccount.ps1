#=================================================================================================================
#       Accounts > Sign-In Options > Only Allow Windows Hello Sign-In For Microsoft Accounts On This Device
#=================================================================================================================

# Requires a Microsoft account to have this option visible.

# This setting also control the automatic-logon checkbox visibility in user accounts (Netplwiz.exe):
#   Users must enter a user name and password to use this computer.
# Untick this option and enter your Username/Password to enable automatic login.
# Does not require a Microsoft account to show or hide this option.

<#
.SYNTAX
    Set-SigninOnlyWindowsHelloForMSAccount
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SigninOnlyWindowsHelloForMSAccount
{
    <#
    .EXAMPLE
        PS> Set-SigninOnlyWindowsHelloForMSAccount -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 | off: 2 (default)
        $OnlyPasswordLessForMSAccount = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device'
            Entries = @(
                @{
                    Name  = 'DevicePasswordLessBuildVersion'
                    Value = $State -eq 'Enabled' ? '0' : '2'
                    Type  = 'DWord'
                }
            )
        }

        $PasswordLessMsg = 'For Improved Security, Only Allow Windows Hello Sign-In For Microsoft Accounts On This Device'

        Write-Verbose -Message "Setting 'Sign-In Options - $PasswordLessMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $OnlyPasswordLessForMSAccount
    }
}
