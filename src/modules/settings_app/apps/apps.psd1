@{
    RootModule        = 'apps.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '89657aa1-33fd-4109-a961-be3c43917ef7'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-GeneralAppsSetting'
        'Set-OfflineMapsSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
