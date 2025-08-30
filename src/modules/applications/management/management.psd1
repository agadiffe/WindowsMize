@{
    RootModule        = 'management.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'b26e3545-9bb1-49b8-bcfd-080fa2ebfd3b'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Export-DefaultAppxPackagesNames'
        'Get-ApplicationInfo'
        'Install-Application'
        'Install-ApplicationWithWinget'
        'Install-WindowsSubsystemForLinux'
        'Remove-AllDesktopShortcuts'
        'Remove-ApplicationPackage'
        'Remove-MicrosoftEdge'
        'Remove-MSMaliciousSoftwareRemovalTool'
        'Remove-OneDrive'
        'Remove-PreinstalledAppPackage'
        'Remove-StartMenuPromotedApps'
        'Set-Copilot'
        'Set-Cortana'
        'Set-MicrosoftStorePushToInstall'
        'Set-OneDriveNewUserAutoInstall'
        'Set-Recall'
        'Set-StartMenuBingSearch'
        'Set-Widgets'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
