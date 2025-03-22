#=================================================================================================================
#             Bluetooth & Devices > USB > Show A Notification If This PC Is Charging Slowly Over USB
#=================================================================================================================

<#
.SYNTAX
    Set-UsbNotificationOnWeakCharger
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-UsbNotificationOnWeakCharger
{
    <#
    .EXAMPLE
        PS> Set-UsbNotificationOnWeakCharger -State 'Enabled'
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
        $UsbNotificationOnWeakCharger = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Shell\USB'
            Entries = @(
                @{
                    Name  = 'NotifyOnWeakCharger'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'USB - Show A Notification If This PC Is Charging Slowly Over USB' to '$State' ..."
        Set-RegistryEntry -InputObject $UsbNotificationOnWeakCharger
    }
}
