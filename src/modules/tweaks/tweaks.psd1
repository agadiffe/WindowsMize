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
        'Move-CharacterMapShortcutToWindowsTools'
        'Set-ActionCenterLayout'
        'Set-CopyPasteDialogShowMoreDetails'
        'Set-EaseOfAccessReadScanSection'
        'Set-EventLogLocation'
        'Set-FileHistory'
        'Set-FirstSigninAnimation'
        'Set-FontProviders'
        'Set-FullscreenOptimizations'
        'Set-HelpTips'
        'Set-HomeGroup'
        'Set-HomeSettingPageVisibility'
        'Set-Hotspot2'
        'Set-LocalAccountsSecurityQuestions'
        'Set-LocationPermission'
        'Set-LocationScriptingPermission'
        'Set-LockScreenCameraAccess'
        'Set-LongPaths'
        'Set-MenuShowDelay'
        'Set-MessagingCloudSync'
        'Set-NotificationsNetworkUsage'
        'Set-NtfsLastAccessTime'
        'Set-NumLockAtStartup'
        'Set-OnlineTips'
        'Set-OpenWithDialogStoreAccess'
        'Set-PasswordExpiration'
        'Set-PasswordRevealButton'
        'Set-PrinterDriversDownloadOverHttp'
        'Set-PrintingOverHttp'
        'Set-SensorsPermission'
        'Set-ServiceHostSplitting'
        'Set-ShareShowDragTrayOnTopScreen'
        'Set-Short8Dot3FileName'
        'Set-ShortcutNameSuffix'
        'Set-StartMenuAllAppsViewMode'
        'Set-StartMenuRecommendedSection'
        'Set-StartupShutdownVerboseStatusMessages'
        'Set-SuggestedContent'
        'Set-TaskbarLastActiveClick'
        'Set-WifiSense'
        'Set-WindowsExperimentation'
        'Set-WindowsHelpSupportSetting'
        'Set-WindowsInputExperience'
        'Set-WindowsMediaDrmOnlineAccess'
        'Set-WindowsPrivacySettingsExperience'
        'Set-WindowsSettingsSearchAgent'
        'Set-WindowsSharedExperience'
        'Set-WindowsSpotlight'
        'Set-WindowsUpdateSearchDrivers'
        'Set-Wpbt'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
