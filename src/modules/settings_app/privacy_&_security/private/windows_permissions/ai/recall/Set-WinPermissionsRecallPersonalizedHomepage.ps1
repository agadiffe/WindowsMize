#=================================================================================================================
#       Privacy & Security > Recall & Snapshots > Advanced Settings > Recall Shows A Customized Experience
#=================================================================================================================

# Recall shows a customized experience using your snapshots

<#
.SYNTAX
    Set-WinPermissionsRecallPersonalizedHomepage
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsRecallPersonalizedHomepage
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsRecallPersonalizedHomepage -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $WinPermissionsRecallPersonalizedHomepage = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SettingSync\WindowsSettingHandlers'
            Entries = @(
                @{
                    Name  = 'A9HomeContentEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $RecallPersonalizedHomepageMsg = 'Recall & Snapshots: Recall Shows A Customized Experience'

        Write-Verbose -Message "Setting 'Windows Permissions - $RecallPersonalizedHomepageMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsRecallPersonalizedHomepage
    }
}
