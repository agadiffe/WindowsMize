#=================================================================================================================
#                      Time & Language > Date & Time > Show Time And Date In The System Tray
#=================================================================================================================

<#
.SYNTAX
    Set-DateAndTimeShowInSystemTray
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DateAndTimeShowInSystemTray
{
    <#
    .EXAMPLE
        PS> Set-DateAndTimeShowInSystemTray -State 'Disabled'
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
        $DateAndTimeShowInSystemTray = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'ShowSystrayDateTimeValueName'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Date & Time - Show Time And Date In The System Tray' to '$State' ..."
        Set-RegistryEntry -InputObject $DateAndTimeShowInSystemTray
    }
}
