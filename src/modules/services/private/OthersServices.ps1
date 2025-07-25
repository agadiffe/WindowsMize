#=================================================================================================================
#                                                Services - Others
#=================================================================================================================

# Untouched services.
# I didn't test to change these services (Could break (or not) Windows).

# Not included in main script.

$ServicesListNotConfigured += @{
    OthersServices = @(
        @{
            DisplayName = 'App Readiness'
            ServiceName = 'AppReadiness'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Application Information'
            ServiceName = 'Appinfo'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Auto Time Zone Updater'
            ServiceName = 'tzautoupdate'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'Background Intelligent Transfer Service'
            ServiceName = 'BITS'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Background Tasks Infrastructure Service'
            ServiceName = 'BrokerInfrastructure'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Base Filtering Engine'
            ServiceName = 'BFE'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'CNG Key Isolation'
            ServiceName = 'KeyIso'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'COM+ Event System'
            ServiceName = 'EventSystem'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'COM+ System Application'
            ServiceName = 'COMSysApp'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'ConsentUX User Service'
            ServiceName = 'ConsentUxUserSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'CoreMessaging'
            ServiceName = 'CoreMessagingRegistrar'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Credential Manager'
            ServiceName = 'VaultSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'CredentialEnrollmentManagerUserSvc'
            ServiceName = 'CredentialEnrollmentManagerUserSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Cryptographic Services'
            ServiceName = 'CryptSvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'DCOM Server Process Launcher'
            ServiceName = 'DcomLaunch'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Declared Configuration(DC) service'
            ServiceName = 'dcsvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Device Install Service'
            ServiceName = 'DeviceInstall'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'DHCP Client'
            ServiceName = 'Dhcp'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'DialogBlockingService'
            ServiceName = 'DialogBlockingService'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'DNS Client'
            ServiceName = 'Dnscache'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Extensible Authentication Protocol'
            ServiceName = 'EapHost'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'GameInput Service'
            ServiceName = 'GameInputSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Group Policy Client'
            ServiceName = 'gpsvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Hotpatch Monitoring Service'
            ServiceName = 'hpatchmon'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Host Network Service'
            ServiceName = 'hns'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Local Profile Assistant Service'
            ServiceName = 'wlpasvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Local Session Manager'
            ServiceName = 'LSM'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'McpManagementService'
            ServiceName = 'McpManagementService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Microsoft App-V Client'
            ServiceName = 'AppVClient'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'Microsoft Defender Antivirus Network Inspection Service'
            ServiceName = 'WdNisSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Microsoft Defender Antivirus Service'
            ServiceName = 'WinDefend'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Microsoft Defender Core Service'
            ServiceName = 'MDCoreSvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Microsoft Keyboard Filter'
            ServiceName = 'MsKeyboardFilter'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'Microsoft Update Health Service'
            ServiceName = 'uhssvc'
            StartupType = 'AutomaticDelayedStart'
            DefaultType = 'AutomaticDelayedStart'
        }
        @{
            DisplayName = 'Net.Tcp Port Sharing Service'
            ServiceName = 'NetTcpPortSharing'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'Network Connection Broker'
            ServiceName = 'NcbService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Network Connections'
            ServiceName = 'Netman'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Network List Service'
            ServiceName = 'netprofm'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Network Location Awareness'
            ServiceName = 'NlaSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Network Setup Service'
            ServiceName = 'NetSetupSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Network Store Interface Service'
            ServiceName = 'nsi'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Network Virtualization Service'
            ServiceName = 'nvagent'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'OpenSSH Authentication Agent'
            ServiceName = 'ssh-agent'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'Optimize drives'
            ServiceName = 'defragsvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Performance Counter DLL Host'
            ServiceName = 'PerfHost'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Plug and Play'
            ServiceName = 'PlugPlay'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Power'
            ServiceName = 'Power'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Remote Procedure Call (RPC)'
            ServiceName = 'RpcSs'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'RPC Endpoint Mapper'
            ServiceName = 'RpcEptMapper'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Security Accounts Manager'
            ServiceName = 'SamSs'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Security Center'
            ServiceName = 'wscsvc'
            StartupType = 'AutomaticDelayedStart'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Shared PC Account Manager'
            ServiceName = 'shpamsvc'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'Software Protection'
            ServiceName = 'sppsvc'
            StartupType = 'AutomaticDelayedStart'
            DefaultType = 'AutomaticDelayedStart'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Spot Verifier'
            ServiceName = 'svsvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'State Repository Service'
            ServiceName = 'StateRepository'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'System Event Notification Service'
            ServiceName = 'SENS'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'System Events Broker'
            ServiceName = 'SystemEventsBroker'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'System Guard Runtime Monitor Broker'
            ServiceName = 'SgrmBroker'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Task Scheduler'
            ServiceName = 'Schedule'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Text Input Management Service'
            ServiceName = 'TextInputManagementService'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.
                           DO NOT DISABLE (system will fail to boot).'
        }
        @{
            DisplayName = 'This service provides profile management for mobile connectivity modules'
            ServiceName = 'McmSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Time Broker'
            ServiceName = 'TimeBrokerSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Udk User Service'
            ServiceName = 'UdkUserSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Update Orchestrator Service'
            ServiceName = 'UsoSvc'
            StartupType = 'AutomaticDelayedStart'
            DefaultType = 'AutomaticDelayedStart'
        }
        @{
            DisplayName = 'User Experience Virtualization Service'
            ServiceName = 'UevAgentService'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'User Manager'
            ServiceName = 'UserManager'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'User Profile Service'
            ServiceName = 'ProfSvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Virtual Disk'
            ServiceName = 'vds'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'WaaSMedicSvc'
            ServiceName = 'WaaSMedicSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Warp JIT Service'
            ServiceName = 'WarpJITSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Audio'
            ServiceName = 'Audiosrv'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Windows Audio Endpoint Builder'
            ServiceName = 'AudioEndpointBuilder'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Windows Connection Manager'
            ServiceName = 'Wcmsvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Windows Defender Advanced Threat Protection Service'
            ServiceName = 'Sense'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Windows Defender Firewall'
            ServiceName = 'mpssvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Windows Encryption Provider Host Service'
            ServiceName = 'WEPHOSTSVC'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Event Log'
            ServiceName = 'EventLog'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Windows Installer'
            ServiceName = 'msiserver'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.'
        }
        @{
            DisplayName = 'Windows Management Instrumentation'
            ServiceName = 'Winmgmt'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Windows Management Service'
            ServiceName = 'WManSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Push Notifications User Service'
            ServiceName = 'WpnUserService'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'DO NOT DISABLE. needed by action center.'
        }
        @{
            DisplayName = 'Windows Security Service'
            ServiceName = 'SecurityHealthService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Windows Time'
            ServiceName = 'W32Time'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Update'
            ServiceName = 'wuauserv'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Virtual Audio Device Proxy Service'
            ServiceName = 'ApxSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Wired AutoConfig'
            ServiceName = 'dot3svc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'WLAN AutoConfig'
            ServiceName = 'WlanSvc'
            StartupType = 'Automatic'
            DefaultType = 'Automatic'
            Comment     = 'if no wireless device default is Manual.'
        }
        @{
            DisplayName = 'WMI Performance Adapter'
            ServiceName = 'wmiApSrv'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
    )
}
