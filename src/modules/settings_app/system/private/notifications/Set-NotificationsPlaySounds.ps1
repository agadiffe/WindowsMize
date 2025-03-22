#=================================================================================================================
#                                      System > Notifications > Play Sounds
#=================================================================================================================

<#
.SYNTAX
    Set-NotificationsPlaySounds
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NotificationsPlaySounds
{
    <#
    .EXAMPLE
        PS> Set-NotificationsPlaySounds -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete (default) | off: 0
        $NotificationsPlaySounds = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Notifications\Settings'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Notifications - Play Sounds' to '$State' ..."
        Set-RegistryEntry -InputObject $NotificationsPlaySounds
    }
}
