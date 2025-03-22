#=================================================================================================================
#                                        System > Notifications - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-NotificationsSetting
        [-Notifications {Disabled | Enabled}]
        [-NotificationsGPO {Disabled | NotConfigured}]
        [-PlaySounds {Disabled | Enabled}]
        [-ShowOnLockScreen {Disabled | Enabled}]
        [-ShowOnLockScreenGPO {Disabled | NotConfigured}]
        [-ShowRemindersAndIncomingCallsOnLockScreen {Disabled | Enabled}]
        [-ShowBellIcon {Disabled | Enabled}]
        [-ShowWelcomeExperience {Disabled | Enabled}]
        [-ShowWelcomeExperienceGPO {Disabled | NotConfigured}]
        [-SuggestWaysToFinishConfig {Disabled | Enabled}]
        [-TipsAndSuggestions {Disabled | Enabled}]
        [-TipsAndSuggestionsGPO {Disabled | NotConfigured}]
        [<CommonParameters>]

    Set-NotificationsSetting
        -AppsAndOtherSenders {Apps | Autoplay | BatterySaver | MicrosoftStore | NotificationSuggestions |
                              PrintNotification | Settings | StartupAppNotification | Suggested | WindowsBackup}
        -State {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NotificationsSetting
{
    <#
    .EXAMPLE
        PS> Set-NotificationsSetting -ShowBellIcon 'Disabled' -Notifications 'Disabled' -NotificationsGPO 'NotConfigured'

    .EXAMPLE
        PS> Set-NotificationsSetting -AppsAndOtherSenders 'Apps', 'Autoplay', 'BatterySaver' -State 'Disabled'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Notifications')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'AppsAndOtherSenders')]
        [NotifsAppsAndOtherSenders[]] $AppsAndOtherSenders,

        [Parameter(Mandatory, ParameterSetName = 'AppsAndOtherSenders')]
        [state] $State,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $Notifications,

        [Parameter(ParameterSetName = 'Notifications')]
        [GpoStateWithoutEnabled] $NotificationsGPO,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $PlaySounds,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $ShowOnLockScreen,

        [Parameter(ParameterSetName = 'Notifications')]
        [GpoStateWithoutEnabled] $ShowOnLockScreenGPO,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $ShowRemindersAndIncomingCallsOnLockScreen,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $ShowBellIcon,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $ShowWelcomeExperience,

        [Parameter(ParameterSetName = 'Notifications')]
        [GpoStateWithoutEnabled] $ShowWelcomeExperienceGPO,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $SuggestWaysToFinishConfig,

        [Parameter(ParameterSetName = 'Notifications')]
        [state] $TipsAndSuggestions,

        [Parameter(ParameterSetName = 'Notifications')]
        [GpoStateWithoutEnabled] $TipsAndSuggestionsGPO
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'AppsAndOtherSenders'       { $AppsAndOtherSenders | Set-NotificationsAppsAndOtherSenders -State $State }

            'Notifications'             { Set-Notifications -State $Notifications }
            'NotificationsGPO'          { Set-Notifications -GPO $NotificationsGPO }
            'PlaySounds'                { Set-NotificationsPlaySounds -State $PlaySounds }
            'ShowOnLockScreen'          { Set-NotificationsShowOnLockScreen -State $ShowOnLockScreen }
            'ShowOnLockScreenGPO'       { Set-NotificationsShowOnLockScreen -GPO $ShowOnLockScreenGPO }
            'ShowRemindersAndIncomingCallsOnLockScreen' {
                Set-NotificationsShowRemindersAndIncomingCallsOnLockScreen -State $ShowRemindersAndIncomingCallsOnLockScreen
            }
            'ShowBellIcon'              { Set-NotificationsShowBellIcon -State $ShowBellIcon }
            'ShowWelcomeExperience'     { Set-NotificationsShowWelcomeExperience -State $ShowWelcomeExperience }
            'ShowWelcomeExperienceGPO'  { Set-NotificationsShowWelcomeExperience -GPO $ShowWelcomeExperienceGPO }
            'SuggestWaysToFinishConfig' { Set-NotificationsSuggestWaysToFinishConfig -State $SuggestWaysToFinishConfig }
            'TipsAndSuggestions'        { Set-NotificationsTipsAndSuggestions -State $TipsAndSuggestions }
            'TipsAndSuggestionsGPO'     { Set-NotificationsTipsAndSuggestions -GPO $TipsAndSuggestionsGPO }
        }
    }
}
