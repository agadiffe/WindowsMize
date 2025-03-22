@{
    RootModule        = 'privacy_&_security.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '45be6f05-a530-4346-bcee-5b72a4ebf98a'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
        "$PSScriptRoot\..\..\helper_functions\classes\RegistrySetting.ps1"
    )

    FunctionsToExport = @(
        'Set-AppPermissionsSetting'
        'Set-WinPermissionsSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
