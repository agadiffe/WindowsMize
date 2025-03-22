@{
    RootModule        = 'bluetooth_&_devices.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = 'fc1b8c94-7fdc-46a8-92e0-a99cc803455a'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Set-AutoPlaySetting'
        'Set-BluetoothSetting'
        'Set-DevicesSetting'
        'Set-MobileDevicesSetting'
        'Set-MouseSetting'
        'Set-TouchpadSetting'
        'Set-UsbSetting'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
