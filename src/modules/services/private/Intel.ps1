#=================================================================================================================
#                                                Services - Intel
#=================================================================================================================

# Be sure to make your own test.
# If everything works in your everyday usage after disabling these services, I guess its ok.
# If not, re-enable the services you need.

$ServicesList += @{
    Intel = @(
        @{
            DisplayName = 'Intel(R) Audio Service'
            ServiceName = 'IntelAudioService'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'handles audio over HDMI/DisplayPort.'
        }
        @{
            DisplayName = 'Intel(R) Capability Licensing Service TCP IP Interface'
            ServiceName = 'Intel(R) Capability Licensing Service TCP IP Interface'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Intel(R) Content Protection HDCP Service'
            ServiceName = 'cplspcon'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'drm related.
                           protection to disable capturing digital content.'
        }
        @{
            DisplayName = 'Intel(R) Content Protection HECI Service'
            ServiceName = 'cphs'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'drm related.
                           needed for premium video playback (such as blu-Ray).'
        }
        @{
            DisplayName = 'Intel(R) Dynamic Application Loader Host Interface Service'
            ServiceName = 'jhi_service'
            StartupType = 'Disabled'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'intel ME related.
                           Intel Rapid Storage Technology related ?'
        }
        @{
            DisplayName = 'Intel(R) Dynamic Platform and Thermal Framework service'
            ServiceName = 'esifsvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'not recommended to disable.
                           power and thermal management.'
        }
        @{
            DisplayName = 'Intel(R) Dynamic Tuning Technology Telemetry Service'
            ServiceName = 'dptftcs'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'not recommended to disable.
                           power and thermal management, resolve fan noise, overheating, optimize performance.'
        }
        @{
            DisplayName = 'Intel(R) Graphics Command Center Service'
            ServiceName = 'igccservice'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'some advanced graphics features might not be available without this service running ?'
        }
        @{
            DisplayName = 'Intel(R) HD Graphics Control Panel Service'
            ServiceName = 'igfxCUIService2.0.0.0'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Intel(R) Innovation Platform Framework Service'
            ServiceName = 'ipfsvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'not recommended to disable.
                           power and thermal management, resolve fan noise, overheating, optimize performance.'
        }
        @{
            DisplayName = 'Intel(R) Management and Security Application Local Management Service'
            ServiceName = 'LMS'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'remote PC management.
                           do not enable, could raise security risk.'
        }
        @{
            DisplayName = 'Intel(R) Management Engine WMI Provider Registration'
            ServiceName = 'WMIRegistrationService'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Intel(R) Platform License Manager Service'
            ServiceName = 'Intel(R) Platform License Manager Service'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Intel(R) Storage Middleware Service'
            ServiceName = 'RstMwService'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Intel(R) TPM Provisioning Service'
            ServiceName = 'Intel(R) TPM Provisioning Service'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Thunderbolt(TM) Application Launcher'
            ServiceName = 'TbtHostControllerService'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'do not disable if you use Thunderbolt.'
        }
        @{
            DisplayName = 'Thunderbolt(TM) Peer to Peer Shortcut'
            ServiceName = 'TbtP2pShortcutService'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'do not disable if you use Thunderbolt.'
        }
    )
}
