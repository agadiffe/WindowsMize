#=================================================================================================================
#                               Privacy & Security > Windows Permissions - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsSetting

        # User Data
        [-FindMyDevice {Disabled | Enabled}]
        [-FindMyDeviceGPO {Disabled | Enabled | NotConfigured}]
        [-AdvertisingID {Disabled | Enabled}]
        [-AdvertisingIDGPO {Disabled | NotConfigured}]
        [-LanguageListAccess {Disabled | Enabled}]
        [-TrackAppLaunches {Disabled | Enabled}]
        [-TrackAppLaunchesGPO {Disabled | NotConfigured}]
        [-ShowAdsInSettingsApp {Disabled | Enabled}]
        [-ShowAdsInSettingsAppGPO {Disabled | NotConfigured}]
        [-ShowNotifsInSettingsApp {Disabled | Enabled}]
        [-ActivityHistory {Disabled | Enabled}]
        [-ActivityHistoryGPO {Disabled | NotConfigured}]

        # AI
        [-RecallSnapshotsGPO {Disabled | NotConfigured}]
        [-RecallFilteringTelemetry {Disabled | Enabled}]
        [-RecallPersonalizedHomepage {Disabled | Enabled}]
        [-ClickToDo {Disabled | Enabled}]
        [-ClickToDoGPO {Disabled | NotConfigured}]
        [-SpeechRecognition {Disabled | Enabled}]
        [-SpeechRecognitionGPO {Disabled | NotConfigured}]
        [-InkingAndTypingPersonalization {Disabled | Enabled}]

        # Telemetry
        [-DiagnosticData {Disabled | OnlyRequired | OptionalAndRequired}]
        [-DiagnosticDataGPO {Disabled | OnlyRequired | OptionalAndRequired | NotConfigured}]
        [-DiagnosticDataViewer {Disabled | Enabled}]
        [-DiagnosticDataViewerGPO {Disabled | NotConfigured}]
        [-DeleteDiagnosticDataGPO {Disabled | NotConfigured}]
        [-ImproveInkingAndTyping {Disabled | Enabled}]
        [-ImproveInkingAndTypingGPO {Disabled | NotConfigured}]
        [-TailoredExperiences {Disabled | Enabled}]
        [-TailoredExperiencesGPO {Disabled | NotConfigured}]
        [-FeedbackFrequency {Never | Automatically | Always | Daily | Weekly}]
        [-FeedbackFrequencyGPO {Disabled | NotConfigured}]

        # Search
        [-SafeSearch {Disabled | Moderate | Strict}]
        [-SearchHistory {Disabled | Enabled}]
        [-SearchHighlights {Disabled | Enabled}]
        [-SearchHighlightsGPO {Disabled | NotConfigured}]
        [-CloudSearchMicrosoftAccount {Disabled | Enabled}]
        [-CloudSearchWorkOrSchoolAccount {Disabled | Enabled}]
        [-CloudSearchGPO {Disabled | NotConfigured}]
        [-CloudFileContentSearch {Disabled | Enabled}]
        [-StartMenuWebSearch {Disabled | Enabled}]
        [-FindMyFiles {Classic | Enhanced}]
        [-IndexEncryptedFilesGPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsSetting
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsSetting -AdvertisingIDGPO 'Disabled' -DiagnosticDataGPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # User Data (General / Recommendations & offers)
        [state] $FindMyDevice,
        [GpoState] $FindMyDeviceGPO,

        [state] $AdvertisingID,
        [GpoStateWithoutEnabled] $AdvertisingIDGPO,
        [state] $LanguageListAccess,
        [state] $TrackAppLaunches,
        [GpoStateWithoutEnabled] $TrackAppLaunchesGPO,
        [state] $ShowAdsInSettingsApp,
        [GpoStateWithoutEnabled] $ShowAdsInSettingsAppGPO,
        [state] $ShowNotifsInSettingsApp,

        [state] $ActivityHistory,
        [GpoStateWithoutEnabled] $ActivityHistoryGPO,

        # AI
        [GpoStateWithoutEnabled] $RecallSnapshotsGPO,
        [state] $RecallFilteringTelemetry,
        [state] $RecallPersonalizedHomepage,

        [state] $ClickToDo,
        [GpoStateWithoutEnabled] $ClickToDoGPO,

        [state] $SpeechRecognition,
        [GpoStateWithoutEnabled] $SpeechRecognitionGPO,

        [state] $InkingAndTypingPersonalization,

        # Telemetry (diagnostics & feedback)
        [DiagnosticDataMode] $DiagnosticData,
        [GpoDiagnosticDataMode] $DiagnosticDataGPO,
        [state] $DiagnosticDataViewer,
        [GpoStateWithoutEnabled] $DiagnosticDataViewerGPO,
        [GpoStateWithoutEnabled] $DeleteDiagnosticDataGPO,
        [state] $ImproveInkingAndTyping,
        [GpoStateWithoutEnabled] $ImproveInkingAndTypingGPO,
        [state] $TailoredExperiences,
        [GpoStateWithoutEnabled] $TailoredExperiencesGPO,
        [FeedbackFrequencyMode] $FeedbackFrequency,
        [GpoStateWithoutEnabled] $FeedbackFrequencyGPO,

        # Search
        [SafeSearchMode] $SafeSearch,
        [state] $SearchHistory,
        [state] $SearchHighlights,
        [GpoStateWithoutEnabled] $SearchHighlightsGPO,
        [state] $CloudSearchMicrosoftAccount,
        [state] $CloudSearchWorkOrSchoolAccount,
        [GpoStateWithoutEnabled] $CloudSearchGPO,
        [state] $CloudFileContentSearch,
        [state] $StartMenuWebSearch,

        [FindMyFilesMode] $FindMyFiles,
        [GpoState] $IndexEncryptedFilesGPO
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
            # User Data (General / Recommendations & offers)
            'FindMyDevice'                   { Set-SecurityFindMyDevice -State $FindMyDevice }
            'FindMyDeviceGPO'                { Set-SecurityFindMyDevice -GPO $FindMyDeviceGPO }

            'AdvertisingID'                  { Set-WinPermissionsAdvertisingID -State $AdvertisingID }
            'AdvertisingIDGPO'               { Set-WinPermissionsAdvertisingID -GPO $AdvertisingIDGPO }
            'LanguageListAccess'             { Set-WinPermissionsLanguageListAccess -State $LanguageListAccess }
            'TrackAppLaunches'               { Set-WinPermissionsTrackAppLaunches -State $TrackAppLaunches }
            'TrackAppLaunchesGPO'            { Set-WinPermissionsTrackAppLaunches -GPO $TrackAppLaunchesGPO }
            'ShowAdsInSettingsApp'           { Set-WinPermissionsShowAdsInSettingsApp -State $ShowAdsInSettingsApp }
            'ShowAdsInSettingsAppGPO'        { Set-WinPermissionsShowAdsInSettingsApp -GPO $ShowAdsInSettingsAppGPO }
            'ShowNotifsInSettingsApp'        { Set-WinPermissionsShowNotifsInSettingsApp -State $ShowNotifsInSettingsApp }

            'ActivityHistory'                { Set-WinPermissionsActivityHistory -State $ActivityHistory }
            'ActivityHistoryGPO'             { Set-WinPermissionsActivityHistory -GPO $ActivityHistoryGPO }

            # AI
            'RecallSnapshotsGPO'             { Set-WinPermissionsRecallSnapshots -GPO $RecallSnapshotsGPO }
            'RecallFilteringTelemetry'       { Set-WinPermissionsRecallFilteringTelemetry -State $RecallFilteringTelemetry }
            'RecallPersonalizedHomepage'     { Set-WinPermissionsRecallPersonalizedHomepage -State $RecallPersonalizedHomepage }

            'ClickToDo'                      { Set-WinPermissionsClickToDo -State $ClickToDo }
            'ClickToDoGPO'                   { Set-WinPermissionsClickToDo -GPO $ClickToDoGPO }

            'SpeechRecognition'              { Set-WinPermissionsSpeechRecognition -State $SpeechRecognition }
            'SpeechRecognitionGPO'           { Set-WinPermissionsSpeechRecognition -GPO $SpeechRecognitionGPO }

            'InkingAndTypingPersonalization' { Set-WinPermissionsInkingAndTypingPersonalization -State $InkingAndTypingPersonalization }

            # Telemetry (diagnostics & feedback)
            'DiagnosticData'                 { Set-WinPermissionsDiagnosticData -State $DiagnosticData }
            'DiagnosticDataGPO'              { Set-WinPermissionsDiagnosticData -GPO $DiagnosticDataGPO }
            'DiagnosticDataViewer'           { Set-WinPermissionsDiagnosticDataViewer -State $DiagnosticDataViewer }
            'DiagnosticDataViewerGPO'        { Set-WinPermissionsDiagnosticDataViewer -GPO $DiagnosticDataViewerGPO }
            'DeleteDiagnosticDataGPO'        { Set-WinPermissionsDeleteDiagnosticData -GPO $DeleteDiagnosticDataGPO }
            'ImproveInkingAndTyping'         { Set-WinPermissionsImproveInkingAndTyping -State $ImproveInkingAndTyping }
            'ImproveInkingAndTypingGPO'      { Set-WinPermissionsImproveInkingAndTyping -GPO $ImproveInkingAndTypingGPO }
            'TailoredExperiences'            { Set-WinPermissionsTailoredExperiences -State $TailoredExperiences }
            'TailoredExperiencesGPO'         { Set-WinPermissionsTailoredExperiences -GPO $TailoredExperiencesGPO }
            'FeedbackFrequency'              { Set-WinPermissionsFeedbackFrequency -State $FeedbackFrequency }
            'FeedbackFrequencyGPO'           { Set-WinPermissionsFeedbackFrequency -GPO $FeedbackFrequencyGPO }

            # Search
            'SafeSearch'                     { Set-WinPermissionsSafeSearch -State $SafeSearch }
            'SearchHistory'                  { Set-WinPermissionsSearchHistory -State $SearchHistory }
            'SearchHighlights'               { Set-WinPermissionsSearchHighlights -State $SearchHighlights }
            'SearchHighlightsGPO'            { Set-WinPermissionsSearchHighlights -GPO $SearchHighlightsGPO }
            'CloudSearchMicrosoftAccount'    { Set-WinPermissionsCloudSearch -MicrosoftAccount $CloudSearchMicrosoftAccount }
            'CloudSearchWorkOrSchoolAccount' { Set-WinPermissionsCloudSearch -WorkOrSchoolAccount $CloudSearchWorkOrSchoolAccount }
            'CloudSearchGPO'                 { Set-WinPermissionsCloudSearch -GPO $CloudSearchGPO }
            'CloudFileContentSearch'         { Set-WinPermissionsCloudFileContentSearch -State $CloudFileContentSearch }
            'StartMenuWebSearch'             { Set-WinPermissionsStartMenuWebSearch -State $StartMenuWebSearch }

            'FindMyFiles'                    { Set-WinPermissionsFindMyFiles -State $FindMyFiles }
            'IndexEncryptedFilesGPO'         { Set-WinPermissionsIndexEncryptedFiles -GPO $IndexEncryptedFilesGPO }
        }
    }
}
