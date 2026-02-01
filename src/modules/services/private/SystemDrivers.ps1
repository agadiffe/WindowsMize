#=================================================================================================================
#                                            Services - System Drivers
#=================================================================================================================

# See 'network module' to disable these network protocols without disabling the drivers.

<#
  all apps > windows tools > system information > software environment > system drivers (msinfo32.exe)
  Can also be listed with = Get-CimInstance -ClassName 'Win32_SystemDriver'.

  Not listed by 'Get-Service' but can be queried if the name is provided. e.g. Get-Service -Name 'NetBIOS'.
#>

<#
  To list the currently registered (loaded) filters:
    fltMC.exe filters

  To list all filters:
    Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\*' |
        Where-Object -Property 'Group' -like -Value 'FSFilter*' |
        Select-Object -Property 'PSChildName', 'Group', 'Start'
#>

$SystemDriversList += @{
    UserChoiceProtectionDriver = @(
        @{
            DisplayName = 'ucpd'
            ServiceName = 'UCPD'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'userChoice Protection Driver
                           block access to UserChoice Registry keys.
                           i.e. default web browser, PDF Viewer, image editor, DeviceRegion, ...'
        }
    )
    BridgeDriver = @( #  old ?
        @{
            DisplayName = 'Bridge Driver'
            ServiceName = 'l2bridge'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'old ?'
        }
    )
    NetBiosDriver = @(
        @{
            DisplayName = 'NetBIOS Interface'
            ServiceName = 'NetBIOS'
            StartupType = 'Disabled'
            DefaultType = 'System'
            Comment     = 'legacy/old.
                           needed by old pc/hardware (e.g. File and Printer Sharing)'
        }
    )
    NetBiosOverTcpIpDriver = @(
        @{
            DisplayName = 'netbt'
            ServiceName = 'NetBT'
            StartupType = 'Disabled'
            DefaultType = 'System'
            Comment     = 'NetBios over TCP/IP.
                           legacy/old.
                           needed by old pc/hardware (e.g. File and Printer Sharing)'
        }
    )
    LldpDriver = @(
        @{
            DisplayName = 'Microsoft Link-Layer Discovery Protocol'
            ServiceName = 'MsLldp'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
    )
    LltdIoDriver = @(
        @{
            DisplayName = 'Link-Layer Topology Discovery Mapper I/O Driver'
            ServiceName = 'lltdio'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
    )
    LltdResponderDriver = @(
        @{
            DisplayName = 'Link-Layer Topology Discovery Responder'
            ServiceName = 'rspndr'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
    )
    MicrosoftMultiplexorDriver = @(
        @{
            DisplayName = 'Microsoft Network Adapter Multiplexor Protocol'
            ServiceName = 'NdisImPlatform'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
    QosPacketSchedulerDriver = @(
        @{
            DisplayName = 'QoS Packet Scheduler'
            ServiceName = 'Psched'
            StartupType = 'Disabled'
            DefaultType = 'System'
        }
    )
    OfflineFilesDriver = @(
        @{
            DisplayName = 'Offline Files Driver'
            ServiceName = 'CSC'
            StartupType = 'Disabled'
            DefaultType = 'System'
        }
    )
    NetworkDataUsageDriver = @(
        @{
            DisplayName = 'Windows Network Data Usage Monitoring Driver'
            ServiceName = 'Ndu'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
    )
}
