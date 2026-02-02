@{
    RootModule        = 'services.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '43860a5e-bf0f-42ab-b086-b7f0356cced3'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @()

    FunctionsToExport = @(
        'Export-DefaultServicesStartupType'
        'Export-DefaultSystemDriversStartupType'
        'Get-ServiceNotHandledInModule'
        'Restore-ServiceStartupTypeFromBackup'
        'Set-ServiceStartupType'
        'Set-ServiceStartupTypeGroup'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
