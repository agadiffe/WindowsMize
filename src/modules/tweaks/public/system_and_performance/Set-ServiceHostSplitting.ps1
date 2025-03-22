#=================================================================================================================
#                                             Service Host Splitting
#=================================================================================================================

# Benefits of separating SvcHost services:
#   Increased reliability, security and scalability.
#   Improved resource and memory management.

# Disabling service host splitting reduces RAM usage (a bit) and decreases the process count.
# It might increase performances (?) with the trade-off of losing the benefits mentioned above.

# default: On systems with 3.5 GB or less RAM, SvcHost services will be grouped.
# Recommendation: Enabled (i.e Split SvcHost)

<#
.SYNTAX
    Set-ServiceHostSplitting
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ServiceHostSplitting
{
    <#
    .EXAMPLE
        PS> Set-ServiceHostSplitting -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # default: 3670016 (3.5 GB x 1024 x 1024) | off: 0 (or <YOUR_RAM> in KB)
        $ServiceHostSplitting = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control'
            Entries = @(
                @{
                    Name  = 'SvcHostSplitThresholdInKB'
                    Value = $State -eq 'Enabled' ? '3670016' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Service Host Splitting' to '$State' ..."
        Set-RegistryEntry -InputObject $ServiceHostSplitting
    }
}
