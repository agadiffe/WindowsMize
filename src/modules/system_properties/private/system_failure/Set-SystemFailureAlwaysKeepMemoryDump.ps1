#=================================================================================================================
# System Properties - Advanced > Startup and Recovery > System Failure > Always Keep Memory Dump On Low Disk Space
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# Disable automatic deletion of memory dumps when disk space is low

<#
.SYNTAX
    Set-SystemFailureAlwaysKeepMemoryDump
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SystemFailureAlwaysKeepMemoryDump
{
    <#
    .EXAMPLE
        PS> Set-SystemFailureAlwaysKeepMemoryDump -State 'Enabled'
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
        $SystemFailureAlwaysKeepMemoryDump = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\CrashControl'
            Entries = @(
                @{
                    Name  = 'AlwaysKeepMemoryDump'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $AlwaysKeepMemoryDumpMsg = 'Disable Automatic Deletion Of Memory Dumps When Disk Space Is Low'

        Write-Verbose -Message "Setting 'System Failure - $AlwaysKeepMemoryDumpMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $SystemFailureAlwaysKeepMemoryDump
    }
}
