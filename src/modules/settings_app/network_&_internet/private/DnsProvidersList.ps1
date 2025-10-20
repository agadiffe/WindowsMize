#=================================================================================================================
#                                               DNS Providers List
#=================================================================================================================

$DnsProvidersList = [ordered]@{
    Adguard = @{
        Default = @{ # Ads, Trackers, Malware
            Doh  = 'https://dns.adguard-dns.com/dns-query'
            IPv4 = '94.140.14.14', '94.140.15.15'
            IPv6 = '2a10:50c0::ad1:ff', '2a10:50c0::ad2:ff'
        }
        Unfiltered = @{
            Doh  = 'https://unfiltered.adguard-dns.com/dns-query'
            IPv4 = '94.140.14.140', '94.140.14.141'
            IPv6 = '2a10:50c0::1:ff', '2a10:50c0::2:ff'
        }
        Family = @{ # Ads, Trackers, Malware, Adult
            Doh  = 'https://family.adguard-dns.com/dns-query'
            IPv4 = '94.140.14.15', '94.140.15.16'
            IPv6 = '2a10:50c0::bad1:ff', '2a10:50c0::bad2:ff'
        }
    }
    Cloudflare = @{
        Default = @{ # Unfiltered
            Doh  = 'https://cloudflare-dns.com/dns-query'
            IPv4 = '1.1.1.1', '1.0.0.1'
            IPv6 = '2606:4700:4700::1111', '2606:4700:4700::1001'
        }
        Security = @{ # Malware
            Doh  = 'https://security.cloudflare-dns.com/dns-query'
            IPv4 = '1.1.1.2', '1.0.0.2'
            IPv6 = '2606:4700:4700::1112', '2606:4700:4700::1002'
        }
        Family = @{ # Malware, Adult
            Doh  = 'https://family.cloudflare-dns.com/dns-query'
            IPv4 = '1.1.1.3', '1.0.0.3'
            IPv6 = '2606:4700:4700::1113', '2606:4700:4700::1003'
        }
    }
    Mullvad = @{ # does not support unencrypted DNS
        Default = @{ # Unfiltered
            Doh  = 'https://dns.mullvad.net/dns-query'
            IPv4 = '194.242.2.2'
            IPv6 = '2a07:e340::2'
        }
        Adblock = @{ # Ads, Trackers
            Doh  = 'https://adblock.dns.mullvad.net/dns-query'
            IPv4 = '194.242.2.3'
            IPv6 = '2a07:e340::3'
        }
        Base = @{ # Ads, Trackers, Malware
            Doh  = 'https://base.dns.mullvad.net/dns-query'
            IPv4 = '194.242.2.4'
            IPv6 = '2a07:e340::4'
        }
        Extended = @{ # Ads, Trackers, Malware, Social media
            Doh  = 'https://extended.dns.mullvad.net/dns-query'
            IPv4 = '194.242.2.5'
            IPv6 = '2a07:e340::5'
        }
        Family = @{ # Ads, Trackers, Malware, Adult, Gambling
            Doh  = 'https://family.dns.mullvad.net/dns-query'
            IPv4 = '194.242.2.6'
            IPv6 = '2a07:e340::6'
        }
        All = @{ # Ads, Trackers, Malware, Adult, Gambling, Social media
            Doh  = 'https://all.dns.mullvad.net/dns-query'
            IPv4 = '194.242.2.9'
            IPv6 = '2a07:e340::9'
        }
    }
    Quad9 = @{
        Default = @{ # Malware
            Doh  = 'https://dns.quad9.net/dns-query'
            IPv4 = '9.9.9.9', '149.112.112.112'
            IPv6 = '2620:fe::fe', '2620:fe::9'
        }
        Unfiltered = @{
            Doh  = 'https://dns10.quad9.net/dns-query'
            IPv4 = '9.9.9.10', '149.112.112.10'
            IPv6 = '2620:fe::10', '2620:fe::fe:10'
        }
    }
}
