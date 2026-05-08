#=================================================================================================================
#       Accounts > Sign-In Options > If You've Been Away, When Should Windows Require You To Sign In Again
#=================================================================================================================

# Only available if your account has a password.

<#
.SYNTAX
    Test-ModernStandbyAvailability [<CommonParameters>]
#>

function Test-ModernStandbyAvailability
{
    [CmdletBinding()]
    param ()

    process
    {
        $PowercfgOutput = powercfg.exe /a
        $AvailableStates = $PowercfgOutput |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Select-Object -First $PowercfgOutput.IndexOf("")
        $S0Enabled = $AvailableStates | Select-String -Pattern 'S0' -Quiet
        $S0Enabled
    }
}


<#
.SYNTAX for Standard Standby (S3)
    Set-SigninRequiredIfAway
        [-Delay] {Never | OnWakesUpFromSleep}
        [<CommonParameters>]

.SYNTAX for Modern Standby (S0)
    Set-SigninRequiredIfAway
        [-Delay] {Never | Always | OneMin | ThreeMins | FiveMins | FifteenMins}
        [<CommonParameters>]
#>

function Set-SigninRequiredIfAway
{
    <#
    .DESCRIPTION
        Dynamic parameters: The syntax depends on the Standby mode that the computer use.
            Standard Standby (S3):
                [-Delay] {Never | OnWakesUpFromSleep}

            Modern Standby (S0):
                [-Delay] {Never | Always | OneMin | ThreeMins | FiveMins | FifteenMins}

    .EXAMPLE
        PS> Set-SigninRequiredIfAway -Delay 'Never'
    #>

    [CmdletBinding()]
    param ()

    dynamicparam
    {
        $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $DynamicParamProperties = @{
            Dictionary = $ParamDictionary
            Name       = 'Delay'
            Type       = $null
            Attribute  = @{ Parameter = @{ Mandatory = $true; Position = 0 } }
        }

        if (Test-ModernStandbyAvailability)
        {
            $DynamicParamProperties['Type'] = [SigninRequiredS0]
        }
        else
        {
            $DynamicParamProperties['Type'] = [SigninRequiredS3]
        }

        Add-DynamicParameter @DynamicParamProperties
        $ParamDictionary
    }

    process
    {
        $SigninRequiredIfAwayMsg = 'Sign-In Options - When Should Windows Require You To Sign In Again'
        $Delay = $PSBoundParameters['Delay']

        if (Test-ModernStandbyAvailability)
        {
            $SettingValue = switch ($Delay)
            {
                'Never'       { [uint]::MaxValue }
                'Always'      { 0 }
                'OneMin'      { 60 }
                'ThreeMins'   { 180 }
                'FiveMins'    { 300 }
                'FifteenMins' { 900 }
            }

            # never: 4294967295 (UINT_MAX) | every time: 0 (default)
            # 1 minute: 60 | 3 minutes: 180 | 5 minutes: 300 | 15 minutes: 900
            $SigninRequiredIfAway = @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Control Panel\Desktop'
                Entries = @(
                    @{
                        Name  = 'DelayLockInterval'
                        Value = $SettingValue
                        Type  = 'DWord'
                    }
                )
            }

            Write-Verbose -Message "Setting '$SigninRequiredIfAwayMsg' to '$Delay' ..."
            Set-RegistryEntry -InputObject $SigninRequiredIfAway
        }
        else
        {
            # never: 0 | when PC wakes up from sleep: 1 (default)
            Write-Verbose -Message "Setting '$SigninRequiredIfAwayMsg' to '$Delay' ..."

            $SettingIndex = $Delay -eq 'Never' ? 0 : 1

            powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_NONE CONSOLELOCK $SettingIndex
            powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_NONE CONSOLELOCK $SettingIndex
        }
    }
}
