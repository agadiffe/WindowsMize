#=================================================================================================================
#       System Properties - Advanced > Startup and Recovery > System Failure > Write Debugging Information
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

<#
.SYNTAX
    Set-SystemFailureWriteDebugInfo
        [-Value] {None | Complete | Kernel | Small | Automatic | Active}
        [<CommonParameters>]
#>

function Set-SystemFailureWriteDebugInfo
{
    <#
    .DESCRIPTION
        Write debugging information - Minimum paging file size:
          Complete:  <YOUR_RAM> MB + 257 MB
          Kernel:    800 MB
          Small:     1 MB
          Automatic: 800 MB

    .EXAMPLE
        PS> Set-SystemFailureWriteDebugInfo -Value 'None'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [DebugInfoMethod] $Value
    )

    process
    {
        # None: 0 | Complete: 1 | Kernel: 2 | Small: 3 | Automatic: 7 (default) | Active: 1 + FilterPages
        $SystemFailureDebugInfo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\CrashControl'
            Entries = @(
                @{
                    Name  = 'CrashDumpEnabled'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $Value -ne 'Active'
                    Name  = 'FilterPages'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Failure - Write Debugging Information' to '$Value' ..."
        Set-RegistryEntry -InputObject $SystemFailureDebugInfo
    }
}
