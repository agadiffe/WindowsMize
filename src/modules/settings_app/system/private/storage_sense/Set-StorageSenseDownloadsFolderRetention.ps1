#=================================================================================================================
#                     System > Storage > Storage Sense > Delete Files In My Downloads Folder
#=================================================================================================================

<#
.SYNTAX
    Set-StorageSenseDownloadsFolderRetention
        [[-Days] {0 | 1 | 14 | 30 | 60}]
        [-GPO <object>] # <int> (range 0-365) | NotConfigured
        [<CommonParameters>]
#>

function Set-StorageSenseDownloadsFolderRetention
{
    <#
    .EXAMPLE
        PS> Set-StorageSenseDownloadsFolderRetention -Days 30 -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [ValidateSet(0, 1, 14, 30, 60)]
        [int] $Days,

        [ValidateScript(
            { ($_ -is [int] -and $_ -ge 0 -and $_ -le 365) -or $_ -eq 'NotConfigured' },
            ErrorMessage = "Invalid value. Specify an integer between 0 and 365, or the string 'NotConfigured'.")]
        [object] $GPO
    )

    process
    {
        $DownloadsRetentionMsg = 'Storage Sense - Delete Files In My Downloads Folder After'

        switch ($PSBoundParameters.Keys)
        {
            'Days'
            {
                # Never: 0 (default) | 1 day: 1 | 14 days: 14 | 30 days: 30 | 60 days: 60
                $DownloadsRetention = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy'
                    Entries = @(
                        @{
                            Name  = '512'
                            Value = $Days
                            Type  = 'DWord'
                        }
                    )
                }

                $ValueMsg = $Days -eq 0 ? 'Never' : "$Days day(s)"
                Write-Verbose -Message "Setting '$DownloadsRetentionMsg' to '$ValueMsg' ..."
                Set-RegistryEntry -InputObject $DownloadsRetention
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > storage sense
                #   configure storage sense downloads cleanup threshold
                # not configured: delete (default) | on: value in days (range 0-365) (never: 0)
                $DownloadsRetentionGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\StorageSense'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'ConfigStorageSenseDownloadsCleanupThreshold'
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
                Write-Verbose -Message "Setting '$DownloadsRetentionMsg (GPO)' to '$GpoMsg' ..."
                Set-RegistryEntry -InputObject $DownloadsRetentionGpo
            }
        }
    }
}
