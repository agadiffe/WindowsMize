#=================================================================================================================
#                                      Accounts > Sign-In Options - Settings
#=================================================================================================================

class SigninRequiredIfAwayS0orS3Generator : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        $SetValues = (Test-ModernStandbyAvailability) ?
            'Never', 'Always', 'OneMin', 'ThreeMins', 'FiveMins', 'FifteenMins' :
            'Never', 'OnWakesUpFromSleep'

        return $SetValues
    }
}

<#
.SYNTAX
    Set-SigninOptionsSetting
        [-BiometricsGPO {Disabled | NotConfigured}]
        [-SigninWithExternalDevice {Disabled | Enabled}]
        [-OnlyWindowsHelloForMSAccount {Disabled | Enabled}]
        [-SigninRequiredIfAway {Never | OnWakesUpFromSleep}] # Standard Standby (S3)
        [-SigninRequiredIfAway {Never | Always | OneMin | ThreeMins | FiveMins | FifteenMins}] # Modern Standby (S0)
        [-SigninRequiredIfAwayGPO {Disabled | NotConfigured}]
        [-DynamicLock {Disabled | Enabled}]
        [-DynamicLockGPO {Disabled | Enabled | NotConfigured}]
        [-AutoRestartApps {Disabled | Enabled}]
        [-ShowAccountDetails {Disabled | Enabled}]
        [-ShowAccountDetailsGPO {Disabled | NotConfigured}]
        [-AutoFinishSettingUpAfterUpdate {Disabled | Enabled}]
        [-AutoFinishSettingUpAfterUpdateGPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-SigninOptionsSetting
{
    <#
    .EXAMPLE
        PS> Set-SigninOptionsSetting -OnlyWindowsHelloForMSAccount 'Disabled' -SigninRequiredIfAway 'Never'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [GpoStateWithoutEnabled] $BiometricsGPO,
        [state] $SigninWithExternalDevice,
        [state] $OnlyWindowsHelloForMSAccount,

        [ValidateSet([SigninRequiredIfAwayS0orS3Generator])]
        [string] $SigninRequiredIfAway,
        [GpoStateWithoutEnabled] $SigninRequiredIfAwayGPO,

        [state] $DynamicLock,
        [GpoState] $DynamicLockGPO,
        [state] $AutoRestartApps,
        [state] $ShowAccountDetails,
        [GpoStateWithoutEnabled] $ShowAccountDetailsGPO,
        [state] $AutoFinishSettingUpAfterUpdate,
        [GpoState] $AutoFinishSettingUpAfterUpdateGPO
    )

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
            'SigninRequiredIfAway'              { Set-SigninRequiredIfAway -Delay $SigninRequiredIfAway }
            'SigninRequiredIfAwayGPO'           { Set-SigninRequiredIfAway -GPO $SigninRequiredIfAwayGPO }
            'DynamicLock'                       { Set-SigninDynamicLock -State $DynamicLock }
            'DynamicLockGPO'                    { Set-SigninDynamicLock -GPO $DynamicLockGPO }
            'AutoRestartApps'                   { Set-SigninAutoRestartApps -State $AutoRestartApps }
            'ShowAccountDetails'                { Set-SigninShowAccountDetails -State $ShowAccountDetails }
            'ShowAccountDetailsGPO'             { Set-SigninShowAccountDetails -GPO $ShowAccountDetailsGPO }
            'AutoFinishSettingUpAfterUpdate'    { Set-SigninAutoFinishSettingUpAfterUpdate -State $AutoFinishSettingUpAfterUpdate }
            'AutoFinishSettingUpAfterUpdateGPO' { Set-SigninAutoFinishSettingUpAfterUpdate -GPO $AutoFinishSettingUpAfterUpdateGPO }
        }
    }
}
