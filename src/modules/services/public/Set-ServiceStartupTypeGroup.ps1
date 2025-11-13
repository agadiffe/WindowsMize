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
        [-Name] {UserChoiceProtectionDriver | BridgeDriver | NetBiosDriver | NetBiosOverTcpIpDriver | LldpDriver |
                 LltdIoDriver | LltdResponderDriver | MicrosoftMultiplexorDriver | QosPacketSchedulerDriver |
                 OfflineFilesDriver | NetworkDataUsageDriver |
                 Autoplay | Bluetooth | BluetoothAndCast | BluetoothAudio | DefenderPhishingProtection | Deprecated |
                 DiagnosticAndUsage | Features | FileAndPrinterSharing | HyperV | MicrosoftOffice | MicrosoftStore |
                 Miscellaneous | Network | NetworkDiscovery | Printer | RemoteDesktop | Sensor |
                 WindowsSubsystemForLinux | Xbox | AdobeAcrobat | Intel | Nvidia}
        [-RestoreDefault]
        [<CommonParameters>]
#>

function Set-ServiceStartupTypeGroup
{
    <#
    .EXAMPLE
        PS> $ServiceToConfig = @(
                'UserChoiceProtectionDriver'
                'NetBiosDriver'
                'DefenderPhishingProtection'
                'Deprecated'
                'Telemetry'
            )
        PS> $ServiceToConfig | Set-ServiceStartupTypeGroup
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet([ServicesGroupName])]
        [string] $Name,

        [switch] $RestoreDefault
    )

    process
    {
        $GroupToConfig = $SystemDriversList.Keys -contains $Name ? $SystemDriversList.$Name : $ServicesList.$Name

        if ($RestoreDefault)
        {
            $GroupToConfig | Set-ServiceStartupType -RestoreDefault
        }
        else
        {
            $GroupToConfig | Set-ServiceStartupType
        }
    }
}
