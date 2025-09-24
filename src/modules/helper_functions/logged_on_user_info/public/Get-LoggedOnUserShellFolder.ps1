#=================================================================================================================
#                                        LoggedOn User Info - Shell Folder
#=================================================================================================================

# e.g. Desktop, My Music, My Pictures, My Video, Personal (i.e. My Documents)

<#
.SYNTAX
    Get-LoggedOnUserShellFolder [<CommonParameters>]
#>

function Get-LoggedOnUserShellFolder
{
    [CmdletBinding()]
    param ()

    process
    {
        $UserSid = (Get-LoggedOnUserInfo).Sid
        $ShellFoldersRegPath = "HKEY_USERS\$UserSid\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
        $ShellFoldersRegData = Get-Item -Path "Registry::$ShellFoldersRegPath"
        $ShellFoldersValuesNames = $ShellFoldersRegData.Property

        $UserProfilePath = (Get-LoggedOnUserEnvVariable).USERPROFILE
        $ShellFolders = @{}
        foreach ($ValueName in $ShellFoldersValuesNames)
        {
            $ShellFolders.$ValueName = $ShellFoldersRegData.
                GetValue($ValueName, $null, 'DoNotExpandEnvironmentNames').
                Replace('%USERPROFILE%', $UserProfilePath)
        }

        if (-not $ShellFolders.ContainsKey('Downloads'))
        {
            $ShellFolders.Downloads = $ShellFolders.'{374de290-123f-4565-9164-39c4925e467b}'
        }

        $ShellFolders
    }
}
