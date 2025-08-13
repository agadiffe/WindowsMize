#=================================================================================================================
#                                   System > Recovery > Quick Machine Recovery
#=================================================================================================================

# The settings are stored in "C:\Windows\System32\Recovery\SrSettings.ini" and "\Recovery\WindowsRE\SrSettings.ini".
# Do not edit these files to configure the QMR settings, use "reagentc.exe".

<#
  "reagentc.exe /setrecoverysettings /path .\qrm.xml"
  "reagentc.exe /getrecoverysettings" shows empty wifi ssid and password ...
  bug ?

  <WifiCredential>
    <Wifi ssid="" password=""/>
  </WifiCredential>
#>

<#
.SYNTAX
    Set-QuickMachineRecovery
        [[-State] {Disabled | Enabled}]
        [-WifiSsid <string>]
        [-WifiPassword <string>]
        [-AutoRemediation {Disabled | Enabled}]
        [-RetryInterval {10min | 30min | 1hour | 2hours | 3hours | 6hours | 12hours}]
        [-RestartInterval {12hours | 24hours | 36hours | 48hours | 60hours | 72hours}]
        [-Headless {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-QuickMachineRecovery
{
    <#
    .DESCRIPTION
        Disabling Quick Machine Recovery will disable AutoRemediation.

        Dynamic parameters:
            available when 'State' is defined to 'Enabled':
                [-AutoRemediation {Disabled | Enabled}]
                [-RetryInterval {10min | 30min | 1hour | 2hours | 3hours | 6hours | 12hours}]
                [-RestartInterval {12hours | 24hours | 36hours | 48hours | 60hours | 72hours}]
            
            available when 'WifiSsid' is defined:
                [-WifiPassword <string>]

        RetryInterval & RestartInterval applies to AutoRemediation.

    .EXAMPLE
        PS> Set-QuickMachineRecovery -State 'Disabled'

    .EXAMPLE
        PS> Set-QuickMachineRecovery -State 'Enabled' -AutoRemediation 'Enabled' -RetryInterval '30min' -RestartInterval '72hours'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [state] $State,

        [ValidateNotNullOrWhiteSpace()]
        [string] $WifiSsid,

        [state] $Headless
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
                        Dictionary = $ParamDictionary
                        Name       = 'AutoRemediation'
                        Type       = [state]
                    }
                    [PSCustomObject]@{
                        Dictionary = $ParamDictionary
                        Name       = 'RetryInterval'
                        Type       = [string]
                        Attribute  = @{ ValidateSet = '10min', '30min', '1hour', '2hours', '3hours', '6hours', '12hours' }
                    }
                    [PSCustomObject]@{
                        Dictionary = $ParamDictionary
                        Name       = 'RestartInterval'
                        Type       = [string]
                        Attribute  = @{ ValidateSet = '12hours', '24hours', '36hours', '48hours', '60hours', '72hours' }
                    }
                )
                $DynamicParamProperties | Add-DynamicParameter
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
        # State\ on: 1 (default on Home) | off: 0 (default on Pro/Enterprise)
        # AutoRemediation\ on: 1 | off: 0 (default)
        # RetryInterval\ 10min | 30min (default) | 1hour | 2hours | 3hours | 6hours | 12hours
        # RestartInterval\ 12hours | 24hours | 36hours | 48hours | 60hours | 72hours (default)
        # Headless\ on: 1 | off: 0 (default)

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
                $QmrSetting.Headless = $Headless
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
                $QmrSetting.RetryInterval = switch ($PSBoundParameters.RetryInterval)
                {
                    '10min'   { '10' }
                    '30min'   { '30' }
                    '1hour'   { '60' }
                    '2hours'  { '120' }
                    '3hours'  { '180' }
                    '6hours'  { '360' }
                    '12hours' { '720' }
                }
            }
            { $PSBoundParameters.ContainsKey('RestartInterval') }
            {
                $QmrSetting.RestartInterval = switch ($PSBoundParameters.RestartInterval)
                {
                    '12hours' { '720' }
                    '24hours' { '1440' }
                    '36hours' { '2160' }
                    '48hours' { '2880' }
                    '60hours' { '3600' }
                    '72hours' { '4320' }
                }
            }
        }

        $SettingContent = @"
            <?xml version='1.0' encoding='utf-8'?>

            <WindowsRE>
                <WifiCredential>
                    $($QmrSetting.WifiSsid ? "<Wifi ssid=""$($QmrSetting.WifiSsid)"" password=""$($QmrSetting.WifiPassword)""/>" : '')
                </WifiCredential>
                <CloudRemediation state="$($QmrSetting.CloudRemediation)"/>
                <AutoRemediation state="$($QmrSetting.AutoRemediation)" totalwaittime="$($QmrSetting.RestartInterval)" waitinterval="$($QmrSetting.RetryInterval)"/>
                $($QmrSetting.Headless ? "<Headless state=""$($QmrSetting.Headless)""/>" : '')
            </WindowsRE>
"@

        $SettingFilePath = "$env:TEMP\QMR_settings.xml"
        New-Item -Path $SettingFilePath -Value $SettingContent -Force | Out-Null

        Write-Verbose -Message "Setting 'Recovery - Quick Machine Recovery' to '$State' ..."
        Write-Verbose -Message "Setting 'Recovery - Continue searching if a solution isn't found' to '$($PSBoundParameters.AutoRemediation)' ..."
        if ($PSBoundParameters.AutoRemediation -eq 'Enabled')
        {
            Write-Verbose -Message "                    Look for solutions every '$($PSBoundParameters.RetryInterval)' / Restart every '$($PSBoundParameters.RestartInterval)'"
        }

        $Result = reagentc.exe /SetRecoverySettings /Path $SettingFilePath 2>&1
        Remove-Item -Path $SettingFilePath

        if ($Result -match 'An error has occurred')
        {
            Write-Error -Message 'Setting ''Recovery - Quick Machine Recovery'': An error has occurred.'
        }
    }
}
