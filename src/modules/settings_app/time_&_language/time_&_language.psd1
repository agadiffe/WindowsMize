@{
    RootModule        = 'time_&_language.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '51a44ec7-a2db-44c6-ab87-784d49545666'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Remove-LanguageFeatures'
        'Set-DateAndTimeSetting'
        'Set-TypingSetting'
        'Set-LanguageAndRegionSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
