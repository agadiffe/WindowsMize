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

        $NvidiaInfPathName = 'nvdmsi', 'nvdmi'
        foreach ($PathName in $NvidiaInfPathName)
        {
            $DriverStorePath = "$env:SystemDrive\Windows\System32\DriverStore"
            $NvidiaDisplayPath = "$DriverStorePath\FileRepository\$PathName.inf_amd64_*\Display.NvContainer"
            $NvidiaPluginsSessionPath = "$NvidiaDisplayPath\plugins\Session"
            $GameSessionTelemetryPluginName = "_NvGSTPlugin.dll"
            $GSTPluginFilePath = "$NvidiaPluginsSessionPath\$GameSessionTelemetryPluginName"

            if (Test-Path -Path $GSTPluginFilePath)
            {
                Set-FileSystemAdminsFullControl -Action 'Grant' -Path $NvidiaPluginsSessionPath
                Set-FileSystemAdminsFullControl -Action 'Grant' -Path $GSTPluginFilePath
                Rename-Item -Path $GSTPluginFilePath -NewName "$GameSessionTelemetryPluginName.bak"

                Write-Verbose -Message "    '$GSTPluginFilePath' disabled"
            }
            elseif (Test-Path -Path "$GSTPluginFilePath.bak")
            {
                Write-Verbose -Message "    already disabled: '$GSTPluginFilePath'"
            }
            else
            {
                Write-Verbose -Message "    file not found: '$GSTPluginFilePath'"
            }
        }
    }
}
