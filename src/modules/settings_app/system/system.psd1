@{
    RootModule        = 'system.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '562b9d9e-3124-4955-9c98-c7fec4f60f6a'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-AIComponentsSetting'
        'Set-ClipboardSetting'
        'Set-DisplayBrightnessSetting'
        'Set-DisplayGraphicsSetting'
        'Set-EnergySaverSetting'
        'Set-MultitaskingSetting'
        'Set-NearbySharingSetting'
        'Set-NotificationsSetting'
        'Set-PowerSetting'
        'Set-ProjectingToThisPC'
        'Set-QuickMachineRecovery'
        'Set-RemoteDesktopSetting'
        'Set-SnapWindowsSetting'
        'Set-SoundSetting'
        'Set-StorageSenseSetting'
        'Set-SystemAdvancedSetting'
        'Set-TroubleshooterPreference'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
