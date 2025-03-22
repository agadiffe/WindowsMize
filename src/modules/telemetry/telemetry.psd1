@{
    RootModule        = 'telemetry.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '5f653e6d-6867-402b-89b8-d487a5b4b049'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Disable-DotNetTelemetry'
        'Disable-NvidiaTelemetry'
        'Disable-PowerShellTelemetry'
        'Set-AppAndDeviceInventory'
        'Set-ApplicationCompatibility'
        'Set-Ceip'
        'Set-CloudContent'
        'Set-ConsumerExperience'
        'Set-DiagnosticLogAndDumpCollectionLimit'
        'Set-DiagnosticsAutoLogger'
        'Set-ErrorReporting'
        'Set-GroupPolicySettingsLogging'
        'Set-HandwritingPersonalization'
        'Set-InventoryCollector'
        'Set-KmsClientActivationDataSharing'
        'Set-MsrtDiagnosticReport'
        'Set-OneSettingsDownloads'
        'Set-UserInfoSharing'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
