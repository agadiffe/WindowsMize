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
                $AccessRuleParam = @{
                    Sid        = 'S-1-5-32-544' # 'BUILTIN\Administrators'
                    Permission = 'Allow'
                    Access     = 'FullControl'
                }

                Set-FileSystemAccessRule -Path $NvidiaPluginsSessionPath @AccessRuleParam
                Set-FileSystemAccessRule -Path $GSTPluginFilePath @AccessRuleParam
                Remove-Item -Path "$GSTPluginFilePath.bak" -ErrorAction 'SilentlyContinue'
                Rename-Item -Path $GSTPluginFilePath -NewName "$GameSessionTelemetryPluginName.bak"
                Set-FileSystemAccessRule -Path $NvidiaPluginsSessionPath -Sid $AccessRuleParam.Sid -RemoveAll

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
