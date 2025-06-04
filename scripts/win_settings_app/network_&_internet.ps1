#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#==============================================================================
#                                Requirements
#==============================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\..\..\log\win_settings_app_$ScriptFileName.log"


#==============================================================================
#                                   Modules
#==============================================================================

Write-Output -InputObject 'Loading ''Win_settings_app\Network_&_internet'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\network_&_internet"



#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                              Network & internet
#==============================================================================

Write-Section -Name 'Windows Settings App - Network & internet'

#==========================================================
#                     Ethernet / Wi-Fi
#==========================================================
#region ethernet / wi-fi

Write-Section -Name 'Ethernet / Wi-Fi' -SubSection

#              Properties
#=======================================

# Network profile
#---------------------------------------
# Change all currently connected network.
# Public (default) | Private | DomainAuthenticated
Set-NetworkSetting -ConnectedNetworkProfile 'Private'

#endregion ethernet / wi-fi


#==========================================================
#                          Proxy
#==========================================================
#region proxy

Write-Section -Name 'Proxy' -SubSection

# Automatically detect settings
#---------------------------------------
# Disabled | Enabled (default)
Set-NetworkSetting -ProxyAutoDetectSettings 'Enabled'

#endregion proxy


#==========================================================
#                Advanced network settings
#==========================================================
#region advanced network settings

Write-Section -Name 'Advanced network settings' -SubSection

#           Ethernet / Wi-Fi
#=======================================

# View additional properties > DNS server assignment
#---------------------------------------
# ResetServerAddresses
# FallbackToPlaintext (not available for Mullvad)
# Adguard: Default | Unfiltered | Family
# Cloudflare: Default | Security | Family
# Dns0: Default | Zero | Kids
# Mullvad: Default | Adblock | Base | Extended | Family | All
# Quad9: Default | Unfiltered

#Set-DnsServer -ResetServerAddresses
#Set-DnsServer -Cloudflare 'Default' -FallbackToPlaintext
Set-DnsServer -Cloudflare 'Default'

#endregion advanced network settings


Stop-Transcript
