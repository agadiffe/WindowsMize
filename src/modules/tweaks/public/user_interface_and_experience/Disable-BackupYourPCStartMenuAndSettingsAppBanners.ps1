#=================================================================================================================
#                           Disable Backup Your Pc Start Menu And Settings App Banners
#=================================================================================================================

<#
.SYNTAX
    Disable-BackupYourPCStartMenuAndSettingsAppBanners
        [-Reset]
        [<CommonParameters>]
#>

function Disable-BackupYourPCStartMenuAndSettingsAppBanners
{
    <#
    .EXAMPLE
        PS> Disable-BackupYourPCStartMenuAndSettingsAppBanners
    #>

    [CmdletBinding()]
    param
    (
        [switch] $Reset
    )

    process
    {
        # on: delete key (default) | off: json value
        $BackupYourPcBanners = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\RulesEngine\StateManager'
            Entries = @(
                @{
                    RemoveEntry = $Reset
                    Name  = 'LastSuppressionTimes'
                    Value = '{"settingshomealertbanner":"2099-01-01T00:00:00Z","startmenu":"2099-01-01T00:00:00Z"}'
                    Type  = 'String'
                }
                @{
                    RemoveEntry = $true
                    Name  = 'Data'
                    Value = ''
                    Type  = 'String'
                }
            )
        }

        $BackupYourPcBannersState = $Reset ? 'Resetting' : 'Disabling'
        Write-Verbose -Message "$BackupYourPcBannersState 'Backup Your PC - Start Menu And Settings App Banners' ..."
        Set-RegistryEntry -InputObject $BackupYourPcBanners
    }
}
