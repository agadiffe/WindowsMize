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

        if (-not $ShellFolders.ContainsKey('Downloads'))
        {
            $ShellFolders.Downloads = $ShellFolders.'{374de290-123f-4565-9164-39c4925e467b}'
        }

        $ShellFolders
    }
}
