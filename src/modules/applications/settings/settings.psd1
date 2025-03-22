@{
    RootModule        = 'settings.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '513d34bf-6832-4e3e-aeb4-ab0898ed7b9a'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
        "$PSScriptRoot\..\..\applications\management"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-AdobeAcrobatReaderSetting'
        'Set-BraveBrowserSettings'
        'Set-KeePassXCRunAtStartup'
        'Set-MicrosoftEdgePolicy'
        'Set-MicrosoftOfficeSetting'
        'Set-MicrosoftStoreSetting'
        'Set-MyAppsSetting'
        'Set-WindowsNotepadSetting'
        'Set-WindowsPhotosSetting'
        'Set-WindowsSnippingToolSetting'
        'Set-WindowsTerminalSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
