@{
    RootModule        = 'accessibility.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'e879c768-35e2-4ad5-9f49-d3754830607e'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
        "$PSScriptRoot\..\..\system_properties"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-AccessibilitySetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
