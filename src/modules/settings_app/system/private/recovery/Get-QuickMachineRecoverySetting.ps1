#=================================================================================================================
#                                       Get Quick Machine Recovery Setting
#=================================================================================================================

<#
.SYNTAX
    Get-QuickMachineRecoverySetting [<CommonParameters>]
#>

function Get-QuickMachineRecoverySetting
{
    [CmdletBinding()]
    param ()

    process
    {
        # "$CurrentSetting = reagentc.exe /getrecoverysettings" produce "REAGENTC.EXE: Operation failed: 57"
        $CurrentSettingFilePath = "$env:TEMP\reagentc_getrecoverysettings.txt"
        $StartProcessParameter = @{
            Wait         = $true
            NoNewWindow  = $true
            FilePath     = 'reagentc.exe'
            ArgumentList = '/getrecoverysettings'
            RedirectStandardOutput = $CurrentSettingFilePath
        }
        Start-Process @StartProcessParameter
        $CurrentSettingContent = Get-Content -Raw -Path $CurrentSettingFilePath
        Remove-Item -Path $CurrentSettingFilePath

        $CurrentSetting = @{}
        switch -Regex ($CurrentSettingContent)
        {
            'Wifi ssid="(.+)" password="(.+)"'
            {
                $CurrentSetting += @{
                    WifiSsid     = $Matches[1]
                    WifiPassword = $Matches[2]
                }
            }
            'CloudRemediation state="(\d)"'
            {
                $CurrentSetting.CloudRemediation = $Matches[1]
            }
            'AutoRemediation state="(\d)" totalwaittime="(\d+)" waitinterval="(\d+)"'
            {
                $CurrentSetting += @{
                    AutoRemediation = $Matches[1]
                    RestartInterval = $Matches[2]
                    RetryInterval   = $Matches[3]
                }
            }
            'Headless state="(\d)"'
            {
                $CurrentSetting.Headless = $Matches[1]
            }
        }
        $CurrentSetting
    }
}
