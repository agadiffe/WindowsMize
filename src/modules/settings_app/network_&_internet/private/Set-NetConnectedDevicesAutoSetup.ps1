#=================================================================================================================
#    Network & Internet > Advanced Network Settings > Advanced Sharing Settings > Auto Setup Connected Devices
#=================================================================================================================

# Private networks: Set Up Network Connected Devices Automatically

<#
.SYNTAX
    Set-NetConnectedDevicesAutoSetup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetConnectedDevicesAutoSetup
{
    <#
    .EXAMPLE
        PS> Set-NetConnectedDevicesAutoSetup -State 'Disabled'
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
        $NcdAutoSetup = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private'
            Entries = @(
                @{
                    Name  = 'AutoSetup'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Network Sharing Settings - Set Up Network Connected Devices Automatically' to '$State' ..."
        Set-RegistryEntry -InputObject $NcdAutoSetup
    }
}
