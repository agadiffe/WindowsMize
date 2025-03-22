#=================================================================================================================
#                                               Set My Apps Setting
#=================================================================================================================

<#
.SYNTAX
    Set-MyAppsSetting
        [-Git]
        [-KeePassXC]
        [-qBittorrent]
        [-VLC]
        [-VSCode]
        [<CommonParameters>]
#>

function Set-MyAppsSetting
{
    <#
    .DESCRIPTION
        The current app settings will be overwritten.
        A backup is made with the extension '.old'.

    .EXAMPLE
        PS> Set-MyAppsSetting -qBittorrent -VSCode
    #>

    [CmdletBinding()]
    param
    (
        [switch] $Git,
        [switch] $KeePassXC,
        [switch] $qBittorrent,
        [switch] $VLC,
        [switch] $VSCode
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $EnvVariable = Get-LoggedOnUserEnvVariable
        $AppsListData = @{
            Git = @{
                SettingFilePath = "$($EnvVariable.USERPROFILE)\.gitconfig"
                ConfigFileName  = 'Git.ini'
            }
            KeePassXC = @{
                SettingFilePath = "$($EnvVariable.APPDATA)\KeePassXC\keepassxc.ini"
                ConfigFileName  = 'KeePassXC.ini'
            }
            qBittorrent = @{
                SettingFilePath = "$($EnvVariable.APPDATA)\qBittorrent\qBittorrent.ini"
                ConfigFileName  = 'qBittorrent.ini'
            }
            VLC = @{
                SettingFilePath = "$($EnvVariable.APPDATA)\vlc\vlcrc"
                ConfigFileName  = 'VLC.ini'
            }
            VSCode = @{
                SettingFilePath = "$($EnvVariable.APPDATA)\Code\User\settings.json"
                ConfigFileName  = 'VSCode.json'
            }
        }

        foreach ($Key in $PSBoundParameters.Keys)
        {
            if ($PSBoundParameters.$Key)
            {
                Write-Verbose -Message "Setting $Key Settings ..."

                $AppData = $AppsListData.$Key
                Copy-AppConfigFile -Destination $AppData.SettingFilePath -ConfigFileName $AppData.ConfigFileName
            }
        }
    }
}
