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
        A backup file is created with the ".bak" extension.

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

        $TargetFilePath = $AppsListData.$Name.SettingFilePath
        $SourceFileName = $AppsListData.$Name.ConfigFileName
        $SourceFilePath = "$PSScriptRoot\..\config_files\$SourceFileName"

        if ((Test-Path -Path $TargetFilePath) -and -not (Test-Path -Path "$TargetFilePath.bak"))
        {
            Copy-Item -Path $TargetFilePath -Destination "$TargetFilePath.bak"
        }

        New-ParentPath -Path $TargetFilePath
        Copy-Item -Path $SourceFilePath -Destination $TargetFilePath
    }
}
