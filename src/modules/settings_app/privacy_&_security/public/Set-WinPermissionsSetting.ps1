#=================================================================================================================
#                               Privacy & Security > Windows Permissions - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsSetting
        # User Data
        [-FindMyDevice {Disabled | Enabled}]
        [-FindMyDeviceGPO {Disabled | Enabled | NotConfigured}]
        [-PersonalizedOffers {Disabled | Enabled}]
        [-PersonalizedOffersGPO {Disabled | NotConfigured}]
        [-LanguageListAccess {Disabled | Enabled}]
        [-TrackAppLaunches {Disabled | Enabled}]
        [-TrackAppLaunchesGPO {Disabled | NotConfigured}]
        [-ShowAdsInSettingsApp {Disabled | Enabled}]
        [-ShowAdsInSettingsAppGPO {Disabled | NotConfigured}]
        [-AdvertisingID {Disabled | Enabled}]
        [-AdvertisingIDGPO {Disabled | NotConfigured}]
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
        [-FeedbackFrequency {Never | Automatically | Always | Daily | Weekly}]
        [-FeedbackFrequencyGPO {Disabled | NotConfigured}]

        # Search
        [-SafeSearch {Disabled | Moderate | Strict}]
        [-SearchHistory {Disabled | Enabled}]
        [-SearchHighlights {Disabled | Enabled}]
        [-SearchHighlightsGPO {Disabled | NotConfigured}]
        [-StartMenuSearchWebSuggestions {Disabled | Enabled}]
        [-StartMenuSearchMSStoreSuggestions {Disabled | Enabled}]
        [-StartMenuSearchWebSuggestions2 {Disabled | Enabled}]
        [-StartMenuSearchWebSuggestions2GPO {Disabled | NotConfigured}]
        [-StartMenuSearchWebSuggestions3 {Disabled | Enabled}]
        [-StartMenuSearchWebSuggestions3GPO {Disabled | NotConfigured}]
        [-StartMenuSearchMSStoreSuggestions2 {Disabled | Enabled}]
        [-CloudSearchMicrosoftAccount {Disabled | Enabled}]
        [-CloudSearchWorkOrSchoolAccount {Disabled | Enabled}]
        [-CloudSearchGPO {Disabled | NotConfigured}]
        [-CloudFileContentSearch {Disabled | Enabled}]
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

        [state] $PersonalizedOffers,
        [GpoStateWithoutEnabled] $PersonalizedOffersGPO,
        [state] $LanguageListAccess,
        [state] $TrackAppLaunches,
        [GpoStateWithoutEnabled] $TrackAppLaunchesGPO,
        [state] $ShowAdsInSettingsApp,
        [GpoStateWithoutEnabled] $ShowAdsInSettingsAppGPO,
        [state] $AdvertisingID,
        [GpoStateWithoutEnabled] $AdvertisingIDGPO,
        [state] $ShowNotifsInSettingsApp,
        [state] $ActivityHistory,
        [GpoStateWithoutEnabled] $ActivityHistoryGPO,

        # AI (Recall / Speech / Typing)
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
        [FeedbackFrequencyMode] $FeedbackFrequency,
        [GpoStateWithoutEnabled] $FeedbackFrequencyGPO,

        # Search
        [SafeSearchMode] $SafeSearch,
        [state] $SearchHistory,
        [state] $SearchHighlights,
        [GpoStateWithoutEnabled] $SearchHighlightsGPO,
        [state] $StartMenuSearchWebSuggestions,
        [state] $StartMenuSearchMSStoreSuggestions,
        [state] $StartMenuSearchWebSuggestions2,
        [GpoStateWithoutEnabled] $StartMenuSearchWebSuggestions2GPO,
        [state] $StartMenuSearchWebSuggestions3,
        [GpoStateWithoutEnabled] $StartMenuSearchWebSuggestions3GPO,
        [state] $StartMenuSearchMSStoreSuggestions2,
        [state] $CloudSearchMicrosoftAccount,
        [state] $CloudSearchWorkOrSchoolAccount,
        [GpoStateWithoutEnabled] $CloudSearchGPO,
        [state] $CloudFileContentSearch,

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
            'FindMyDevice'                       { Set-SecurityFindMyDevice -State $FindMyDevice }
            'FindMyDeviceGPO'                    { Set-SecurityFindMyDevice -GPO $FindMyDeviceGPO }

            'PersonalizedOffers'                 { Set-WinPermissionsPersonalizedOffers -State $PersonalizedOffers }
            'PersonalizedOffersGPO'              { Set-WinPermissionsPersonalizedOffers -GPO $PersonalizedOffersGPO }
            'LanguageListAccess'                 { Set-WinPermissionsLanguageListAccess -State $LanguageListAccess }
            'TrackAppLaunches'                   { Set-WinPermissionsTrackAppLaunches -State $TrackAppLaunches }
            'TrackAppLaunchesGPO'                { Set-WinPermissionsTrackAppLaunches -GPO $TrackAppLaunchesGPO }
            'ShowAdsInSettingsApp'               { Set-WinPermissionsShowAdsInSettingsApp -State $ShowAdsInSettingsApp }
            'ShowAdsInSettingsAppGPO'            { Set-WinPermissionsShowAdsInSettingsApp -GPO $ShowAdsInSettingsAppGPO }
            'AdvertisingID'                      { Set-WinPermissionsAdvertisingID -State $AdvertisingID }
            'AdvertisingIDGPO'                   { Set-WinPermissionsAdvertisingID -GPO $AdvertisingIDGPO }
            'ShowNotifsInSettingsApp'            { Set-WinPermissionsShowNotifsInSettingsApp -State $ShowNotifsInSettingsApp }
            'ActivityHistory'                    { Set-WinPermissionsActivityHistory -State $ActivityHistory }
            'ActivityHistoryGPO'                 { Set-WinPermissionsActivityHistory -GPO $ActivityHistoryGPO }

            # AI (Recall / Speech / Typing)
            'RecallSnapshotsGPO'                 { Set-WinPermissionsRecallSnapshots -GPO $RecallSnapshotsGPO }
            'RecallFilteringTelemetry'           { Set-WinPermissionsRecallFilteringTelemetry -State $RecallFilteringTelemetry }
            'RecallPersonalizedHomepage'         { Set-WinPermissionsRecallPersonalizedHomepage -State $RecallPersonalizedHomepage }

            'ClickToDo'                          { Set-WinPermissionsClickToDo -State $ClickToDo }
            'ClickToDoGPO'                       { Set-WinPermissionsClickToDo -GPO $ClickToDoGPO }

            'SpeechRecognition'                  { Set-WinPermissionsSpeechRecognition -State $SpeechRecognition }
            'SpeechRecognitionGPO'               { Set-WinPermissionsSpeechRecognition -GPO $SpeechRecognitionGPO }

            'InkingAndTypingPersonalization'     { Set-WinPermissionsInkingAndTypingPersonalization -State $InkingAndTypingPersonalization }

            # Telemetry (diagnostics & feedback)
            'DiagnosticData'                     { Set-WinPermissionsDiagnosticData -State $DiagnosticData }
            'DiagnosticDataGPO'                  { Set-WinPermissionsDiagnosticData -GPO $DiagnosticDataGPO }
            'DiagnosticDataViewer'               { Set-WinPermissionsDiagnosticDataViewer -State $DiagnosticDataViewer }
            'DiagnosticDataViewerGPO'            { Set-WinPermissionsDiagnosticDataViewer -GPO $DiagnosticDataViewerGPO }
            'DeleteDiagnosticDataGPO'            { Set-WinPermissionsDeleteDiagnosticData -GPO $DeleteDiagnosticDataGPO }
            'ImproveInkingAndTyping'             { Set-WinPermissionsImproveInkingAndTyping -State $ImproveInkingAndTyping }
            'ImproveInkingAndTypingGPO'          { Set-WinPermissionsImproveInkingAndTyping -GPO $ImproveInkingAndTypingGPO }
            'FeedbackFrequency'                  { Set-WinPermissionsFeedbackFrequency -Mode $FeedbackFrequency }
            'FeedbackFrequencyGPO'               { Set-WinPermissionsFeedbackFrequency -GPO $FeedbackFrequencyGPO }

            # Search
            'SafeSearch'                         { Set-WinPermissionsSafeSearch -State $SafeSearch }
            'SearchHistory'                      { Set-WinPermissionsSearchHistory -State $SearchHistory }
            'SearchHighlights'                   { Set-WinPermissionsSearchHighlights -State $SearchHighlights }
            'SearchHighlightsGPO'                { Set-WinPermissionsSearchHighlights -GPO $SearchHighlightsGPO }
            'StartMenuSearchWebSuggestions'      { Set-WinPermissionsStartMenuSearchWebSuggestions -State $StartMenuSearchWebSuggestions }
            'StartMenuSearchMSStoreSuggestions'  { Set-WinPermissionsStartMenuSearchMSStoreSuggestions -State $StartMenuSearchMSStoreSuggestions }
            'StartMenuSearchWebSuggestions2'     { Set-WinPermissionsStartMenuSearchWebSuggestions2 -State $StartMenuSearchWebSuggestions2 }
            'StartMenuSearchWebSuggestions2GPO'  { Set-WinPermissionsStartMenuSearchWebSuggestions2 -GPO $StartMenuSearchWebSuggestions2GPO }
            'StartMenuSearchWebSuggestions3'     { Set-WinPermissionsStartMenuSearchWebSuggestions3 -State $StartMenuSearchWebSuggestions3 }
            'StartMenuSearchWebSuggestions3GPO'  { Set-WinPermissionsStartMenuSearchWebSuggestions3 -GPO $StartMenuSearchWebSuggestions3GPO }
            'StartMenuSearchMSStoreSuggestions2' { Set-WinPermissionsStartMenuSearchMSStoreSuggestions2 -State $StartMenuSearchMSStoreSuggestions2 }
            'CloudSearchMicrosoftAccount'        { Set-WinPermissionsCloudSearch -MicrosoftAccount $CloudSearchMicrosoftAccount }
            'CloudSearchWorkOrSchoolAccount'     { Set-WinPermissionsCloudSearch -WorkOrSchoolAccount $CloudSearchWorkOrSchoolAccount }
            'CloudSearchGPO'                     { Set-WinPermissionsCloudSearch -GPO $CloudSearchGPO }
            'CloudFileContentSearch'             { Set-WinPermissionsCloudFileContentSearch -State $CloudFileContentSearch }

            'FindMyFiles'                        { Set-WinPermissionsFindMyFiles -Mode $FindMyFiles }
            'IndexEncryptedFilesGPO'             { Set-WinPermissionsIndexEncryptedFiles -GPO $IndexEncryptedFilesGPO }
        }
    }
}
