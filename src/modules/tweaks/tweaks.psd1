@{
    RootModule        = 'tweaks.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'b7be1d37-e89c-4478-9c8c-b865ca76a62f'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        # --- security_privacy_and_networking
        'Set-HomeGroup'
        'Set-Hotspot2'
        'Set-LocalAccountsSecurityQuestions'
        'Set-LockScreenCameraAccess'
        'Set-MessagingCloudSync'
        'Set-NotificationsNetworkUsage'
        'Set-PasswordExpiration'
        'Set-PasswordRevealButton'
        'Set-PrinterDriversDownloadOverHttp'
        'Set-PrintingOverHttp'
        'Set-WifiSense'
        'Set-Wpbt'

        # --- system_and_performance
        'Set-FirstSigninAnimation'
        'Set-FullscreenOptimizations'
        'Set-LongPaths'
        'Set-NtfsLastAccessTime'
        'Set-NumLockAtStartup'
        'Set-ServiceHostSplitting'
        'Set-Short8Dot3FileName'
        'Set-StartupShutdownVerboseStatusMessages'

        # --- user_interface_and_experience
        'Disable-GameBarLinks'
        'Set-ActionCenterLayout'
        'Set-CopyPasteDialogShowMoreDetails'
        'Set-HelpTips'
        'Set-MenuShowDelay'
        'Set-OnlineTips'
        'Set-ShortcutNameSuffix'
        'Set-StartMenuAllAppsViewMode'
        'Set-StartMenuRecommendedSection'
        'Set-SuggestedContent'
        'Set-WindowsExperimentation'
        'Set-WindowsInputExperience'
        'Set-WindowsPrivacySettingsExperience'
        'Set-WindowsSettingsSearchAgent'
        'Set-WindowsSharedExperience'
        'Set-WindowsSpotlight'

        # --- windows_features_and_settings
        'Move-CharacterMapShortcutToWindowsTools'
        'Set-DisplayModeChangeAnimation'
        'Set-EaseOfAccessReadScanSection'
        'Set-EventLogLocation'
        'Set-FileHistory'
        'Set-FontProviders'
        'Set-HomeSettingPageVisibility'
        'Set-LocationPermission'
        'Set-LocationScriptingPermission'
        'Set-OpenWithDialogStoreAccess'
        'Set-SensorsPermission'
        'Set-ShareShowDragTrayOnTopScreen'
        'Set-TaskbarLastActiveClick'
        'Set-WindowsHelpSupportSetting'
        'Set-WindowsMediaDrmOnlineAccess'
        'Set-WindowsUpdateSearchDrivers'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
