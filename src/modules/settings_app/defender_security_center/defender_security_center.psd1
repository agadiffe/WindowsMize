@{
    RootModule        = 'defender_security_center.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '550fa48f-95ad-47dc-8f0c-a05a29f011c0'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-DefenderNotificationsSetting'
        'Set-DefenderSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
