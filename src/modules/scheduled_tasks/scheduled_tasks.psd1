@{
    RootModule        = 'scheduled_tasks.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '76a0e508-26c9-46a1-966c-e08a8d73615c'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @()

    FunctionsToExport = @(
        'Export-DefaultScheduledTasksState'
        'Set-ScheduledTaskState'
        'Set-ScheduledTaskStateGroup'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
