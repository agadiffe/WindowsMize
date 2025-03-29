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
            Comment     = 'used by Cortana (audio driver-related process).'
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
            DisplayName = 'BranchCache'
            ServiceName = 'PeerDistSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Windows Update sharing (downloads from other PCs).'
        }
        @{
            DisplayName = 'CaptureService'
            ServiceName = 'CaptureService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'needed by snipping tool.
                           screen capture functionality for apps using Windows.Graphics.Capture API.'
        }
        @{
            DisplayName = 'Cellular Time'
            ServiceName = 'autotimesvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'set time from mobile network.'
        }
        @{
            DisplayName = 'Cloud Backup and Restore Service'
            ServiceName = 'CloudBackupRestoreSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Connected Devices Platform Service'
            ServiceName = 'CDPSvc'
            StartupType = 'AutomaticDelayedStart'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'needed by Night Light.
                           needed by Nearby sharing.'
        }
        @{
            DisplayName = 'Connected Devices Platform User Service'
            ServiceName = 'CDPUserSvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'needed to enable/disable Night Light.
                           needed by Nearby sharing.
                           connect, manage, and control connected devices.
                           (mobile, Xbox, HoloLens, or smart/IoT devices).'
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
            Comment     = 'telemetry related ?
                           needed by SMB (e.g. file and printer sharing) ?'
        }
        @{
            DisplayName = 'Delivery Optimization'
            ServiceName = 'DoSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           needed by windows update and microsoft store (not only delivery optimization).
                           even if disabled, will be set to Manual by windows update or microsoft store.'
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
            DisplayName = 'Encrypting File System (EFS)'
            ServiceName = 'EFS'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'encrypt/access files or folders on NTFS file system volumes.
                           files/folders > properties > advanced > encrypt contents to secure data.'
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
            DisplayName = 'IP Helper'
            ServiceName = 'iphlpsvc'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'deprecated.'
        }
        @{
            DisplayName = 'IP Translation Configuration Service'
            ServiceName = 'IpxlatCfgSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'translation from v4 to v6 and vice versa.'
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
            DisplayName = 'Language Experience Service'
            ServiceName = 'LxpSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed to install additional Windows languages.'
        }
        @{
            DisplayName = 'Link-Layer Topology Discovery Mapper'
            ServiceName = 'lltdsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'network map.'
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
            DisplayName = 'Microsoft Storage Spaces SMP'
            ServiceName = 'smphost'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'group drives together to helps protect from drive failure.
                           settings > storage > advanced storage settings > storage spaces.
                           also needed by Powershell Get-Volume and Get-Disk (and possibly more cmdlet).'
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
            DisplayName = 'ReFS Dedup Service'
            ServiceName = 'refsdedupsvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'ReFS data deduplication.'
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
            DisplayName = 'Secondary Logon'
            ServiceName = 'seclogon'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Run as different user (option in the extended context menu).'
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
            DisplayName = 'SysMain'
            ServiceName = 'SysMain'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'Superfetch and memory compression.'
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
            DisplayName = 'Web Account Manager'
            ServiceName = 'TokenBroker'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'needed to load settings > account > sign-in options.
                           needed by microsoft store (only by apps that need login).'
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
            DisplayName = 'Windows Modules Installer'
            ServiceName = 'TrustedInstaller'
            StartupType = 'Manual'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with registry editing.
                           default is Manual ?'
        }
        @{
            DisplayName = 'Windows Presentation Foundation Font Cache 3.0.0.0'
            ServiceName = 'FontCache3.0.0.0'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Push Notifications System Service'
            ServiceName = 'WpnService'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'needed by action center for network notifications.
                           e.g. Microsoft Teams, Discord, ...'
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
            DefaultType = 'Manual'
            Comment     = 'probably an Azure AI-related thing.'
        }
    )
}
