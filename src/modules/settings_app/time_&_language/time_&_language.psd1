@{
    RootModule        = 'time_&_language.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '51a44ec7-a2db-44c6-ab87-784d49545666'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
        "$PSScriptRoot\..\..\settings_app\optional_features"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-DateAndTimeSetting'
        'Set-LanguageAndRegionSetting'
        'Set-LanguageFeatures'
        'Set-TypingSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
