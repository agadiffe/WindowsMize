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

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\..\..\log\win_settings_app_$ScriptFileName.log"

$Global:ModuleVerbosePreference = 'Continue' # Do not disable (log file will be empty)

Write-Output -InputObject 'Loading ''Win_settings_app\Network_&_internet'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\network_&_internet"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.

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

# --- Network profile
# Change all currently connected network.
# State: Public (default) | Private | DomainAuthenticated
Set-NetworkSetting -ConnectedNetworkProfile 'Private'

#endregion ethernet / wi-fi

#==========================================================
#                           VPN
#==========================================================
#region vpn

Write-Section -Name 'VPN' -SubSection

# --- Allow VPN over metered networks (default: Enabled)
Set-NetworkSetting -VpnOverMeteredNetworks 'Enabled'

# --- Allow VPN while roaming (default: Enabled)
Set-NetworkSetting -VpnWhileRoaming 'Enabled'

#endregion vpn

#==========================================================
#                          Proxy
#==========================================================
#region proxy

Write-Section -Name 'Proxy' -SubSection

# --- Automatically detect settings (default: Enabled)
Set-NetworkSetting -ProxyAutoDetectSettings 'Disabled'

#endregion proxy

#==========================================================
#                Advanced network settings
#==========================================================
#region advanced network settings

Write-Section -Name 'Advanced network settings' -SubSection

#           Ethernet / Wi-Fi
#=======================================

# --- View additional properties > DNS server assignment
# ResetServerAddresses
# FallbackToPlaintext (does not work for Mullvad)
# Provider: Adguard | Cloudflare | Dns0 | Mullvad | Quad9
# Server:
#   Adguard    : Default | Unfiltered | Family
#   Cloudflare : Default | Security | Family
#   Dns0       : Default | Zero | Kids
#   Mullvad    : Default | Adblock | Base | Extended | Family | All
#   Quad9      : Default | Unfiltered

#Set-DnsServer -ResetServerAddresses
#Set-DnsServer -Provider 'Cloudflare' -Server 'Default' -FallbackToPlaintext
Set-DnsServer -Provider 'Cloudflare' -Server 'Default'

#endregion advanced network settings


Stop-Transcript
