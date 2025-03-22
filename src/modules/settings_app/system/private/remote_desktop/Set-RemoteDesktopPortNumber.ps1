#=================================================================================================================
#                                  System > Remote Desktop > Remote Desktop Port
#=================================================================================================================

# Changing the default RDP port from 3389 can improve security, but it's not a complete solution.
# Skilled attackers can still find the new port, so it should be part of a broader security strategy,
# not the only measure taken.

<#
.SYNTAX
    Set-RemoteDesktopPortNumber
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-RemoteDesktopPortNumber
{
    <#
    .EXAMPLE
        PS> Set-RemoteDesktopPortNumber -Value 3389
    #>

    [CmdletBinding()]
    param
    (
        [ValidateRange(1, 65535)]
        [int] $PortNumber
    )

    process
    {
        # default: 3389
        $RemoteDesktopPortNumber = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
            Entries = @(
                @{
                    Name  = 'PortNumber'
                    Value = $PortNumber
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Remote Desktop - Remote Desktop Port' to '$PortNumber' ..."
        Set-RegistryEntry -InputObject $RemoteDesktopPortNumber

        # update Windows Firewall rules
        $FirewallRule = @{
            DisplayName = @(
                'Remote Desktop - User Mode (TCP-In)'
                'Remote Desktop - User Mode (UDP-In)'
            )
            LocalPort   = $PortNumber
        }
        Set-NetFirewallRule @FirewallRule
    }
}
