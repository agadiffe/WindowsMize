@{
    RootModule        = 'system_properties.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'a6b3e06a-2018-4c42-ac68-49e3d1147404'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-DataExecutionPrevention'
        'Set-ManufacturerAppsAutoDownload'
        'Set-PagingFileSize'
        'Set-RemoteAssistance'
        'Set-SystemFailureSetting'
        'Set-SystemRestore'
        'Set-VisualEffects'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
