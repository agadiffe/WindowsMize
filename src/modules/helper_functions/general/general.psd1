@{
    RootModule        = 'general.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '2d3e4fef-e986-4fbb-bb5f-c5e76e0e26a4'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\logged_on_user_info"
    )

    NestedModules = @()

    FunctionsToExport = @(
        'Add-DynamicParameter'
        'Get-HashtableSubset'
        'Get-LogPath'
        'New-ParentPath'
        'New-ScheduledTaskScript'
        'Set-ByteBitFlag'
        'Set-FileSystemAdminsFullControl'
        'Set-KeyboardHotkey'
        'Set-RegistryEntry'
        'Start-Logging'
        'Test-NewerWindowsMizeVersion'
        'Test-PowerShellLanguageMode'
        'Write-InsufficientParameterCount'
        'Write-Section'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
