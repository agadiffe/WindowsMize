#=================================================================================================================
#                        Time & Language > Date & Time > Show Time In Notification Center
#=================================================================================================================

<#
.SYNTAX
    Set-DateAndTimeShowTimeInNotifCenter
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DateAndTimeShowTimeInNotifCenter
{
    <#
    .EXAMPLE
        PS> Set-DateAndTimeShowTimeInNotifCenter -State 'Disabled'
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
        $DateAndTimeShowTimeInNotifCenter = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'ShowClockInNotificationCenter'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Date & Time - Show Time In Notification Center' to '$State' ..."
        Set-RegistryEntry -InputObject $DateAndTimeShowTimeInNotifCenter
    }
}
