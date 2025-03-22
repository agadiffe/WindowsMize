#=================================================================================================================
#                                 System > Notifications > Apps And Other Senders
#=================================================================================================================

# Depending on which notifications you already got, you might have more or less items.
# Not needed if you already disabled the main notification toggle.

<#
.SYNTAX
    Set-NotificationsAppsAndOtherSenders
        [-Name] {Apps | Autoplay | BatterySaver | MicrosoftStore | NotificationSuggestions | PrintNotification |
                 Settings | StartupAppNotification | Suggested | WindowsBackup}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NotificationsAppsAndOtherSenders
{
    <#
    .EXAMPLE
        PS> $NotificationsToDisable = @(
                Apps
                Autoplay
                BatterySaver
                ...
            )
        PS> $NotificationsToDisable | Set-NotificationsAppsAndOtherSenders -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NotifsAppsAndOtherSenders] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $RegKeyName = switch ($Name)
        {
            'Apps'                    { 'Windows.SystemToast.PinConsent' }
            'Autoplay'                { 'Windows.SystemToast.AutoPlay' }
            'BatterySaver'            { 'Windows.SystemToast.BackgroundAccess' }
            'MicrosoftStore'          { 'Microsoft.WindowsStore_8wekyb3d8bbwe!App' }
            'NotificationSuggestions' { 'Windows.ActionCenter.SmartOptOut' }
            'PrintNotification'       { 'Windows.SystemToast.Print.Notification' }
            'Settings'                { 'windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel' }
            'StartupAppNotification'  { 'Windows.SystemToast.StartupApp' }
            'Suggested'               { 'Windows.SystemToast.Suggested' } # Ads for Microsoft apps
            'WindowsBackup'           { 'MicrosoftWindows.Client.CBS_cw5n1h2txyewy!WindowsBackup' }
        }

        $NotificationsAppsAndOtherSenders = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = "Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$RegKeyName"
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Notifications - Apps And Other Senders: $Name' to '$State' ..."
        Set-RegistryEntry -InputObject $NotificationsAppsAndOtherSenders
    }
}
