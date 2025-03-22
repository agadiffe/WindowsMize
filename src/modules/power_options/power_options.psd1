@{
    RootModule        = 'power_options.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '51a8376b-286e-4567-a47a-eb4254e0586b'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-AdvancedBatterySetting'
        'Set-FastStartup'
        'Set-HardDiskTimeout'
        'Set-Hibernate'
        'Set-ModernStandbyNetworkConnectivity'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
