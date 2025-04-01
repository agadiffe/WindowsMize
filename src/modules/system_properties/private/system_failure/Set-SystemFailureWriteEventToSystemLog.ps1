#=================================================================================================================
#     System Properties - Advanced > Startup and Recovery > System Failure > Write An Event To The System Log
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

<#
.SYNTAX
    Set-SystemFailureWriteEventToSystemLog
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SystemFailureWriteEventToSystemLog
{
    <#
    .EXAMPLE
        PS> Set-SystemFailureWriteEventToSystemLog -State 'Enabled'
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
        $SystemFailureWriteEventToSystemLog = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\CrashControl'
            Entries = @(
                @{
                    Name  = 'LogEvent'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Failure - Write An Event To The System Log' to '$State' ..."
        Set-RegistryEntry -InputObject $SystemFailureWriteEventToSystemLog
    }
}
