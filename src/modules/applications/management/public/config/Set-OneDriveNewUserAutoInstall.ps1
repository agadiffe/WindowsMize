#=================================================================================================================
#                                       Set OneDrive New User Auto Install
#=================================================================================================================

<#
.SYNTAX
    Set-OneDriveNewUserAutoInstall
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-OneDriveNewUserAutoInstall
{
    <#
    .EXAMPLE
        PS> Set-OneDriveNewUserAutoInstall -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'OneDrive New User Auto Install' to '$State' ..."

        $NTUserRegKeyName = 'NTUSER_DEFAULT'
        $OneDriveSetup = @{
            Hive    = 'HKEY_USERS'
            Path    = "$NTUserRegKeyName\Software\Microsoft\Windows\CurrentVersion\Run"
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Disabled'
                    Name  = 'OneDriveSetup'
                    Value = "$env:SystemRoot\System32\OneDriveSetup.exe /thfirstsetup"
                    Type  = 'String'
                }
            )
        }

        $NTUserRegPath = "HKEY_USERS\$NTUserRegKeyName"
        $NTUserFilePath = "$env:SystemDrive\Users\Default\NTUSER.DAT"

        reg.exe UNLOAD $NTUserRegPath 2>&1 | Out-Null
        reg.exe LOAD $NTUserRegPath $NTUserFilePath | Out-Null
        Set-RegistryEntry -InputObject $OneDriveSetup -Verbose:$false
        reg.exe UNLOAD $NTUserRegPath | Out-Null
    }
}
