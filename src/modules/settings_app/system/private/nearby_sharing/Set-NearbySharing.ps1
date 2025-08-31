#=================================================================================================================
#                                             System > Nearby Sharing
#=================================================================================================================

<#
.SYNTAX
    Set-NearbySharing
        [-State] {Disabled | DevicesOnly | EveryoneNearby}
        [<CommonParameters>]
#>

function Set-NearbySharing
{
    <#
    .EXAMPLE
        PS> Set-NearbySharing -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NearShareMode] $State
    )

    process
    {
        # x means that the value doesn't matters.
        # off: 0 0 x 0 0 (default) | my devices only: 1 1 1 x x | everyone nearby: 2 2 2 x x
        $NearbySharing = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP'
                Entries = @(
                    @{
                        Name  = 'CdpSessionUserAuthzPolicy'
                        Value = [int]$State
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'NearShareChannelUserAuthzPolicy'
                        Value = [int]$State
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP\SettingsPage'
                Entries = @(
                    @{
                        Name  = 'NearShareChannelUserAuthzPolicy'
                        Value = [int]$State
                        Type  = 'DWord'
                    }
                )
            }
            @{
                SkipKey = $State -ne 'Disabled'
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP\SettingsPage'
                Entries = @(
                    @{
                        Name  = 'BluetoothLastDisabledNearShare'
                        Value = '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'WifiLastDisabledNearShare'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Nearby Sharing' to '$State' ..."
        $NearbySharing | Set-RegistryEntry
    }
}
