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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\network_&_internet"


# Parameters values (if not specified):
#   State: Disabled | Enabled

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
#region advanced settings

Write-Section -Name 'Advanced network settings' -SubSection

#           Ethernet / Wi-Fi
#=======================================

# --- View additional properties > DNS server assignment
# ResetServerAddresses
# FallbackToPlaintext (does not work for Mullvad)
# Provider: Adguard | Cloudflare | Mullvad | Quad9
# Server:
#   Adguard    : Default | Unfiltered | Family
#   Cloudflare : Default | Security | Family
#   Mullvad    : Default | Adblock | Base | Extended | Family | All
#   Quad9      : Default | Unfiltered

#Set-DnsServer -ResetServerAddresses
#Set-DnsServer -Provider 'Cloudflare' -Server 'Default' -FallbackToPlaintext
Set-DnsServer -Provider 'Cloudflare' -Server 'Default'

#       Advanced sharing settings
#=======================================

# --- Private networks: Set up network connected devices automatically (default: Enabled)
Set-NetworkSetting -AutoSetupConnectedDevices 'Disabled'

# --- Network discovery (default\ Private: Enabled | Public: Disabled | Domain: Disabled)
Set-NetworkSharingSetting -Name 'NetworkDiscovery' -NetProfile 'Private' -State 'Disabled'
Set-NetworkSharingSetting -Name 'NetworkDiscovery' -NetProfile 'Public'  -State 'Disabled'
Set-NetworkSharingSetting -Name 'NetworkDiscovery' -NetProfile 'Domain'  -State 'Disabled'

# --- File and Printer Sharing (default: Disabled)
Set-NetworkSharingSetting -Name 'FileAndPrinterSharing' -NetProfile 'Private' -State 'Disabled'
Set-NetworkSharingSetting -Name 'FileAndPrinterSharing' -NetProfile 'Public'  -State 'Disabled'
Set-NetworkSharingSetting -Name 'FileAndPrinterSharing' -NetProfile 'Domain'  -State 'Disabled'

#endregion advanced settings
