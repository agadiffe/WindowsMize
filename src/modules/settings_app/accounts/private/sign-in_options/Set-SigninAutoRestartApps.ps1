#=================================================================================================================
#    Accounts > Sign-In Options > Automatically Save My Restartable Apps And Restart Them When I Sign Back In
#=================================================================================================================

<#
.SYNTAX
    Set-SigninAutoRestartApps
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SigninAutoRestartApps
{
    <#
    .EXAMPLE
        PS> Set-SigninAutoRestartApps -State 'Disabled'
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
        $SigninRestartApps = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            Entries = @(
                @{
                    Name  = 'RestartApps'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $RestartAppsMsg = 'Automatically Save My Restartable Apps And Restart Them When I Sign Back In'

        Write-Verbose -Message "Setting 'Sign-In Options - $RestartAppsMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $SigninRestartApps
    }
}
