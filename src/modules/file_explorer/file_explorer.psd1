@{
    RootModule        = 'file_explorer.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '1690dcc9-861a-4e9f-a3fb-4847ea8b2106'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\helper_functions\classes\State_enums.ps1"
        "$PSScriptRoot\..\helper_functions\classes\RegistrySetting.ps1"
    )

    FunctionsToExport = @(
        'Set-FileExplorerSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
