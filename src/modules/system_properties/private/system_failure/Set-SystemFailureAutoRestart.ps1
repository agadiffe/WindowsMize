#=================================================================================================================
#          System Properties - Advanced > Startup and Recovery > System Failure > Automatically Restart
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

<#
.SYNTAX
    Set-SystemFailureAutoRestart
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SystemFailureAutoRestart
{
    <#
    .EXAMPLE
        PS> Set-SystemFailureAutoRestart -State 'Disabled'
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
        $SystemFailureAutoRestart = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\CrashControl'
            Entries = @(
                @{
                    Name  = 'AutoReboot'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Failure - Automatically Restart' to '$State' ..."
        Set-RegistryEntry -InputObject $SystemFailureAutoRestart
    }
}
