#=================================================================================================================
#            System > Remote Desktop > Require Devices To Use Network Level Authentication To Connect
#=================================================================================================================

<#
.SYNTAX
    Set-RemoteDesktopNetworkLevelAuthentication
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-RemoteDesktopNetworkLevelAuthentication
{
    <#
    .EXAMPLE
        PS> Set-RemoteDesktopNetworkLevelAuthentication -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $RemoteDesktopNetworkLevelAuthentication = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
            Entries = @(
                @{
                    Name  = 'UserAuthentication'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Remote Desktop - Require Devices To Use Network Level Authentication To Connect' to '$State' ..."
        Set-RegistryEntry -InputObject $RemoteDesktopNetworkLevelAuthentication
    }
}
