#=================================================================================================================
#                                Acrobat Reader - Miscellaneous > Usage Statistics
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderUsageStatistics
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderUsageStatistics
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderUsageStatistics -State 'Disabled'
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
        $AcrobatReaderUsageStatistics = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
            Entries = @(
                @{
                    Name  = 'bUsageMeasurement'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Usage Statistics' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderUsageStatistics
    }
}
