#=================================================================================================================
#                                          Set Service StartupType Group
#=================================================================================================================

class ServicesGroupName : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return $Script:SystemDriversList.Keys + $Script:ServicesList.Keys
    }
}

<#
.SYNTAX
    Set-ServiceStartupTypeGroup
        [-Name] {UserChoiceProtectionDriver | BridgeDriver | NetBiosDriver | LldpDriver | LltdDriver |
                 MicrosoftMultiplexorDriver | QosPacketSchedulerDriver | OfflineFilesDriver | NetworkDataUsageDriver |
                 Autoplay | Bluetooth | BluetoothAndCast | BluetoothAudio | DefenderPhishingProtection | Deprecated |
                 DiagnosticAndUsage | Features | FileAndPrinterSharing | HyperV | MicrosoftEdge | MicrosoftOffice |
                 MicrosoftStore | Miscellaneous | Network | NetworkDiscovery | Printer | RemoteDesktop | Sensor |
                 SmartCard | Telemetry | VirtualReality | Vpn | Webcam | WindowsBackupAndSystemRestore | WindowsSearch |
                 WindowsSubsystemForLinux | Xbox | AdobeAcrobat | Intel | Nvidia}
        [<CommonParameters>]
#>

function Set-ServiceStartupTypeGroup
{
    <#
    .EXAMPLE
        PS> $ServiceToDisable = @(
                'UserChoiceProtectionDriver'
                'NetBiosDriver'
                'DefenderPhishingProtection'
                'Deprecated'
                'Telemetry'
            )
        PS> $TaskToDisable | Set-ServiceStartupTypeGroup
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet([ServicesGroupName])]
        [string] $Name
    )

    process
    {
        $GroupToConfig = $SystemDriversList.Keys -contains $Name ? $SystemDriversList.$Name : $ServicesList.$Name
        $GroupToConfig | Set-ServiceStartupType
    }
}
