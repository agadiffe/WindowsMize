@{
    RootModule        = 'windows_update.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'a3cd2b95-0da2-4003-9675-c3b2373f5893'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-WinUpdateSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
