@{
    RootModule        = 'optional_features.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '7c11b638-3172-42d9-8bb4-a6fbaf42023f'
    PowerShellVersion = '7.5'

    RequiredModules = @()

    NestedModules = @()

    FunctionsToExport = @(
        'Export-EnabledWindowsOptionalFeaturesNames'
        'Export-InstalledWindowsCapabilitiesNames'
        'Remove-PreinstalledOptionalFeature'
        'Set-WindowsCapability'
        'Set-WindowsOptionalFeature'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
