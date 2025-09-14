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
        [Parameter(Mandatory)]
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

        $FirewallRuleName = 'RemoteDesktop-UserMode-In-TCP', 'RemoteDesktop-UserMode-In-UDP'
        Write-Verbose -Message "  Setting 'Firewall rules: $($FirewallRuleName -join ', '))' to '$PortNumber'"
        Set-NetFirewallRule -Name $FirewallRuleName -LocalPort $PortNumber
    }
}
