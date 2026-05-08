#=================================================================================================================
#                               Apps > Advanced App Settings > Share Across Devices
#=================================================================================================================

# For GPO see: tweaks > Set-WindowsSharedExperience

<#
.SYNTAX
    Set-AppsShareAcrossDevices
        [[-Mode] {Disabled | DevicesOnly | EveryoneNearby}]
        [<CommonParameters>]
#>

function Set-AppsShareAcrossDevices
{
    <#
    .EXAMPLE
        PS> Set-AppsShareAcrossDevices -Mode 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ShareAcrossDevicesMode] $Mode
    )

    process
    {
        # If disabled, 'SettingsPage\RomeSdkChannelUserAuthzPolicy' value does not matter.
        # off: 0 | my devices only: 1 (default) | everyone nearby: 2
        $AppsShareAcrossDevices = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP'
                Entries = @(
                    @{
                        Name  = 'CdpSessionUserAuthzPolicy'
                        Value = [int]$Mode
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'RomeSdkChannelUserAuthzPolicy'
                        Value = [int]$Mode
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP\SettingsPage'
                Entries = @(
                    @{
                        Name  = 'RomeSdkChannelUserAuthzPolicy'
                        Value = [int]$Mode
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Apps - Share Across Devices' to '$Mode' ..."
        $AppsShareAcrossDevices | Set-RegistryEntry
    }
}
