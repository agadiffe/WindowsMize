#=================================================================================================================
#                        Defender > Settings > Notifications > Problems With Windows Hello
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderNotifsWindowsHello
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderNotifsWindowsHello
{
    <#
    .EXAMPLE
        PS> Set-DefenderNotifsWindowsHello -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $DefenderNotifsWindowsHello = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows Defender Security Center\Account protection'
            Entries = @(
                @{
                    Name  = 'DisableWindowsHelloNotifications'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender Notifications - Problems With Windows Hello' to '$State' ..."
        Set-RegistryEntry -InputObject $DefenderNotifsWindowsHello
    }
}
