#=================================================================================================================
#                                   System > Recovery > Quick Machine Recovery
#=================================================================================================================

# The settings are stored in "C:\Windows\System32\Recovery\SrSettings.ini" and "\Recovery\WindowsRE\SrSettings.ini".
# Do not edit these files to configure the QMR settings, use "reagentc.exe".

<#
.SYNTAX
    Set-QuickMachineRecovery
        [-State] {Disabled | Enabled}
        [-WifiSsid <string>]
        [-WifiPassword <string>]
        [-ResetWifiCredential]
        [-AutoRemediation {Disabled | Enabled}]
        [-RetryInterval <int>]
        [-RestartInterval <int>]
        [-Headless {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-QuickMachineRecovery
{
    <#
    .DESCRIPTION
        Disabling Quick Machine Recovery will disable AutoRemediation.
        'ResetWifiCredential' parameter takes precendence over 'WifiSsid/WifiPassword' parameters.

        Dynamic parameters:
            available when 'State' is defined to 'Enabled':
                [-AutoRemediation {Disabled | Enabled}]
                [-RetryInterval <int>]
                [-RestartInterval <int>]
            
            available when 'WifiSsid' is defined:
                [-WifiPassword <string>]

        RetryInterval & RestartInterval applies to AutoRemediation.

    .EXAMPLE
        PS> Set-QuickMachineRecovery -State 'Disabled'

    .EXAMPLE
        PS> Set-QuickMachineRecovery -State 'Enabled' -AutoRemediation 'Enabled' -RetryInterval 30 -RestartInterval 180
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [state] $State,

        [ValidateNotNullOrWhiteSpace()]
        [string] $WifiSsid,

        [state] $Headless,

        [switch] $ResetWifiCredential
    )

    dynamicparam
    {
        if ($State -eq 'Enabled' -or $WifiSsid)
        {
            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

            if ($State -eq 'Enabled')
            {
                $DynamicParamProperties = @(
                    [PSCustomObject]@{
                        Name = 'AutoRemediation'
                        Type = [state]
                    }
                    [PSCustomObject]@{
                        Name      = 'RetryInterval'
                        Type      = [int]
                        Attribute = @{ ValidateRange = 0, 720 }
                    }
                    [PSCustomObject]@{
                        Name      = 'RestartInterval'
                        Type      = [int]
                        Attribute = @{ ValidateRange = 0, 4320 }
                    }
                )
                $DynamicParamProperties | Add-DynamicParameter -Dictionary $ParamDictionary
            }

            if ($WifiSsid)
            {
                $DynamicParamProperties = @{
                    Dictionary = $ParamDictionary
                    Name       = 'WifiPassword'
                    Type       = [string]
                    Attribute  = @{ Parameter = @{ Mandatory = $true }; ValidateNotNullOrWhiteSpace = $true }
                }
                Add-DynamicParameter @DynamicParamProperties
            }

            $ParamDictionary
        }
    }

    process
    {
        # State (QuickMachineRecovery)\ on: 1 (default on Home) | off: 0 (default on Pro/Enterprise)
        # AutoRemediation (Automatically check for solutions)\ on: 1 | off: 0 (default)
        # RetryInterval (Look for solutions)\ value are in minutes, default: 0
        #   GUI values: Once (0) | 10 mins | 30 mins | 1 hour (60) | 2 hours (120) | 3 hours (180) | 6 hours (360) | 12 hours (720)
        # RestartInterval (Restart every) (no GUI toggle)\ value are in minutes, default: 180
        #   (old) GUI values: 12 hours (720) | 24 hours (1440) | 36 hours (2160) | 48 hours (2880) | 60 hours (3600) | 72 hours (4320)
        # Headless (no GUI toggle)\ on: 1 | off: 0 (default)

        $QmrSetting = Get-QuickMachineRecoverySetting
        $QmrSetting.CloudRemediation = $State -eq 'Enabled' ? '1' : '0'

        switch ($true)
        {
            { $State -eq 'Disabled' }
            {
                $QmrSetting.AutoRemediation = '0'
            }
            { $PSBoundParameters.ContainsKey('Headless') }
            {
                $QmrSetting.Headless = $Headless -eq 'Enabled' ? '1' : '0'
            }
            { $WifiSsid }
            {
                $QmrSetting.WifiSsid = $WifiSsid
                $QmrSetting.WifiPassword = $PSBoundParameters.WifiPassword
            }
            { $PSBoundParameters.ContainsKey('AutoRemediation') }
            {
                $QmrSetting.AutoRemediation = $PSBoundParameters.AutoRemediation -eq 'Enabled' ? '1' : '0'
            }
            { $PSBoundParameters.ContainsKey('RetryInterval') }
            {
                $QmrSetting.RetryInterval = $PSBoundParameters.RetryInterval
            }
            { $PSBoundParameters.ContainsKey('RestartInterval') }
            {
                $QmrSetting.RestartInterval = $PSBoundParameters.RestartInterval
            }
        }

        if (-not $ResetWifiCredential -and $QmrSetting.WifiSsid)
        {
            $WifiCredential = "<Wifi ssid=""$($QmrSetting.WifiSsid)"" password=""$($QmrSetting.WifiPassword)""/>"
        }

        $SettingContent = @"
            <?xml version='1.0' encoding='utf-8'?>

            <WindowsRE>
                <WifiCredential>
                    $WifiCredential
                </WifiCredential>
                <CloudRemediation state="$($QmrSetting.CloudRemediation)"/>
                <AutoRemediation state="$($QmrSetting.AutoRemediation)" totalwaittime="$($QmrSetting.RestartInterval)" waitinterval="$($QmrSetting.RetryInterval)"/>
                <Headless state="$($QmrSetting.Headless)"/>"
            </WindowsRE>
"@

        $SettingFilePath = "$env:TEMP\QMR_settings.xml"
        New-Item -Path $SettingFilePath -Value $SettingContent -Force | Out-Null

        Write-Verbose -Message "Setting 'Recovery - Quick Machine Recovery' to '$State' ..."
        $AutoRemediationMsg = $QmrSetting.AutoRemediation -eq '1' ? 'Enabled' : 'Disabled'
        Write-Verbose -Message "Setting 'Recovery QMR - Automatically check for solutions' to '$AutoRemediationMsg' ..."

        if ($QmrSetting.AutoRemediation -eq '1')
        {
            $RetryIntervalMsg = $QmrSetting.RetryInterval -ne '0' ? "Every $($QmrSetting.RetryInterval) mins" : 'Once'
            Write-Verbose -Message "    Set 'Look for solutions' to '$RetryIntervalMsg'"
            Write-Verbose -Message "    Set 'Restart every' to '$($QmrSetting.RestartInterval) mins' (if RetryInterval != Once)"
        }

        if ($ResetWifiCredential)
        {
            Write-Verbose -Message 'Resetting ''Recovery QMR - WifiSsid & WifiPassword'' ...'
        }

        if ($WifiCredential)
        {
            Write-Verbose -Message "Setting 'Recovery QMR - WifiSsid' to '$($QmrSetting.WifiSsid)' ..."
        }

        reagentc.exe /SetRecoverySettings /Path $SettingFilePath 2>&1 | Out-Null
        if ($Global:LASTEXITCODE -ne 0)
        {
            Write-Error -Message 'Setting ''Recovery - Quick Machine Recovery'': An error has occurred.'
        }
        Remove-Item -Path $SettingFilePath
    }
}
