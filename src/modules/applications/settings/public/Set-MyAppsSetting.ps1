#=================================================================================================================
#                                               Set My Apps Setting
#=================================================================================================================

<#
.SYNTAX
    Set-MyAppsSetting
        [-Name] {KeePassXC | qBittorrent | VLC | VSCode | Git}
        [<CommonParameters>]
#>

function Set-MyAppsSetting
{
    <#
    .DESCRIPTION
        The current app settings will be overwritten.
        A backup is made with the extension '.old'.

    .EXAMPLE
        PS> Set-MyAppsSetting -Name 'qBittorrent'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet('KeePassXC', 'qBittorrent', 'VLC', 'VSCode', 'Git')]
        [string] $Name
    )

    begin
    {
        $EnvVariable = Get-LoggedOnUserEnvVariable
        $AppsListData = @{
            KeePassXC = @{
                ConfigFileName  = 'KeePassXC.ini'
                SettingFilePath = "$($EnvVariable.APPDATA)\KeePassXC\keepassxc.ini"
            }
            qBittorrent = @{
                ConfigFileName  = 'qBittorrent.ini'
                SettingFilePath = "$($EnvVariable.APPDATA)\qBittorrent\qBittorrent.ini"
            }
            VLC = @{
                ConfigFileName  = 'VLC.ini'
                SettingFilePath = "$($EnvVariable.APPDATA)\vlc\vlcrc"
            }
            VSCode = @{
                ConfigFileName  = 'VSCode.json'
                SettingFilePath = "$($EnvVariable.APPDATA)\Code\User\settings.json"
            }
            Git = @{
                ConfigFileName  = 'Git.ini'
                SettingFilePath = "$($EnvVariable.USERPROFILE)\.gitconfig"
            }
        }
    }

    process
    {
        Write-Verbose -Message "Setting $Name Settings ..."

        $Target = $AppsListData.$Name.SettingFilePath
        $Source = $AppsListData.$Name.ConfigFileName
        $ConfigFilePath = "$PSScriptRoot\..\config_files\$Source"

        if (Test-Path -Path $Target)
        {
            Rename-Item -Path $Target -NewName "$Target.old" -ErrorAction 'SilentlyContinue'
        }

        New-ParentPath -Path $Target
        Copy-Item -Path $ConfigFilePath -Destination $Target
    }
}
