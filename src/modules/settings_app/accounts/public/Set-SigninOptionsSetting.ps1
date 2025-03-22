#=================================================================================================================
#                                      Accounts > Sign-In Options - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-SigninOptionsSetting
        [-BiometricsGPO {Disabled | NotConfigured}]
        [-SigninWithExternalDevice {Disabled | Enabled}]
        [-OnlyWindowsHelloForMSAccount {Disabled | Enabled}]
        [-SigninRequiredIfAway {Never | OnWakesUpFromSleep}] # Standard Standby (S3)
        [-SigninRequiredIfAway {Never | Always | OneMin | ThreeMins | FiveMins | FifteenMins}] # Modern Standby (S0)
        [-DynamicLock {Disabled | Enabled}]
        [-DynamicLockGPO {Disabled | Enabled | NotConfigured}]
        [-AutoRestartApps {Disabled | Enabled}]
        [-ShowAccountDetailsGPO {Disabled | NotConfigured}]
        [-AutoFinishSettingUpAfterUpdate {Disabled | Enabled}]
        [-AutoFinishSettingUpAfterUpdateGPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-SigninOptionsSetting
{
    <#
    .DESCRIPTION
        Dynamic parameters: The syntax depends on the Standby mode that the computer use.
            Standard Standby (S3):
                [-RequiredIfAway {Never | OnWakesUpFromSleep}]

            Modern Standby (S0):
                [-RequiredIfAway {Never | Always | OneMin | ThreeMins | FiveMins | FifteenMins}]

    .EXAMPLE
        PS> Set-SigninOptionsSetting -OnlyWindowsHelloForMSAccount 'Disabled' -SigninRequiredIfAway 'Never'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [GpoStateWithoutEnabled] $BiometricsGPO,

        [state] $SigninWithExternalDevice,

        [state] $OnlyWindowsHelloForMSAccount,

        [state] $DynamicLock,

        [GpoState] $DynamicLockGPO,

        [state] $AutoRestartApps,

        [GpoStateWithoutEnabled] $ShowAccountDetailsGPO,

        [state] $AutoFinishSettingUpAfterUpdate,

        [GpoState] $AutoFinishSettingUpAfterUpdateGPO
    )

    dynamicparam
    {
        $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $DynamicParamProperties = @{
            Dictionary = $ParamDictionary
            Name       = 'SigninRequiredIfAway'
            Type       = $null
        }

        if (Test-ModernStandbyAvailability)
        {
            $DynamicParamProperties.Type = [SigninRequiredS0]
        }
        else
        {
            $DynamicParamProperties.Type = [SigninRequiredS3]
        }

        Add-DynamicParameter @DynamicParamProperties
        $ParamDictionary
    }

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'BiometricsGPO'                     { Set-SigninBiometrics -GPO $BiometricsGPO }
            'SigninWithExternalDevice'          { Set-SigninWithExternalDevice -State $SigninWithExternalDevice }
            'OnlyWindowsHelloForMSAccount'      { Set-SigninOnlyWindowsHelloForMSAccount -State $OnlyWindowsHelloForMSAccount }
            'SigninRequiredIfAway'              { Set-SigninRequiredIfAway -Value $PSBoundParameters.SigninRequiredIfAway }
            'DynamicLock'                       { Set-SigninDynamicLock -State $DynamicLock }
            'DynamicLockGPO'                    { Set-SigninDynamicLock -GPO $DynamicLockGPO }
            'AutoRestartApps'                   { Set-SigninAutoRestartApps -State $AutoRestartApps }
            'ShowAccountDetailsGPO'             { Set-SigninShowAccountDetails -GPO $ShowAccountDetailsGPO }
            'AutoFinishSettingUpAfterUpdate'    { Set-SigninAutoFinishSettingUpAfterUpdate -State $AutoFinishSettingUpAfterUpdate }
            'AutoFinishSettingUpAfterUpdateGPO' { Set-SigninAutoFinishSettingUpAfterUpdate -GPO $AutoFinishSettingUpAfterUpdateGPO }
        }
    }
}
