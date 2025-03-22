#=================================================================================================================
#               Bluetooth & Devices > Mobile Devices > Allow This PC To Access Your Mobile Devices
#=================================================================================================================

<#
.SYNTAX
    Set-MobileDevices
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MobileDevices
{
    <#
    .EXAMPLE
        PS> Set-MobileDevices -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $MobileDevices = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Mobility'
            Entries = @(
                @{
                    Name  = 'CrossDeviceEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mobile Devices - Allow This PC To Access Your Mobile Devices' to '$State' ..."
        Set-RegistryEntry -InputObject $MobileDevices
    }
}
