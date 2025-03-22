#=================================================================================================================
#                  System > Notifications > Show Reminders And Incoming Calls On The Lock Screen
#=================================================================================================================

<#
.SYNTAX
    Set-NotificationsShowRemindersAndIncomingCallsOnLockScreen
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NotificationsShowRemindersAndIncomingCallsOnLockScreen
{
    <#
    .EXAMPLE
        PS> Set-NotificationsShowRemindersAndIncomingCallsOnLockScreen -State 'Disabled'
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
        $NotificationsRemindersAndIncomingCalls = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Notifications\Settings'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Notifications - Show Incoming Calls On The Lock Screen' to '$State' ..."
        Set-RegistryEntry -InputObject $NotificationsRemindersAndIncomingCalls
    }
}
