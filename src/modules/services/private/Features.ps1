#=================================================================================================================
#                                        Services - Miscellaneous Features
#=================================================================================================================

$ServicesList += @{
    Features = @(
        @{
            DisplayName = 'BitLocker Drive Encryption Service'
            ServiceName = 'BDESVC'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Clipboard User Service'
            ServiceName = 'cbdhsvc'
            StartupType = 'Disabled'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'clipboard multiple items (win + v).
                           settings > system > clipboard.'
        }
        @{
            DisplayName = 'Downloaded Maps Manager'
            ServiceName = 'MapsBroker'
            StartupType = 'Disabled'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'windows/bing maps.
                           settings > apps > offline maps.'
        }
        @{
            DisplayName = 'GameDVR and Broadcast User Service'
            ServiceName = 'BcastDVRUserService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'game recording.
                           settings > gaming > captures.'
        }
        @{
            DisplayName = 'Geolocation Service'
            ServiceName = 'lfsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'settings > privacy & security > location.'
        }
        @{
            DisplayName = 'Microsoft Passport'
            ServiceName = 'NgcSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           needed by Windows Hello.
                           settings > accounts > sign-in options.
                           process isolation for cryptographic keys.'
        }
        @{
            DisplayName = 'Microsoft Passport Container'
            ServiceName = 'NgcCtnrSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           needed by Windows Hello.
                           settings > accounts > sign-in options.
                           manages local user identity keys.'
        }
        @{
            DisplayName = 'Now Playing Session Manager Service'
            ServiceName = 'NPSMSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'show the now playing media on the action center.'
        }
        @{
            DisplayName = 'Parental Controls'
            ServiceName = 'WpcMonSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'PenService'
            ServiceName = 'PenService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Phone Service'
            ServiceName = 'PhoneSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Phone Link and VoIP.'
        }
        @{
            DisplayName = 'Radio Management Service'
            ServiceName = 'RmSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'airplane mode.'
        }
        @{
            DisplayName = 'Windows Biometric Service'
            ServiceName = 'WbioSrvc'
            StartupType = 'Manual'
            DefaultType = 'Automatic'
            Comment     = 'if disabled with device present, break/freeze settings > account > sign-in options.
                           default is Manual if no biometric device.'
        }
        @{
            DisplayName = 'Windows Mobile Hotspot Service'
            ServiceName = 'icssvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'settings > network & internet > mobile hotspot.'
        }
    )
}
