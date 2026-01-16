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
            DisplayName = 'Connected Devices Platform Service'
            ServiceName = 'CDPSvc'
            StartupType = 'Disabled'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'needed by Nearby sharing.
                           also telemetry related.
                           in previous version: was needed by Night Light.'
        }
        @{
            DisplayName = 'Connected Devices Platform User Service'
            ServiceName = 'CDPUserSvc'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'needed by Nearby sharing.
                           connect, manage, and control connected devices.
                           (e.g. mobile, Xbox, HoloLens, or smart/IoT devices).
                           i.e. manage Windows experiences across devices.
                           also telemetry related.
                           in previous version: was needed to enable/disable Night Light.'
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
            DisplayName = 'Encrypting File System (EFS)'
            ServiceName = 'EFS'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'encrypt/access files or folders on NTFS file system volumes.
                           files/folders > properties > advanced > encrypt contents to secure data.'
        }
        @{
            DisplayName = 'File History Service'
            ServiceName = 'fhsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
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
            DisplayName = 'Language Experience Service'
            ServiceName = 'LxpSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed to install additional Windows languages.'
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
            DisplayName = 'Secondary Logon'
            ServiceName = 'seclogon'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Run as different user (option in the extended context menu).'
        }
        @{
            DisplayName = 'SysMain'
            ServiceName = 'SysMain'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'Superfetch and memory compression.'
        }
        @{
            DisplayName = 'Windows Biometric Service'
            ServiceName = 'WbioSrvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'if disabled with device present, break/freeze settings > account > sign-in options.
                           default is Automatic if biometric device.'
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
