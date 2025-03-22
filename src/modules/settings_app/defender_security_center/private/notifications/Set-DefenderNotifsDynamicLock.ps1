#=================================================================================================================
#                        Defender > Settings > Notifications > Problems With Dynamic Lock
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderNotifsDynamicLock
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderNotifsDynamicLock
{
    <#
    .EXAMPLE
        PS> Set-DefenderNotifsDynamicLock -State 'Disabled'
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
        $DefenderNotifsDynamicLock = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows Defender Security Center\Account protection'
            Entries = @(
                @{
                    Name  = 'DisableDynamiclockNotifications'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender Notifications - Problems With Dynamic Lock' to '$State' ..."
        Set-RegistryEntry -InputObject $DefenderNotifsDynamicLock
    }
}
