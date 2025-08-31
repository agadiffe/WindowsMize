#=================================================================================================================
#                                Telemetry - Nvidia Game Session Telemetry Plugin
#=================================================================================================================

<#
.SYNTAX
    Disable-NvidiaGameSessionTelemetry [<CommonParameters>]
#>

function Disable-NvidiaGameSessionTelemetry
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Disabling ''Nvidia Game Session Telemetry Plugin'' ...'

        $DriverStorePath = "$env:SystemDrive\Windows\System32\DriverStore"
        $NvidiaDisplayPath = "$DriverStorePath\FileRepository\nvdmsi.inf_amd64_*\Display.NvContainer"
        $NvidiaPluginsSessionPath = "$NvidiaDisplayPath\plugins\Session"
        $GameSessionTelemetryPluginName = "_NvGSTPlugin.dll"
        $GSTPluginFilePath = "$NvidiaPluginsSessionPath\$GameSessionTelemetryPluginName"

        if (Test-Path -Path $GSTPluginFilePath)
        {
            Set-FileSystemAdminsFullControl -Action 'Grant' -Path $NvidiaPluginsSessionPath
            Set-FileSystemAdminsFullControl -Action 'Grant' -Path $GSTPluginFilePath
            Rename-Item -Path $GSTPluginFilePath -NewName "$GameSessionTelemetryPluginName.bak"
        }
        else
        {
            Write-Verbose -Message '    ''Nvidia Game Session Telemetry Plugin'' file not found'
        }
    }
}
