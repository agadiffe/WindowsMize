#=================================================================================================================
#                            Accounts > Windows Backup > Remember My Apps/Preferences
#=================================================================================================================

<#
.SYNTAX
    Set-WinBackupRememberAppsAndPrefs
        [-GPO] {DefaultOff | Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WinBackupRememberAppsAndPrefs
{
    <#
    .EXAMPLE
        PS> Set-WinBackupRememberAppsAndPrefs -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [RememberAppsAndPrefsMode] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ computer config > administrative tpl > windows components > sync your settings
        #   do not sync
        # not configured: delete (default) | on: DefaultOff (2 0), Disabled (2 1)
        $WinBackupRememberAppsAndPrefsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\SettingSync'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableSettingSync'
                    Value = '2'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableSettingSyncUserOverride'
                    Value = $GPO -eq 'Disabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Backup - Remember My Apps/Preferences (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WinBackupRememberAppsAndPrefsGpo
    }
}
