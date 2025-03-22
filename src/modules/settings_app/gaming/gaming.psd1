@{
    RootModule        = 'gaming.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '48f6376a-49dc-432f-be8d-bd76e9e77793'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-GamingSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
