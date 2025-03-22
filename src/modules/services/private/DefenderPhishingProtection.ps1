#=================================================================================================================
#                                         Services - Phishing Protection
#=================================================================================================================

$ServicesList += @{
    DefenderPhishingProtection = @(
        @{
            DisplayName = 'Web Threat Defense Service'
            ServiceName = 'webthreatdefsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Web Threat Defense User Service'
            ServiceName = 'webthreatdefusersvc'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
    )
}
