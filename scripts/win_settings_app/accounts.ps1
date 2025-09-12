#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

$Global:ModuleVerbosePreference = 'Continue' # Do not disable (log file will be empty)

Import-Module -Name "$PSScriptRoot\..\..\src\modules\helper_functions\general"

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$(Get-LogPath -User)\win_settings_app_$ScriptFileName.log"

Write-Output -InputObject 'Loading ''Win_settings_app\Accounts'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\accounts"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.
#   GPO:   Disabled | NotConfigured # GPO's default is always NotConfigured.

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                   Accounts
#==============================================================================

Write-Section -Name 'Windows Settings App - Accounts'

#==========================================================
#                        Your info
#==========================================================
#region your info

Write-Section -Name 'Your info' -SubSection

# --- Account setting
# Enabled: also disable and gray out 'settings > bluetooth & devices > mobile devices'
# GPO: CannotAddMicrosoftAccount | CannotAddOrLogonWithMicrosoftAccount | NotConfigured
Set-YourInfoSetting -BlockMicrosoftAccountsGPO 'NotConfigured'

#endregion your info

#==========================================================
#                     Sign-in options
#==========================================================
#region sign-in options

Write-Section -Name 'Sign-in options' -SubSection

# --- Biometrics
Set-SigninOptionsSetting -BiometricsGPO 'NotConfigured'

# --- Sign in with an external camera or fingerprint reader (default: Enabled)
# Requires compatible hardware and software components to have this option visible.
Set-SigninOptionsSetting -SigninWithExternalDevice 'Enabled'

# --- For improved security, only allow Windows Hello sign-in for Microsoft accounts on this device (default: Disabled)
# Requires a Microsoft account to have this option visible.
Set-SigninOptionsSetting -OnlyWindowsHelloForMSAccount 'Disabled'

# --- If you've been away, when should Windows require you to sign in again
# Only available if your account has a password.
# Standard Standby (S3) : Never | OnWakesUpFromSleep (default)
# Modern Standby (S0)   : Never | Always (default) | OneMin | ThreeMins | FiveMins | FifteenMins
Set-SigninOptionsSetting -SigninRequiredIfAway 'Never'

# --- Dynamic lock : Allow Windows to automatically lock your device when you're away (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-SigninOptionsSetting -DynamicLock 'Disabled' -DynamicLockGPO 'NotConfigured'

# --- Automatically save my restartable apps and restart them when I sign back in (default: Enabled)
Set-SigninOptionsSetting -AutoRestartApps 'Disabled'

# --- Show account details such as my email address on the sign-in screen
Set-SigninOptionsSetting -ShowAccountDetailsGPO 'NotConfigured'

# --- Use my sign-in info to automatically finish setting up after an update (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-SigninOptionsSetting -AutoFinishSettingUpAfterUpdate 'Disabled' -AutoFinishSettingUpAfterUpdateGPO 'NotConfigured'

#endregion sign-in options


Stop-Transcript
