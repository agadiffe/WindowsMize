#=================================================================================================================
#                        Bluetooth & Devices > USB > Connection Notifications (On Errors)
#=================================================================================================================

<#
.SYNTAX
    Set-UsbNotificationOnErrors
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-UsbNotificationOnErrors
{
    <#
    .EXAMPLE
        PS> Set-UsbNotificationOnErrors -State 'Enabled'
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
        $UsbNotificationOnErrors = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Shell\USB'
            Entries = @(
                @{
                    Name  = 'NotifyOnUsbErrors'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'USB - Connection Notifications (On Errors)' to '$State' ..."
        Set-RegistryEntry -InputObject $UsbNotificationOnErrors
    }
}
