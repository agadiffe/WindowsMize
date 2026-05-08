#=================================================================================================================
#                                             Backup Your Pc Banners
#=================================================================================================================

<#
.SYNTAX
    Set-BackupYourPCBanners
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-BackupYourPCBanners
{
    <#
    .EXAMPLE
        PS> Set-BackupYourPCBanners -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete key (default) | off: json value
        $BackupYourPcBanners = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\RulesEngine\StateManager'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
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

        Write-Verbose -Message "Setting 'Backup Your PC banners (Start Menu And Settings App)' to '$State' ..."
        Set-RegistryEntry -InputObject $BackupYourPcBanners
    }
}
