@{
    RootModule        = 'accounts.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '2a323678-2e22-407c-a234-0e814e594589'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-SigninOptionsSetting'
        'Set-YourInfoSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
