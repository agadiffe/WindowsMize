#=================================================================================================================
#       System Properties - Advanced > Startup and Recovery > System Failure > Overwrite Any Existing File
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

<#
.SYNTAX
    Set-SystemFailureOverwriteExistingDebugFile
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SystemFailureOverwriteExistingDebugFile
{
    <#
    .EXAMPLE
        PS> Set-SystemFailureOverwriteExistingDebugFile -State 'Enabled'
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
        $SystemFailureOverwriteExistingDebugFile = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\CrashControl'
            Entries = @(
                @{
                    Name  = 'Overwrite'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Failure - Overwrite Any Existing File' to '$State' ..."
        Set-RegistryEntry -InputObject $SystemFailureOverwriteExistingDebugFile
    }
}
