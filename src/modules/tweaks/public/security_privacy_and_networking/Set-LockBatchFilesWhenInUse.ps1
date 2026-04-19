#=================================================================================================================
#                                          Lock Batch Files When In Use
#=================================================================================================================

<#
.SYNTAX
    Set-LockBatchFilesWhenInUse
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-LockBatchFilesWhenInUse
{
    <#
    .EXAMPLE
        PS> Set-LockBatchFilesWhenInUse -State 'Enabled'
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
        $LockBatchFilesWhenInUse = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Command Processor'
            Entries = @(
                @{
                    Name  = 'LockBatchFilesWhenInUse'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Lock Batch Files When In Use' to '$State' ..."
        Set-RegistryEntry -InputObject $LockBatchFilesWhenInUse
    }
}
