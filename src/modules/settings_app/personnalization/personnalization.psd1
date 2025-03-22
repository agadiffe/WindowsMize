@{
    RootModule        = 'personnalization.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'f1c7b8b7-4ed4-425f-b55e-c085983958b3'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-BackgroundSetting'
        'Set-ColorsSetting'
        'Set-DeviceUsageSetting'
        'Set-DynamicLightingSetting'
        'Set-LockScreenSetting'
        'Set-StartSetting'
        'Set-TaskbarSetting'
        'Set-ThemesSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
