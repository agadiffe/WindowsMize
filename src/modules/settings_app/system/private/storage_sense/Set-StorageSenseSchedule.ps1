#=================================================================================================================
#                              System > Storage > Storage Sense > Run Storage Sense
#=================================================================================================================

<#
.SYNTAX
    Set-StorageSenseSchedule
        [[-Value] {OnLowFreeDiskSpace | Daily | Weekly | Monthly}]
        [-GPO {OnLowFreeDiskSpace | Daily | Weekly | Monthly | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StorageSenseSchedule
{
    <#
    .EXAMPLE
        PS> Set-StorageSenseSchedule -Value 'OnLowFreeDiskSpace' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [StorageSenseSchedule] $Value,

        [GpoStorageSenseSchedule] $GPO
    )

    process
    {
        $StorageSenseScheduleMsg = 'Storage Sense - Run Storage Sense'

        switch ($PSBoundParameters.Keys)
        {
            'Value'
            {
                # During low free disk space: 0 (default) | Every day: 1 | Every week: 7 | Every month: 30
                $StorageSenseSchedule = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy'
                    Entries = @(
                        @{
                            Name  = '2048'
                            Value = [int]$Value
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$StorageSenseScheduleMsg' to '$Value' ..."
                Set-RegistryEntry -InputObject $StorageSenseSchedule
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > storage sense
                #   configure storage sense cadence
                # not configured: delete (default) | on: During low free disk space (0), Every day (1), Every week (7), Every month (30)
                $StorageSenseScheduleGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\StorageSense'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'ConfigStorageSenseGlobalCadence'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$StorageSenseScheduleMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StorageSenseScheduleGpo
            }
        }
    }
}
