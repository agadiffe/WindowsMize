#=================================================================================================================
#               Time & Language > Date & Time > Show Seconds In System Tray Clock (Uses More Power)
#=================================================================================================================

<#
.SYNTAX
    Set-DateAndTimeShowSecondsInSystemClock
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DateAndTimeShowSecondsInSystemClock
{
    <#
    .EXAMPLE
        PS> Set-DateAndTimeShowSecondsInSystemClock -State 'Disabled'
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
        $DateAndTimeShowSecondsInSystemTray = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'ShowSecondsInSystemClock'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Date & Time - Show Seconds In System Tray Clock (Uses More Power)' to '$State' ..."
        Set-RegistryEntry -InputObject $DateAndTimeShowSecondsInSystemTray
    }
}
