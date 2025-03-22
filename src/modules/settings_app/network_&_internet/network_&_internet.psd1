@{
    RootModule        = 'network_&_internet.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'fd8d6ce3-40fb-4d70-baee-f64e721572c6'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-DnsServer'
        'Set-NetworkSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
