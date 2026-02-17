#=================================================================================================================
#                                        Services - Miscellaneous Services
#=================================================================================================================

$ServicesList += @{
    Miscellaneous = @(
        @{
            DisplayName = 'Application Identity'
            ServiceName = 'AppIDSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           needed by AppLocker.'
        }
        @{
            DisplayName = 'Agent Activation Runtime'
            ServiceName = 'AarSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'conversational agent applications.
                           AI related. copilot ? AI agents ?
                           was used by Cortana.'
        }
        @{
            DisplayName = 'Application Management'
            ServiceName = 'AppMgmt'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'software deployed through Group Policy.'
        }
        @{
            DisplayName = 'AssignedAccessManager Service'
            ServiceName = 'AssignedAccessManagerSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Kiosk mode.'
        }
        @{
            DisplayName = 'Cellular Time'
            ServiceName = 'autotimesvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'set time from mobile network.'
        }
        @{
            DisplayName = 'Contact Data'
            ServiceName = 'PimIndexMaintenanceSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'contact data indexing.'
        }
        @{
            DisplayName = 'Data Sharing Service'
            ServiceName = 'DsSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'on Win10, needed by Snipping Tool.
                           also facilitate the sharing of diagnostic and usage data with Microsoft ?'
        }
        @{
            DisplayName = 'DevQuery Background Discovery Broker'
            ServiceName = 'DevQueryBroker'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'enables apps to discover devices with a backgroud task.
                           periodically scans for devices and sends a notification to all apps
                           that have registered for device discovery events.
                           enable if problems with an app trying to discover a device.'
        }
        @{
            DisplayName = 'Device Management Enrollment Service'
            ServiceName = 'DmEnrollmentSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'access organization resources.'
        }
        @{
            DisplayName = 'Distributed Transaction Coordinator'
            ServiceName = 'MSDTC'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'coordinates transactions from multiple resource managers.'
        }
        @{
            DisplayName = 'Embedded Mode'
            ServiceName = 'embeddedmode'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           activate background applications (IoT related).'
        }
        @{
            DisplayName = 'Enterprise App Management Service'
            ServiceName = 'EntAppSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'GraphicsPerfSvc'
            ServiceName = 'GraphicsPerfSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Human Interface Device Service'
            ServiceName = 'hidserv'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'enable if some (rare?) peripherals does not function correctly.'
        }
        @{
            DisplayName = 'IPsec Policy Agent'
            ServiceName = 'PolicyAgent'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'enforces IPsec policies (secpol.msc or netsh ipsec).
                           if using IPsec, you also need IKE and AuthIP IPsec Keying Modules.'
        }
        @{
            DisplayName = 'KtmRm for Distributed Transaction Coordinator'
            ServiceName = 'KtmRm'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'coordinates transactions between MSDTC and KTM.'
        }
        @{
            DisplayName = 'MessagingService'
            ServiceName = 'MessagingService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'text messaging and related functionality.
                           settings > privacy & security > messaging.'
        }
        @{
            DisplayName = 'Microsoft Cloud Identity Service'
            ServiceName = 'cloudidsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'tenant restrictions (cloud-policy based authorization control plane).
                           used in corporate environnement.'
        }
        @{
            DisplayName = 'Microsoft Windows SMS Router Service'
            ServiceName = 'SmsRouter'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Natural Authentication'
            ServiceName = 'NaturalAuthentication'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'device unlock (face recognition) and dynamic Lock.'
        }
        @{
            DisplayName = 'Payments and NFC/SE Manager'
            ServiceName = 'SEMgrSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Performance Logs & Alerts'
            ServiceName = 'pla'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'collects performance data from local or remote computers.'
        }
        @{
            DisplayName = 'Portable Device Enumerator Service'
            ServiceName = 'WPDBusEnum'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'enforces group policy for removable mass-storage devices.'
        }
        @{
            DisplayName = 'Quality Windows Audio Video Experience'
            ServiceName = 'QWAVE'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'VoIP.'
        }
        @{
            DisplayName = 'Remote Access Auto Connection Manager'
            ServiceName = 'RasAuto'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'connects to remote network (when apps using remote DNS/NetBIOS address).'
        }
        @{
            DisplayName = 'Remote Procedure Call (RPC) Locator'
            ServiceName = 'RpcLocator'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'old/legacy service.
                           application compatibility for very old software.'
        }
        @{
            DisplayName = 'Retail Demo Service'
            ServiceName = 'RetailDemo'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Still Image Acquisition Events'
            ServiceName = 'WiaRpc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'scanners and cameras.'
        }
        @{
            DisplayName = 'Storage Service'
            ServiceName = 'StorSvc'
            StartupType = 'Manual'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'needed by micosoft store (install/update apps) and storage sense.
                           needed to detect external usb drive ?
                           if disabled, break/crash:
                           settings > system > storage (no data, no auto clean up, no advanced settings).'
        }
        @{
            DisplayName = 'Storage Tiers Management'
            ServiceName = 'TieringEngineService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Telephony'
            ServiceName = 'TapiSrv'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'VoIP.'
        }
        @{
            DisplayName = 'Themes'
            ServiceName = 'Themes'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'User Data Access'
            ServiceName = 'UserDataSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'contact info, calendars, messages, and other content.'
        }
        @{
            DisplayName = 'User Data Storage'
            ServiceName = 'UnistoreSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'contact info, calendars, messages, and other content.'
        }
        @{
            DisplayName = 'WalletService'
            ServiceName = 'WalletService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Connect Now - Config Registrar'
            ServiceName = 'wcncsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'WPS protocol.'
        }
        @{
            DisplayName = 'Windows Event Collector'
            ServiceName = 'Wecsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'events from remote sources.'
        }
        @{
            DisplayName = 'Windows Font Cache Service'
            ServiceName = 'FontCache'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Windows Health and Optimized Experiences'
            ServiceName = 'whesvc'
            StartupType = 'Disabled'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'adaptive Energy Saver mode.'
        }
        @{
            DisplayName = 'Windows Image Acquisition (WIA)'
            ServiceName = 'StiSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'scanners and cameras.'
        }
        @{
            DisplayName = 'Windows Insider Service'
            ServiceName = 'wisvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Media Player Network Sharing Service'
            ServiceName = 'WMPNetworkSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows MIDI Service'
            ServiceName = 'midisrv'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Modules Installer'
            ServiceName = 'TrustedInstaller'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Windows Presentation Foundation Font Cache 3.0.0.0'
            ServiceName = 'FontCache3.0.0.0'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Remote Management (WS-Management)'
            ServiceName = 'WinRM'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Work Folders'
            ServiceName = 'workfolderssvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'WWAN AutoConfig'
            ServiceName = 'WwanSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'mobile network connection.
                           default is probably Automatic if you got celluar modem device.'
        }
        @{
            DisplayName = 'WSAIFabricSvc'
            ServiceName = 'WSAIFabricSvc'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'AI-related thing. Azure only ? (probably not)'
        }

        # Untouched
        @{
            DisplayName = 'CaptureService'
            ServiceName = 'CaptureService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'needed by snipping tool.
                           screen capture functionality for apps using Windows.Graphics.Capture API.'
        }
        @{
            DisplayName = 'Delivery Optimization'
            ServiceName = 'DoSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           needed by windows update and microsoft store (not only delivery optimization from other PCs).
                           even if disabled, it may be reset to Manual by windows Update or Microsoft Store.'
        }
        @{
            DisplayName = 'Device Setup Manager'
            ServiceName = 'DsmSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'somehow similar to: prevent device metadata retrieval from the Internet.
                           see tweaks > system properties > hardware.'
        }
        @{
            DisplayName = 'Display Enhancement Service'
            ServiceName = 'DisplayEnhancementService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'manages display enhancement (e.g. brightness control).'
        }
        @{
            DisplayName = 'Display Policy Service'
            ServiceName = 'DispBrokerDesktopSvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'local and remote displays.
                           required on 24H2+ for some things ?
                           if disabled, on VirtualBox, the auto resize window on startup is broken.
                           could probably broke some other things on bare metal install ?'
        }
        @{
            DisplayName = 'Microsoft Storage Spaces SMP'
            ServiceName = 'smphost'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'group drives together to helps protect from drive failure.
                           settings > storage > advanced storage settings > storage spaces.
                           needed by settings > about > storage.
                           also needed by Powershell Get-Volume and Get-Disk (and possibly more cmdlet).'
        }
        @{
            DisplayName = 'ReFS Dedup Service'
            ServiceName = 'refsdedupsvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'ReFS data deduplication.'
        }
        @{
            DisplayName = 'Web Account Manager'
            ServiceName = 'TokenBroker'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'needed to load settings > account > sign-in options.
                           needed by microsoft store (only by apps that need login).'
        }
        @{
            DisplayName = 'Windows Push Notifications System Service'
            ServiceName = 'WpnService'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'needed by action center for network notifications.
                           e.g. Microsoft Teams, Discord, ...
                           mainly needed by MS Store apps (and some desktop apps that use WNS)'
        }
        @{
            DisplayName = 'ZTHELPER'
            ServiceName = 'ZTHELPER'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'zero trust DNS.'
        }
    )
}
