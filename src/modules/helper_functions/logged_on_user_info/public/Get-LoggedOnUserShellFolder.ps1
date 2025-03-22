#=================================================================================================================
#                                        LoggedOn User Info - Shell Folder
#=================================================================================================================

# e.g. Desktop, My Music, My Pictures, My Video, Personal (i.e. My Documents)

function Get-LoggedOnUserShellFolder
{
    $UserSID = Get-LoggedOnUserSID
    $ShellFoldersRegPath = "HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
    $ShellFoldersValueNames = (Get-Item -Path "Registry::$ShellFoldersRegPath").Property

    $UserProfilePath = (Get-LoggedOnUserEnvVariable).USERPROFILE
    $ShellFolders = @{}
    foreach ($ValueName in $ShellFoldersValueNames)
    {
        $ShellFolders.$ValueName = (Get-Item -Path "Registry::$ShellFoldersRegPath").GetValue(
            $ValueName, $null, 'DoNotExpandEnvironmentNames')
        $ShellFolders.$ValueName = $ShellFolders.$ValueName.Replace('%USERPROFILE%', $UserProfilePath)
    }

    $ShellFolders
}
