#=================================================================================================================
#                        System > Storage > Storage Sense > Delete Files In My Recycle Bin
#=================================================================================================================

<#
.SYNTAX
    Set-StorageSenseRecycleBinRetentionDays
        [[-Value] {0 | 1 | 14 | 30 | 60}]
        [-GPO <object>] # <int> (range 0-365) | NotConfigured
        [<CommonParameters>]
#>

function Set-StorageSenseRecycleBinRetentionDays
{
    <#
    .EXAMPLE
        PS> Set-StorageSenseRecycleBinRetentionDays -Value 30 -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [ValidateSet(0, 1, 14, 30, 60)]
        [int] $Value,

        [ValidateScript(
            { ($_ -is [int] -and $_ -ge 0 -and $_ -le 365) -or $_ -eq 'NotConfigured' },
            ErrorMessage = "Invalid value. Specify an integer between 0 and 365, or the string 'NotConfigured'.")]
        [object] $GPO
    )

    process
    {
        $RecycleBinRetentionDaysMsg = 'Storage Sense - Delete Files In My Recycle Bin After'

        switch ($PSBoundParameters.Keys)
        {
            'Value'
            {
                # Never: 0 | 1 day: 1 | 14 days: 14 | 30 days: 30 (default) | 60 days: 60
                $RecycleBinRetentionDays = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy'
                    Entries = @(
                        @{
                            Name  = '256'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }

                $ValueMsg = $Value -eq 0 ? 'Never' : "$Value day(s)"
                Write-Verbose -Message "Setting '$RecycleBinRetentionDaysMsg' to '$ValueMsg' ..."
                Set-RegistryEntry -InputObject $RecycleBinRetentionDays
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > storage sense
                #   configure storage sense recycle bin cleanup threshold
                # not configured: delete (default) | on: value in days (range 0-365) (never: 0)
                $RecycleBinRetentionDaysGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\StorageSense'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'ConfigStorageSenseRecycleBinCleanupThreshold'
                            Value = $GPO
                            Type  = 'DWord'
                        }
                    )
                }

                $GpoMsg = switch ($GPO)
                {
                    0               { 'Never' }
                    'NotConfigured' { 'NotConfigured' }
                    Default         { "$GPO day(s)" }
                }
                Write-Verbose -Message "Setting '$RecycleBinRetentionDaysMsg (GPO)' to '$GpoMsg' ..."
                Set-RegistryEntry -InputObject $RecycleBinRetentionDaysGpo
            }
        }
    }
}
