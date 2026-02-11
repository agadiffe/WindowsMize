#=================================================================================================================
#                                 Privacy & Security > App Permissions - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsSetting

        # General
        [-Location {Disabled | Enabled}]
        [-LocationGPO {Disabled | Enabled | NotConfigured}]
        [-LocationAllowOverride {Disabled | Enabled}]
        [-LocationAppsRequestNotif {Disabled | Enabled}]
        [-Camera {Disabled | Enabled}]
        [-CameraGPO {Disabled | Enabled | NotConfigured}]
        [-Microphone {Disabled | Enabled}]
        [-MicrophoneGPO {Disabled | Enabled | NotConfigured}]
        [-VoiceActivation {Disabled | Enabled}]
        [-VoiceActivationGPO {Disabled | Enabled | NotConfigured}]
        [-Notifications {Disabled | Enabled}]
        [-NotificationsGPO {Disabled | Enabled | NotConfigured}]

        [-TextAndImageGeneration {Disabled | Enabled}]
        [-TextAndImageGenerationGPO {Disabled | Enabled | NotConfigured}]
        [-BackgroundApps {Disabled | Enabled}]
        [-BackgroundAppsGPO {Disabled | Enabled | NotConfigured}]

        # User Data
        [-AccountInfo {Disabled | Enabled}]
        [-AccountInfoGPO {Disabled | Enabled | NotConfigured}]
        [-Contacts {Disabled | Enabled}]
        [-ContactsGPO {Disabled | Enabled | NotConfigured}]
        [-Calendar {Disabled | Enabled}]
        [-CalendarGPO {Disabled | Enabled | NotConfigured}]
        [-PhoneCalls {Disabled | Enabled}]
        [-PhoneCallsGPO {Disabled | Enabled | NotConfigured}]
        [-CallHistory {Disabled | Enabled}]
        [-CallHistoryGPO {Disabled | Enabled | NotConfigured}]
        [-Email {Disabled | Enabled}]
        [-EmailGPO {Disabled | Enabled | NotConfigured}]
        [-Tasks {Disabled | Enabled}]
        [-TasksGPO {Disabled | Enabled | NotConfigured}]
        [-Messaging {Disabled | Enabled}]
        [-MessagingGPO {Disabled | Enabled | NotConfigured}]
        [-Radios {Disabled | Enabled}]
        [-RadiosGPO {Disabled | Enabled | NotConfigured}]
        [-SyncWithUnpairedDevices {Disabled | Enabled}]
        [-SyncWithUnpairedDevicesGPO {Disabled | Enabled | NotConfigured}]
        [-TrustedDevicesGPO {Disabled | Enabled | NotConfigured}]
        [-AppDiagnostics {Disabled | Enabled}]
        [-AppDiagnosticsGPO {Disabled | Enabled | NotConfigured}]

        # User Files
        [-Documents {Disabled | Enabled}]
        [-DownloadsFolder {Disabled | Enabled}]
        [-MusicLibrary {Disabled | Enabled}]
        [-Pictures {Disabled | Enabled}]
        [-Videos {Disabled | Enabled}]
        [-FileSystem {Disabled | Enabled}]
        [-ScreenshotBorders {Disabled | Enabled}]
        [-ScreenshotBordersGPO {Disabled | Enabled | NotConfigured}]
        [-ScreenshotsAndRecording {Disabled | Enabled}]
        [-ScreenshotsAndRecordingGPO {Disabled | Enabled | NotConfigured}]
        [-Passkeys {Disabled | Enabled}]
        [-PasskeysAutofill {Disabled | Enabled}]

        # Tablet
        [-EyeTracker {Disabled | Enabled}]
        [-EyeTrackerGPO {Disabled | Enabled | NotConfigured}]
        [-Motion {Disabled | Enabled}]
        [-MotionGPO {Disabled | Enabled | NotConfigured}]
        [-PresenceSensing {Disabled | Enabled}]
        [-PresenceSensingGPO {Disabled | Enabled | NotConfigured}]
        [-UserMovement {Disabled | Enabled}]
        [-UserMovementGPO {Disabled | Enabled | NotConfigured}]
        [-CellularData {Disabled | Enabled}]
        [-CellularDataGPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsSetting
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsSetting -Location 'Disabled' -AccountInfo 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # General
        [state] $Location,
        [GpoState] $LocationGPO,
        [state] $LocationAllowOverride,
        [state] $LocationAppsRequestNotif,
        [state] $Camera,
        [GpoState] $CameraGPO,
        [state] $Microphone,
        [GpoState] $MicrophoneGPO,
        [state] $VoiceActivation,
        [GpoState] $VoiceActivationGPO,
        [state] $Notifications,
        [GpoState] $NotificationsGPO,

        [state] $TextAndImageGeneration,
        [GpoState] $TextAndImageGenerationGPO,
        [state] $BackgroundApps,
        [GpoState] $BackgroundAppsGPO,

        # User Data
        [state] $AccountInfo,
        [GpoState] $AccountInfoGPO,
        [state] $Contacts,
        [GpoState] $ContactsGPO,
        [state] $Calendar,
        [GpoState] $CalendarGPO,
        [state] $PhoneCalls,
        [GpoState] $PhoneCallsGPO,
        [state] $CallHistory,
        [GpoState] $CallHistoryGPO,
        [state] $Email,
        [GpoState] $EmailGPO,
        [state] $Tasks,
        [GpoState] $TasksGPO,
        [state] $Messaging,
        [GpoState] $MessagingGPO,
        [state] $Radios,
        [GpoState] $RadiosGPO,
        [state] $SyncWithUnpairedDevices,
        [GpoState] $SyncWithUnpairedDevicesGPO,
        [GpoState] $TrustedDevicesGPO,
        [state] $AppDiagnostics,
        [GpoState] $AppDiagnosticsGPO,

        # User Files
        [state] $Documents,
        [state] $DownloadsFolder,
        [state] $MusicLibrary,
        [state] $Pictures,
        [state] $Videos,
        [state] $FileSystem,
        [state] $ScreenshotBorders,
        [GpoState] $ScreenshotBordersGPO,
        [state] $ScreenshotsAndRecording,
        [GpoState] $ScreenshotsAndRecordingGPO,
        [state] $Passkeys,
        [state] $PasskeysAutofill,

        # Tablet
        [state] $EyeTracker,
        [GpoState] $EyeTrackerGPO,
        [state] $Motion,
        [GpoState] $MotionGPO,
        [state] $PresenceSensing,
        [GpoState] $PresenceSensingGPO,
        [state] $UserMovement,
        [GpoState] $UserMovementGPO,
        [state] $CellularData,
        [GpoState] $CellularDataGPO
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        # needed starting with version 26200.7623
        # https://github.com/agadiffe/WindowsMize/issues/3
        Remove-CapabilityConsentStorageDatabase -Verbose:$false

        switch ($PSBoundParameters.Keys)
        {
            # General
            'Location'                   { Set-AppPermissionsLocation -State $Location }
            'LocationGPO'                { Set-AppPermissionsLocation -GPO $LocationGPO }
            'LocationAllowOverride'      { Set-AppPermissionsLocationAllowOverride -State $LocationAllowOverride }
            'LocationAppsRequestNotif'   { Set-AppPermissionsLocationAppsRequestNotif -State $LocationAppsRequestNotif }
            'Camera'                     { Set-AppPermissionsCamera -State $Camera }
            'CameraGPO'                  { Set-AppPermissionsCamera -GPO $CameraGPO }
            'Microphone'                 { Set-AppPermissionsMicrophone -State $Microphone }
            'MicrophoneGPO'              { Set-AppPermissionsMicrophone -GPO $MicrophoneGPO }
            'VoiceActivation'            { Set-AppPermissionsVoiceActivation -State $VoiceActivation }
            'VoiceActivationGPO'         { Set-AppPermissionsVoiceActivation -GPO $VoiceActivationGPO }
            'Notifications'              { Set-AppPermissionsNotifications -State $Notifications }
            'NotificationsGPO'           { Set-AppPermissionsNotifications -GPO $NotificationsGPO }

            'TextAndImageGeneration'     { Set-AppPermissionsTextAndImageGeneration -State $TextAndImageGeneration }
            'TextAndImageGenerationGPO'  { Set-AppPermissionsTextAndImageGeneration -GPO $TextAndImageGenerationGPO }
            'BackgroundApps'             { Set-AppPermissionsBackgroundApps -State $BackgroundApps }
            'BackgroundAppsGPO'          { Set-AppPermissionsBackgroundApps -GPO $BackgroundAppsGPO }

            # User Data
            'AccountInfo'                { Set-AppPermissionsAccountInfo -State $AccountInfo }
            'AccountInfoGPO'             { Set-AppPermissionsAccountInfo -GPO $AccountInfoGPO }
            'Contacts'                   { Set-AppPermissionsContacts -State $Contacts }
            'ContactsGPO'                { Set-AppPermissionsContacts -GPO $ContactsGPO }
            'Calendar'                   { Set-AppPermissionsCalendar -State $Calendar }
            'CalendarGPO'                { Set-AppPermissionsCalendar -GPO $CalendarGPO }
            'PhoneCalls'                 { Set-AppPermissionsPhoneCalls -State $PhoneCalls }
            'PhoneCallsGPO'              { Set-AppPermissionsPhoneCalls -GPO $PhoneCallsGPO }
            'CallHistory'                { Set-AppPermissionsCallHistory -State $CallHistory }
            'CallHistoryGPO'             { Set-AppPermissionsCallHistory -GPO $CallHistoryGPO }
            'Email'                      { Set-AppPermissionsEmail -State $Email }
            'EmailGPO'                   { Set-AppPermissionsEmail -GPO $EmailGPO }
            'Tasks'                      { Set-AppPermissionsTasks -State $Tasks }
            'TasksGPO'                   { Set-AppPermissionsTasks -GPO $TasksGPO }
            'Messaging'                  { Set-AppPermissionsMessaging -State $Messaging }
            'MessagingGPO'               { Set-AppPermissionsMessaging -GPO $MessagingGPO }
            'Radios'                     { Set-AppPermissionsRadios -State $Radios }
            'RadiosGPO'                  { Set-AppPermissionsRadios -GPO $RadiosGPO }
            'SyncWithUnpairedDevices'    { Set-AppPermissionsDevicesSyncWithUnpaired -State $SyncWithUnpairedDevices }
            'SyncWithUnpairedDevicesGPO' { Set-AppPermissionsDevicesSyncWithUnpaired -GPO $SyncWithUnpairedDevicesGPO }
            'TrustedDevicesGPO'          { Set-AppPermissionsDevicesTrustedHadware -GPO $TrustedDevicesGPO }
            'AppDiagnostics'             { Set-AppPermissionsAppDiagnostics -State $AppDiagnostics }
            'AppDiagnosticsGPO'          { Set-AppPermissionsAppDiagnostics -GPO $AppDiagnosticsGPO }

            # User Files
            'Documents'                  { Set-AppPermissionsDocuments -State $Documents }
            'DownloadsFolder'            { Set-AppPermissionsDownloadsFolder -State $DownloadsFolder }
            'MusicLibrary'               { Set-AppPermissionsMusicLibrary -State $MusicLibrary }
            'Pictures'                   { Set-AppPermissionsPictures -State $Pictures }
            'Videos'                     { Set-AppPermissionsVideos -State $Videos }
            'FileSystem'                 { Set-AppPermissionsFileSystem -State $FileSystem }
            'ScreenshotBorders'          { Set-AppPermissionsScreenshotBorders -State $ScreenshotBorders }
            'ScreenshotBordersGPO'       { Set-AppPermissionsScreenshotBorders -GPO $ScreenshotBordersGPO }
            'ScreenshotsAndRecording'    { Set-AppPermissionsScreenshotsAndRecording -State $ScreenshotsAndRecording }
            'ScreenshotsAndRecordingGPO' { Set-AppPermissionsScreenshotsAndRecording -GPO $ScreenshotsAndRecordingGPO }
            'Passkeys'                   { Set-AppPermissionsPasskeys -State $Passkeys }
            'PasskeysAutofill'           { Set-AppPermissionsPasskeysAutofill -State $PasskeysAutofill }

            # Tablet
            'EyeTracker'                 { Set-AppPermissionsEyeTracker -State $EyeTracker }
            'EyeTrackerGPO'              { Set-AppPermissionsEyeTracker -GPO $EyeTrackerGPO }
            'Motion'                     { Set-AppPermissionsMotion -State $Motion }
            'MotionGPO'                  { Set-AppPermissionsMotion -GPO $MotionGPO }
            'PresenceSensing'            { Set-AppPermissionsPresenceSensing -State $PresenceSensing }
            'PresenceSensingGPO'         { Set-AppPermissionsPresenceSensing -GPO $PresenceSensingGPO }
            'UserMovement'               { Set-AppPermissionsUserMovement -State $UserMovement }
            'UserMovementGPO'            { Set-AppPermissionsUserMovement -GPO $UserMovementGPO }
            'CellularData'               { Set-AppPermissionsCellularData -State $CellularData }
            'CellularDataGPO'            { Set-AppPermissionsCellularData -GPO $CellularDataGPO }
        }
    }
}
