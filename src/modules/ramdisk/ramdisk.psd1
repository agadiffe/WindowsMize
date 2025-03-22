@{
    RootModule        = 'ramdisk.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '773c2755-5baf-4e8d-8adb-fa415c15c089'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
        "$PSScriptRoot\..\applications\management"
    )

    NestedModules = @()

    FunctionsToExport = @(
        'Install-OSFMount'
        'Set-RamDisk'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
